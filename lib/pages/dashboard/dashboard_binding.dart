import 'package:get/get.dart';
import 'package:getx_app/globals/settings.dart';
import 'package:getx_app/pages/account/library_controller.dart';
import 'package:getx_app/pages/dashboard/components/music_player_controller.dart';
import 'package:getx_app/pages/home/settings_controller.dart';

import 'dashboard_controller.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<Settings>(() => Settings());
    Get.lazyPut<DashboardController>(() => DashboardController());
    Get.lazyPut<SettingsController>(() => SettingsController());
    Get.lazyPut<LibraryController>(() => LibraryController());
    Get.lazyPut<MusicPlayerController>(() => MusicPlayerController());
  }
}
