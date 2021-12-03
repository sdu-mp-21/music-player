import 'dart:io';

import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/state_manager.dart';
import 'package:getx_app/audio_service/audio_player_handler.dart';
import 'package:getx_app/audio_service/media_state.dart';
import 'package:getx_app/library/genius_provider.dart';
import 'package:getx_app/models/song.dart';
import 'package:getx_app/pages/account/library_controller.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart';
import 'package:audiotagger/audiotagger.dart';
import 'dart:convert';

class CachedSongs {
  static RxList<Song> cachedSongs = RxList([]);
  static RxList<String> checkedFolders = RxList([]);

  static List watchers = [];

  Future<void> _addSong(String path) async {
    if (path.contains(".mp3")) {
      final fileName =
          basename(path).replaceAll('.mp3', '').replaceAll("y2mate.com -", "");

      GeniusProvider(path: path, query: fileName).get(onSuccess: (song) {
        cachedSongs.add(song);
        Get.find<LibraryController>().update();
      });
    }
  }

  init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? songs = prefs.getStringList("found_folders");
    List<String>? folders = prefs.getStringList("checked_folders");
    if (songs != null) {
      print(songs);
      cachedSongs = RxList<Song>(
          songs.map((e) => Song.fromJson(json.decode(e))).toList());
    }
    if (folders != null) {
      checkedFolders = RxList<String>(folders);
      checkedFolders.forEach((element) {
        _watchDir(element);
      });
    }

    _createListeners();
  }

  _watchDir(element) {
    if (!watchers.contains(element) && !Platform.isIOS) {
      watchers.add(element);
      Directory(element).watch().listen((event) {
        if (event.type == FileSystemEvent.delete) {
          cachedSongs
              .removeWhere((element) => element.originalPath == event.path);
          Get.find<LibraryController>().update();
        } else if (event.type == FileSystemEvent.create) {
          _addSong(event.path);
        }
      });
    }
  }

  _createListeners() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var prev = prefs.getStringList('checked_folders') ?? [];

    cachedSongs.listen((p) async {
      prefs.setStringList("found_folders",
          cachedSongs.map((element) => json.encode(element.toJson())).toList());
      await audioHandler
          .updateQueue(MediaLibrary().updateLib()[MediaLibrary.albumsRootId]);
    });

    checkedFolders.listen((folders) async {
      // cachedSongs.removeRange(0, cachedSongs.length);

      folders.forEach((path) {
        print(path);
        print(prev);
        if (!prev.contains(path)) {
          if (Directory(path).existsSync()) {
            final subDir = Directory(path).listSync();

            subDir.forEach((subElement) => _addSong(subElement.path));
          }
          _watchDir(path);
        } else {
          cachedSongs.removeWhere((element) {
            var p = element.originalPath!.split("/");
            p.removeLast();
            return p.join("/") == prev.firstWhere((element) => element == path);
          });
        }
      });
      prev = folders;
      prefs.setStringList("checked_folders", folders);
    });
  }
}
