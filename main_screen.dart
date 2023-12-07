import 'package:carousel_slider/carousel_slider.dart';
import 'package:project/fluid/liquid_swipe.dart';
import 'package:project/models/subscrible.dart';
import 'package:url_launcher/url_launcher.dart';
import '/screens/board_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/boards.dart';
import '../providers/auth.dart';
import '../providers/notifications.dart';
import '../widgets/app_drawer.dart';
import 'dart:convert'; // Add this import for json decoding
import 'package:http/http.dart' as http;
import 'package:project/providers/image_dart.dart';

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

Future<Map<String, dynamic>?> getContentApi(String email) async {
  final baseUrl = "http://10.0.2.2:5000";
  final path = "/api_get_content";
  final uri = Uri.parse('$baseUrl$path?email=$email');

  try {
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final Map<String, dynamic>? result = json.decode(response.body);
      // JSON 데이터로 파싱
      print("Connection is Welldone");
      return result;
    } else {
      // 서버로부터 오류 응답
      print("Error: ${response.statusCode}");
      return null;
    }
  } catch (e) {
    // 네트워크 오류 등의 예외 처리
    print("Error: $e");
    return null;
  }
}

class TwoColumnGrid extends StatelessWidget {
  final List<Map<String, dynamic>> items;

  TwoColumnGrid(this.items);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
      ),
      itemCount: items.length,
      itemBuilder: (BuildContext context, int index) {
        final item = items[index];
        return GridItem(
          title: item['title'],
          imgUrl: item['img'],
        );
      },
    );
  }
}

class GridItem extends StatelessWidget {
  final String title;
  final String imgUrl;

  GridItem({required this.title, required this.imgUrl});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Image.network(
            imgUrl,
            height: 150.0,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

class MainScreen extends StatelessWidget {
  List<Map<String, dynamic>> items = [];

  Future<void> _refreshBoards(BuildContext context) async {
    String email = "plain_romance@naver.com";
    print("Auth: ${Auth().email}");
    final result = await getContentApi(email);

    if (result != null) {
      // Use values property to get an Iterable<dynamic> and cast each item
      items.addAll(result.values.map((item) => item as Map<String, dynamic>));
    }

    await Provider.of<Board_List>(context, listen: false).fetchAndSetBoards();
  }

  void _launchURL(String url) async {
    try {
      await launch(url);
    } catch (e) {
      print("url launch error");
    }
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

  Widget build(BuildContext context) {
    final userId = Provider.of<Auth>(context).userId;
    return Scaffold(
        appBar: AppBar(
          title: Text('Welcome CEE'),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 30),
            ImageCarousel(),
            const SizedBox(height: 30),
            _platformList(),
            Expanded(
              child: FutureBuilder(
                future: _refreshBoards(context),
                builder: (ctx, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return TwoColumnGrid(items);
                  }
                },
              ),
            ),
            FutureBuilder(
                future: _refreshBoards(context),
                builder: (ctx, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return Consumer<Board_List>(
                      builder: (ctx, boardsData, _) => Padding(
                        padding: EdgeInsets.all(8),
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: boardsData.items.length,
                          itemBuilder: (_, i) => Column(
                            children: [
                              Container(
                                width: double.infinity,
                                child: OutlinedButton(
                                  onPressed: () {
                                    Navigator.of(context).pushNamed(
                                      BoardScreen.routeName,
                                      arguments: BoardScreenArguments(
                                        boardsData.items[i].id,
                                        boardsData.items[i].name,
                                      ),
                                    );
                                  },
                                  child: Text(boardsData.items[i].name),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                }),
          ],
        ),
        drawer: AppDrawer());
  }
}

// board_screen에 전달할 arguments
class BoardScreenArguments {
  final String boardId;
  final String boardName;

  BoardScreenArguments(this.boardId, this.boardName);
}
