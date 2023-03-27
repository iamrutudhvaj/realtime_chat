import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:realtime_chat/app/core/constant/colors.dart';

import '../controllers/spalsh_screen_page_controller.dart';

class SpalshScreenPageView extends GetView<SpalshScreenPageController> {
  const SpalshScreenPageView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("assets/logo.gif"),
          const SizedBox(
            height: 20,
          ),
          const Text(
            "Chat App",
            style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                decorationStyle: TextDecorationStyle.solid,
                leadingDistribution: TextLeadingDistribution.proportional,
                decoration: TextDecoration.underline),
          )
        ],
      )),
    );
  }
}
