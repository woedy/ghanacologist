import 'dart:convert';

import 'package:country_picker/country_picker.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ghanacologist/Screens/Authentication/SignUp/sign_up_model.dart';
import 'package:ghanacologist/Screens/Authentication/SignUp/sign_up_screen_2.dart';
import 'package:ghanacologist/constants.dart';
import 'package:http/http.dart' as http;

import '../../Components/keyboard_utils.dart';



Future<SignUpModel> signUpUser(
    String first_name,
    String last_name,
    String dob,
    String country,
    String phone,
    ) async {
  //Uri.parse(hostName + "/api/accounts/login-user"),

  final response = await http.post(
    Uri.parse(hostName + "/api/accounts/pre-register-user"),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json'
    },
    body: jsonEncode({
      "first_name": first_name,
      "last_name": last_name,
      "dob": dob,
      "country": country,
      "phone": "phone"
    }),
  );

  if (response.statusCode == 200) {
    print(jsonDecode(response.body));
    return SignUpModel.fromJson(jsonDecode(response.body));
  } else if (response.statusCode == 404) {
    print(jsonDecode(response.body));
    return SignUpModel.fromJson(jsonDecode(response.body));
  }  else {

    throw Exception('Failed to Sign In');
    //return SignInModel.fromJson(jsonDecode(response.body));
  }
}



class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {


  final _formKey = GlobalKey<FormState>();

  Future<SignUpModel>? _futureSignUp;

  String? first_name;
  String? last_name;
  String? dob;
  String? country;
  String? phone;

  @override
  Widget build(BuildContext context) {
    return (_futureSignUp == null) ? buildColumn() : buildFutureBuilder();
  }


  buildColumn() {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Container(
        margin: EdgeInsets.only(left: 15, right: 15),
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  child: Image(
                      image: AssetImage('assets/images/BG3.png')),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 15),
                    child: Image(
                        height: 60,
                        image: AssetImage('assets/images/ghanaco-logo.png', )),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Text.rich(
                      TextSpan(
                          text: "Sign ",
                          style: TextStyle(fontSize: 64,  fontWeight: FontWeight.w900, color: dark),
                          children: <InlineSpan>[
                            TextSpan(
                                text: "Up",
                                style: TextStyle(color: ghanaPrimary, fontSize: 64, fontWeight: FontWeight.w900)
                            )
                          ]
                      )
                  ),
                  SizedBox(
                    height: 30,
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
                            /*validator: (name) {
                              if (name!.isEmpty) {
                                return 'First Name is required';
                              }
                              if (name.length < 3) {
                                return 'First Name too short';
                              }
                              return null;
                            },*/
                            textInputAction: TextInputAction.next,
                            autofocus: true,
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
                            /*validator: (name) {
                              if (name!.isEmpty) {
                                return 'Last Name is required';
                              }
                              if (name.length < 3) {
                                return 'Last Name too short';
                              }
                              return null;
                            },*/
                            textInputAction: TextInputAction.next,
                            autofocus: true,
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
                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(color: dark.withOpacity(0.1))
                            ),
                            child:   DateTimeFormField(
                              decoration: const InputDecoration(
                                hintStyle: TextStyle(color: Colors.black45),
                                errorStyle: TextStyle(color: Colors.redAccent),
                                border: InputBorder.none,
                                suffixIcon: Icon(Icons.event_note),
                                labelText: 'Date of birth',
                              ),
                              mode: DateTimeFieldPickerMode.date,
                              autovalidateMode: AutovalidateMode.always,
                              validator: (e) {
                                if(e == null){
                                  //return 'Date of birth required';
                                } return null;

                              },
                              // initialValue: DateTime.parse(widget.data["field_value"].toString()),
                              onDateSelected: (DateTime value) {

                              },
                              onSaved: (value) {
                                //_onSaveForm(value.toString());
                                setState(() {

                                  dob = value.toString();

                                });

                              },

                            )
                        ),
                        SizedBox(
                          height: 30,
                        ),

                        Container(
                          child:  CSCPicker(
                            showStates: false,
                            showCities: false,
                            onCountryChanged: (value) {
                              setState(() {
                                country = value;

                              });
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
                                hintStyle: TextStyle(
                                    color: Colors.grey, fontWeight: FontWeight.normal),
                                labelText: "Phone Number",
                                labelStyle: TextStyle(fontSize: 13, color: bodyText2),
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white)),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white)),
                                border: UnderlineInputBorder(
                                    borderSide: BorderSide(color: bodyText2))),
                            inputFormatters: [LengthLimitingTextInputFormatter(225)],
                           /* validator: (name) {
                              if (name!.isEmpty) {
                                return 'Phone Number is required';
                              }
                              if (name.length < 3) {
                                return 'Too short';
                              }
                              return null;
                            },*/
                            textInputAction: TextInputAction.next,
                            autofocus: true,
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
                                    signUpUser(first_name!, last_name!, dob!, country!, phone!);
                                    _futureSignUp = signUpUser(first_name!, last_name!, dob!, country!, phone!);
                                  }
                                },
                                child: Align(
                                  child: Container(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text("Continue", style: TextStyle(fontSize: 15, color: Colors.white),),

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
                    height: 30,
                  ),


                  Align(
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);

                      },
                      child: Text.rich(
                          TextSpan(
                              text: "Already have an account? ",
                              style: TextStyle(fontSize: 12,),
                              children: <InlineSpan>[
                                TextSpan(
                                    text: "Sign In here",
                                    style: TextStyle(color: dark, fontSize: 12, fontWeight: FontWeight.bold)
                                )
                              ]
                          )
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }


  FutureBuilder<SignUpModel> buildFutureBuilder() {
    return FutureBuilder<SignUpModel>(
        future: _futureSignUp,
        builder: (context, snapshot) {
          if(snapshot.hasData) {

            var data = snapshot.data!;

            print("#########################");
            print(data.message);

            if(data.message == "Successful") {


              WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));

                showDialog(
                    barrierDismissible: true,
                    context: context,
                    builder: (BuildContext context){
                      return AlertDialog(
                        title: Text(data.message!),
                        content: Text(data.data!.email!.toString()),
                      );
                    }
                );

              });
            } else if (data.message == "Error") {
              WidgetsBinding.instance.addPostFrameCallback((timeStamp) {

                //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignInScreen()));


                showDialog(
                    barrierDismissible: true,
                    context: context,
                    builder: (BuildContext context){
                      return AlertDialog(
                        title: Text("data.errors!.email![0]"),
                        //content: Text(data.data!.email!.toString()),
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







}


