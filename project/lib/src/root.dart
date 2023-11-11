import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project/src/App.dart';
import 'package:project/src/controller/auth_controller.dart'; // 수정 필요
import 'package:project/src/models/project_user_.dart';
import 'package:project/src/pages/login.dart';
import 'package:project/src/pages/signup._page.dart';
import 'package:get/get.dart';

class Root extends GetView<AuthController> {
  const Root({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(AuthController()); // AuthController를 등록

    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      // initialData: initialData,
      builder: (BuildContext _, AsyncSnapshot<User?> user) {
        // todo 내부 파이어 베이스 유저 정보 조회
        // with user.data.id
        if (user.hasData) {
          return FutureBuilder<Puser?>(
            future: controller.loginUser(user.data!.uid),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return const App();
              } else {
                return Obx(() => controller.user.value.uid != null
                    ? const App()
                    : SignupPage(uid: user.data!.uid));
              }
            },
          );
        } else {
          return const Login();
        }
        // child: child,
      },
    );
  }
}
