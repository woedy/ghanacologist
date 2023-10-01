import 'dart:convert';
import 'dart:io';

import 'package:csc_picker/csc_picker.dart';
import 'package:date_field/date_field.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ghanacologist/Screens/Components/keyboard_utils.dart';
import 'package:ghanacologist/Screens/Components/photos/select_photo_options_screen.dart';
import 'package:ghanacologist/Screens/HomeScreen/event_details.dart';
import 'package:ghanacologist/Screens/Insights/insights.dart';
import 'package:ghanacologist/Screens/Services/models/add_insights_model.dart';
import 'package:ghanacologist/Screens/Shop/shop_screen.dart';
import 'package:ghanacologist/Screens/UserProfile/user_profile.dart';
import 'package:ghanacologist/constants.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:http/http.dart' as http;


Future<AddInsightModel> addInsight(caption, media) async {
  var token = await getApiPref();

  var request = http.MultipartRequest('POST', Uri.parse(hostName + "/insights"));

  // Add the image to the request
  var imageStream = http.ByteStream(media.openRead());
  var imageLength = await media.length();
  var multipartFile = http.MultipartFile('media', imageStream, imageLength,
      filename: media.path);

  request.headers['Accept'] = 'application/json';
  request.headers['Authorization'] = 'Bearer ' + token.toString();


  request.files.add(multipartFile);

  request.fields['caption'] = caption;

  // Send the request and get the response
  var response = await http.Response.fromStream(await request.send());

  print('######################');
  print(response.statusCode);




  if (response.statusCode == 201) {
    print(jsonDecode(response.body));
    return AddInsightModel.fromJson(jsonDecode(response.body));
  } else if (response.statusCode == 200) {
    print(jsonDecode(response.body));
    return AddInsightModel.fromJson(jsonDecode(response.body));
  }else if (response.statusCode == 422) {
    print(jsonDecode(response.body));
    return AddInsightModel.fromJson(jsonDecode(response.body));
  }   else {

    throw Exception('Failed to add data');
  }
}



class AddScreen extends StatefulWidget {
  const AddScreen({Key? key}) : super(key: key);

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {

  final _insightsFormKey = GlobalKey<FormState>();


  File? _insightImage;
  String? _insightsCaption;

  Future<AddInsightModel>? _futureAddInsights;




  File? _image2;


  @override
  Widget build(BuildContext context) {

    return (_futureAddInsights == null) ? buildColumn() : buildFutureBuilder();


  }


  buildColumn(){
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
                                              borderRadius: BorderRadius.circular(100)

                                          ),
                                          child: Center(
                                            child: Text("1", style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),),
                                          ),
                                        )
                                    )
                                  ],
                                ),
                                InkWell(
                                  onTap:(){
                                    Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => UserProfile()));
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
                                      fontSize: 36, fontWeight: FontWeight.w600),
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
                        height: MediaQuery.of(context).size.height-115,

                        child: Container(
                          width: double.infinity,
                          child: DefaultTabController(
                            length: 2,
                            child: Column(
                              children: [

                                Container(
                                  child: TabBar(
                                    indicator: BoxDecoration(
                                      borderRadius:  BorderRadius.circular(25.0),
                                    ),
                                    labelColor: ghanaPrimary,
                                    unselectedLabelColor: dark,
                                    tabs:   [
                                      Align(
                                        child: Container(
                                          //width: 384,
                                          //height: 45,
                                          padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                              color: ghanaPrimary,
                                              borderRadius: BorderRadius.circular(10)

                                          ),
                                          child: Material(
                                            color: Colors.transparent,
                                            child: InkWell(
                                              onTap: (){

                                              },
                                              child: Align(
                                                child: Container(
                                                  child: Row(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      Text("Service", style: TextStyle(fontSize: 15, color: Colors.white),),

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
                                              borderRadius: BorderRadius.circular(10),
                                              border: Border.all(
                                                color: dark.withOpacity(0.2),
                                                width: 1,
                                              ),
                                              color: Colors.white
                                          ),
                                          child: Material(
                                            color: Colors.transparent,
                                            child: InkWell(
                                              onTap: (){

                                              },
                                              child: Align(
                                                child: Container(
                                                  child: Row(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      Text("Insight", style: TextStyle(fontSize: 15,),),

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
                                  child: TabBarView(
                                      children: [

                                        service_widgets(),
                                        insight_widget(context),


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
                              MaterialPageRoute(builder: (context) => InsightsPage()),
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

                                  Image(image: AssetImage('assets/icons/home.png')),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text('Home'),
                                ],
                              ),
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    InsightsPage()));
                          },
                          child: Column(
                            children: [

                              Image(image: AssetImage('assets/icons/insights.png')),
                              SizedBox(
                                height: 5,
                              ),
                              Text('Insight'),
                            ],
                          ),
                        ),

                        InkWell(
                          onTap: () {
                            /*  Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    AddScreen()));
                          */},
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
                                    backgroundImage: AssetImage('assets/icons/logo-yellow.png'), // Replace with your profile image path
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


  FutureBuilder<AddInsightModel> buildFutureBuilder() {
    return FutureBuilder<AddInsightModel>(
        future: _futureAddInsights,
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

            if(data.message == "service created successfully") {
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


  Widget service_widgets() {
    return SingleChildScrollView(

      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [


                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DottedBorder(
                      borderType: BorderType.RRect,
                      radius: Radius.circular(100),
                      dashPattern: [10, 10],
                      color: Colors.red,
                      strokeWidth: 2,
                      child: Container(
                        width: 110,
                        height: 110,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),


                        ),
                        child: InkWell(
                          onTap: (){
                            //_showSelectPhotoOptions(context);
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add_a_photo,size: 30,),

                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
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
                        labelText: "Service Name",
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
                        return 'Service Name is required';
                      }
                      if (name.length < 3) {
                        return 'Service Name too short';
                      }
                      return null;
                    },
                    textInputAction: TextInputAction.next,
                    autofocus: true,
                    onSaved: (value) {

                      setState(() {

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
                        labelText: "Phone",
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
                        return 'Phone is required';
                      }
                      if (name.length < 3) {
                        return 'Phone too short';
                      }
                      return null;
                    },
                    textInputAction: TextInputAction.next,
                    autofocus: true,
                    onSaved: (value) {

                      setState(() {

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
                        labelText: "Email",
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
                        return 'Email is required';
                      }
                      if (name.length < 3) {
                        return 'Email too short';
                      }
                      return null;
                    },
                    textInputAction: TextInputAction.next,
                    autofocus: true,
                    onSaved: (value) {

                      setState(() {

                      });



                    },
                  ),
                ),

                SizedBox(
                  height: 30,
                ),

                Container(
                  child:  CSCPicker(
                    showStates: false,
                    showCities: false,
                    defaultCountry: CscCountry.Ghana,
                    onCountryChanged: (country) {

                    },
                  ),
                ),

                /*ElevatedButton(
                    onPressed: () {
                      showCountryPicker(
                        context: context,
                        //Optional.  Can be used to exclude(remove) one ore more country from the countries list (optional).
                        exclude: <String>['KN', 'MF'],
                        favorite: <String>['SE'],
                        //Optional. Shows phone code before the country name.
                        showPhoneCode: true,
                        onSelect: (Country country) {
                          print('Select country: ${country.displayNameNoCountryCode}');
                          print('Select country: ${country.flagEmoji}');
                        },
                        // Optional. Sets the theme for the country list picker.
                        countryListTheme: CountryListThemeData(
                          // Optional. Sets the border radius for the bottomsheet.
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(40.0),
                            topRight: Radius.circular(40.0),
                          ),
                          // Optional. Styles the search field.
                          inputDecoration: InputDecoration(
                            labelText: 'Search',
                            hintText: 'Start typing to search',
                            prefixIcon: const Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: const Color(0xFF8C98A8).withOpacity(0.2),
                              ),
                            ),
                          ),
                          // Optional. Styles the text in the search field
                          searchTextStyle: TextStyle(
                            color: Colors.blue,
                            fontSize: 18,
                          ),
                        ),
                      );
                    },
                    child: const Text('Show country picker'),
                  ),*/

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
                        labelText: "URL",
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
                        return 'URL is required';
                      }
                      if (name.length < 3) {
                        return 'URL too short';
                      }
                      return null;
                    },
                    textInputAction: TextInputAction.next,
                    autofocus: true,
                    onSaved: (value) {

                      setState(() {

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
                        labelText: "Service Description",
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
                        return 'URL is required';
                      }
                      if (name.length < 3) {
                        return 'URL too short';
                      }
                      return null;
                    },
                    textInputAction: TextInputAction.next,
                    autofocus: true,
                    onSaved: (value) {

                      setState(() {

                      });



                    },
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

                        },
                        child: Align(
                          child: Container(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text("Upload Service", style: TextStyle(fontSize: 15, color: Colors.white),),

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
    );
  }


  Widget insight_widget(BuildContext context) {
    return SingleChildScrollView(

      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Form(
              key: _insightsFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  DottedBorder(
                    borderType: BorderType.RRect,
                    radius: Radius.circular(20),
                    dashPattern: [10, 10],
                    color: Colors.red,
                    strokeWidth: 2,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 300,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),


                      ),
                      child: Stack(
                        children: [
                          InkWell(
                            onTap: (){
                              _showSelectInsightPhotoOptions(context);
                            },
                            child: _insightImage == null ? Container(
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.add_a_photo,size: 50,),
                                  SizedBox(
                                    height: 20,
                                  ),

                                  Text("Upload Media of your Event")
                                ],
                              ),
                            )
                                : Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  image: DecorationImage(
                                      image: FileImage(_insightImage!),
                                      fit: BoxFit.contain
                                  )
                              ),
                            ),
                          ),
                          if (_insightImage != null)
                            Positioned(
                              /* bottom: 0,
                                                  right: 0,
                                                  left:0,
                                                  top: 0,*/
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    _insightImage = null;
                                  });
                                },
                                child: Icon(Icons.delete_forever, color: Colors.white,),
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.red,

                                  shape: CircleBorder(

                                  ),
                                  padding: EdgeInsets.all(2),
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
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: dark.withOpacity(0.1))
                    ),
                    child: TextFormField(
                      maxLines: 5,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(

                          hintStyle: TextStyle(
                              color: Colors.grey, fontWeight: FontWeight.normal),
                          labelText: "Caption",
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
                          return 'Caption is required';
                        }
                        if (name.length < 3) {
                          return 'Caption too short';
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.next,
                      autofocus: true,
                      onSaved: (value) {

                        setState(() {
                          _insightsCaption = value;
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
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                          color: ghanaPrimary,
                          borderRadius: BorderRadius.circular(15)

                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: (){

                            if (_insightsFormKey.currentState!.validate()) {
                              _insightsFormKey.currentState!.save();
                              KeyboardUtil.hideKeyboard(context);

                              if(_insightImage != null){
                                var _data = {
                                  "media": _insightImage,
                                  "caption": _insightsCaption
                                };

                                print(_data);




                                _futureAddInsights = addInsight(_insightsCaption, _insightImage);

                              } else{

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Media Require'),
                                  ),
                                );

                              }



                            }

                          },
                          child: Align(
                            child: Container(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text("Upload Insight", style: TextStyle(fontSize: 15, color: Colors.white),),

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





}
