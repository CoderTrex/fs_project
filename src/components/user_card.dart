import 'package:flutter/material.dart';
import 'avatar_widget.dart';

class UserCard extends StatelessWidget {
  final String userID;
  final String description;
  const UserCard({
    Key? key,
    required this.userID,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      width: 150,
      height: 220,
      // color: Colors.blueGrey,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: Colors.black12),
      ),
      child: Stack(
        children: [
          Positioned(
            left: 15,
            right: 15,
            top: 0,
            bottom: 0,
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                AvatarWidget(
                  type: AvatarType.TYPE2,
                  thumbPath:
                      'https://www.urbanbrush.net/web/wp-content/uploads/edd/2019/09/urbanbrush-20190904080511711323.png',
                  size: 80,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  userID,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                Text(
                  description,
                  style: const TextStyle(
                    // fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                  textAlign: TextAlign.center,
                ),
                ElevatedButton(onPressed: () {}, child: const Text('Follow')),
              ],
            ),
          ),
          Positioned(
            right: 5,
            top: 5,
            child: GestureDetector(
              onTap: () {},
              child: const Icon(
                Icons.close,
                size: 14,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
