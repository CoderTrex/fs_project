import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';

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
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0, // Adjust the font size as needed
              ),
            ),
            SizedBox(height: 4.0), // Add spacing between title and author
            Text(author),
          ],
        ),
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
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.favorite),
            SizedBox(width: 8),
            Icon(Icons.star),
          ],
        ),
        onTap: () {
          try {
            launch(url);
          } catch (e) {
            print("url launch error");
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
            final allWebtoonWidgets = result.entries.map<Widget>((entry) {
              final webtoonList = entry.value;
              final webtoonListWidgets = webtoonList.map<Widget>((webtoon) {
                return Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(
                        8.0), // Optional: Add rounded corners
                  ),
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
