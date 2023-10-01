import 'dart:convert';
import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ghanacologist/Screens/Components/keyboard_utils.dart';
import 'package:ghanacologist/Screens/Components/photos/select_photo_options_screen.dart';
import 'package:ghanacologist/Screens/Insights/insights.dart';
import 'package:ghanacologist/Screens/Services/models/add_insights_model.dart';
import 'package:ghanacologist/Screens/Services/models/insights_model.dart';
import 'package:ghanacologist/Screens/Services/models/service_model.dart';
import 'package:ghanacologist/Screens/Shop/shop_screen.dart';
import 'package:ghanacologist/Screens/UserProfile/user_profile.dart';
import 'package:ghanacologist/constants.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import 'package:http/http.dart' as http;



Future<Insights> createInsights(String caption, imageFile) async {
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
    data,
    imageFile,
    ) async {
  var token = await getApiPref();
  final url = Uri.parse(hostName + "/services");


  final request = http.MultipartRequest('POST', url);

  request.headers['Accept'] = 'application/json';
  request.headers['Authorization'] = 'Bearer ' + token.toString();


  request.fields['name'] = data['name'];
  request.fields['phone'] = data['phone'];
  request.fields['email'] = data['email'];
  request.fields['city'] = data['city'];
  request.fields['region'] = data['region'];
  request.fields['url'] = data['url'];
  request.fields['description'] = data['description'];
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



class AddScreen extends StatefulWidget {
  const AddScreen({Key? key}) : super(key: key);

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  final _insightsFormKey = GlobalKey<FormState>();
  final _servicesFormKey = GlobalKey<FormState>();
  Future<dynamic>? _futureData;


  File? _insightImage;
  String? _insightsCaption;

  File? _serviceImage;
  String? _service_name;
  String? _phone;
  String? _email;
  String? _city;
  String? _region;
  String? _url;
  String? _description;
  String? countryError;

  Future<AddInsightModel>? _futureAddInsights;

  @override
  void initState() {
    super.initState();
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }


  @override
  Widget build(BuildContext context) {
    return (_futureData == null) ? buildColumn() : buildFutureBuilder();
  }

  buildColumn() {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  child: Image(
                                      height: 41,
                                      image: AssetImage(
                                        'assets/images/ghanaco-logo.png',
                                      )),
                                ),
                                Stack(
                                  children: [
                                    Container(
                                      width: 80,
                                      child: Image(
                                          height: 41,
                                          image: AssetImage(
                                            'assets/icons/cart.png',
                                          )),
                                    ),
                                    Positioned(
                                        top: 0,
                                        right: 0,
                                        child: Container(
                                          //padding: EdgeInsets.all(5),
                                          height: 20,
                                          width: 20,
                                          decoration: BoxDecoration(
                                              color: Colors.red,
                                              borderRadius:
                                                  BorderRadius.circular(100)),
                                          child: Center(
                                            child: Text(
                                              "1",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ))
                                  ],
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                UserProfile()));
                                  },
                                  child: Image(
                                      height: 41,
                                      image: AssetImage(
                                        'assets/icons/logo-yellow.png',
                                      )),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Upload",
                                  style: TextStyle(
                                      fontSize: 36,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height - 115,
                        child: Container(
                          width: double.infinity,
                          child: DefaultTabController(
                            length: 2,
                            child: Column(
                              children: [
                                Container(
                                  child: TabBar(
                                    indicator: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25.0),
                                    ),
                                    labelColor: ghanaPrimary,
                                    unselectedLabelColor: dark,
                                    tabs: [
                                      Align(
                                        child: Container(
                                          //width: 384,
                                          //height: 45,
                                          padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                              color: ghanaPrimary,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Material(
                                            color: Colors.transparent,
                                            child: InkWell(
                                              onTap: () {},
                                              child: Align(
                                                child: Container(
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Text(
                                                        "Service",
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Align(
                                        child: Container(
                                          //width: 384,
                                          //height: 45,
                                          padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all(
                                                color: dark.withOpacity(0.2),
                                                width: 1,
                                              ),
                                              color: Colors.white),
                                          child: Material(
                                            color: Colors.transparent,
                                            child: InkWell(
                                              onTap: () {},
                                              child: Align(
                                                child: Container(
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Text(
                                                        "Insight",
                                                        style: TextStyle(
                                                          fontSize: 15,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Expanded(
                                  child: TabBarView(children: [
                                    SingleChildScrollView(
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Form(
                                          key: _servicesFormKey,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Stack(
                                                        children: [
                                                          DottedBorder(
                                                            borderType:
                                                                BorderType.RRect,
                                                            radius: Radius.circular(
                                                                100),
                                                            dashPattern: [10, 10],
                                                            color: Colors.red,
                                                            strokeWidth: 2,
                                                            child: Container(
                                                              width: 110,
                                                              height: 110,
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                              ),
                                                              child: InkWell(
                                                                onTap: () {
                                                                  _showSelectServicePhotoOptions(context);
                                                                },
                                                                child: _serviceImage == null ? Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Icon(
                                                                      Icons
                                                                          .add_a_photo,
                                                                      size: 30,
                                                                    ),
                                                                  ],
                                                                ) : Container(
                                                                  decoration: BoxDecoration(
                                                                      borderRadius:
                                                                      BorderRadius.circular(100),
                                                                      image: DecorationImage(image: FileImage(_serviceImage!), fit: BoxFit.contain)),
                                                                ),
                                                              ),
                                                            ),
                                                          ),

                                                          if (_serviceImage != null)
                                                            Positioned(
                                                              child:
                                                              ElevatedButton(
                                                                onPressed: () {
                                                                  setState(() {
                                                                    _serviceImage =
                                                                    null;
                                                                  });
                                                                },
                                                                child: Icon(
                                                                  Icons
                                                                      .delete_forever,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                                style: ElevatedButton
                                                                    .styleFrom(
                                                                  primary:
                                                                  Colors
                                                                      .red,
                                                                  shape:
                                                                  CircleBorder(),
                                                                  padding:
                                                                  EdgeInsets
                                                                      .all(
                                                                      2),
                                                                ),
                                                              ),
                                                            ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 30,
                                                  ),
                                                  Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 10),
                                                    decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                        border: Border.all(
                                                            color: dark
                                                                .withOpacity(
                                                                    0.1))),
                                                    child: TextFormField(
                                                      style: TextStyle(
                                                          color: Colors.black),
                                                      decoration:
                                                          InputDecoration(
                                                              //hintText: 'Enter Username/Email',

                                                              hintStyle: TextStyle(
                                                                  color: Colors
                                                                      .grey,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal),
                                                              labelText:
                                                                  "Service Name",
                                                              labelStyle: TextStyle(
                                                                  fontSize: 13,
                                                                  color:
                                                                      bodyText2),
                                                              enabledBorder: UnderlineInputBorder(
                                                                  borderSide: BorderSide(
                                                                      color: Colors
                                                                          .white)),
                                                              focusedBorder: UnderlineInputBorder(
                                                                  borderSide: BorderSide(
                                                                      color: Colors
                                                                          .white)),
                                                              border: UnderlineInputBorder(
                                                                  borderSide:
                                                                      BorderSide(
                                                                          color:
                                                                              bodyText2))),
                                                      inputFormatters: [
                                                        LengthLimitingTextInputFormatter(
                                                            225)
                                                      ],
                                                      validator: (name) {
                                                        if (name!.isEmpty) {
                                                          return 'Service Name is required';
                                                        }
                                                        if (name.length < 3) {
                                                          return 'Service Name too short';
                                                        }
                                                        return null;
                                                      },
                                                      textInputAction:
                                                          TextInputAction.next,
                                                      autofocus: true,
                                                      onSaved: (value) {
                                                        setState(() {
                                                          _service_name = value;
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 30,
                                                  ),
                                                  Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 10),
                                                    decoration: BoxDecoration(
                                                        //color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                        color: Colors.white,
                                                        border: Border.all(
                                                          color: dark
                                                              .withOpacity(0.1),
                                                        )),
                                                    child: TextFormField(
                                                      style: TextStyle(
                                                          color: Colors.black),
                                                      decoration:
                                                          InputDecoration(
                                                        //hintText: 'Enter Username/Email',

                                                        hintStyle: TextStyle(
                                                            color: Colors.grey,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal),
                                                        labelText:
                                                            "Ex. +447373838388",
                                                        labelStyle: TextStyle(
                                                            fontSize: 13,
                                                            color: Colors.grey),
                                                        enabledBorder:
                                                            UnderlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    color: Colors
                                                                        .transparent)),
                                                        focusedBorder:
                                                            UnderlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    color: Colors
                                                                        .transparent)),
                                                        border:
                                                            InputBorder.none,
                                                      ),
                                                      inputFormatters: [
                                                        LengthLimitingTextInputFormatter(
                                                            225),
                                                        // PasteTextInputFormatter(),
                                                      ],
                                                      keyboardType:
                                                          TextInputType.phone,
                                                      validator: (value) {
                                                        if (value!.isEmpty) {
                                                          return 'Phone number is required';
                                                        }

                                                        bool isValid =
                                                            validatePhoneNumber(
                                                                value);

                                                        if (isValid) {
                                                          print(
                                                              "THE NUMBER IS VALID");
                                                        } else {
                                                          return "International format required. Eg.+447373838388.";
                                                        }

                                                        return null;
                                                      },
                                                      textInputAction:
                                                          TextInputAction.next,
                                                      autofocus: false,
                                                      onSaved: (value) {
                                                        setState(() {
                                                          _phone = value;
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 30,
                                                  ),
                                                  Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 10),
                                                    decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                        border: Border.all(
                                                            color: dark
                                                                .withOpacity(
                                                                    0.1))),
                                                    child: TextFormField(
                                                      style: TextStyle(
                                                          color: Colors.black),
                                                      decoration: InputDecoration(
                                                          hintStyle: TextStyle(
                                                              color:
                                                                  Colors.grey,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal),
                                                          labelText: "Email",
                                                          labelStyle: TextStyle(
                                                              fontSize: 13,
                                                              color: bodyText2),
                                                          enabledBorder:
                                                              UnderlineInputBorder(
                                                                  borderSide:
                                                                      BorderSide(
                                                                          color: Colors
                                                                              .white)),
                                                          focusedBorder:
                                                              UnderlineInputBorder(
                                                                  borderSide:
                                                                      BorderSide(
                                                                          color: Colors
                                                                              .white)),
                                                          border: UnderlineInputBorder(
                                                              borderSide:
                                                                  BorderSide(
                                                                      color:
                                                                          bodyText2))),
                                                      inputFormatters: [
                                                        LengthLimitingTextInputFormatter(
                                                            225)
                                                      ],
                                                      validator: (email) {
                                                        if (email!.isEmpty) {
                                                          return 'Email is required';
                                                        }

                                                        String pattern =
                                                            r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
                                                            r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
                                                            r"{0,253}[a-zA-Z0-9])?)*$";
                                                        RegExp regex =
                                                            RegExp(pattern);
                                                        if (email == null ||
                                                            email.isEmpty ||
                                                            !regex.hasMatch(
                                                                email))
                                                          return 'Enter a valid email address';
                                                        else
                                                          return null;
                                                      },
                                                      keyboardType:
                                                          TextInputType
                                                              .emailAddress,
                                                      textInputAction:
                                                          TextInputAction.next,
                                                      autofocus: true,
                                                      onSaved: (value) {
                                                        setState(() {
                                                          _email = value;
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 30,
                                                  ),
                                                  Container(
                                                    padding:
                                                    EdgeInsets.symmetric(
                                                        horizontal: 10),
                                                    decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                        BorderRadius
                                                            .circular(5),
                                                        border: Border.all(
                                                            color: dark
                                                                .withOpacity(
                                                                0.1))),
                                                    child: TextFormField(
                                                      style: TextStyle(
                                                          color: Colors.black),
                                                      decoration:
                                                      InputDecoration(
                                                        //hintText: 'Enter Username/Email',

                                                          hintStyle: TextStyle(
                                                              color: Colors
                                                                  .grey,
                                                              fontWeight:
                                                              FontWeight
                                                                  .normal),
                                                          labelText:
                                                          "City",
                                                          labelStyle: TextStyle(
                                                              fontSize: 13,
                                                              color:
                                                              bodyText2),
                                                          enabledBorder: UnderlineInputBorder(
                                                              borderSide: BorderSide(
                                                                  color: Colors
                                                                      .white)),
                                                          focusedBorder: UnderlineInputBorder(
                                                              borderSide: BorderSide(
                                                                  color: Colors
                                                                      .white)),
                                                          border: UnderlineInputBorder(
                                                              borderSide:
                                                              BorderSide(
                                                                  color:
                                                                  bodyText2))),
                                                      inputFormatters: [
                                                        LengthLimitingTextInputFormatter(
                                                            225)
                                                      ],
                                                      validator: (name) {
                                                        if (name!.isEmpty) {
                                                          return 'City is required';
                                                        }
                                                        if (name.length < 3) {
                                                          return 'City too short';
                                                        }
                                                        return null;
                                                      },
                                                      textInputAction:
                                                      TextInputAction.next,
                                                      autofocus: true,
                                                      onSaved: (value) {
                                                        setState(() {
                                                          _city = value;
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 30,
                                                  ),
                                                  Container(
                                                    padding:
                                                    EdgeInsets.symmetric(
                                                        horizontal: 10),
                                                    decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                        BorderRadius
                                                            .circular(5),
                                                        border: Border.all(
                                                            color: dark
                                                                .withOpacity(
                                                                0.1))),
                                                    child: TextFormField(
                                                      style: TextStyle(
                                                          color: Colors.black),
                                                      decoration:
                                                      InputDecoration(
                                                        //hintText: 'Enter Username/Email',

                                                          hintStyle: TextStyle(
                                                              color: Colors
                                                                  .grey,
                                                              fontWeight:
                                                              FontWeight
                                                                  .normal),
                                                          labelText:
                                                          "Region",
                                                          labelStyle: TextStyle(
                                                              fontSize: 13,
                                                              color:
                                                              bodyText2),
                                                          enabledBorder: UnderlineInputBorder(
                                                              borderSide: BorderSide(
                                                                  color: Colors
                                                                      .white)),
                                                          focusedBorder: UnderlineInputBorder(
                                                              borderSide: BorderSide(
                                                                  color: Colors
                                                                      .white)),
                                                          border: UnderlineInputBorder(
                                                              borderSide:
                                                              BorderSide(
                                                                  color:
                                                                  bodyText2))),
                                                      inputFormatters: [
                                                        LengthLimitingTextInputFormatter(
                                                            225)
                                                      ],
                                                      validator: (name) {
                                                        if (name!.isEmpty) {
                                                          return 'Region is required';
                                                        }
                                                        if (name.length < 3) {
                                                          return 'Region too short';
                                                        }
                                                        return null;
                                                      },
                                                      textInputAction:
                                                      TextInputAction.next,
                                                      autofocus: true,
                                                      onSaved: (value) {
                                                        setState(() {
                                                          _region = value;
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 30,
                                                  ),
                                                  Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 10),
                                                    decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                        border: Border.all(
                                                            color: dark
                                                                .withOpacity(
                                                                    0.1))),
                                                    child: TextFormField(
                                                      style: TextStyle(
                                                          color: Colors.black),
                                                      decoration:
                                                          InputDecoration(
                                                              //hintText: 'Enter Username/Email',

                                                              hintStyle: TextStyle(
                                                                  color: Colors
                                                                      .grey,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal),
                                                              labelText: "URL",
                                                              labelStyle: TextStyle(
                                                                  fontSize: 13,
                                                                  color:
                                                                      bodyText2),
                                                              enabledBorder: UnderlineInputBorder(
                                                                  borderSide: BorderSide(
                                                                      color: Colors
                                                                          .white)),
                                                              focusedBorder: UnderlineInputBorder(
                                                                  borderSide: BorderSide(
                                                                      color: Colors
                                                                          .white)),
                                                              border: UnderlineInputBorder(
                                                                  borderSide:
                                                                      BorderSide(
                                                                          color:
                                                                              bodyText2))),
                                                      inputFormatters: [
                                                        LengthLimitingTextInputFormatter(
                                                            225)
                                                      ],
                                                      validator: (name) {
                                                        if (name!.isEmpty) {
                                                          return 'URL is required';
                                                        }
                                                        if (name.length < 3) {
                                                          return 'URL too short';
                                                        }
                                                        return null;
                                                      },
                                                      textInputAction:
                                                          TextInputAction.next,
                                                      autofocus: true,
                                                      onSaved: (value) {
                                                        setState(() {
                                                          _url = value;
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 30,
                                                  ),
                                                  Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 10),
                                                    decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                        border: Border.all(
                                                            color: dark
                                                                .withOpacity(
                                                                    0.1))),
                                                    child: TextFormField(
                                                      style: TextStyle(
                                                          color: Colors.black),
                                                      maxLines: 3,
                                                      decoration:
                                                          InputDecoration(
                                                              //hintText: 'Enter Username/Email',

                                                              hintStyle: TextStyle(
                                                                  color: Colors
                                                                      .grey,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal),
                                                              labelText:
                                                                  "Service Description",
                                                              labelStyle: TextStyle(
                                                                  fontSize: 13,
                                                                  color:
                                                                      bodyText2),
                                                              enabledBorder: UnderlineInputBorder(
                                                                  borderSide: BorderSide(
                                                                      color: Colors
                                                                          .white)),
                                                              focusedBorder: UnderlineInputBorder(
                                                                  borderSide: BorderSide(
                                                                      color: Colors
                                                                          .white)),
                                                              border: UnderlineInputBorder(
                                                                  borderSide:
                                                                      BorderSide(
                                                                          color:
                                                                              bodyText2))),
                                                      inputFormatters: [
                                                        LengthLimitingTextInputFormatter(
                                                            225)
                                                      ],
                                                      validator: (name) {
                                                        if (name!.isEmpty) {
                                                          return 'Description is required';
                                                        }
                                                        if (name.length < 3) {
                                                          return 'Description too short';
                                                        }
                                                        return null;
                                                      },
                                                      textInputAction:
                                                          TextInputAction.next,
                                                      autofocus: true,
                                                      onSaved: (value) {
                                                        setState(() {
                                                          _description = value;
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 30,
                                                  ),
                                                  Align(
                                                    child: Container(
                                                      width: 384,
                                                      height: 55,
                                                      padding:
                                                          EdgeInsets.all(15),
                                                      decoration: BoxDecoration(
                                                          color: ghanaPrimary,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      15)),
                                                      child: Material(
                                                        color:
                                                            Colors.transparent,
                                                        child: InkWell(
                                                          onTap: () {
                                                            if (_servicesFormKey.currentState!.validate()) {
                                                              _servicesFormKey.currentState!.save();
                                                              KeyboardUtil.hideKeyboard(context);

                                                              var _service_data = {
                                                                'name': _service_name,
                                                                'phone': _phone,
                                                                'email': _email,
                                                                'city': _city,
                                                                'region': _region,
                                                                'url': _url,
                                                                'description': _description,
                                                              };

                                                              print(_serviceImage);

                                                              print(_service_data);

                                                              setState(() {
                                                                _futureData = createServices(_service_data, _serviceImage);
                                                              });

                                                            }
                                                          },
                                                          child: Align(
                                                            child: Container(
                                                              child: Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: [
                                                                  Text(
                                                                    "Upload Service",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            15,
                                                                        color: Colors
                                                                            .white),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 100,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    SingleChildScrollView(
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Form(
                                              key: _insightsFormKey,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  DottedBorder(
                                                    borderType:
                                                        BorderType.RRect,
                                                    radius: Radius.circular(20),
                                                    dashPattern: [10, 10],
                                                    color: Colors.red,
                                                    strokeWidth: 2,
                                                    child: Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      height: 300,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                      child: Stack(
                                                        children: [
                                                          InkWell(
                                                            onTap: () {
                                                              _showSelectInsightPhotoOptions(
                                                                  context);
                                                            },
                                                            child:
                                                                _insightImage ==
                                                                        null
                                                                    ? Container(
                                                                        width: MediaQuery.of(context)
                                                                            .size
                                                                            .width,
                                                                        child:
                                                                            Column(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.center,
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          children: [
                                                                            Icon(
                                                                              Icons.add_a_photo,
                                                                              size: 50,
                                                                            ),
                                                                            SizedBox(
                                                                              height: 20,
                                                                            ),
                                                                            Text("Upload Media of your Event")
                                                                          ],
                                                                        ),
                                                                      )
                                                                    : Container(
                                                                        decoration: BoxDecoration(
                                                                            borderRadius:
                                                                                BorderRadius.circular(20),
                                                                            image: DecorationImage(image: FileImage(_insightImage!), fit: BoxFit.contain)),
                                                                      ),
                                                          ),
                                                          if (_insightImage != null)
                                                            Positioned(
                                                              /* bottom: 0,
                                                  right: 0,
                                                  left:0,
                                                  top: 0,*/
                                                              child:
                                                                  ElevatedButton(
                                                                onPressed: () {
                                                                  setState(() {
                                                                    _insightImage =
                                                                        null;
                                                                  });
                                                                },
                                                                child: Icon(
                                                                  Icons
                                                                      .delete_forever,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                                style: ElevatedButton
                                                                    .styleFrom(
                                                                  primary:
                                                                      Colors
                                                                          .red,
                                                                  shape:
                                                                      CircleBorder(),
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              2),
                                                                ),
                                                              ),
                                                            ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 10),
                                                    decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                        border: Border.all(
                                                            color: dark
                                                                .withOpacity(
                                                                    0.1))),
                                                    child: TextFormField(
                                                      maxLines: 5,
                                                      style: TextStyle(
                                                          color: Colors.black),
                                                      decoration: InputDecoration(
                                                          hintStyle: TextStyle(
                                                              color:
                                                                  Colors.grey,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal),
                                                          labelText: "Caption",
                                                          labelStyle: TextStyle(
                                                              fontSize: 13,
                                                              color: bodyText2),
                                                          enabledBorder:
                                                              UnderlineInputBorder(
                                                                  borderSide:
                                                                      BorderSide(
                                                                          color: Colors
                                                                              .white)),
                                                          focusedBorder:
                                                              UnderlineInputBorder(
                                                                  borderSide:
                                                                      BorderSide(
                                                                          color: Colors
                                                                              .white)),
                                                          border: UnderlineInputBorder(
                                                              borderSide:
                                                                  BorderSide(
                                                                      color:
                                                                          bodyText2))),
                                                      inputFormatters: [
                                                        LengthLimitingTextInputFormatter(
                                                            225)
                                                      ],
                                                      validator: (name) {
                                                        if (name!.isEmpty) {
                                                          return 'Caption is required';
                                                        }
                                                        if (name.length < 3) {
                                                          return 'Caption too short';
                                                        }
                                                        return null;
                                                      },
                                                      textInputAction:
                                                          TextInputAction.next,
                                                      autofocus: true,
                                                      onSaved: (value) {
                                                        setState(() {
                                                          _insightsCaption =
                                                              value;
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Align(
                                                    child: Container(
                                                      width: 384,
                                                      height: 55,
                                                      padding:
                                                          EdgeInsets.all(15),
                                                      decoration: BoxDecoration(
                                                          color: ghanaPrimary,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      15)),
                                                      child: Material(
                                                        color:
                                                            Colors.transparent,
                                                        child: InkWell(
                                                          onTap: () {
                                                            if (_insightsFormKey
                                                                .currentState!
                                                                .validate()) {
                                                              _insightsFormKey
                                                                  .currentState!
                                                                  .save();
                                                              KeyboardUtil
                                                                  .hideKeyboard(
                                                                      context);

                                                              if (_insightImage !=
                                                                  null) {
                                                                var _data = {
                                                                  "media":
                                                                      _insightImage,
                                                                  "caption":
                                                                      _insightsCaption
                                                                };

                                                                print(_data);

                                                                setState(() {
                                                                  _futureData = createInsights(_insightsCaption.toString(), _insightImage);
                                                                });

                                                              } else {
                                                                ScaffoldMessenger.of(
                                                                        context)
                                                                    .showSnackBar(
                                                                  SnackBar(
                                                                    content: Text(
                                                                        'Media Require'),
                                                                  ),
                                                                );
                                                              }
                                                            }
                                                          },
                                                          child: Align(
                                                            child: Container(
                                                              child: Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: [
                                                                  Text(
                                                                    "Upload Insight",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            15,
                                                                        color: Colors
                                                                            .white),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 30,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  ]),
                                )
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                color: Colors.white,
                //height: 70,
                child: Column(
                  children: [
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => InsightsPage()),
                              (route) => false,
                            );
                          },
                          child: Row(
                            children: [
                              SizedBox(
                                width: 10,
                              ),
                              Column(
                                children: [
                                  Image(
                                      image:
                                          AssetImage('assets/icons/home.png')),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text('Home'),
                                ],
                              ),
                            ],
                          ),
                        ),
                    /*    InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    InsightsPage()));
                          },
                          child: Column(
                            children: [
                              Image(
                                  image:
                                      AssetImage('assets/icons/insights.png')),
                              SizedBox(
                                height: 5,
                              ),
                              Text('Insight'),
                            ],
                          ),
                        ),*/
                        InkWell(
                          onTap: () {
                            /*  Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    AddScreen()));
                          */
                          },
                          child: Column(
                            children: [
                              Image(image: AssetImage('assets/icons/add.png')),
                              SizedBox(
                                height: 5,
                              ),
                              Text('Add'),
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    ShopScreen()));
                          },
                          child: Column(
                            children: [
                              Image(image: AssetImage('assets/icons/shop.png')),
                              SizedBox(
                                height: 5,
                              ),
                              Text('Shop'),
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    UserProfile()));
                          },
                          child: Row(
                            children: [
                              Column(
                                children: [
                                  CircleAvatar(
                                    radius: 18,
                                    backgroundImage: AssetImage(
                                        'assets/icons/logo-yellow.png'), // Replace with your profile image path
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text('Profile'),
                                ],
                              ),
                              SizedBox(
                                width: 10,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  FutureBuilder<dynamic> buildFutureBuilder() {
    return FutureBuilder<dynamic>(
      future: _futureData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(
                    height: 10,
                  ),
                  Text("Please Wait...")
                ],
              ),
            ),
          );
        } else if (snapshot.hasData) {
          if (snapshot.data is Insights) {
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => InsightsPage())
              );

              showDialog(
                  barrierDismissible: true,
                  context: context,
                  builder: (BuildContext context){
                    return AlertDialog(
                      title: Row(
                        children: [
                          Icon(Icons.check_circle, color: Colors.green,),
                          SizedBox(
                            width: 10,
                          ),
                          Text("Successful"),
                        ],
                      ),
                      content: Text("Insight created successfully"),
                    );
                  }
              );

            });
          } else if (snapshot.data is Services) {
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => InsightsPage())
              );

              showDialog(
                  barrierDismissible: true,
                  context: context,
                  builder: (BuildContext context){
                    return AlertDialog(
                      title: Row(
                        children: [
                          Icon(Icons.check_circle, color: Colors.green,),
                          SizedBox(
                            width: 10,
                          ),
                          Text("Successful"),
                        ],
                      ),
                      content: Text("Service created successfully"),
                    );
                  }
              );

            });
          }
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }

        return Container();
      },
    );
  }

  Future _pickInsightImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;
      File? img = File(image.path);
      img = await _cropImage(imageFile: img);
      setState(() {
        _insightImage = img;
        Navigator.of(context).pop();
      });
    } on PlatformException catch (e) {
      print(e);
      Navigator.of(context).pop();
    }
  }

  Future _pickServiceImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;
      File? img = File(image.path);
      img = await _cropImage(imageFile: img);
      setState(() {
        _serviceImage = img;
        Navigator.of(context).pop();
      });
    } on PlatformException catch (e) {
      print(e);
      Navigator.of(context).pop();
    }
  }


  Future<File?> _cropImage({required File imageFile}) async {
    CroppedFile? croppedImage =
        await ImageCropper().cropImage(sourcePath: imageFile.path);
    if (croppedImage == null) return null;
    return File(croppedImage.path);
  }

  void _showSelectInsightPhotoOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0),
        ),
      ),
      builder: (context) => DraggableScrollableSheet(
          initialChildSize: 0.28,
          maxChildSize: 0.4,
          minChildSize: 0.28,
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: SelectPhotoOptionsScreen(
                onTap: _pickInsightImage,
              ),
            );
          }),
    );
  }


  void _showSelectServicePhotoOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0),
        ),
      ),
      builder: (context) => DraggableScrollableSheet(
          initialChildSize: 0.28,
          maxChildSize: 0.4,
          minChildSize: 0.28,
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: SelectPhotoOptionsScreen(
                onTap: _pickServiceImage,
              ),
            );
          }),
    );
  }




}
