import 'dart:io';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_media_metadata/flutter_media_metadata.dart';

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
