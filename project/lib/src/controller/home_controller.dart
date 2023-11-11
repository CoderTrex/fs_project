import 'package:get/get.dart';
import 'package:project/src/models/post.dart';
import 'package:project/src/repository/post_repository.dart';

class HomeController extends GetxController {
  @override
  RxList<Post> postList = <Post>[].obs;

  void onInit() {
    // TODO: implement onInit
    super.onInit();
    _loadFeedList();
  }

  void _loadFeedList() async {
    var feedList = await PostRepository.loadFeedList();
    postList.addAll(feedList);
    // print(feedList.length);
  }
}
