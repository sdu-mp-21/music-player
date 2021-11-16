import 'dart:io';

import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/state_manager.dart';
import 'package:getx_app/library/genius_provider.dart';
import 'package:getx_app/pages/account/library_controller.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart';
import 'package:audiotagger/audiotagger.dart';
import 'dart:convert';

class CachedSongs {
  static RxList<Map<String, dynamic>> cachedSongs = RxList([]);
  static RxList<String> checkedFolders = RxList([]);

  static List watchers = [];

  Future<void> _addSong(String path) async {
    if (path.contains(".mp3")) {
      final fileName = basename(path).replaceAll('.mp3', '');
      GeniusProvider(fileName, (Map<String, dynamic> song) async {
        final duration = await AudioPlayer().setUrl(path);
        song.addAll({"originalPath": path, "duration": duration!.inSeconds});

        cachedSongs.add(song);

        Get.find<LibraryController>().update();
      });
    }
  }

  init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? songs = prefs.getStringList("found_folders");
    List<String>? folders = prefs.getStringList("checked_folders");
    if (songs != null)
      cachedSongs = RxList<Map<String, dynamic>>(
          songs.map((e) => json.decode(e) as Map<String, dynamic>).toList());
    if (folders != null) checkedFolders = RxList<String>(folders);

    _createListeners();
  }

  _createListeners() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    cachedSongs.listen((p) => prefs.setStringList("found_folders",
        cachedSongs.map((element) => json.encode(element)).toList()));

    checkedFolders.listen((folders) async {
      prefs.setStringList("checked_folders", folders);
      folders.forEach((element) {
        final subDir = Directory(element).listSync();

        subDir.forEach((subElement) => _addSong(subElement.path));

        if (!watchers.contains(element)) {
          watchers.add(element);
          Directory(element).watch().listen((event) {
            if (event.type == FileSystemEvent.delete) {
              cachedSongs.removeWhere(
                  (element) => element["originalPath"] == event.path);
            } else if (event.type == FileSystemEvent.create) {
              _addSong(event.path);
            }
          });
        }
      });
    });
  }
}
