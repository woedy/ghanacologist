import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ghanacologist/Screens/Services/models/insights_model.dart';
import 'package:ghanacologist/Screens/Services/models/service_model.dart';
import 'package:ghanacologist/constants.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';




Future<Insights> createInsights(String caption, XFile imageFile) async {
  var token = await getApiPref();

  final url = Uri.parse(hostName + "/insights");
  final request = http.MultipartRequest('POST', url);

  request.headers['Accept'] = 'application/json';
  request.headers['Authorization'] = 'Bearer ' + token.toString();


  request.fields['caption'] = caption;
  request.files.add(await http.MultipartFile.fromPath('media', imageFile.path));

  final response = await request.send();
  if (response.statusCode == 201) {
    return Insights.fromJson(jsonDecode(await response.stream.bytesToString()));
  } else {
    throw Exception('Failed to create insights.');
  }
}

Future<Services> createServices(
    String name,
    String phone,
    String email,
    String city,
    String region,
    String _url,
    String description,
    XFile imageFile,
    ) async {
  var token = await getApiPref();
  final url = Uri.parse(hostName + "/services");


  final request = http.MultipartRequest('POST', url);

  request.headers['Accept'] = 'application/json';
  request.headers['Authorization'] = 'Bearer ' + token.toString();


  request.fields['name'] = name;
  request.fields['phone'] = phone;
  request.fields['email'] = email;
  request.fields['city'] = city;
  request.fields['region'] = region;
  request.fields['url'] = _url;
  request.fields['description'] = description;
  request.files.add(await http.MultipartFile.fromPath('photo', imageFile.path));

  final response = await request.send();
  if (response.statusCode == 201) {
    final responseBody = await response.stream.bytesToString();
    print('Services Response Body: $responseBody');
    return Services.fromJson(jsonDecode(responseBody));
  } else {
    final responseBody = await response.stream.bytesToString();
    print('Services Response Body: $responseBody');
    throw Exception('Failed to create services.');
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  final TextEditingController _captionController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _regionController = TextEditingController();
  final TextEditingController _urlController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  Future<dynamic>? _futureData;
  XFile? _selectedImage;

  Future<void> _pickImage() async {
    final imagePicker = ImagePicker();
    XFile? pickedImage = await imagePicker.pickImage(source: ImageSource.camera);
    if (pickedImage != null) {
      setState(() {
        _selectedImage = pickedImage;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Create Data Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Create Data Example'),
        ),
        body: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8),
          child: (_futureData == null) ? buildColumn() : buildFutureBuilder(),
        ),
      ),
    );
  }

  Column buildColumn() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        TextField(
          controller: _captionController,
          decoration: const InputDecoration(hintText: 'Enter Caption'),
        ),
        ElevatedButton(
          onPressed: () {
            _pickImage().then((_) {
              setState(() {
                _futureData = createInsights(_captionController.text, _selectedImage!);
              });
            });
          },
          child: const Text('Create Insights'),
        ),
        SizedBox(height: 20),
        TextField(
          controller: _nameController,
          decoration: const InputDecoration(hintText: 'Enter Name'),
        ),
        TextField(
          controller: _phoneController,
          decoration: const InputDecoration(hintText: 'Enter Phone'),
        ),
        TextField(
          controller: _emailController,
          decoration: const InputDecoration(hintText: 'Enter Email'),
        ),
        TextField(
          controller: _cityController,
          decoration: const InputDecoration(hintText: 'Enter City'),
        ),
        TextField(
          controller: _regionController,
          decoration: const InputDecoration(hintText: 'Enter Region'),
        ),
        TextField(
          controller: _urlController,
          decoration: const InputDecoration(hintText: 'Enter URL'),
        ),
        TextField(
          controller: _descriptionController,
          decoration: const InputDecoration(hintText: 'Enter Description'),
        ),
        ElevatedButton(
          onPressed: () {
            _pickImage().then((_) {
              setState(() {
                _futureData = createServices(
                  _nameController.text,
                  _phoneController.text,
                  _emailController.text,
                  _cityController.text,
                  _regionController.text,
                  _urlController.text,
                  _descriptionController.text,
                  _selectedImage!,
                );
              });
            });
          },
          child: const Text('Create Services'),
        ),
      ],
    );
  }

  FutureBuilder<dynamic> buildFutureBuilder() {
    return FutureBuilder<dynamic>(
      future: _futureData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasData) {
          if (snapshot.data is Insights) {
            return Column(
              children: [
                Text('Caption: ${snapshot.data!.data!.caption}'),
                Image.network(snapshot.data!.data!.media),
              ],
            );
          } else if (snapshot.data is Services) {
            return Column(
              children: [
                Text('Name: ${snapshot.data!.data!.name}'),
                Text('Phone: ${snapshot.data!.data!.phone}'),
                Text('Email: ${snapshot.data!.data!.email}'),
                Text('City: ${snapshot.data!.data!.city}'),
                Text('Region: ${snapshot.data!.data!.region}'),
                Text('URL: ${snapshot.data!.data!.url}'),
                Text('Description: ${snapshot.data!.data!.description}'),
                Image.network(snapshot.data!.data!.photo),
              ],
            );
          }
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }

        return Container();
      },
    );
  }
}
