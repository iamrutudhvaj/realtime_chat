import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/login_page_controller.dart';

class LoginPageView extends GetView<LoginPageController> {
  const LoginPageView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LOGIN'),
        centerTitle: true,
      ),
      body: Center(
          child: ElevatedButton.icon(
              onPressed: controller.handleSignIn,
              icon: const Icon(Icons.login),
              label: const Text("Sign in with Google"))),
    );
  }
}
