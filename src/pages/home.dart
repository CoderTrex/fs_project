import 'package:carousel_slider/carousel_slider.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../components/avatar_widget.dart';
import '../components/image_dart.dart';
import '../components/post_widget.dart';
import '../controller/home_controller.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:app/src/models/post.dart';

// // // ignore: no_leading_underscores_for_local_identifiers
// void _launchURL(String url) async {
//   var httpsUri = Uri(
//       scheme: 'https',
//       host: 'dart.dev',
//       path: '/guides/libraries/library-tour',
//       fragment: 'numbers');
//   if (await canLaunch(url)) {
//     await launch(url);
//   } else {
//     throw 'Could not launch $httpsUri';
//   }
// }

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
        children: controller.postList.isNotEmpty
            ? [
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: PostWidget(post: controller.postList.first),
                ),
                ...List.generate(
                  controller.postList.length - 1,
                  (index) => PostWidget(post: controller.postList[index + 1]),
                ).toList(),
              ]
            : [], // postList가 비어 있는 경우 빈 리스트 반환
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
                  Positioned(
                    bottom: 200,
                    left: 240.0,
                    child: Text(
                      'Everything',
                      style: GoogleFonts.amethysta(
                        textStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 170,
                    left: 290.0,
                    child: Text(
                      'in CEE',
                      style: GoogleFonts.amethysta(
                        textStyle: TextStyle(
                          color: Colors.blueGrey,
                          fontSize: 25.0,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 130,
                    left: 220.0,
                    child: Text(
                      'infinity content',
                      style: GoogleFonts.amethysta(
                        textStyle: TextStyle(
                          color: Colors.blueGrey,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
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

// ...

  Widget _platformList() {
    List<String> imagePath = [
      IconsPath.naverWebtoon,
      IconsPath.kakaoWebtoon,
      IconsPath.kakaoPage,
      IconsPath.lezhinComics,
    ];

    List<String> platformUrls = [
      "https://comic.naver.com/index",
      "https://webtoon.kakao.com/",
      "https://page.kakao.com/",
      "https://www.lezhinus.com/ko",
      // Add other URLs for each platform
    ];

    List<String> platformNames = [
      'NaverWebtoon',
      'KakaoWebtoon',
      'KakaoPage',
      'LezhinComics',
    ];

    double imageMargin = 0.0;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: SizedBox(
        height: 130.0,
        child: PageView.builder(
          itemCount: imagePath.length,
          itemBuilder: (context, index) {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: imageMargin),
              child: GestureDetector(
                onTap: () =>
                    _launchURL(platformUrls[index]), // Launch URL on tap
                child: Stack(
                  children: [
                    ClipOval(
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
                    Positioned(
                      bottom: 10,
                      left: 0,
                      right: 30,
                      child: Container(
                        padding: EdgeInsets.all(0.0),
                        color: Colors.transparent,
                        child: Text(
                          platformNames[index],
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.visible,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          controller: PageController(viewportFraction: 0.3),
        ),
      ),
    );
  }

// Function to launch URL
  void _launchURL(String url) async {
    // if (await canLaunch(url)) {
    await launch(url);
    // } else {
    //   throw 'Could not launch $url';
    // }
  }

  //////////////////////////////////////////////////////////
  Widget _Content_you_Missing() {
    return const Text(
      'Content you missing',
      style: TextStyle(
        fontSize: 20.0, // 글자 크기 조절
        fontWeight: FontWeight.bold, // 글자 굵기 조절
      ),
      textAlign: TextAlign.center, // 텍스트 가운데 정렬
    );
  }

  ////////////////////////////////////////////////////////
  static const List<String> imagePath = [
    'assets/naver_webtoon.png',
    'assets/kakao_webtoon.png',
    'assets/kakao_page.png',
    'assets/lezhin_comics.png',
  ];
  static const List<String> platformNames = [
    'Naver Webtoon',
    'Kakao Webtoon',
    'Kakao Page',
    'Lezhin Comics',
  ];

  Widget _buildPlatformGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // 2열로 설정
        crossAxisSpacing: 0.0, // 열 간의 간격
        mainAxisSpacing: 0.0, // 행 간의 간격
      ),
      itemCount: imagePath.length,
      itemBuilder: (context, index) {
        return Container(
          child: Column(
            children: [
              Container(
                width: 180.0,
                height: 150.0,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0), // 원하는 네모의 모양을 정의
                ),
                // child: Image.asset(
                //   imagePath[index],
                //   fit: BoxFit.contain,
                // ),
              ),
              SizedBox(height: 8.0),
              Text(
                platformNames[index],
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withAlpha(10),
              const Color.fromARGB(255, 105, 198, 242).withOpacity(0.8)
            ],
          ),
        ),
        child: Stack(
          children: [
            ListView(
              children: [
                _profile(),
                const SizedBox(height: 30),
                _advertiseList(),
                const SizedBox(height: 30),
                _platformList(),
                _postList(),
                _Content_you_Missing(),
                const SizedBox(height: 30),
                _buildPlatformGrid(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
