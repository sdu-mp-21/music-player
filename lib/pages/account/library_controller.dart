import 'dart:ffi';
import 'dart:io';

import 'package:flutter/animation.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:getx_app/audio_service/audio_player_handler.dart';
import 'package:getx_app/audio_service/media_state.dart';
import 'package:getx_app/globals/cached_music.dart';
import 'package:getx_app/models/song.dart';
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
  String searchQuery = "";

  ScrollController scrollController = ScrollController();
  PageController pageController = PageController(initialPage: 0);
  SlidingUpPanelController panelController = SlidingUpPanelController();

  late final AnimationController offsetController = AnimationController(
      duration: const Duration(milliseconds: 400), vsync: this, value: 0.3);
  late final Animation<Offset> offsetAnimation = Tween<Offset>(
    begin: Offset.zero,
    end: const Offset(0.0, 1.5),
  ).animate(CurvedAnimation(
    parent: offsetController,
    curve: Curves.easeIn,
  ));

  final checkedFolders = CachedSongs.checkedFolders;
  final foundFiles = CachedSongs.cachedSongs;

  double bottomNavOpacity = 1.0;

  Song? nowPlaying;

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

  loading() {
    return false;
  }

  getLength() {
    return foundFiles.length;
  }

  hasValue(String value) {
    if (searchQuery.length == 0) {
      return true;
    }

    if (value.toLowerCase().contains(searchQuery)) {
      return true;
    }

    return false;
  }

  Song? getItem(index) {
    if (searchQuery.length == 0) {
      return foundFiles[index];
    }

    if (foundFiles[index].artist!.toLowerCase().contains(searchQuery) ||
        foundFiles[index].title!.toLowerCase().contains(searchQuery)) {
      return foundFiles[index];
    }
  }

  handleSearchBar(String value) {
    searchQuery = value;
    update();
  }

  setPlaying(index) async {
    await audioHandler.skipToQueueItem(index);

    nowPlaying = foundFiles[index];

    update();
  }

  setOpacity(val) {
    bottomNavOpacity = val;
    update();
  }
}
