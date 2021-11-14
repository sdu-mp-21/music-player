import 'package:audio_service/audio_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:getx_app/audio_service/components/control_buttons.dart';
import 'package:getx_app/audio_service/components/mini_control_buttons.dart';
import 'package:getx_app/audio_service/components/seek_bar.dart';
import 'package:getx_app/audio_service/audio_player_handler.dart';
import 'package:getx_app/audio_service/media_state.dart';
import 'package:getx_app/pages/account/library_controller.dart';
import 'package:getx_app/components/sliding_up_panel.dart';
import 'package:getx_app/pages/dashboard/dashboard_page.dart';
import 'package:rxdart/rxdart.dart';

class MusicPlayer extends StatelessWidget {
  Widget bottomNavigationBar;
  Widget body;

  MusicPlayer({required this.bottomNavigationBar, required this.body});

  Stream<Duration> get _bufferedPositionStream => audioHandler.playbackState
      .map((state) => state.bufferedPosition)
      .distinct();
  Stream<Duration?> get _durationStream =>
      audioHandler.mediaItem.map((item) => item?.duration).distinct();
  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          AudioService.position,
          _bufferedPositionStream,
          _durationStream,
          (position, bufferedPosition, duration) => PositionData(
              position, bufferedPosition, duration ?? Duration.zero));

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LibraryController>(builder: (controller) {
      return Material(
          child: Stack(
        children: <Widget>[
          body,
          controller.nowPlaying.length != 0
              ? SlidingUpPanelWidget(
                  child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.6),
                            spreadRadius: 1,
                            blurRadius: 7,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Stack(children: [
                        Positioned(
                          width: MediaQuery.of(context).size.width,
                          height: 30.0,
                          top: 0,
                          child: AnimatedOpacity(
                              opacity: controller.bottomNavOpacity,
                              duration: Duration(milliseconds: 200),
                              child: ListTile(
                                title: Text(controller.nowPlaying["songName"]),
                                subtitle:
                                    Text(controller.nowPlaying["artistName"]),
                                leading: MiniPlayBack(),
                              )),
                        ),
                        Positioned(
                            width: MediaQuery.of(context).size.width,
                            height: 400,
                            top: 0,
                            child: PageView(
                              controller: controller.pageController,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: StreamBuilder<MediaItem?>(
                                        stream: audioHandler.mediaItem
                                            .asBroadcastStream(),
                                        builder: (context, snapshot) {
                                          final mediaItem = snapshot.data;
                                          if (mediaItem == null)
                                            return const SizedBox();
                                          return Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              if (mediaItem.artUri != null)
                                                Expanded(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Center(
                                                      child: Image.network(
                                                          '${mediaItem.artUri!}'),
                                                    ),
                                                  ),
                                                ),
                                              Text(mediaItem.album ?? '',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headline6),
                                              Text(mediaItem.title),
                                            ],
                                          );
                                        },
                                      ),
                                    ),
                                    ControlButtons(audioHandler),
                                    StreamBuilder<PositionData>(
                                      stream: _positionDataStream
                                          .asBroadcastStream(),
                                      builder: (context, snapshot) {
                                        final positionData = snapshot.data ??
                                            PositionData(Duration.zero,
                                                Duration.zero, Duration.zero);
                                        return SeekBar(
                                          duration: positionData.duration,
                                          position: positionData.position,
                                          onChangeEnd: (newPosition) {
                                            audioHandler.seek(newPosition);
                                          },
                                        );
                                      },
                                    ),
                                    const SizedBox(height: 8.0),
                                    // Repeat/shuffle controls
                                    Row(
                                      children: [
                                        StreamBuilder<AudioServiceRepeatMode>(
                                          stream: audioHandler.playbackState
                                              .asBroadcastStream()
                                              .map((state) => state.repeatMode)
                                              .distinct(),
                                          builder: (context, snapshot) {
                                            final repeatMode = snapshot.data ??
                                                AudioServiceRepeatMode.none;
                                            const icons = [
                                              Icon(Icons.repeat,
                                                  color: Colors.grey),
                                              Icon(Icons.repeat,
                                                  color: Colors.orange),
                                              Icon(Icons.repeat_one,
                                                  color: Colors.orange),
                                            ];
                                            const cycleModes = [
                                              AudioServiceRepeatMode.none,
                                              AudioServiceRepeatMode.all,
                                              AudioServiceRepeatMode.one,
                                            ];
                                            final index =
                                                cycleModes.indexOf(repeatMode);
                                            return IconButton(
                                              icon: icons[index],
                                              onPressed: () {
                                                audioHandler.setRepeatMode(
                                                    cycleModes[
                                                        (cycleModes.indexOf(
                                                                    repeatMode) +
                                                                1) %
                                                            cycleModes.length]);
                                              },
                                            );
                                          },
                                        ),
                                        Expanded(
                                          child: Text(
                                            "Playlist",
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline6,
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        StreamBuilder<bool>(
                                          stream: audioHandler.playbackState
                                              .asBroadcastStream()
                                              .map((state) =>
                                                  state.shuffleMode ==
                                                  AudioServiceShuffleMode.all)
                                              .distinct(),
                                          builder: (context, snapshot) {
                                            final shuffleModeEnabled =
                                                snapshot.data ?? false;
                                            return IconButton(
                                              icon: shuffleModeEnabled
                                                  ? const Icon(Icons.shuffle,
                                                      color: Colors.orange)
                                                  : const Icon(Icons.shuffle,
                                                      color: Colors.grey),
                                              onPressed: () async {
                                                final enable =
                                                    !shuffleModeEnabled;
                                                await audioHandler
                                                    .setShuffleMode(enable
                                                        ? AudioServiceShuffleMode
                                                            .all
                                                        : AudioServiceShuffleMode
                                                            .none);
                                              },
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                    // Playlist
                                  ],
                                ),
                                Container(
                                  height: 140.0,
                                  child: StreamBuilder<QueueState>(
                                    stream: audioHandler.queueState
                                        .asBroadcastStream(),
                                    builder: (context, snapshot) {
                                      final queueState =
                                          snapshot.data ?? QueueState.empty;
                                      final queue = queueState.queue;
                                      return ReorderableListView(
                                        onReorder:
                                            (int oldIndex, int newIndex) {
                                          if (oldIndex < newIndex) newIndex--;
                                          audioHandler.moveQueueItem(
                                              oldIndex, newIndex);
                                        },
                                        children: [
                                          for (var i = 0; i < queue.length; i++)
                                            ListTile(
                                              key: Key(queue[i].id),
                                              title: Text(queue[i].title),
                                              onTap: () => audioHandler
                                                  .skipToQueueItem(i),
                                            ),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ))
                      ])),
                  controlHeight: 30.0,
                  panelController: controller.panelController,
                  onTap: () {
                    if (SlidingUpPanelStatus.expanded ==
                        controller.panelController.status) {
                      controller.panelController.collapse();
                    } else {
                      controller.panelController.expand();
                    }
                  },
                  enableOnTap: true,
                  dragUpdate: (u, anim) {
                    controller.setOpacity(anim.value.dy);
                  },
                  onStatusChanged: (status) {
                    if (status == SlidingUpPanelStatus.expanded) {
                      controller.setOpacity(0.0);
                    } else {
                      controller.setOpacity(1.0);
                    }
                  },
                )
              : Container(),
          Align(
              alignment: Alignment.bottomCenter,
              child: AnimatedOpacity(
                  opacity: controller.bottomNavOpacity,
                  duration: Duration(milliseconds: 200),
                  child: Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.6),
                            spreadRadius: 1,
                            blurRadius: 7,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: bottomNavigationBar))),
        ],
      ));
    });
  }
}
