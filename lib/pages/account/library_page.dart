import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_app/globals/player_state.dart';

import 'library_controller.dart';

class LibraryPage extends GetView<LibraryController> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<LibraryController>(builder: (controller) {
      return Scaffold(
        body: ListView.builder(
            itemCount: controller.getLength(),
            itemBuilder: (context, index) {
              return ListTile(
                onTap: () {
                  controller.setPlaying(index);
                },
                title: Text(controller.getItem(index)),
              );
            }),
      );
    });
  }
}
