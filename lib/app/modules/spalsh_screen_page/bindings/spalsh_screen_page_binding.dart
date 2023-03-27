import 'package:get/get.dart';

import '../controllers/spalsh_screen_page_controller.dart';

class SpalshScreenPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<SpalshScreenPageController>(
      SpalshScreenPageController(),
    );
  }
}
