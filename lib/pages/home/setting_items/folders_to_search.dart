import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_app/components/bottom_navigation_bar.dart';
import 'package:getx_app/globals/cached_music.dart';
import 'package:getx_app/globals/settings.dart';
import 'package:getx_app/pages/home/settings_controller.dart';
import 'package:path/path.dart';

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
                      return false;
                    },
                    child: Scaffold(
                      appBar: AppBar(
                        title: Text(controller.dd.last),
                        actions: [
                          CachedSongs.isLoading
                              ? Center(
                                  child: Container(
                                      width: 16,
                                      height: 16,
                                      margin: EdgeInsets.only(right: 30),
                                      child: CircularProgressIndicator()),
                                )
                              : Container()
                        ],
                      ),
                      body: Container(
                          color: Theme.of(context).primaryColor,
                          child: ListView.builder(
                              padding: EdgeInsets.all(20),
                              itemCount: controller.items.length,
                              itemBuilder: (context, index) {
                                final path = controller.items[index].path;
                                final name =
                                    basename(controller.items[index].path);
                                return GestureDetector(
                                  onTap: () => controller.addDirectory(path),
                                  child: ListTile(
                                      leading: FutureBuilder(
                                        future: controller.getIcon(path),
                                        initialData: CupertinoIcons.app,
                                        builder: (context,
                                                AsyncSnapshot<IconData> icon) =>
                                            Icon(icon.data),
                                      ),
                                      title: Text(
                                        name,
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
                                                    if (!CachedSongs.isLoading)
                                                      controller
                                                          .toggleCheckFolder(
                                                              changed!, path);
                                                  },
                                                )
                                              : Text(extension(path));
                                        },
                                      )),
                                );
                              })),
                      bottomNavigationBar: Container(
                          child: CustomBottomNavigationBar(
                        onTap: (i) {
                          if (controller.dd.length == 1) Navigator.pop(context);
                          if (i == 0)
                            controller.goBack();
                          else if (i == 1) Navigator.pop(context);
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
