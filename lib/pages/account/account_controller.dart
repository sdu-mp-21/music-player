import 'dart:io';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountController extends GetxController {
  RxList<String> checkedFolders = <String>[].obs;
  RxList<String> foundFiles = <String>[].obs;

  void updateFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList("checked_folders");
    print(list);
    if (list != null) {
      checkedFolders = RxList<String>(list);

      for (var i = 0; i < list.length; i++) {
        List<FileSystemEntity> dir = Directory(list[i]).listSync();
        for (var k = 0; k < dir.length; k++) {
          if (dir[k].path.endsWith(".mp3")) {
            if (!foundFiles.contains(dir[k].path)) foundFiles.add(dir[k].path);
          }
        }
      }
    }
  }

  @override
  void onInit() async {
    updateFromStorage();
    super.onInit();
  }

  getLength() {
    updateFromStorage();
    update();
    return foundFiles.length;
  }

  getItem(index) {
    updateFromStorage();
    return foundFiles[index];
  }
}
