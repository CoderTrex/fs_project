import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/clone//src/components/avatar_widget.dart';
import 'package:project/clone//src/components/image_dart.dart';
import 'package:project/clone//src/components/post_widget.dart';
import 'package:project/clone//src/controller/home_controller.dart';

class Home extends GetView<HomeController> {
  const Home({super.key});

  Widget _myStory() {
    return Stack(
      children: [
        AvatarWidget(
          type: AvatarType.TYPE2,
          thumbPath:
              'https://img.hankyung.com/photo/202306/AKR20230630015400005_02_i_P4.jpg',
          size: 70,
        ),
        Positioned(
          right: 5,
          bottom: 0,
          child: Container(
            width: 25,
            height: 25,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blue,
              border: Border.all(
                color: Colors.white,
                width: 2,
              ),
            ),
            child: const Center(
              child: Text(
                '+',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  height: 1.1,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _storyBoardList() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          const SizedBox(width: 20),
          _myStory(),
          const SizedBox(width: 5),
          ...List.generate(
            100,
            (index) => AvatarWidget(
              type: AvatarType.TYPE1,
              thumbPath:
                  'https://biz.chosun.com/resizer/S78jsOEv58BcET2IzCAS-gp2tss=/530x530/smart/cloudfront-ap-northeast-1.images.arcpublishing.com/chosunbiz/RCKNAWOKYLAB7KYM5UBGDJFGRY.jpg',
            ),
          ),
        ],
      ),
    );
  }

  Widget _postList() {
    return Obx(() => Column(
          children: List.generate(
            controller.postList.length,
            (index) => PostWidget(post: controller.postList[index]),
          ).toList(),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: ImageData(
          IconsPath.logo,
          width: 270,
        ),
        actions: [
          GestureDetector(
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: ImageData(
                IconsPath.directMessage,
                width: 50,
              ),
            ),
          )
        ],
      ),
      body: ListView(children: [
        _storyBoardList(),
        _postList(),
      ]),
    );
  }
}
