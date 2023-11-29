// import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../controller/home_controller.dart';
import '../controller/auth_controller.dart';
import '../controller/mypage_controller.dart';
import '../controller/bottom_nav_controller.dart';
// import 'package:app/src/binding/init_bindings.dart';
import '../controller/upload_controller.dart';

class InitBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(BottomNavcontroller(), permanent: true);
    Get.put(AuthController(), permanent: true);
  }

  static AdditionalBinding() {
    Get.put(MyPageController(), permanent: true);
    Get.put(HomeController(), permanent: true);
    Get.put(UploadController(), permanent: true);
  }
}
