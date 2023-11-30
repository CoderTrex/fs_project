import 'package:project/providers/subscribles.dart';

import './providers/auth.dart';
import './providers/posts.dart';
import 'providers/comments.dart';
import './providers/boards.dart';
import './screens/auth_screen.dart';
import './screens/board_screen.dart';
import '/screens/serach_screen.dart';
import './screens/splash_screen.dart';
import 'package:flutter/material.dart';
import './providers/notifications.dart';
import 'package:provider/provider.dart';
import 'package:project/screens/fluid_screen.dart';
import './screens/edit_post_screen.dart';
import './screens/post_detail_screen.dart';
import 'package:project/screens/main_page.dart';
import 'package:firebase_core/firebase_core.dart';
import './screens/notification_center_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(Myproject());
}

class Myproject extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Posts>(
          create: (_) => Posts('', '', []),
          update: (ctx, auth, previousPosts) => Posts(
            auth.token,
            auth.userId,
            previousPosts == null ? [] : previousPosts.items,
          ),
        ),
        ChangeNotifierProxyProvider<Auth, Board_List>(
          create: (_) => Board_List('', []),
          update: (ctx, auth, previousBoards) => Board_List(
            auth.token,
            previousBoards == null ? [] : previousBoards.items,
          ),
        ),
        ChangeNotifierProxyProvider<Auth, Comments>(
          create: (_) => Comments('', '', []),
          update: (ctx, auth, previousComments) => Comments(
            auth.token,
            auth.userId,
            previousComments == null ? [] : previousComments.items,
          ),
        ),
        ChangeNotifierProxyProvider<Auth, Notifications>(
          create: (_) => Notifications('', '', []),
          update: (ctx, auth, previousNotifications) => Notifications(
            auth.token,
            auth.userId,
            previousNotifications == null ? [] : previousNotifications.items,
          ),
        ),
        ChangeNotifierProxyProvider<Auth, subscribles>(
          create: (_) => subscribles('', '', []),
          update: (ctx, auth, previousSubscrible) => subscribles(
            auth.token,
            auth.userId,
            previousSubscrible == null ? [] : previousSubscrible.items,
          ),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'ForumDemo',
          theme: ThemeData(
            primaryColor: Colors.purple,
            primarySwatch: Colors.purple,
            fontFamily: 'Lato',
          ),
          // ? MainScreen()
          home: auth.isAuth
              // ? Home()
              ? WithPages()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, authResultSnapshot) =>
                      authResultSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen(),
                ),
          routes: {
            BoardScreen.routeName: (ctx) => BoardScreen(),
            PostDetailScreen.routeName: (ctx) => PostDetailScreen(),
            EditPostScreen.routeName: (ctx) => EditPostScreen(),
            NotiCenterScreen.routeName: (ctx) => NotiCenterScreen(),
            SearchScreen.routeName: (ctx) => SearchScreen(),
          },
        ),
      ),
    );
  }
}
