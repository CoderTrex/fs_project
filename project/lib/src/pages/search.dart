import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/src/components/image_dart.dart';
import 'package:quiver/iterables.dart';
import './search/search_focus.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  List<List<int>> groupbox = [[], [], []];
  List<int> groupIndex = [0, 0, 0];

  @override
  void initState() {
    super.initState();
    for (var i = 0; i < 100; i++) {
      var gi = groupIndex.indexOf(min<int>(groupIndex)!);
      var size = 1;
      if (gi != 1) {
        size = Random().nextInt(100) % 2 == 0 ? 1 : 2;
      }
      groupbox[gi].add(size);
      groupIndex[gi] += size;
    }
  }

  Widget _appbar() {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SearchFocus()));
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
              margin: const EdgeInsets.only(left: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: const Color(0xffefefef),
              ),
              child: Row(
                children: const [
                  Icon(Icons.search),
                  Text(
                    '검색',
                    style: TextStyle(
                      fontSize: 15,
                      color: Color(0xff838383),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.all(15.0),
          child: Icon(Icons.location_pin),
        )
      ],
    );
  }

  Widget _body() {
    return SingleChildScrollView(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(
          groupbox.length,
          (index) => Expanded(
            child: Column(
              children: List.generate(
                groupbox[index].length,
                (jndex) => Container(
                  height: Get.width * 0.33 * groupbox[index][jndex],
                  // color: Colors.,
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white,
                      ),
                      color: Colors.primaries[
                          Random().nextInt(Colors.primaries.length)]),
                  child: CachedNetworkImage(
                    imageUrl:
                        'https://img.hankyung.com/photo/202306/AKR20230630015400005_02_i_P4.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
                // Container(
                //   height: 280,
                //   color: Colors.green,
                // ),
              ).toList(),
            ),
          ),
        ).toList(),
      ),
    );
  }

  double widgetHeight = 0.0;

  Widget _buildMovingWidget() {
    String imageUrl1 =
        // "https://www.urbanbrush.net/web/wp-content/uploads/edd/2019/09/urbanbrush-20190904080511711323.png";
        "https://i.namu.wiki/i/U5dn88xRShxCjIpIg7aYPXgN4_-Idr2BMIU2HohOFAQ9oNgKBSlsRUCrsX1YfXjTkkJnLKkP8jrRIrmWsDfeWw.webp";
    // String imageUrl2 = "path/to/your/image2.png"; // 이미지2의 경로 또는 URL

    return AnimatedPositioned(
      duration: Duration(milliseconds: 300),
      bottom: widgetHeight,
      left: 0,
      right: 0,
      child: GestureDetector(
        onVerticalDragUpdate: (details) {
          setState(() {
            widgetHeight = (widgetHeight + details.primaryDelta!)
                .clamp(-1 * (MediaQuery.of(context).size.height * 2 / 5), 0.0);
          });
        },
        child: Container(
          height: MediaQuery.of(context).size.height * 4 / 5,
          color: Colors.white.withOpacity(0.5),
          // color: Color.fromARGB(255, 218, 144, 232).withOpacity(0.8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildImageContainer(imageUrl1), // 첫 번째 이미지를 띄우는 Container
              // _buildImageContainer(imageUrl2), // 두 번째 이미지를 띄우는 Container
              // 추가적인 이미지를 띄우는 Container를 필요에 따라 계속 추가할 수 있습니다.
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageContainer(String imageUrl) {
    return Container(
      height: 200,
      width: 400,
      color: Colors.blue, // 구역의 배경색
      margin: EdgeInsets.symmetric(vertical: 10), // 간격을 조절하는 margin 속성 추가
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start, // 이미지를 왼쪽에 정렬
        children: [
          Image.network(
            imageUrl, // 이미지 경로 또는 URL
            height: 150, // 이미지 높이 조절
            width: 150, // 이미지 너비 조절
          ),
          SizedBox(width: 10), // 이미지와 텍스트 간의 간격 조절
          Text(
            'Your Custom Widget', // 이미지에 대한 텍스트
            style: TextStyle(fontSize: 20),
          ),
        ],
      ),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _appbar(),
            Expanded(
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(IconsPath.communityBackground),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  _buildMovingWidget(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
