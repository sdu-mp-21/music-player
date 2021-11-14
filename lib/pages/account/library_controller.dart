import 'dart:ffi';
import 'dart:io';

import 'package:flutter/animation.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:getx_app/audio_service/audio_player_handler.dart';
import 'package:getx_app/audio_service/media_state.dart';
import 'package:getx_app/pages/dashboard/components/music_player.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:getx_app/audio_service/media_state.dart';

import 'library_provider.dart';
import 'package:getx_app/globals/settings.dart';
import 'package:getx_app/components/sliding_up_panel.dart';
import 'package:audioplayers/audioplayers.dart';

class LibraryController extends GetxController
    with SingleGetTickerProviderMixin {
  AudioPlayer audioPlayer = AudioPlayer();

  ScrollController scrollController = ScrollController();
  PageController pageController = PageController(initialPage: 0);
  SlidingUpPanelController panelController = SlidingUpPanelController();

  final checkedFolders = Settings.checkedFolders;
  final foundFiles = Settings.cachedSongs;

  double bottomNavOpacity = 1.0;

  Map<String, dynamic> nowPlaying = {};

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
        pageController.jumpToPage(0);
      } else {}
    });
    super.onInit();
  }

  play(path) async {}

  loading() {
    return Settings.isLoading;
  }

  getLength() {
    return foundFiles.length;
  }

  Map<String, dynamic> getItem(index) {
    return foundFiles[index];
  }

  setPlaying(index) async {
    await audioHandler
        .updateQueue(MediaLibrary().updateLib()[MediaLibrary.albumsRootId]);

    nowPlaying = foundFiles[index];

    update();
    audioHandler.skipToQueueItem(index);
  }

  setOpacity(val) {
    bottomNavOpacity = val;
    update();
  }
}
