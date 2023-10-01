import 'dart:convert';
import 'dart:io';

import 'package:country_picker/country_picker.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:date_field/date_field.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ghanacologist/Screens/Components/keyboard_utils.dart';
import 'package:ghanacologist/Screens/Components/photos/select_photo_options_screen.dart';
import 'package:ghanacologist/Screens/HomeScreen/event_details.dart';
import 'package:ghanacologist/Screens/Insights/insights.dart';
import 'package:ghanacologist/Screens/UserProfile/models/user_profile_model.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../constants.dart';

import 'package:http/http.dart' as http;

Future<ProfileModel> updateProfile(data) async {

  var token = await getApiPref();

  final url = Uri.parse(hostName + "/profile/avatar");
  final request = http.MultipartRequest('PATCH', url);

  request.headers['Accept'] = 'application/json';
  request.headers['Authorization'] = 'Bearer ' + token.toString();



  request.files.add(await http.MultipartFile.fromPath('avatar', data.path));

  final response = await request.send();
  if (response.statusCode == 200) {
    return ProfileModel.fromJson(jsonDecode(await response.stream.bytesToString()));
  } else if (response.statusCode == 422) {
    return ProfileModel.fromJson(jsonDecode(await response.stream.bytesToString()));

  }  else {

    throw Exception('Failed to Update profile');
  }
}



class EditProfilePic extends StatefulWidget {
  const EditProfilePic({Key? key,}) : super(key: key);

  @override
  State<EditProfilePic> createState() => _EditProfilePicState();
}

class _EditProfilePicState extends State<EditProfilePic> {
  final _formKey = GlobalKey<FormState>();

  Future<ProfileModel>? _futureUpdateProfile;

  File? _image;




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

                          Text("Edit Profile Picture")
                        ],
                      ),
                
                      SizedBox(
                        height: 20,
                      ),

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
                                  _showSelectPhotoOptions(
                                      context);
                                },
                                child:
                                _image ==
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
                                      Text("Upload profile picture")
                                    ],
                                  ),
                                )
                                    : Container(
                                  decoration: BoxDecoration(
                                      borderRadius:
                                      BorderRadius.circular(20),
                                      image: DecorationImage(image: FileImage(_image!), fit: BoxFit.contain)),
                                ),
                              ),
                              if (_image != null)
                                Positioned(
                                  /* bottom: 0,
                                                  right: 0,
                                                  left:0,
                                                  top: 0,*/
                                  child:
                                  ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        _image =
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
                        height: 20,
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
                                if(_image != null){
                                  _futureUpdateProfile = updateProfile(_image);

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
                    MaterialPageRoute(builder: (context) => EditProfilePic())
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


  void _showSelectPhotoOptions(BuildContext context) {
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
                onTap: _pickImage,
              ),
            );
          }),
    );
  }


  Future _pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;
      File? img = File(image.path);
      img = await _cropImage(imageFile: img);
      setState(() {
        _image = img;
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


}
