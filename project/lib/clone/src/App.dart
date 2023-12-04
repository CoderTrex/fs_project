import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/clone/src/components/image_dart.dart';
import 'package:project/clone/src/controller/bottom_nav_controller.dart';
import 'package:project/clone/src/pages/home.dart';
import 'package:project/clone/src/pages/search.dart';
import 'package:project/clone/src/pages/active_history.dart';
import 'package:project/clone/src/pages/mypage.dart';

// getx 영상을 봐야함
class App extends GetView<BottomNavcontroller> {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Obx(
        () => Scaffold(
          body: IndexedStack(
            index: controller.pageIndex.value,
            children: [
              const Home(),
              Navigator(
                key: controller.searchPageNavigationkey,
                onGenerateRoute: (RouteSettings) {
                  return MaterialPageRoute(
                    builder: (context) => const Search(),
                  );
                },
              ),
              Container(),
              const ActiveHistory(),
              const MyPage(),
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            currentIndex: controller.pageIndex.value,
            onTap: controller.changeBottomNav,
            elevation: 0,
            items: [
              BottomNavigationBarItem(
                icon: ImageData(IconsPath.homeOff),
                activeIcon: ImageData(IconsPath.homeOn),
                label: 'home',
              ),
              BottomNavigationBarItem(
                icon: ImageData(IconsPath.searchOff),
                activeIcon: ImageData(IconsPath.searchOn),
                label: 'home',
              ),
              BottomNavigationBarItem(
                icon: ImageData(IconsPath.uploadIcon),
                activeIcon: ImageData(IconsPath.uploadIcon),
                label: 'home',
              ),
              BottomNavigationBarItem(
                icon: ImageData(IconsPath.activeOff),
                activeIcon: ImageData(IconsPath.activeOn),
                label: 'home',
              ),
              BottomNavigationBarItem(
                icon: Container(
                  width: 50,
                  height: 30,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey,
                  ),
                ),
                // activeIcon: ImageData(IconsPath.homeOn),
                label: 'home',
              ),
            ],
          ),
        ),
      ),
      onWillPop: controller.willPopAction,
    );
  }
}
