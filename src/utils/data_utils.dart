import 'package:uuid/uuid.dart';

class DataUtil {
  // static String makeFilePath(String filename) {
  static String makeFilePath() {
    // filename.split('.');
    return '${Uuid().v4()}.jpg';
  }
}
