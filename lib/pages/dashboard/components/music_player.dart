import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:getx_app/audio_service/components/mini_control_buttons.dart';
import 'package:getx_app/audio_service/media_state.dart';
import 'package:getx_app/pages/account/library_controller.dart';
import 'package:getx_app/components/sliding_up_panel.dart';
import 'package:getx_app/pages/dashboard/components/music_control.dart';
import 'package:getx_app/pages/dashboard/components/queue_list.dart';
import 'music_control.dart';

class MusicPlayer extends StatelessWidget {
  Widget bottomNavigationBar;
  Widget body;

  MusicPlayer({required this.bottomNavigationBar, required this.body});

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
                            child: StreamBuilder<MediaItem?>(
                                stream: audioHandler.mediaItem,
                                builder: (context, snapshot) {
                                  final mediaItem = snapshot.data;
                                  if (mediaItem == null)
                                    return const SizedBox();
                                  return ListTile(
                                    title: Text(mediaItem.title),
                                    subtitle: Text(mediaItem.artist!),
                                    leading: MiniPlayBack(),
                                  );
                                })),
                        SlideTransition(
                            position: controller.offsetAnimation,
                            child: Container(
                                child: PageView(
                              controller: controller.pageController,
                              children: [
                                MusicControl(audioHandler),
                                QueueList(audioHandler)
                              ],
                            )))
                      ])),
                  controlHeight: 30.0,
                  panelController: controller.panelController,
                  onTap: () {},
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
