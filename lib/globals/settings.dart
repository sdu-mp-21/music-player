import 'dart:io';

import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/state_manager.dart';
import 'package:getx_app/library/genius_provider.dart';
import 'package:getx_app/pages/account/library_controller.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart';
import 'dart:convert';

class Settings extends GetxController {
  static RxList<Map<String, dynamic>> cachedSongs = RxList([]);
  static RxList<String> checkedFolders = RxList([]);
  static bool isLoading = false;
  static List watchers = [];

  Future<void> _addSong(String path) async {
    isLoading = true;
    if (path.contains(".mp3")) {
      final fileName = basename(path).replaceAll('.mp3', '');
      GeniusProvider(fileName, (Map<String, dynamic> song) async {
        final duration = await AudioPlayer().setUrl(path);

        song.addAll({"originalPath": path, "duration": duration!.inSeconds});
        cachedSongs.add(song);
        isLoading = false;
        Get.find<LibraryController>().update();
      });
    }
  }

  static init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> songs = prefs.getStringList("found_folders")!;
    List<String> folders = prefs.getStringList("checked_folders")!;
    cachedSongs = RxList<Map<String, dynamic>>(
        songs.map((e) => json.decode(e) as Map<String, dynamic>).toList());
    checkedFolders = RxList<String>(folders);

    cachedSongs.listen((p) => prefs.setStringList("found_folders",
        cachedSongs.map((element) => json.encode(element)).toList()));

    checkedFolders.listen((p) async {
      cachedSongs.removeRange(0, cachedSongs.length);

      for (var i = 0; i < p.length; i++) {
        List<FileSystemEntity> dirList = Directory(p[i]).listSync();
        prefs.setStringList("checked_folders", p);

        dirList.forEach((element) => Settings()._addSong(element.path));

        isLoading = false;

        if (!Settings.watchers.contains(p[i])) {
          Settings.watchers.add(p[i]);

          Directory(p[i]).watch().listen((event) {
            if (event.type == FileSystemEvent.delete) {
              cachedSongs.removeWhere(
                  (element) => element["originalPath"] == event.path);
            } else if (event.type == FileSystemEvent.create) {
              Settings()._addSong(event.path);
            }
          });
        }
      }
    });
  }
}
