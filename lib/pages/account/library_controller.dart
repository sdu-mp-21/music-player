import 'dart:ffi';
import 'dart:io';

import 'package:flutter/animation.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:getx_app/globals/player_state.dart';
import 'package:getx_app/pages/dashboard/components/music_player.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_media_metadata/flutter_media_metadata.dart';
import 'package:getx_app/globals/player_state.dart';

import 'library_provider.dart';
import 'package:getx_app/components/sliding_up_panel.dart';

class LibraryController extends GetxController
    with SingleGetTickerProviderMixin {
  ScrollController scrollController = ScrollController();
  SlidingUpPanelController panelController = SlidingUpPanelController();

  final checkedFolders = [];
  final foundFiles = [];

  double bottomNavOpacity = 0.1;

  String nowPlaying = "";

  @override
  void onInit() async {
    scrollController.addListener(() {
      if (scrollController.offset >=
              scrollController.position.maxScrollExtent &&
          !scrollController.position.outOfRange) {
        panelController.expand();
      } else if (scrollController.offset <=
              scrollController.position.minScrollExtent &&
          !scrollController.position.outOfRange) {
        panelController.anchor();
      } else {}
    });
    super.onInit();
  }

  getLength() {
    return foundFiles.length;
  }

  getItem(index) {
    return foundFiles[index];
  }

  setPlaying(index) {
    nowPlaying = foundFiles[index];
    update();
  }

  setOpacity(val) {
    bottomNavOpacity = val;
    update();
  }
}
