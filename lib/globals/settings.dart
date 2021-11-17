import 'dart:io';

import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/state_manager.dart';
import 'package:getx_app/globals/cached_music.dart';
import 'package:getx_app/library/genius_provider.dart';
import 'package:getx_app/pages/account/library_controller.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart';
import 'package:audiotagger/audiotagger.dart';
import 'dart:convert';

class Settings extends GetxController {
  static init() async {
    CachedSongs().init();
  }
}
