import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'POST Request Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _responseData = '';

  Future<String> postData(String url, Map<String, dynamic> data) async {
    final response = await http.post(Uri.parse(url), body: data);
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to post data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('POST Request Demo'),
      ),
      body: Center(
        child: FutureBuilder<String>(
          future: postData('YOUR_POST_URL', {'key': 'value'}), // Replace with your post URL and data
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              _responseData = snapshot.data!;
              return Text('Response: $_responseData');
            }
          },
        ),
      ),
    );
  }
}
