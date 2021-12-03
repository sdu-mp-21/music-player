import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:getx_app/audio_service/components/mini_control_buttons.dart';
import 'package:getx_app/audio_service/media_state.dart';
import 'package:getx_app/pages/dashboard/components/music_control.dart';
import 'package:getx_app/pages/dashboard/components/music_player_controller.dart';
import 'package:getx_app/pages/dashboard/components/queue_list.dart';
import 'music_control.dart';
import 'dart:ui';
import 'package:getx_app/components/bottom_sheet.dart' as Custom;

class _ModalBottomSheetLayout extends SingleChildLayoutDelegate {
  _ModalBottomSheetLayout(this.progress, this.op);

  final double progress;
  final double op;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    return BoxConstraints(
        minWidth: constraints.maxWidth,
        maxWidth: constraints.maxWidth,
        maxHeight: constraints.maxHeight);
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    return Offset(
        0.0,
        size.height -
            childSize.height * progress -
            kBottomNavigationBarHeight * 2 * op -
            8);
  }

  @override
  bool shouldRelayout(_ModalBottomSheetLayout oldDelegate) {
    return progress != oldDelegate.progress;
  }
}

class MusicPlayer extends StatelessWidget {
  Widget bottomNavigationBar;
  Widget body;

  MusicPlayer({required this.bottomNavigationBar, required this.body});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MusicPlayerController>(builder: (controller) {
      Color color = Theme.of(context).primaryColor;

      return Scaffold(
        body: Stack(children: [
          body,
          AnimatedBuilder(
            animation: controller.animation,
            child: Custom.BottomSheet(
              enableDrag: controller.canDrag,
              animationController: controller.animationController,
              onClosing: () {},
              builder: (bcontext) {
                return Stack(children: [
                  StreamBuilder<MediaItem?>(
                      stream: audioHandler.mediaItem,
                      builder: (context, snapshot) {
                        final mediaItem = snapshot.data;
                        return Container(
                          height: window.physicalSize.height,
                          decoration: BoxDecoration(
                            color: color,
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              opacity: 0.9,
                              image: NetworkImage(
                                mediaItem != null
                                    ? mediaItem.artUri.toString()
                                    : 'assets/placeholder.png',
                              ),
                            ),
                          ),
                          child: ClipRRect(
                            // Clip it cleanly.
                            child: BackdropFilter(
                                filter:
                                    ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                child: PageView(
                                  controller: controller.pageController,
                                  children: [
                                    MusicControl(audioHandler),
                                    QueueList(audioHandler)
                                  ],
                                )),
                          ),
                        );
                      }),
                  AnimatedOpacity(
                      duration: Duration(milliseconds: 100),
                      opacity: controller.opacity,
                      child: StreamBuilder<MediaItem?>(
                          stream: audioHandler.mediaItem,
                          builder: (context, snapshot) {
                            final mediaItem = snapshot.data;
                            if (mediaItem == null) return const SizedBox();
                            return Container(
                                color: color,
                                child: Stack(children: [
                                  ListTile(
                                    dense: true,
                                    title: Text(
                                      mediaItem.album!,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    subtitle: Text(
                                      mediaItem.artist!,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    trailing: MiniPlayBack(),
                                  )
                                ]));
                          })),
                ]);
              },
            ),
            builder: (BuildContext context, Widget? child) {
              return Semantics(
                scopesRoute: true,
                namesRoute: true,
                explicitChildNodes: true,
                child: ClipRect(
                  child: CustomSingleChildLayout(
                    delegate: _ModalBottomSheetLayout(
                        controller.animationController.value,
                        controller.opacity),
                    child: child,
                  ),
                ),
              );
            },
          ),
          AnimatedOpacity(
              duration: Duration(milliseconds: 100),
              opacity: controller.opacity,
              child: Align(
                  alignment: Alignment.bottomCenter,
                  child: bottomNavigationBar))
        ]),
      );
    });
  }
}
/**
 * import 'package:audio_service/audio_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:getx_app/audio_service/components/mini_control_buttons.dart';
import 'package:getx_app/audio_service/media_state.dart';
import 'package:getx_app/globals/cached_music.dart';
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
      Color color = Theme.of(context).primaryColor;

      return Material(
          child: Stack(
        children: <Widget>[
          body,
          controller.nowPlaying != null
              ? SlidingUpPanelWidget(
                  child: Container(
                      decoration: BoxDecoration(
                        color: color,
                        boxShadow: [
                          BoxShadow(
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20)),
                      ),
                      child: Stack(children: [
                        AnimatedOpacity(
                          opacity: 1.0 - controller.bottomNavOpacity,
                          duration: Duration(milliseconds: 200),
                          child: Container(
                              height: MediaQuery.of(context).size.height / 15,
                              child: Center(
                                child: Icon(CupertinoIcons.chevron_down),
                              )),
                        ),
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
                                    dense: true,
                                    title: Text(
                                      mediaItem.album!,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    subtitle: Text(
                                      mediaItem.artist!,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
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
                      controller.offsetController.animateTo(0.13);
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
                  duration: Duration(milliseconds: 300),
                  child: bottomNavigationBar)),
        ],
      ));
    });
  }
}

 */
