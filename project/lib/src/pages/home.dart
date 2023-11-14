import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/src/components/avatar_widget.dart';
import 'package:project/src/components/image_dart.dart';
import 'package:project/src/components/post_widget.dart';
import 'package:project/src/controller/home_controller.dart';
// import 'package:project/src/models/post.dart';
import 'package:url_launcher/url_launcher.dart';

class Home extends GetView<HomeController> {
  const Home({super.key});

  Widget _myStory() {
    return Container(
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.only(top: 20.0, right: 10.0),
            child: AvatarWidget(
              type: AvatarType.TYPE2,
              thumbPath:
                  'https://img.hankyung.com/photo/202306/AKR20230630015400005_02_i_P4.jpg',
              size: 60,
            ),
          ),
          // 이미지와 텍스트를 담을 Column을 추가합니다.
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'silvercastle',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _profile() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          const SizedBox(width: 20),
          _myStory(),
          const SizedBox(width: 5),
        ],
      ),
    );
  }

  Widget _postList() {
    return Obx(
      () => Column(
        children: List.generate(
          controller.postList.length,
          (index) => PostWidget(post: controller.postList[index]),
        ).toList(),
      ),
    );
  }

  Widget _advertiseList() {
    return CarouselSlider(
      options: CarouselOptions(
        height: 250.0,
        aspectRatio: 16 / 9,
        viewportFraction: 1.0,
      ),
      items: [1, 2, 3, 4, 5].map((i) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
              // margin: EdgeInsets.symmetric(horizontal: 20.0),
              // decoration: BoxDecoration(color: Colors.amber),
              child: Stack(
                children: [
                  Image.asset(
                    IconsPath.advertiseMain,
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.cover,
                  ),
                  ColorFiltered(
                    colorFilter: ColorFilter.mode(
                      Color.fromARGB(255, 10, 146, 191).withOpacity(0.1),
                      BlendMode.dstATop,
                    ),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 250.0,
                      color: Color.fromARGB(255, 4, 153, 176),
                    ),
                  ),
                  const Positioned(
                    bottom: 150.0,
                    left: 230.0,
                    child: Text(
                      'Everything',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 25.0,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                  const Positioned(
                    bottom: 120.0,
                    left: 230.0,
                    child: Text(
                      'in CEE',
                      style: TextStyle(
                        color: Colors.blueGrey,
                        fontSize: 25.0,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                  const Positioned(
                    bottom: 90.0,
                    left: 230.0,
                    child: Text(
                      'infinity content',
                      style: TextStyle(
                        color: Color.fromARGB(255, 16, 123, 176),
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }).toList(),
    );
  }

  Widget _platformList() {
    List<String> imagePath = [
      IconsPath.naverWebtoon,
      IconsPath.kakaoWebtoon,
      IconsPath.kakaoPage,
      IconsPath.lezhinComics,
    ];

    double imageMargin = 10.0; // 이미지 간의 간격 조절

    // ignore: no_leading_underscores_for_local_identifiers
    void _launchURL() async {
      // String url = "https://comic.naver.com/index";

      Uri url = Uri(
        scheme: 'https',
        host: 'dart.dev',
        path: '/guides/libraries/library-tour',
        fragment: 'numbers',
      );
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        throw 'Could not launch $url';
      }
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: SizedBox(
        height: 100.0,
        child: PageView.builder(
          itemCount: imagePath.length,
          itemBuilder: (context, index) {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: imageMargin),
              child: GestureDetector(
                onTap: _launchURL,
                child: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  child: Container(
                    width: 90.0,
                    height: 90.0,
                    color: Colors.white,
                    child: Image.asset(
                      imagePath[index],
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            );
          },
          controller:
              PageController(viewportFraction: 0.3), // 한 번에 보여지는 아이템의 개수를 조절
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ListView(children: [
            _profile(),
            SizedBox(height: 30),
            _advertiseList(),
            _platformList(),
            _postList(),
          ]),
          Container(
            color: Color.fromARGB(255, 126, 185, 233)
                .withOpacity(0.2), // 검은색 필터 및 투명도 조절
          ),
        ],
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     // appBar: AppBar(
  //     //   elevation: 0,
  //     //   title: ImageData(
  //     //     IconsPath.logo,
  //     //     width: 270,
  //     //   ),
  //     //   actions: [
  //     //     GestureDetector(
  //     //       onTap: () {},
  //     //       child: Padding(
  //     //         padding: const EdgeInsets.all(15.0),
  //     //         child: ImageData(
  //     //           IconsPath.directMessage,
  //     //           width: 50,
  //     //         ),
  //     //       ),
  //     //     )
  //     //   ],
  //     // ),
  //     body: ListView(children: [
  //       _profile(),
  //       SizedBox(height: 30),
  //       _advertiseList(),
  //       _platformList(),
  //       _postList(),
  //     ]),
  //   );
  // }
}
