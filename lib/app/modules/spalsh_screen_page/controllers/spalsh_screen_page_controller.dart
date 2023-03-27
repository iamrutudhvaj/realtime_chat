import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:realtime_chat/app/routes/app_pages.dart';

import '../../../controller/app_controller.dart';

class SpalshScreenPageController extends GetxController {
  final appController = Get.put<AppController>(AppController());

  final count = 0.obs;
  @override
  void onInit() {
    Timer(const Duration(seconds: 1), () {
      if (FirebaseAuth.instance.currentUser != null) {
        Get.toNamed(Routes.HOME);
      } else {
        Get.toNamed(Routes.LOGIN_PAGE);
      }
    });
    super.onInit();
  }

  void increment() => count.value++;
}
