import 'dart:io';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountController extends GetxController {
  List<String> checkedFolders = [];
  List<String> foundFiles = [];

  void updateFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList("checked_folders");
    final temp = <String>[];
    if (list != null) {
      for (var i = 0; i < list.length; i++) {
        List<FileSystemEntity> dir = Directory(list[i]).listSync();
        for (var k = 0; k < dir.length; k++) {
          if (dir[k].path.endsWith(".mp3")) {
            temp.add(dir[k].path);
          }
        }
      }
      foundFiles = temp;
      update();
    }
  }

  @override
  void onInit() async {
    updateFromStorage();
    super.onInit();
  }

  getLength() {
    updateFromStorage();
    return foundFiles.length;
  }

  getItem(index) {
    return foundFiles[index];
  }
}
