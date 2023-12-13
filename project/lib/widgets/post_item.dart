import 'package:flutter/material.dart';
import 'package:flutter_fancy_container/flutter_fancy_container.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../screens/post_detail_screen.dart';
import '../providers/posts.dart';
import '../providers/comments.dart';
import '../providers/auth.dart';

class PostItem extends StatelessWidget {
  final String? id;
  PostItem(
    this.id,
  );

  @override
  Widget build(BuildContext context) {
    final posts = Provider.of<Posts>(context, listen: false).items;
    final postIndex = posts.indexWhere((post) => post.id == id);
    final post = posts[postIndex];

    return FlutterFancyContainer(
      colorOne: Colors.redAccent,
      colorTwo: Colors.blueGrey,
      width: MediaQuery.of(context).size.width * 0.8,
      height: MediaQuery.of(context).size.height * 0.15,
      child: ListTile(
        title: Text(
          post.title!,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          post.contents!,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: (DateTime.now().day - post.datetime!.day >= 1)
            ? Text(DateFormat('MM/dd').format(post.datetime!))
            : Text(DateFormat('HH:mm').format(post.datetime!)),
        onTap: () async {
          await Provider.of<Comments>(context, listen: false)
              .fetchAndSetComments(id!);
          Navigator.of(context)
              .pushNamed(PostDetailScreen.routeName, arguments: id);
        },
      ),
    );
  }
}
