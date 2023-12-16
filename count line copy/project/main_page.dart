import 'dart:convert'; // Import the dart:convert library
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:project/models/subscrible.dart';
import 'package:project/providers/auth.dart';
import 'package:project/providers/home_controller.dart';
import 'package:project/providers/image_dart.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project/models/subscrible.dart';

class ImageCarousel extends StatelessWidget {
  final List<String> images = [
    IconsPath.nmixx_team,
    IconsPath.nmixx_bae,
    IconsPath.nmixx_seolyoon,
    IconsPath.nmixx_haeown,
  ];

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        height: 200.0, // 이미지 높이
        aspectRatio: 16 / 9, // 이미지 가로세로 비율
        viewportFraction: 0.8, // 한 번에 보이는 이미지의 비율
        initialPage: 0, // 초기 페이지
        enableInfiniteScroll: true, // 무한 스크롤 활성화
        reverse: false, // 순방향 스크롤 활성화
        autoPlay: true, // 자동 재생 활성화
        autoPlayInterval: Duration(seconds: 5), // 자동 재생 간격
        autoPlayAnimationDuration:
            Duration(milliseconds: 1800), // 자동 재생 애니메이션 속도
        autoPlayCurve: Curves.fastOutSlowIn, // 자동 재생 애니메이션 커브
        enlargeCenterPage: true, // 현재 페이지 크게 표시
        onPageChanged: (index, reason) {
          // 페이지 변경 이벤트 핸들링
        },
        scrollDirection: Axis.horizontal, // 스크롤 방향
      ),
      items: images.map((url) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.symmetric(horizontal: 5.0),
              decoration: BoxDecoration(
                color: Colors.amber,
              ),
              child: Image.asset(
                url,
                fit: BoxFit.cover,
              ),
            );
          },
        );
      }).toList(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _MyHome createState() => _MyHome();
}

class _MyHome extends State<Home> {
  static get dataSnapShot => null;

  Widget _profile() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          const SizedBox(width: 20),
          // _myStory(),
          const SizedBox(width: 5),
        ],
      ),
    );
  }

  List<subscribleContent> dataList = [];

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
    try {
      await launch(url);
    } catch (e) {
      print("url launch error");
    }
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
    'assets/images/naver_webtoon.jpg',
    'assets/images/kakao_webtoon.jpg',
    'assets/images/kakao_page.jpg',
    'assets/images/lezhin_comics.jpg',
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
      itemCount: dataList.length,
      itemBuilder: (context, index) {
        return _buildExpansionTile(dataList[index]);
      },
    );
  }

  Widget _buildExpansionTile(subscribleContent data) {
    return ExpansionTile(
      title: Text(
        data.title,
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 10,
        ),
        textAlign: TextAlign.center,
      ),
      children: [
        Stack(
          children: [
            Container(
              width: 150.0,
              height: 120.0,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            Transform.scale(
              scale: 1, // Adjust the scale factor as needed
              child: Container(
                width: 150.0,
                height: 120.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                      data.img,
                      headers: {
                        'User-Agent':
                            'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36',
                      },
                    ),
                    fit: BoxFit.contain,
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  void getCurrentSubInfo() async {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await _firestore.collection(Auth().email!).get();

    for (QueryDocumentSnapshot<Map<String, dynamic>> document
        in querySnapshot.docs) {
      String author = document.data()["author"];
      String url = document.data()["url"];
      String img = document.data()["img"];
      String service = document.data()["service"];
      String title = document.data()["title"];

      subscribleContent data = subscribleContent(
          author: author, url: url, img: img, service: service, title: title);
      dataList.add(data);
    }
  }

  bool isGridVisible = false;
  @override
  Widget build(BuildContext context) {
    getCurrentSubInfo();
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.blueGrey[600],
        body: Stack(
          children: [
            Positioned.fill(
              child: ListView(
                children: [
                  // Printing the data
                  const SizedBox(height: 30),
                  ImageCarousel(),
                  const SizedBox(height: 30),
                  _platformList(),
                  _Content_you_Missing(),
                  const SizedBox(height: 30),
                  isGridVisible ? _buildPlatformGrid() : Container(),
                  ElevatedButton(
                    onPressed: () {
                      // Toggle the visibility of the grid
                      setState(() {
                        isGridVisible = !isGridVisible;
                      });
                    },
                    child: Text(isGridVisible ? 'HIDE' : 'SHOW'),
                    // _buildPlatformGrid(),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
