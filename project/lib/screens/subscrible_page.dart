import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:project/screens/search_and_api_call.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart'; // Add this import for json decoding

void main() {
  runApp(MyApp_Sub());
}

class MyApp_Sub extends StatelessWidget {
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

Future<Map<String, dynamic>?> _delContentApi(String email, String title) async {
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

  void _onTrashIconPressed(String email, String title) async {
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
    return Container(
      width: MediaQuery.of(context).size.width - 30,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(8.0),
        // title: Column(
        //   crossAxisAlignment: CrossAxisAlignment.start,
        //   mainAxisAlignment:
        //       MainAxisAlignment.end, // Align to the end of the row
        //   children: [
        //     Text(
        //       title,
        //       style: TextStyle(
        //         fontWeight: FontWeight.bold,
        //         fontSize: 16.0,
        //       ),
        //     ),
        //     SizedBox(height: 4.0),
        //     Text(author),
        //   ],
        // ),
        leading: Image.network(
          imageUrl,
          headers: {
            'User-Agent':
                'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36',
          },
          errorBuilder: (context, error, stackTrace) {
            return Icon(Icons.error);
          },
        ),
        // trailing: Row(
        //   mainAxisSize: MainAxisSize.min,
        //   children: [
        //     GestureDetector(
        //       onTap: () {
        //         String email = "plain_romance@naver.com";
        //         // _onTrashIconPressed(email, title);
        //         print("Trash icon tapped for $title");
        //       },
        //       child: Container(
        //         padding: EdgeInsets.all(4.0),
        //         decoration: BoxDecoration(
        //           shape: BoxShape.circle,
        //         ),
        //         child:
        //             Icon(Icons.delete, size: 20.0), // Adjust the size as needed
        //       ),
        //     ),
        //     SizedBox(width: 8),
        //   ],
        // ),
        onTap: () {
          try {
            // Perform the main action when the whole ListTile is tapped
            launch(url);
          } catch (e) {
            print("URL launch error");
          }
          print("Open URL: $url");
        },
      ),
    );
  }
}

class _MyHomePageState extends State<MyHomePage> {
  Future<Map<String, dynamic>?> getContentApi(String email) async {
    final baseUrl = "http://10.0.2.2:5000";
    final path = "/api_get_content";
    final uri = Uri.parse('$baseUrl$path?email=$email');

    try {
      final response = await http.get(uri);
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
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
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
        future: getContentApi("plain_romance@naver.com"),
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
            final webtoonList =
                result.entries.expand((entry) => entry.value).toList();

            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              itemCount: webtoonList.length,
              itemBuilder: (context, index) {
                final webtoon = webtoonList[index];
                return Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  margin: EdgeInsets.all(8.0),
                  child: WebtoonTile(
                    title: webtoon["title"] ?? "",
                    author: webtoon["author"] ?? "",
                    imageUrl: webtoon["img"] ?? "",
                    url: webtoon["url"] ?? "",
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
