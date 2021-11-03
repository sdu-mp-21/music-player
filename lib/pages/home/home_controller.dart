import 'package:get/get.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'dart:collection';
import 'package:shared_preferences/shared_preferences.dart';

class HomeController extends GetxController {
  List<FileSystemEntity> items = [];
  List<String> checkedFolders = [];
  DoubleLinkedQueue dd = new DoubleLinkedQueue();
  String initialPath = Platform.isIOS ? './' : '/storage/emulated/0';

  double pos = 100;

  void toggleCheckFolder(bool remove, String path) {
    if (remove) {
      checkedFolders.add(path);
    } else {
      checkedFolders.remove(path);
    }

    update();
  }

  @override
  void onInit() async {
    dd.add(initialPath);
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getStringList("checked_folders") != null) {
      checkedFolders = prefs.getStringList("checked_folders")!;
    }
    Directory dir = Directory(initialPath);
    await Permission.manageExternalStorage.request().isGranted;

    items.addAll(dir.listSync());

    update();
    super.onInit();
  }

  setPosition(newPos) {
    if (newPos > 100) {
      pos = newPos;
      update();
    }
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
    openDirectory(path);
    dd.add(path);
  }

  openDirectory(path) {
    Directory dir = Directory(path);
    try {
      items.clear();
      items.addAll(dir.listSync());
    } catch (e) {
      print(e);
    }

    print(items);
    update();
  }
}
