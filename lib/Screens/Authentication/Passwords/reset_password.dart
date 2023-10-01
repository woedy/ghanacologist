import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ghanacologist/Screens/Authentication/Passwords/reset_password_form.dart';
import 'package:ghanacologist/Screens/Authentication/Passwords/verify_password_otp.dart';
import 'package:ghanacologist/Screens/Authentication/SignIn/models/sign_in_model.dart';
import 'package:ghanacologist/Screens/Authentication/SignUp/sign_up_screen.dart';
import 'package:ghanacologist/Screens/Components/keyboard_utils.dart';
import 'package:ghanacologist/constants.dart';
import 'package:ghanacologist/main.dart';
import 'package:http/http.dart' as http;
import 'package:pin_code_text_field/pin_code_text_field.dart';
import 'package:shared_preferences/shared_preferences.dart';


Future<SignInModel> resetUserPassword(String email) async {
  //Uri.parse(hostName + "/api/accounts/login-user"),

  final response = await http.post(
    Uri.parse(hostName + "/forgot-password"),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json'
    },
    body: jsonEncode({
      "email": email,
    }),
  );

  if (response.statusCode == 200) {
    print(jsonDecode(response.body));
    return SignInModel.fromJson(jsonDecode(response.body));
  } else if (response.statusCode == 422) {
    print(jsonDecode(response.body));
    return SignInModel.fromJson(jsonDecode(response.body));
  }  else {

    throw Exception('Failed to Sign In');
  //return SignInModel.fromJson(jsonDecode(response.body));
  }
}

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {

  TextEditingController controller = TextEditingController(text: "");
  bool hasError = false;


  Future<SignInModel>? _futureSignIn;
  final _formKey = GlobalKey<FormState>();
  String? email;



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
                          text: "Reset ",
                          style: TextStyle(fontSize: 64,  fontWeight: FontWeight.w900, color: dark),
                          children: <InlineSpan>[
                            TextSpan(
                                text: "Password",
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
                                labelText: "Username/Email",
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
                                return 'Username/Email is required';
                              }
                              if (name.length < 3) {
                                return 'Name too short';
                              }
                              return null;
                            },
                            textInputAction: TextInputAction.next,
                            autofocus: true,
                            onSaved: (value) {

                              setState(() {
                                email = value;
                              });



                            },
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
                              _futureSignIn = resetUserPassword(email!);
                            }
                          },
                          child: Align(
                            child: Container(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text("Reset Password", style: TextStyle(fontSize: 15, color: Colors.white),),

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

           if(data.message == "We have emailed your password reset link.") {
              save_user_data(data);

              WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => VerifyPasswordOTP(email: email,))
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
                            Expanded(child: Text("Email verification")),
                          ],
                        ),
                        content: Text(data.message!),
                      );
                    }
                );

              });
            } else if (data.message == "Error") {


             String? errorKey = snapshot.data!.errors!.keys.firstWhere(
                   (key) => key == "password" || key == "email",
               orElse: () => null!,
             );
             if (errorKey != null) {
               WidgetsBinding.instance.addPostFrameCallback((timeStamp) {

                 Navigator.pushReplacement(context,
                     MaterialPageRoute(builder: (context) => ResetPassword())
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
                         content: Text(snapshot.data!.errors![errorKey]![0]),
                       );
                     }
                 );


               });
             } else {
               return Text("Unknown error occurred");
             }

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

  void save_user_data(SignInModel data) async {
    await saveIDApiKey(data.data!.token!.toString());
    await saveUSER_ID(data.data!.userId.toString());

  }


}


