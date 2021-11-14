import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'dart:collection';
import 'package:shared_preferences/shared_preferences.dart';
import 'setting_items/index.dart' as SettingItems;
import 'package:getx_app/globals/settings.dart';

class SettingsController extends GetxController {
  final checkedFolders = Settings.checkedFolders;
  List<FileSystemEntity> items = [];
  List<StatelessWidget> settingsItems = [];
  DoubleLinkedQueue dd = new DoubleLinkedQueue();
  String initialPath = Platform.isIOS ? './' : '/storage/emulated/0';

  void toggleCheckFolder(bool willCheck, String path) {
    if (willCheck) {
      checkedFolders.add(path);
    } else {
      checkedFolders.remove(path);
    }

    update();
  }

  @override
  void onInit() async {
    await Permission.manageExternalStorage.request().isGranted;

    dd.add(initialPath);

    Directory dir = Directory(initialPath);
    items.addAll(dir.listSync());

    {
      settingsItems.add(SettingItems.FolderSelector());
    }

    update();
    super.onInit();
  }

  goBack() {
    if (dd.length > 1) {
      dd.removeLast();
      openDirectory(dd.last);
    } else {
      openDirectory(initialPath);
    }
  }

  willPopUp() {
    if (dd.length <= 1) {
      return true;
    } else {
      goBack();
    }
  }

  addDirectory(path) {
    if (FileSystemEntity.isDirectorySync(path)) {
      openDirectory(path);
      dd.add(path);
      print(dd);
    }
  }

  openDirectory(path) {
    Directory dir = Directory(path);
    try {
      items.clear();
      items.addAll(dir.listSync());
    } catch (e) {
      print(e);
    }

    update();
  }

  Future<IconData> getIcon(String path) async {
    var type = await FileSystemEntity.type(path);
    if (type == FileSystemEntityType.directory) {
      return CupertinoIcons.folder;
    } else if (type == FileSystemEntityType.file) {
      return CupertinoIcons.square_fill_on_square_fill;
    }
    return CupertinoIcons.question;
  }

  Future<bool> showCheckBox(path) async {
    var type = await FileSystemEntity.type(path);
    return type == FileSystemEntityType.directory;
  }
}
