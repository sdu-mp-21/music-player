import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:getx_app/pages/account/library_controller.dart';
import 'package:getx_app/components/sliding_up_panel.dart';
import 'package:getx_app/pages/dashboard/dashboard_page.dart';

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
          SlidingUpPanelWidget(
            child: Container(
              color: Colors.amberAccent,
              child: Column(
                children: <Widget>[
                  Container(
                      alignment: Alignment.center,
                      child: Text(
                        controller.nowPlaying,
                        style: TextStyle(fontSize: 16),
                        overflow: TextOverflow.ellipsis,
                      )),
                ],
                mainAxisSize: MainAxisSize.min,
              ),
            ),
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
          ),
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
