import 'package:flutter/material.dart';
import 'package:flutter_fancy_container/flutter_fancy_container.dart';
import 'dart:convert'; // Import the dart:convert library
import 'package:http/http.dart' as http;
import 'package:project/providers/auth.dart';
import 'package:project/providers/image_dart.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(SearchApi());
}

class SearchApi extends StatelessWidget {
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

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _wordController = TextEditingController();
  Future<Map<String, dynamic>?> _setContentApi(
      String title, String? email) async {
    final baseUrl = "http://10.0.2.2:5000";
    final path = "/api_set_content";
    final url = Uri.parse('$baseUrl$path?email=$email&title=$title');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final result = json.decode(response.body); // Parse JSON response
        print("4321 $result");
        return result;
      } else {
        print("Error: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Error: $e");
      return null;
    }
  }

  void _onSearchButtonPressed(BuildContext context, String? email) async {
    final String word = _wordController.text.trim();
    if (word.isNotEmpty) {
      final result = await _setContentApi(word, email);
      if (result != null) {
        // Check if the result is empty or not
        if (result.isNotEmpty) {
          _showResultSnackBar(context, "Search result is available!");
        } else {
          _showResultSnackBar(context, "No search result found.");
        }
      } else {
        _showResultSnackBar(context, "Failed to get recommendations from API.");
      }
    } else {
      _showResultSnackBar(context, "Please enter a word");
    }
  }

  void _showResultSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    String? email = Provider.of<Auth>(context).email;
    print("email test: $email");
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Get Webtoon!',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: Stack(children: [
        // 배경 이미지
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: FlutterFancyContainer(
            colorOne: Colors.red,
            colorTwo: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: _wordController,
                  decoration: InputDecoration(labelText: 'Enter a word'),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => _onSearchButtonPressed(context, email),
                  child: Text('Webtoon Search'),
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
