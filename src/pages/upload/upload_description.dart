import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../components/image_dart.dart';
import '../../controller/upload_controller.dart';

class UploadDescription extends GetView<UploadController> {
  const UploadDescription({super.key});

  Widget _description() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        children: [
          SizedBox(
            width: 60,
            height: 60,
            child: Image.file(
              controller.fileteredImage!,
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: TextField(
              controller: controller.textEditingController,
              maxLines: null,
              decoration: const InputDecoration(
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                contentPadding: EdgeInsets.only(left: 15),
                hintText: '문구 입력...',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoOnt(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 15),
      child: Text(
        title,
        style: const TextStyle(fontSize: 17),
      ),
    );
  }

  Widget get line => const Divider(
        color: Color(0xffe9e9e9),
        thickness: 1,
      );

  Widget _snsInfo() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Facebook',
                style: TextStyle(fontSize: 17),
              ),
              Switch(value: false, onChanged: (bool value) {})
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'X',
                style: TextStyle(fontSize: 17),
              ),
              Switch(value: false, onChanged: (bool value) {})
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Tumbler',
                style: TextStyle(fontSize: 17),
              ),
              Switch(value: false, onChanged: (bool value) {})
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        leading: GestureDetector(
          onTap: Get.back,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: ImageData(
              IconsPath.backBtnIcon,
              width: 50,
            ),
          ),
        ),
        title: const Text(
          '새 게시물',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
          GestureDetector(
            onTap: controller.uploadPost,
            child: Padding(
              padding: EdgeInsets.all(15),
              child: ImageData(
                IconsPath.uploadComplete,
                width: 50,
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            top: 0,
            child: GestureDetector(
              onTap: controller.unfocusKeyBoard,
              // () {
              // FocusManager.instance.primaryFocus?.unfocus();
              // },
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _description(),
                    _infoOnt('사람테그하기'),
                    line,
                    _infoOnt('위치 추가'),
                    line,
                    _infoOnt('다른 미디어에도 게시'),
                    line,
                    _snsInfo(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
