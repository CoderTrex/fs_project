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

  double widgetHeight = 0.0;
  Widget _buildMovingWidget() {
    return AnimatedPositioned(
      duration: Duration(milliseconds: 300),
      bottom: widgetHeight,
      left: 0,
      right: 0,
      child: GestureDetector(
        onVerticalDragUpdate: (details) {
          setState(() {
            // 현재 위치에서 세부 정보(primaryDelta)를 더하고, 그 값을 특정 범위로 제한합니다.
            widgetHeight = (widgetHeight + details.primaryDelta!)
                .clamp(-1 * (MediaQuery.of(context).size.height * 2 / 5), 0.0);
          });
        },
        child: Container(
          height: MediaQuery.of(context).size.height * 4 / 5,
          color: Colors.white,
          child: Center(
            child: Text(
              'Your Custom Widget',
              style: TextStyle(fontSize: 20),
            ),
          ),
        ),
      ),
    );
  }
}
