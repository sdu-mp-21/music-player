import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_app/pages/account/library_controller.dart';
import 'package:getx_app/pages/account/library_page.dart';
import 'package:getx_app/pages/dashboard/components/music_player.dart';
import 'package:getx_app/pages/home/settings_page.dart';
import 'package:getx_app/components/bottom_navigation_bar.dart';
import 'package:getx_app/globals/player_state.dart';
import 'dashboard_controller.dart';

class DashboardPage extends StatelessWidget {
  IndexedStack getStack(tabIndex) {
    return IndexedStack(
      index: tabIndex,
      children: [LibraryPage(), SettingsPage()],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DashboardController>(builder: (controller) {
      return MusicPlayer(
          body: Container(child: this.getStack(controller.tabIndex)),
          bottomNavigationBar: CustomBottomNavigationBar(
            onTap: controller.changeTabIndex,
            currentIndex: controller.tabIndex,
            items: [
              BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.music_albums),
                  activeIcon: Icon(CupertinoIcons.music_albums_fill)),
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.gear_alt),
                activeIcon: Icon(CupertinoIcons.gear_alt_fill),
              )
            ],
          ));
    });
  }
}
