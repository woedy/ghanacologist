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
import 'package:intl/intl.dart';

import '../../Components/keyboard_utils.dart';






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
  String? phone;


  var _selectedCountry;
  String? countryError;


  @override
  Widget build(BuildContext context) {
    return  buildColumn();
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
                    height: 20,
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
                            onSaved: (value) {
                              setState(() {
                                first_name = value;
                              });
                            },
                          ),
                        ),
                        SizedBox(
                          height: 20,
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
                            onSaved: (value) {
                              setState(() {
                                last_name = value;
                              });
                            },
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),


                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Container(
                              height: 60,
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                      color: dark.withOpacity(0.1))),
                              child: Center(
                                child: DateTimeFormField(
                                  decoration: const InputDecoration(
                                    hintStyle: TextStyle(color: Colors.white),
                                    errorStyle: TextStyle(color: Colors.redAccent),
                                    border: InputBorder.none,
                                    suffixIcon: Icon(Icons.event_note, color: Colors.grey,),
                                    labelText: 'Date of birth',
                                    labelStyle: TextStyle(color: Colors.grey),
                                  ),
                                  //initialValue: DateTime.parse(widget.data!.dob),
                                  mode: DateTimeFieldPickerMode.date,
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  validator: (e) {
                                    if(e == null){
                                      return 'Date of birth required';
                                    }

                                    bool isValid = isDateBeforeToday(e.toString());

                                    if (isValid) {

                                    }else {
                                      return "The dob field must be a date before today.";
                                    }


                                    return null;

                                  },
                                  // initialValue: DateTime.parse(widget.data["field_value"].toString()),
                                  onDateSelected: (DateTime value) {

                                  },
                                  onSaved: (value) {
                                    //_onSaveForm(value.toString());
                                    setState(() {

                                      dob = formatDateTime(value.toString());

                                    });

                                  },

                                ),
                              ),
                            ),

                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),

                        InkWell(
                          onTap: () {
                            showCountryPicker(

                                context: context,
                                showPhoneCode: true,
                                onSelect: (Country country) {
                                  setState(() {
                                    _selectedCountry = country;
                                  });
                                },
                                countryListTheme: CountryListThemeData(
                                    textStyle: TextStyle(color: Colors.black)
                                )

                            );

                          },
                          child: Container(
                            height: 55,
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(color: dark.withOpacity(0.1)),
                            ),
                            child: Row(
                              children: [
                               Text(_selectedCountry != null ? _selectedCountry!.flagEmoji : '', style: TextStyle(fontSize: 25),),
                                if(_selectedCountry != null)...[
                                  SizedBox(
                                    width: 20,
                                  ),
                                ],
                                Text(_selectedCountry != null ? _selectedCountry!.name.toString() : 'Select Country'),
                              ],
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                countryError != null ? countryError.toString() : '',
                                style: TextStyle(color: Colors.red, fontSize: 12),
                              ),
                            ],
                          ),
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

                                    if(_selectedCountry != null){


                                      var reg_data = {
                                        "first_name": first_name,
                                        "last_name": last_name,
                                        "dob": dob,
                                        "country": _selectedCountry.countryCode.toString(),
                                        "phone": phone,
                                        "phone_country": _selectedCountry.countryCode.toString(),
                                      };

                                      print(reg_data);


                                      Navigator.of(context).push(MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              SignUp2Screen(data: reg_data,)));

                                    }else{
                                      setState(() {
                                        countryError = "Country required.";
                                      });
                                    }

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





}


