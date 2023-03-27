import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:realtime_chat/app/core/constant/colors.dart';

import '../controllers/chat_page_controller.dart';
import 'chat_list.dart';
import 'input_widget.dart';

class ChatPageView extends GetView<ChatPageController> {
  const ChatPageView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          controller.peerUserData.name,
          style: const TextStyle(color: AppColor.primaryColor),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: WillPopScope(
          onWillPop: controller.onBackPress,
          child: Stack(
            children: <Widget>[
              Column(
                children: const <Widget>[
                  // List of messages
                  ChatList(),

                  // Input content
                  InputWidget(),
                ],
              ),

              // Loading
              const LoadingView()
            ],
          ),
        ),
      ),
    );
  }
}

class LoadingView extends GetView<ChatPageController> {
  const LoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading) {
        return Container(
          color: Colors.white.withOpacity(0.8),
          child: const Center(
            child: CircularProgressIndicator(
              color: AppColor.themeColor,
            ),
          ),
        );
      } else {
        return const SizedBox.shrink();
      }
    });
  }
}
