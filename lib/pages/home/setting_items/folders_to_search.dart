import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_app/components/bottom_navigation_bar.dart';
import 'package:getx_app/pages/home/settings_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FolderSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingsController>(builder: (controller) {
      return ListTile(
        title: Text("Select folder to search"),
        onTap: () {
          showCupertinoModalPopup<void>(
            context: context,
            builder: (BuildContext context) {
              return GetBuilder<SettingsController>(builder: (controller) {
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
                      ),
                      body: Container(
                          child: ListView.builder(
                              padding: EdgeInsets.all(20),
                              itemCount: controller.items.length,
                              itemBuilder: (context, index) {
                                final path = controller.items[index].path;
                                return GestureDetector(
                                  onTap: () => controller.addDirectory(path),
                                  child: ListTile(
                                      leading: FutureBuilder(
                                        future: controller.getIcon(path),
                                        initialData: CupertinoIcons.placemark,
                                        builder: (context,
                                                AsyncSnapshot<IconData> icon) =>
                                            Icon(icon.data),
                                      ),
                                      title: Text(
                                        path.replaceAll(
                                            controller.initialPath, ""),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      trailing: FutureBuilder(
                                        future: controller.showCheckBox(path),
                                        initialData: false,
                                        builder: (context,
                                            AsyncSnapshot<bool> show) {
                                          return show.data!
                                              ? Checkbox(
                                                  value: controller
                                                      .checkedFolders
                                                      .contains(path),
                                                  onChanged: (changed) {
                                                    controller
                                                        .toggleCheckFolder(
                                                            changed!, path);
                                                  },
                                                )
                                              : Text("");
                                        },
                                      )),
                                );
                              })),
                      bottomNavigationBar: Container(
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: Offset(0, 3),
                                ),
                              ],
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20))),
                          child: CustomBottomNavigationBar(
                            onTap: (i) {
                              if (i == 0) {
                                if (controller.dd.length == 1) {
                                  Navigator.pop(context);
                                }
                                controller.goBack();
                              } else if (i == 1) {
                                Navigator.pop(context);
                              }
                            },
                            items: [
                              BottomNavigationBarItem(
                                icon: Icon(CupertinoIcons.chevron_left),
                              ),
                              BottomNavigationBarItem(
                                icon: Icon(CupertinoIcons.chevron_down),
                              ),
                            ],
                          )),
                    ));
              });
            },
          );
        },
      );
    });
  }
}
