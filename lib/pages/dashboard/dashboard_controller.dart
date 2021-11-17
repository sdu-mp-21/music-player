import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashboardController extends GetxController
    with SingleGetTickerProviderMixin {
  var tabIndex = 0;
  late AnimationController animationController;
  late Animation bottomBarAnim;

  @override
  void onInit() {
    animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 3));

    bottomBarAnim = Tween(begin: 50.0, end: 0).animate(animationController);
    super.onInit();
  }

  void changeTabIndex(int index) {
    tabIndex = index;
    update();
  }
}
