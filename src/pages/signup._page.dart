import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../controller/auth_controller.dart';
import '../models/project_user_.dart';

class SignupPage extends StatefulWidget {
  final String uid;
  const SignupPage({Key? key, required this.uid}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  TextEditingController nicknameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  XFile? thumbnailXfile;

  void update() => setState(() {});

  Widget _avatar() {
    return Column(
      children: [
        ClipRRect(
          borderRadius: (BorderRadius.circular(100)),
          child: SizedBox(
            width: 100,
            height: 100,
            child: thumbnailXfile != null
                ? Image.file(
                    File(thumbnailXfile!.path),
                    fit: BoxFit.cover,
                  )
                : Image.asset(
                    'assets/images/default_image.png',
                    fit: BoxFit.cover,
                  ),
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        ElevatedButton(
          onPressed: () async {
            thumbnailXfile = await _picker.pickImage(
                source: ImageSource.gallery, imageQuality: 100);
            update();
          },
          child: const Text('이미지 변경'),
        ),
      ],
    );
  }

  Widget _nickname() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50.0),
      child: TextField(
        controller: nicknameController,
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.all(10),
          hintText: '닉네임',
        ),
      ),
    );
  }

  Widget _description() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50.0),
      child: TextField(
        controller: descriptionController,
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.all(10),
          hintText: '나를 소개하는 한마디',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          '회원가입',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        // controller: controller,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 30),
            _avatar(),
            SizedBox(height: 30),
            _nickname(),
            SizedBox(height: 30),
            _description(),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 50),
        child: ElevatedButton(
          onPressed: () {
            // print(nicknameController.text);
            // print(descriptionController.text);

            // validation 있어야 함 닉네임에 대한 대소문자 및 아이디 중복
            var signupUser = Puser(
              uid: widget.uid,
              nickname: nicknameController.text,
              description: descriptionController.text,
            );
            AuthController.to.signup(signupUser, thumbnailXfile);
          },
          child: const Text('회원가입'),
        ),
      ),
    );
  }
}
