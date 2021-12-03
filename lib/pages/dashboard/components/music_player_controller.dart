import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MusicPlayerController extends GetxController
    with SingleGetTickerProviderMixin {
  late Animation<Offset> animation;
  double opacity = 1.0;
  int currentPage = 0;
  bool canDrag = true;
  PageController pageController = PageController(initialPage: 0);

  late AnimationController animationController;
  @override
  void onInit() {
    pageController.addListener(() {
      if (pageController.page == 0)
        canDrag = true;
      else
        canDrag = false;
      update();
    });
    animationController = AnimationController(
        duration: Duration(milliseconds: 200),
        debugLabel: 'SlidingUpPanelWidget',
        vsync: this,
        value: 0);

    animation = animationController.drive(
      Tween(begin: Offset(0.0, 1.0), end: Offset.zero).chain(
        CurveTween(
          curve: Curves.easeInOutBack,
        ),
      ),
    );

    animationController.addListener(() {
      opacity = 1.0 - animationController.value;
      update();
    });

    super.onInit();
  }
}
