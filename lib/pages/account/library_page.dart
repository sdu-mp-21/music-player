import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_app/audio_service/audio_player_handler.dart';
import 'package:getx_app/components/loading_overlay.dart';
import 'package:getx_app/audio_service/media_state.dart';
import 'package:getx_app/components/search_bar.dart';
import 'package:getx_app/globals/cached_music.dart';
import 'package:getx_app/globals/settings.dart';
import 'package:getx_app/pages/dashboard/components/song_item.dart';

import 'library_controller.dart';

class LibraryPage extends GetView<LibraryController> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<LibraryController>(builder: (controller) {
      return GestureDetector(
          onTap: FocusManager.instance.primaryFocus?.unfocus,
          child: Stack(
            children: [
              SearchBar(
                  hintText: "Search...", onChanged: controller.handleSearchBar),
              Container(
                  margin: EdgeInsets.only(top: 100),
                  child: StreamBuilder<QueueState>(
                    stream: audioHandler.queueState,
                    builder: (context, snapshot) {
                      final queueState = snapshot.data ?? QueueState.empty;
                      final queue = queueState.queue;

                      return ReorderableListView(
                        padding: EdgeInsets.only(
                          top: 10,
                        ),
                        onReorder: (int oldIndex, int newIndex) {
                          if (oldIndex < newIndex) newIndex--;
                          audioHandler.moveQueueItem(oldIndex, newIndex);
                        },
                        children: [
                          for (var i = 0; i < queue.length; i++)
                            controller.hasValue(queue[i].title) ||
                                    controller.hasValue(queue[i].album!)
                                ? Container(
                                    key: Key(i.toString()),
                                    child: SongItem(
                                        onTap: () {
                                          controller.setPlaying(i);
                                        },
                                        index: i,
                                        title: queue[i].album!,
                                        artUri: queue[i].artUri!,
                                        artist: queue[i].artist!))
                                : Container(
                                    key: Key(i.toString()),
                                  )
                        ],
                      );
                    },
                  ))
            ],
          ));
    });
  }
}


/**
 * [
                          for (var i = 0; i < queue.length; i++)
                            controller.hasValue(queue[i].title) ||
                                    controller.hasValue(queue[i].album!)
                                ? Container(
                                    key: Key(i.toString()),
                                    child: SongItem(
                                        onTap: () {
                                          controller.setPlaying(i);
                                        },
                                        index: i,
                                        title: queue[i].album!,
                                        artUri: queue[i].artUri!,
                                        artist: queue[i].artist!))
                                : Container(
                                    key: Key(i.toString()),
                                  )
                        ]
 */