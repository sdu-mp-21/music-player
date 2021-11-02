import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'account_controller.dart';

class AccountPage extends GetView<AccountController> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AccountController>(builder: (controller) {
      return Scaffold(
        body: ListView.builder(
            itemCount: controller.getLength(),
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(controller.getItem(index)),
              );
            }),
      );
    });
  }
}
