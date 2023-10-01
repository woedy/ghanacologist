import 'dart:convert';

import 'package:country_picker/country_picker.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ghanacologist/Screens/Components/keyboard_utils.dart';
import 'package:ghanacologist/Screens/HomeScreen/event_details.dart';
import 'package:ghanacologist/Screens/Insights/insights.dart';
import 'package:ghanacologist/Screens/UserProfile/edit_profile_pic.dart';
import 'package:ghanacologist/Screens/UserProfile/models/user_profile_model.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../constants.dart';

import 'package:http/http.dart' as http;

Future<ProfileModel> updateProfile(data) async {

  var token = await getApiPref();


  final response = await http.patch(
      Uri.parse(hostName + "/profile"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer ' + token.toString()
      },
      body: jsonEncode(data)

  );

  if (response.statusCode == 200) {
    print(jsonDecode(response.body));
    return ProfileModel.fromJson(jsonDecode(response.body));
  } else if (response.statusCode == 422) {
    print(jsonDecode(response.body));
    return ProfileModel.fromJson(jsonDecode(response.body));
  }  else {

    throw Exception('Failed to Update profile');
  }
}



class EditUserProfile extends StatefulWidget {
  final data;
  const EditUserProfile({Key? key, required this.data}) : super(key: key);

  @override
  State<EditUserProfile> createState() => _EditUserProfileState();
}

class _EditUserProfileState extends State<EditUserProfile> {
  final _formKey = GlobalKey<FormState>();

  Future<ProfileModel>? _futureUpdateProfile;




  String? first_name;
  String? last_name;
  String? title;
  String? phone;
  String? username;




  @override
  Widget build(BuildContext context) {

    return (_futureUpdateProfile == null) ? buildColumn() : buildFutureBuilder();




  }


  buildColumn(){
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image(
                                height: 41,
                                image: AssetImage(
                                  'assets/images/ghanaco-logo.png',
                                )),
                            Image(
                                height: 41,
                                image: AssetImage(
                                  'assets/icons/logo-yellow.png',
                                )),
                          ],
                        ),
                      ),

                      SizedBox(
                        height: 5,
                      ),

                      Row(
                        children: [
                          InkWell(
                            onTap: (){
                              Navigator.pop(context);
                            },
                            child: Container(
                              padding: EdgeInsets.all(10),
                              margin: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: dark.withOpacity(0.2),
                                    width: 1,
                                  ),
                                  color: Colors.white
                              ),
                              child: Icon(Icons.arrow_back),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),

                          Text("Edit Profile")
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: (){
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      EditProfilePic()));

                            },
                            child: Stack(
                              children: [
                                Container(
                                  height: 130,
                                  child: Container(
                                    height: 100,
                                    width: 100,
                                    decoration: BoxDecoration(
                                        //color: Colors.red,
                                        borderRadius: BorderRadius.circular(100),
                                        image: DecorationImage(
                                            image: NetworkImage("https://ghanacologist.teamalfy.co.uk" + widget.data.avatar!.toString())
                                        )
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                    left: 0,
                                    right: 0,
                                    child: Icon(Icons.camera))
                              ],
                            ),
                          ),

                        ],
                      ),

                      SizedBox(
                        height: 20,
                      ),


                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(color: dark.withOpacity(0.1))
                              ),
                              child: TextFormField(
                                style: TextStyle(color: Colors.black),
                                decoration: InputDecoration(
                                  //hintText: 'Enter Username/Email',

                                    hintStyle: TextStyle(
                                        color: Colors.grey, fontWeight: FontWeight.normal),
                                    labelText: "First Name",
                                    labelStyle: TextStyle(fontSize: 13, color: bodyText2),
                                    enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Colors.white)),
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Colors.white)),
                                    border: UnderlineInputBorder(
                                        borderSide: BorderSide(color: bodyText2))),
                                inputFormatters: [LengthLimitingTextInputFormatter(225)],
                                validator: (name) {
                                  if (name!.isEmpty) {
                                    return 'First Name is required';
                                  }
                                  if (name.length < 3) {
                                    return 'First Name too short';
                                  }
                                  return null;
                                },
                                textInputAction: TextInputAction.next,
                                autofocus: true,
                                initialValue: widget.data.firstName,
                                onSaved: (value) {

                                  setState(() {
                                    first_name = value;

                                  });



                                },
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),

                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(color: dark.withOpacity(0.1))
                              ),
                              child: TextFormField(
                                style: TextStyle(color: Colors.black),
                                decoration: InputDecoration(
                                  //hintText: 'Enter Password',

                                    hintStyle: TextStyle(
                                        color: Colors.grey, fontWeight: FontWeight.normal),
                                    labelText: "Last Name",
                                    labelStyle: TextStyle(fontSize: 13, color: bodyText2),
                                    enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Colors.white)),
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Colors.white)),
                                    border: UnderlineInputBorder(
                                        borderSide: BorderSide(color: bodyText2))),
                                inputFormatters: [LengthLimitingTextInputFormatter(225)],
                                validator: (name) {
                                  if (name!.isEmpty) {
                                    return 'Last Name is required';
                                  }
                                  if (name.length < 3) {
                                    return 'Last Name too short';
                                  }
                                  return null;
                                },
                                textInputAction: TextInputAction.next,
                                autofocus: true,
                                initialValue: widget.data.lastName,
                                onSaved: (value) {

                                  setState(() {
                                    last_name = value;

                                  });



                                },
                              ),
                            ),

                            SizedBox(
                              height: 30,
                            ),


                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(color: dark.withOpacity(0.1))
                              ),
                              child: TextFormField(
                                style: TextStyle(color: Colors.black),
                                decoration: InputDecoration(
                                  //hintText: 'Enter Username/Email',

                                    hintStyle: TextStyle(
                                        color: Colors.grey, fontWeight: FontWeight.normal),
                                    labelText: "Username",
                                    labelStyle: TextStyle(fontSize: 13, color: bodyText2),
                                    enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Colors.white)),
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Colors.white)),
                                    border: UnderlineInputBorder(
                                        borderSide: BorderSide(color: bodyText2))),
                                inputFormatters: [LengthLimitingTextInputFormatter(225)],
                                validator: (name) {
                                  if (name!.isEmpty) {
                                    return 'Username is required';
                                  }
                                  if (name.length < 3) {
                                    return 'Username too short';
                                  }
                                  return null;
                                },
                                textInputAction: TextInputAction.next,
                                autofocus: true,
                                initialValue: widget.data.username,
                                onSaved: (value) {

                                  setState(() {
                                    username =value;
                                  });



                                },
                              ),
                            ),

                            SizedBox(
                              height: 30,
                            ),


                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(color: dark.withOpacity(0.1))
                              ),
                              child: TextFormField(
                                style: TextStyle(color: Colors.black),
                                decoration: InputDecoration(
                                  //hintText: 'Enter Username/Email',

                                    hintStyle: TextStyle(
                                        color: Colors.grey, fontWeight: FontWeight.normal),
                                    labelText: "Title",
                                    labelStyle: TextStyle(fontSize: 13, color: bodyText2),
                                    enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Colors.white)),
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Colors.white)),
                                    border: UnderlineInputBorder(
                                        borderSide: BorderSide(color: bodyText2))),
                                inputFormatters: [LengthLimitingTextInputFormatter(225)],
                                validator: (name) {

                                },
                                textInputAction: TextInputAction.next,
                                autofocus: true,
                                initialValue: widget.data.title,
                                onSaved: (value) {

                                  setState(() {
                                    title = value;

                                  });



                                },
                              ),
                            ),


                            SizedBox(
                              height: 30,
                            ),

                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                //color: Colors.white,
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.white,
                                  border: Border.all(
                                    color: dark.withOpacity(0.1),
                                  )),
                              child: TextFormField(
                                style: TextStyle(color: Colors.black),
                                decoration: InputDecoration(
                                  //hintText: 'Enter Username/Email',

                                  hintStyle: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.normal),
                                  labelText: "Ex. +447373838388",
                                  labelStyle:
                                  TextStyle(fontSize: 13, color: Colors.grey),
                                  enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.transparent)),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.transparent)),
                                  border: InputBorder.none,),
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(225),
                                  // PasteTextInputFormatter(),
                                ],
                                keyboardType: TextInputType.phone,
                                initialValue: widget.data.phone,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Phone number is required';
                                  }

                                  bool isValid = validatePhoneNumber(value);

                                  if (isValid) {
                                    print("THE NUMBER IS VALID");
                                  } else {
                                    return "International format required. Eg.+447373838388.";
                                  }


                                  return null;
                                },
                                textInputAction: TextInputAction.next,
                                autofocus: false,
                                onSaved: (value) {
                                  setState(() {
                                    phone = value;
                                  });
                                },
                              ),
                            ),


                            SizedBox(
                              height: 30,
                            ),
                          ],
                        ),
                      ),


                      Align(
                        child: Container(
                          width: 384,
                          height: 55,
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                              color: ghanaPrimary,
                              borderRadius: BorderRadius.circular(15)

                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: (){
                                if (_formKey.currentState!.validate()) {
                                  _formKey.currentState!.save();
                                  KeyboardUtil.hideKeyboard(context);

                                  var _data = {
                                    "first_name": first_name,
                                    "last_name": last_name,
                                    "title": title,
                                    "phone": phone,
                                    "username": username,

                                  };


                                    _futureUpdateProfile = updateProfile(_data);







                                }

                              },
                              child: Align(
                                child: Container(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text("Save & Continue", style: TextStyle(fontSize: 15, color: Colors.white),),

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


                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  FutureBuilder<ProfileModel> buildFutureBuilder() {
    return FutureBuilder<ProfileModel>(
        future: _futureUpdateProfile,
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
          }
          else if(snapshot.hasData) {

            var data = snapshot.data!;

            print("#########################");
            print(data.message);

            if(data.message == "Profile information updated successfully") {
              WidgetsBinding.instance.addPostFrameCallback((timeStamp) {



                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => InsightsPage()));

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
                            Expanded(child: Text("Successful")),
                          ],
                        ),
                        content: Text("Profile information updated successfully"),
                      );
                    }
                );

              });
            }

            else {

              WidgetsBinding.instance.addPostFrameCallback((timeStamp) {

                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => EditUserProfile(data: widget.data))
                );


                showDialog(
                    barrierDismissible: true,
                    context: context,
                    builder: (BuildContext context){
                      return AlertDialog(
                        title: Row(
                          children: [
                            Icon(Icons.error, color: Colors.red,),
                            SizedBox(
                              width: 10,
                            ),
                            Text("Failed to register"),
                          ],
                        ),
                        content: Text("Unable to register user in our database."),
                      );
                    }
                );


              });
            }
          }

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


        }
    );
  }


  Widget location_widget() {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (BuildContext context, int index) {
        return Column(
          children: [
            InkWell(
              onTap:(){
                Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => EventDetails()));
              },
              child: Container(
                height: 362,
                //color: Colors.blue,
                child: Stack(
                  children: [
                    Image.asset(
                      'assets/images/homeimage.png',
                      height: 362,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    Container(
                      height: 362,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.9),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(30)),
                    ),
                    Positioned(
                      top: 270,
                      left: 20,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Lynx Entertainment",
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "Afrochella",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 24),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.location_on_outlined,
                                color: Colors.white,
                                size: 15,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                "Independence Square",
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
          ],
        );
      },
    );
  }

  Widget date_calendar_widget() {
    return SingleChildScrollView(
      child: Container(
        height: 500,
        child: Card(
          elevation: 3,

          child: Container(
            height: 200,
            child: TableCalendar(
              firstDay: DateTime.utc(2010, 10, 16),
              lastDay: DateTime.utc(2030, 3, 14),
              focusedDay: DateTime.now(),

              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  // update `_focusedDay` here as well
                });
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget popularity_widget() {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (BuildContext context, int index) {
        return Column(
          children: [
            InkWell(
              onTap:(){
                Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => EventDetails()));
              },
              child: Column(

                children: [
                  SizedBox(
                    height: 20,
                  ),

                  Row(
                    children: [
                      Text("Select Rating"),
                      Row(
                        children: [
                          Icon(Icons.star, size: 20, color: Colors.yellow,),
                          Icon(Icons.star, size: 20, color: Colors.yellow,),
                          Icon(Icons.star, size: 20, color: Colors.yellow,),
                          Icon(Icons.star, size: 20, color: Colors.yellow,),
                          Icon(Icons.star_outline, size: 20, color: dark,)
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    height: 362,
                    //color: Colors.blue,
                    child: Stack(
                      children: [
                        Image.asset(
                          'assets/images/homeimage.png',
                          height: 362,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                        Container(
                          height: 362,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withOpacity(0.9),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(30)),
                        ),
                        Positioned(
                          top: 270,
                          left: 20,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Lynx Entertainment",
                                style: TextStyle(color: Colors.white, fontSize: 12),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "Afrochella",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 24),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.location_on_outlined,
                                        color: Colors.white,
                                        size: 15,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        "Independence Square",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 55,
                                  ),
                                  Row(
                                    children: [
                                      Icon(Icons.star, size: 20, color: Colors.yellow,),
                                      Icon(Icons.star, size: 20, color: Colors.yellow,),
                                      Icon(Icons.star, size: 20, color: Colors.yellow,),
                                      Icon(Icons.star, size: 20, color: Colors.yellow,),
                                      Icon(Icons.star_outline, size: 20, color: dark,)
                                    ],
                                  )
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
          ],
        );
      },
    );
  }
}
