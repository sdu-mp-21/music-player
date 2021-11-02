import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home_controller.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(builder: (controller) {
      return Scaffold(
          appBar: AppBar(
            title: Text("SETTINGS"),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
          ),
          body: Container(
              child: Center(
                  child: ElevatedButton(
            child: Text("Select folder"),
            onPressed: () {
              showModalBottomSheet<void>(
                context: context,
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                builder: (BuildContext context) {
                  return GetBuilder<HomeController>(builder: (controller) {
                    return WillPopScope(
                        onWillPop: () async {
                          if (controller.willPopUp()) {
                            Navigator.pop(context);
                          }
                          return false;
                        },
                        child: Scaffold(
                            appBar: AppBar(
                                title: Text(controller.dd.last),
                                actions: [
                                  Container(
                                      padding: EdgeInsets.only(right: 25),
                                      child: IconButton(
                                          color: Colors.green,
                                          onPressed: () async {
                                            Navigator.pop(context);
                                            final prefs =
                                                await SharedPreferences
                                                    .getInstance();
                                            prefs.setStringList(
                                                "checked_folders",
                                                controller.checkedFolders);
                                          },
                                          icon: Icon(
                                              CupertinoIcons.checkmark_alt)))
                                ],
                                leading: IconButton(
                                    icon: Icon(
                                      Icons.arrow_back_sharp,
                                      color: Colors.grey,
                                    ),
                                    onPressed: controller.goBack)),
                            body: Container(
                                child: ListView.builder(
                                    padding: EdgeInsets.all(20),
                                    itemCount: controller.items.length,
                                    itemBuilder: (context, index) {
                                      return GestureDetector(
                                        onTap: () {
                                          controller.openDirectory(
                                              controller.items[index].path);
                                        },
                                        child: ListTile(
                                            leading:
                                                Icon(CupertinoIcons.folder),
                                            title: Text(
                                              controller.items[index].path
                                                  .replaceAll(
                                                      controller.initialPath,
                                                      ""),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            trailing: Checkbox(
                                              value: controller.checkedFolders
                                                  .contains(controller
                                                      .items[index].path),
                                              onChanged: (changed) {
                                                controller.toggleCheckFolder(
                                                    changed!,
                                                    controller
                                                        .items[index].path);
                                              },
                                            )),
                                      );
                                    }))));
                  });
                },
              );
            },
          ))));
    });
  }
}
