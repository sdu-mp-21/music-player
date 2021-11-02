import 'package:get/get.dart';

class DashboardController extends GetxController {
  var tabIndex = 0;
  List<String> tabNames = ["Home", "News", "Alerts", "Account"];

  void changeTabIndex(int index) {
    tabIndex = index;
    update();
  }

  String getActiveTabName() {
    return tabNames.elementAt(this.tabIndex);
  }
}
