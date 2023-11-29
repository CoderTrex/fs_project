import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../binding/init_bindings.dart';
import '../models/project_user_.dart';
import '../repository/user_repository.dart';

class AuthController extends GetxController {
  static AuthController get to => Get.find();

  Rx<Puser> user = Puser().obs;

  Future<Puser?> loginUser(String uid) async {
    var userData = await UserRepository.loginUserByUid(uid);
    if (userData != null) {
      user(userData);
      InitBinding.AdditionalBinding();
    }
    return userData;
  }

  void signup(Puser signupUser, XFile? thumbnail) async {
    if (thumbnail == null) {
      _submitSignup(signupUser);
    } else {
      var task = uploadXFile(thumbnail,
          '${signupUser.uid}/profile.${thumbnail.path.split('.').last}');
      task.snapshotEvents.listen((event) async {
        print(event.bytesTransferred);
        if (event.bytesTransferred == event.totalBytes &&
            event.state == TaskState.success) {
          var downloadUrl = await event.ref.getDownloadURL();
          var updatedUserData = signupUser.copyWith(thumnail: downloadUrl);
          _submitSignup(updatedUserData);
        }
      });
    }
  }

  UploadTask uploadXFile(XFile file, String filename) {
    var f = File(file.path);
    var ref = FirebaseStorage.instance.ref().child('users').child(filename);
    final metadata = SettableMetadata(
        contentType: 'image/jpeg',
        customMetadata: {'picked-file-path': file.path});
    return ref.putFile(f, metadata);
  }

  void _submitSignup(Puser signupUser) async {
    var result = await UserRepository.signup(signupUser);
    if (result) {
      loginUser(signupUser.uid!);
    }
  }
}
