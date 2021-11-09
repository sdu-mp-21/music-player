import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'settings_controller.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingsController>(builder: (controller) {
      return Scaffold(
          appBar: AppBar(
            title: Text("SETTINGS"),
          ),
          body: ListView.builder(
              itemCount: controller.settingsItems.length,
              itemBuilder: (context, index) {
                return controller.settingsItems[index];
              }));
    });
  }
}
