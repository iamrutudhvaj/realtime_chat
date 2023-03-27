import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:realtime_chat/app/modules/chat_page/controllers/chat_page_controller.dart';

import '../../../core/constant/colors.dart';

class InputWidget extends GetView<ChatPageController> {
  const InputWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final FocusNode focusNode = FocusNode();
    return Container(
      width: double.infinity,
      height: 50,
      decoration: const BoxDecoration(
          border:
              Border(top: BorderSide(color: AppColor.greyColor2, width: 0.5)),
          color: Colors.white),
      child: Row(
        children: <Widget>[
          // Edit text
          const SizedBox(
            width: 20,
          ),
          Flexible(
            child: TextField(
              controller: controller.textEditingController,
              onSubmitted: (value) {
                controller.onSendMessage(
                    controller.textEditingController.text, 0);
              },
              style:
                  const TextStyle(color: AppColor.primaryColor, fontSize: 15),
              decoration: const InputDecoration.collapsed(
                hintText: 'Type your message...',
                hintStyle: TextStyle(color: AppColor.greyColor),
              ),
              focusNode: focusNode,
              autofocus: true,
            ),
          ),

          // Button send message
          Material(
            color: Colors.white,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              color: AppColor.primaryColor,
              child: IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    controller.onSendMessage(
                        controller.textEditingController.text, 0);
                  }),
            ),
          ),
        ],
      ),
    );
  }
}
