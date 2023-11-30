import 'package:flutter/material.dart';
import '../components/avatar_widget.dart';

class ActiveHistory extends StatelessWidget {
  const ActiveHistory({super.key});

  Widget _activeItemOne() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          AvatarWidget(
            type: AvatarType.TYPE2,
            size: 40,
            thumbPath:
                'https://www.urbanbrush.net/web/wp-content/uploads/edd/2019/09/urbanbrush-20190904080511711323.png',
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text.rich(
              TextSpan(
                text: '은성',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
                children: [
                  TextSpan(
                    text: '님이 회원님의 게시물을 좋아합니다.',
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  TextSpan(
                    text: ' 5일전',
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 13,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _newRecentlyActiveView(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: const TextStyle(
              // fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 15),
          _activeItemOne(),
          _activeItemOne(),
          _activeItemOne(),
          _activeItemOne(),
          _activeItemOne(),
        ],
      ),
    );
  }

  // Widget _newRecentlyThisWeekView() {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 15.0),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.stretch,
  //       children: [
  //         const Text(
  //           '이번 주',
  //           style: TextStyle(
  //             // fontWeight: FontWeight.bold,
  //             fontSize: 16,
  //           ),
  //         ),
  //         const SizedBox(height: 15),
  //         _activeItemOne(),
  //         _activeItemOne(),
  //         _activeItemOne(),
  //         _activeItemOne(),
  //         _activeItemOne(),
  //       ],
  //     ),
  //   );
  // }

  // Widget _newRecentlyThisMonthView() {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 15.0),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.stretch,
  //       children: [
  //         const Text(
  //           '이번 달',
  //           style: TextStyle(
  //             // fontWeight: FontWeight.bold,
  //             fontSize: 16,
  //           ),
  //         ),
  //         const SizedBox(height: 15),
  //         _activeItemOne(),
  //         _activeItemOne(),
  //         _activeItemOne(),
  //         _activeItemOne(),
  //         _activeItemOne(),
  //       ],
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      AppBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(
          '활동',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _newRecentlyActiveView('오늘'),
            _newRecentlyActiveView('이번 주'),
            _newRecentlyActiveView('다음 달'),
            // _newRecentlyThisWeekView(),
            // _newRecentlyThisMonthView(),
          ],
        ),
      ),
    );
  }
}
