import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_app/pages/home/home_controller.dart';

class Modal {
  build(context) {
    return showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return GetBuilder<HomeController>(builder: (controller) {
          return WillPopScope(
              onWillPop: () async {
                if (controller.willPopUp()) {
                  Navigator.pop(context);
                }
                return false;
              },
              child: Container(
                  decoration: BoxDecoration(
                      border: Border(top: BorderSide(color: Colors.white10))),
                  child: Scaffold(
                      appBar: AppBar(
                          title: Text(controller.dd.last),
                          leading: IconButton(
                              icon: Icon(
                                Icons.arrow_back_sharp,
                                color: Colors.grey,
                              ),
                              enableFeedback: true,
                              splashColor: Colors.grey,
                              highlightColor: Colors.transparent,
                              splashRadius: 20,
                              onPressed: controller.goBack)),
                      body: Center(
                          child: ListView.builder(
                              padding: EdgeInsets.all(20),
                              itemCount: controller.items.length,
                              itemBuilder: (context, index) {
                                return InkWell(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                    enableFeedback: true,
                                    splashFactory: InkRipple.splashFactory,
                                    radius: 250,
                                    highlightColor: Colors.transparent,
                                    onTap: () {
                                      controller.addDirectory(
                                          controller.items[index].path);
                                    },
                                    child: ListTile(
                                      leading: Icon(CupertinoIcons.folder),
                                      title: Text(
                                        controller.items[index].path.replaceAll(
                                            controller.initialPath, ""),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      trailing:
                                          Icon(CupertinoIcons.chevron_forward),
                                    ));
                              })))));
        });
      },
    );
  }
}
