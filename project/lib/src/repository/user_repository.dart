import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project/src/models/project_user_.dart';

class UserRepository {
  static Future<Puser?> loginUserByUid(String uid) async {
    var data = await FirebaseFirestore.instance
        .collection('users')
        .where('uid', isEqualTo: uid)
        .get();

    if (data.size == 0) {
      return null;
    } else {
      return Puser.fromJson(data.docs.first.data());
      ;
    }
  }

  static Future<bool> signup(Puser user) async {
    try {
      await FirebaseFirestore.instance.collection('users').add(user.toMap());
      return true;
    } catch (e) {
      return false;
    }
  }
}
