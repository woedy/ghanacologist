import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ghanacologist/Screens/Authentication/SignIn/models/sign_in_model.dart';
import 'package:ghanacologist/Screens/Authentication/SignIn/sign_in_screen.dart';
import 'package:ghanacologist/Screens/Authentication/SignUp/sign_up_screen.dart';
import 'package:ghanacologist/Screens/Components/keyboard_utils.dart';
import 'package:ghanacologist/constants.dart';
import 'package:ghanacologist/demo_login.dart';
import 'package:ghanacologist/main.dart';
import 'package:http/http.dart' as http;
import 'package:pin_code_text_field/pin_code_text_field.dart';
import 'package:shared_preferences/shared_preferences.dart';


Future<SignInModel> signInUser(String token, String email_token) async {

  final response = await http.post(
    Uri.parse(hostName + "/verify-email"),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      'Authorization': "Bearer " + token
    },
    body: jsonEncode({
      "token": email_token,
    }),
  );

  if (response.statusCode == 200) {
    print(jsonDecode(response.body));
    return SignInModel.fromJson(jsonDecode(response.body));
  } else if (response.statusCode == 422) {
    print(jsonDecode(response.body));
    return SignInModel.fromJson(jsonDecode(response.body));
  }  else {

    throw Exception('Failed to verify');
  //return SignInModel.fromJson(jsonDecode(response.body));
  }
}

class VerifyEmailOTP extends StatefulWidget {
  final token;
  const VerifyEmailOTP({Key? key, required this.token}) : super(key: key);

  @override
  State<VerifyEmailOTP> createState() => _VerifyEmailOTPState();
}

class _VerifyEmailOTPState extends State<VerifyEmailOTP> {

  TextEditingController controller = TextEditingController(text: "");
  bool hasError = false;
  String? email_token;


  Future<SignInModel>? _futureSignIn;
  final _formKey = GlobalKey<FormState>();



  @override
  Widget build(BuildContext context) {
    //return buildColumn();
    return (_futureSignIn == null) ? buildColumn() : buildFutureBuilder();
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
                          text: "Verify ",
                          style: TextStyle(fontSize: 64,  fontWeight: FontWeight.w900, color: dark),
                          children: <InlineSpan>[
                            TextSpan(
                                text: "Email",
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Center(
                          child: PinCodeTextField(
                            autofocus: true,
                            controller: controller,
                            hideCharacter: false,
                            highlight: true,
                            highlightColor: Colors.red,
                            defaultBorderColor:
                            Colors.grey.withOpacity(0.3),
                            hasTextBorderColor:
                            Colors.grey.withOpacity(0.2),
                            highlightPinBoxColor: Colors.white,
                            pinBoxColor: Colors.white,
                            pinBoxRadius: 10,
                            maxLength: 4,
                            //maskCharacter: "😎",
                            onTextChanged: (text) {
                              setState(() {
                                hasError = false;
                              });
                            },
                            onDone: (text) {
                              print("DONE $text");
                              print("DONE CONTROLLER ${controller.text}");
                              email_token=text.toString();
                            },
                            pinBoxWidth: 80,
                            pinBoxHeight: 80,
                            //hasUnderline: true,
                            wrapAlignment: WrapAlignment.spaceAround,
                            pinBoxDecoration: ProvidedPinBoxDecoration
                                .defaultPinBoxDecoration,
                            pinTextStyle: TextStyle(fontSize: 35.0),
                            pinTextAnimatedSwitcherTransition:
                            ProvidedPinBoxTextAnimation
                                .scalingTransition,
                            pinTextAnimatedSwitcherDuration:
                            Duration(milliseconds: 300),
                            highlightAnimationBeginColor: Colors.black,
                            highlightAnimationEndColor: Colors.white12,
                            keyboardType: TextInputType.number,
                          ),
                        ),

                      ],
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
                            //Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => HomeScreen()));

                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              KeyboardUtil.hideKeyboard(context);

                              _futureSignIn = signInUser(widget.token!, email_token!);
                            }
                          },
                          child: Align(
                            child: Container(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text("Confirm", style: TextStyle(fontSize: 15, color: Colors.white),),

                                ],
                              ),
                            ),
                          ),
                        ),
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


  FutureBuilder<SignInModel> buildFutureBuilder() {
    return FutureBuilder<SignInModel>(
      future: _futureSignIn,
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

           if(data.message == "Email verified successfully") {

              WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => SignInScreen())
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
                        content: Text(data.message!),
                      );
                    }
                );

              });
            }
           else {
             WidgetsBinding.instance.addPostFrameCallback((timeStamp) {

               Navigator.pushReplacement(context,
                   MaterialPageRoute(builder: (context) => VerifyEmailOTP(token: widget.token,))
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
                           Text("Error"),
                         ],
                       ),
                       content: Text("Failed to verify."),
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

  Future<bool> saveIDApiKey(String apiKey) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("API_Key", apiKey);
    return prefs.commit();
  }


  Future<bool> saveUSER_ID(String userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("USER_ID", userId.toString());
    return prefs.commit();
  }




  void dispose() {
    super.dispose();
  }




}


