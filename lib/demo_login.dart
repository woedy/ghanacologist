import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ghanacologist/Screens/Insights/insights.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login Demo',
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for the email and password fields
  final TextEditingController? _emailController = TextEditingController();
  final TextEditingController? _passwordController = TextEditingController();

  String _errorMessage = '';

  bool _isLoading = false;

  @override
  void dispose() {
    _emailController!.dispose();
    _passwordController!.dispose();
    super.dispose();
  }

  void _submitForm() async {
    // Show a loading spinner
    setState(() {
      _isLoading = true;
    });

    // Send a login request to the API
    final response = await http.post(
      Uri.parse('http://ghanacologist.teamalfy.co.uk/api/login'),
      body: {
        'email': _emailController!.text,
        'password': _passwordController!.text,
      },
    );

    // Hide the loading spinner
    setState(() {
      _isLoading = false;
    });

    // Check if the response was successful
    if (response.statusCode == 200) {
      // Extract the user data from the response body
      final data = jsonDecode(response.body)['data'];

      // Navigate to the next screen and pass the user data
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => InsightsPage(),
        ),
      );
    } else if (response.statusCode == 422) {
      // Extract the error message from the response body
      final error = jsonDecode(response.body)['errors']['email'][0];

      // Show the error message in a dialog box
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Login Failed'),
          content: Text(error),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    } else {
      // Show a generic error message in a dialog box
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Login Failed'),
          content: Text('An error occurred while logging in.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Login',
                  style: Theme.of(context).textTheme.headline4,
                ),
                SizedBox(height: 32.0),
                TextField(
                  controller: _emailController!,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: 'Email',
                  ),
                ),
                SizedBox(height: 16.0),
                TextField(
                  controller: _passwordController!,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Password',
                  ),
                ),
                SizedBox(height: 32.0),
                ElevatedButton(
                  onPressed: _isLoading ? null : _submitForm,
                  child: _isLoading
                      ? CircularProgressIndicator()
                      : Text('Login'),
                ),
                SizedBox(height: 16.0),
                Text(
                  _errorMessage,
                  style: TextStyle(color: Colors.red),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}