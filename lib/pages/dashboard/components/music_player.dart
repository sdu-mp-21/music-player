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
import 'package:getx_app/pages/dashboard/components/music_control.dart';
import 'package:getx_app/pages/dashboard/dashboard_page.dart';
import 'package:rxdart/rxdart.dart';
import 'music_control.dart';

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
                        AnimatedOpacity(
                            opacity: controller.bottomNavOpacity,
                            duration: Duration(milliseconds: 200),
                            child: ListTile(
                              title: Text(controller.nowPlaying["songName"]),
                              subtitle:
                                  Text(controller.nowPlaying["artistName"]),
                              leading: MiniPlayBack(),
                            )),
                        SlideTransition(
                            position: controller.offsetAnimation,
                            child: Container(
                                child: PageView(
                              controller: controller.pageController,
                              onPageChanged: (s) {
                                controller.update();
                              },
                              children: [
                                MusicControl(),
                                Container(
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
                                              key: Key(i.toString()),
                                              title: Text(queue[i].title),
                                              onTap: () {
                                                audioHandler.skipToQueueItem(i);
                                                controller.update();
                                              },
                                            ),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              ],
                            )))
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
                      controller.offsetController.animateTo(0.0);
                      controller.setOpacity(0.0);
                    } else {
                      controller.offsetController.animateTo(0.2);
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
