import 'package:carousel_slider/carousel_slider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project/fluid/liquid_swipe.dart';
import 'package:project/models/subscrible.dart';
import 'package:project/screens/fluid_screen.dart';
import 'package:project/screens/recommandation.dart';
import 'package:project/screens/subscrible_page.dart';
import 'package:url_launcher/url_launcher.dart';
import '/screens/board_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/boards.dart';
import '../providers/auth.dart';
import 'dart:math';
import '../providers/notifications.dart';
import '../widgets/app_drawer.dart';
import 'dart:convert'; // Add this import for json decoding
import 'package:http/http.dart' as http;
import 'package:project/providers/image_dart.dart';
import 'package:flutter_fancy_container/flutter_fancy_container.dart';

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
        height: 200.0,
        aspectRatio: 16 / 9,
        viewportFraction: 0.8,
        initialPage: 0,
        enableInfiniteScroll: true,
        reverse: false,
        autoPlay: true,
        autoPlayInterval: Duration(seconds: 5),
        autoPlayAnimationDuration: Duration(milliseconds: 1800),
        autoPlayCurve: Curves.fastOutSlowIn,
        enlargeCenterPage: true,
        onPageChanged: (index, reason) {
          // 페이지 변경 이벤트 핸들링
        },
        scrollDirection: Axis.horizontal,
      ),
      items: images.map((url) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.symmetric(horizontal: 5.0),
              decoration: BoxDecoration(
                color: Colors.amber,
                border: Border.all(
                  color: Colors.black,
                  width: 10.0, // 테두리의 두께 조절
                ),
                borderRadius: BorderRadius.circular(8.0), // 테두리의 모서리 둥글기 조절
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

// board_screen에 전달할 arguments
class BoardScreenArguments {
  final String boardId;
  final String boardName;

  BoardScreenArguments(this.boardId, this.boardName);
}

class CombinedWidget extends StatelessWidget {
  final double screenWidth;
  CombinedWidget(this.screenWidth);

  Map<String, dynamic>? result; // Define the result variable

  Future<void> _refreshBoards(BuildContext context, String? email) async {
    await Provider.of<Board_List>(context, listen: false).fetchAndSetBoards();

    final baseUrl = "http://10.0.2.2:5000";
    final path = "/api_get_today_content";
    final uri = Uri.parse('$baseUrl$path?email=$email');

    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        result = json.decode(response.body); // Update the result variable
        print("Connection is Welldone");
      } else {
        print("Error: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
    }
    final path1 = "/api_set_recommendations";
    final uri1 = Uri.parse('$baseUrl$path1?email=$email');
    try {
      final response = await http.get(uri1);
      if (response.statusCode == 200) {
        print("Connection is Welldone");
      } else {
        throw Error();
      }
    } catch (e) {
      // 네트워크 오류 등의 예외 처리
      print("Error: $e");
      return null;
    }
  }

  Color getPrimary(String platform) {
    if (platform == 'naver') {
      print("color test: 1");
      return Colors.green;
    } else if (platform == 'kakao') {
      print("color test: 2");
      return Colors.yellow;
    } else if (platform == 'kakaopage') {
      print("color test: 3");
      return Colors.black;
    }
    print("color test: 4");
    return Colors.blueAccent;
  }

  Widget build(BuildContext context) {
    String? email = Provider.of<Auth>(context).email;
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(IconsPath.loginPage),
          fit: BoxFit.cover,
        ),
        gradient: LinearGradient(
          colors: [
            Color.fromRGBO(117, 237, 255, 1).withOpacity(0.5),
            Color.fromRGBO(117, 175, 255, 1).withOpacity(0.9),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: [0, 1],
        ),
      ),
      child: FutureBuilder(
        future: _refreshBoards(context, email),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Consumer<Board_List>(
              builder: (ctx, boardsData, _) => Padding(
                padding: EdgeInsets.all(3),
                child: ListView.builder(
                  shrinkWrap: false,
                  physics: AlwaysScrollableScrollPhysics(),
                  itemCount: boardsData.items.length + 6,
                  itemBuilder: (_, i) {
                    if (i == 0) {
                      return const SizedBox(height: 30);
                    } else if (i == 1) {
                      return ImageCarousel();
                    } else if (i == 2) {
                      return const SizedBox(height: 30);
                    } else if (i == 3) {
                      return _platformList();
                    } else if (i == 4) {
                      return Expanded(
                        child: GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: (0.6),
                            crossAxisCount: 2,
                            crossAxisSpacing: 10.0,
                            mainAxisSpacing: 0.0,
                          ),
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: result?.length ?? 0,
                          itemBuilder: (context, index) {
                            var category = result!.keys.toList()[index];
                            var items = result![category];

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                for (var item in items) ...[
                                  OutlinedButton(
                                    onPressed: () {
                                      launch(item['url']);
                                    },
                                    child: Container(
                                      width: 300,
                                      height: 280,
                                      decoration: BoxDecoration(
                                        color: getPrimary(item['service']),
                                        border: Border.all(
                                          color: Colors.black,
                                          width: 10.0, // border의 두께
                                        ),
                                      ),
                                      child: Column(
                                        children: [
                                          Image.network(
                                            item['img'],
                                            headers: {
                                              'User-Agent':
                                                  'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36'
                                            },
                                            width: 200,
                                            height: 200,
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            item['title'],
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black87),
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            item['author'],
                                            style: TextStyle(
                                                fontSize: 9,
                                                fontWeight: FontWeight.normal,
                                                color: Colors.black87),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ],
                            );
                          },
                        ),
                      );
                    } else if (i == 5) {
                      return Text("Community");
                    } else {
                      return _buildCommunityWidget(context, boardsData, i);
                    }
                  },
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildCommunityWidget(
      BuildContext context, Board_List boardsData, int i) {
    return Column(
      children: [
        FlutterFancyContainer(
          colorOne: Colors.lightGreenAccent,
          colorTwo: Colors.lightBlue,
          width: MediaQuery.of(context).size.width * 0.8,
          height: 100,
          child: OutlinedButton(
            onPressed: () {
              Navigator.of(context).pushNamed(
                BoardScreen.routeName,
                arguments: BoardScreenArguments(
                  boardsData.items[i - 6].id,
                  boardsData.items[i - 6].name,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 100),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(9.0),
              ),
            ),
            child: Container(
              child: Center(
                child: Text(
                  (boardsData.items[i - 6].name),
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 8),
      ],
    );
  }
}

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
              onTap: () => _launchURL(platformUrls[index]), // Launch URL on tap
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

void _launchURL(String url) async {
  try {
    await launch(url);
  } catch (e) {
    print("url launch error");
  }
}

class MainScreen extends StatefulWidget {
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int page = 0;
  late LiquidController liquidController;
  late UpdateType updateType;
  final pages = [
    CombinedWidget(double.infinity),
    MyApp_Sub(),
    MyApp_Reco(),
  ];

  void initState() {
    liquidController = LiquidController();
    super.initState();
  }

  Widget _buildDot(int index) {
    double selectedness = Curves.easeOut.transform(
      max(
        0.0,
        1.0 - ((page) - index).abs(),
      ),
    );
    double zoom = 1.0 + (2.0 - 1.0) * selectedness;
    return new Container(
      width: 25.0,
      child: new Center(
        child: new Material(
          color: Colors.white,
          type: MaterialType.circle,
          child: new Container(
            width: 8.0 * zoom,
            height: 8.0 * zoom,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    final userId = Provider.of<Auth>(context).userId;
    final token = Provider.of<Auth>(context).token;
    final email = Provider.of<Auth>(context).email;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(IconsPath.loginPage), // 이미지의 경로
                fit: BoxFit.cover, // 이미지를 화면에 맞게 채우도록 설정
              ),
            ),
          ),
          LiquidSwipe(
            pages: pages,
            positionSlideIcon: 0.8,
            fullTransitionValue: 880,
            slideIconWidget: Icon(Icons.arrow_back_ios),
            onPageChangeCallback: pageChangeCallback,
            waveType: WaveType.liquidReveal,
            liquidController: liquidController,
            preferDragFromRevealedArea: true,
            enableSideReveal: true,
            ignoreUserGestureWhileAnimating: true,
            enableLoop: true,
          ),
          Padding(
            padding: EdgeInsets.all(20),
            child: Column(children: <Widget>[
              Expanded(child: SizedBox()),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List<Widget>.generate(pages.length, _buildDot),
              )
            ]),
          ),
        ],
      ),
      drawer: AppDrawer(),
    );
  }

  pageChangeCallback(int lpage) {
    setState(() {
      page = lpage;
    });
  }
}
