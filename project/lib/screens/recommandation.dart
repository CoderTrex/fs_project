import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:project/providers/auth.dart';
import 'package:project/screens/search_and_api_call.dart';
import 'dart:convert';

import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:project/wave/config.dart';
import 'package:project/wave/wave.dart';

import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart'; // Add this import for json decoding

void main() {
  runApp(MyApp_Reco());
}

class MyApp_Reco extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

Future<Map<String, dynamic>?> _delContentApi(
    String? email, String title) async {
  final baseUrl = "http://10.0.2.2:5000";
  final path = "/api_del_content";
  final uri = Uri.parse('$baseUrl$path?email=$email&title=$title');

  try {
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final result = response.body;
      return result.isNotEmpty ? {'message': 'Deleted successfully'} : null;
    } else {
      print("Error: ${response.statusCode}");
      return null;
    }
  } catch (e) {
    print("Error: $e");
    return null;
  }
}

class WebtoonTile extends StatelessWidget {
  final String title;
  final String author;
  final String imageUrl;
  final String url;

  WebtoonTile({
    required this.title,
    required this.author,
    required this.imageUrl,
    required this.url,
  });

  void _onTrashIconPressed(String? email, String title) async {
    try {
      final result = await _delContentApi(email, title);
      if (result != null) {
        print("API Response: $result");
        // Add any additional handling based on the API response, if needed
      } else {
        print("Failed to delete content via API.");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    String imageUrl2 =
        imageUrl.startsWith('https://') ? imageUrl : 'https:$imageUrl';
    return _buildCard(
      title: title,
      backgroundColor: Colors.purpleAccent,
      backgroundImage: DecorationImage(
        image: NetworkImage(
          imageUrl2,
          headers: {
            'User-Agent':
                'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36',
          },
        ),
        fit: BoxFit.cover, // or any other BoxFit that suits your needs
      ),
      config: CustomConfig(
        gradients: [
          [Colors.red, Color(0xEEF44336)],
          [Colors.red[800]!, Color(0x77E57373)],
          [Colors.orange, Color(0x66FF9800)],
          [Colors.yellow, Color(0x55FFEB3B)]
        ],
        durations: [35000, 19440, 10800, 6000],
        heightPercentages: [0.9, 0.8, 0.92, 0.82],
        gradientBegin: Alignment.bottomLeft,
        gradientEnd: Alignment.topRight,
      ),
    );
  }
}

Widget _buildCard({
  required Config config,
  Color? backgroundColor = Colors.transparent,
  DecorationImage? backgroundImage,
  double height = 152.0,
  String? title,
}) {
  double marginHorizontal = 16.0;
  return Container(
    height: height,
    width: double.infinity,
    child: Card(
      elevation: 12.0,
      margin: EdgeInsets.only(
          right: marginHorizontal, left: marginHorizontal, bottom: 16.0),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16.0))),
      child: WaveWidget(
        text: title ?? "",
        config: config,
        backgroundColor: backgroundColor,
        backgroundImage: backgroundImage,
        size: Size(double.infinity, double.infinity),
        waveAmplitude: 0,
      ),
    ),
  );
}

class _MyHomePageState extends State<MyHomePage> {
  Future<Map<String, dynamic>?> getContentApi(String? email) async {
    // 대기할 최대 시간 (초 단위)
    int retryCount = 0;
    final maxRetryDuration = 10;
    final baseUrl = "http://10.0.2.2:5000";
    final path2 = "/api_get_reco_content";
    final uri2 = Uri.parse('$baseUrl$path2?email=$email');

    while (retryCount < maxRetryDuration) {
      try {
        final response = await http.get(uri2);
        if (response.statusCode == 200) {
          final Map<String, dynamic>? result = json.decode(response.body);
          // JSON 데이터로 파싱
          print("Connection is Welldone");
          print(result);
          return result;
        } else {
          // 서버로부터 오류 응답
          print("Error: ${response.statusCode}");
          return null;
        }
      } catch (e) {
        // 네트워크 오류 등의 예외 처리
        print("Error: $e");
        // 재시도를 위해 2초 대기
        await Future.delayed(Duration(seconds: 2));
        retryCount++;
      }
    }

    print("Max retry duration exceeded");
    return null;
  }

  @override
  Widget build(BuildContext context) {
    String? email = Provider.of<Auth>(context).email;
    return Scaffold(
      appBar: AppBar(
        title: Text('Webtoon List'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchApi()),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: getContentApi(email),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError || !snapshot.hasData) {
            return Center(
              child: Text("Error fetching data"),
            );
          } else {
            final result = snapshot.data!;
            final allWebtoonWidgets = result.entries.map<Widget>((entry) {
              final webtoonList = entry.value;
              final webtoonListWidgets = webtoonList.map<Widget>((webtoon) {
                return Container(
                  margin: EdgeInsets.all(8.0), // Add some margin for spacing
                  child: WebtoonTile(
                    title: webtoon["title"] ?? "",
                    author: webtoon["author"] ?? "",
                    imageUrl: webtoon["img"] ?? "",
                    url: webtoon["url"] ?? "",
                  ),
                );
              }).toList();
              // Combine the webtoonListWidgets with a header for each entry.
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                  ),
                  ...webtoonListWidgets,
                ],
              );
            }).toList();

            return ListView(
              children: allWebtoonWidgets,
            );
          }
        },
      ),
    );
  }
}
