import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ghanacologist/Screens/Authentication/Passwords/reset_password.dart';
import 'package:ghanacologist/Screens/Authentication/SignIn/models/sign_in_model.dart';
import 'package:ghanacologist/Screens/Authentication/SignUp/sign_up_screen.dart';
import 'package:ghanacologist/Screens/Components/keyboard_utils.dart';
import 'package:ghanacologist/Screens/Insights/insights.dart';
import 'package:ghanacologist/constants.dart';
import 'package:ghanacologist/main.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


Future<SignInModel> signInUser(String email, String password) async {

  final response = await http.post(
    Uri.parse(hostName + "/login"),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json'
    },
    body: jsonEncode({
      "email": email,
      "password": password,
    }),
  );

  if (response.statusCode == 200) {
    print(jsonDecode(response.body));
    final result = json.decode(response.body);
    if (result != null) {
      print(result['meta']['token'].toString());
      await saveIDApiKey(result['meta']['token'].toString());
    }
    return SignInModel.fromJson(jsonDecode(response.body));
  } else if (response.statusCode == 422) {
    print(jsonDecode(response.body));
    return SignInModel.fromJson(jsonDecode(response.body));
  }  else {

    throw Exception('Failed to Sign In');
  }
}


Future<bool> saveIDApiKey(String apiKey) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("API_Key", apiKey);
  return prefs.commit();
}




class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {

  Future<SignInModel>? _futureSignIn;
  final _formKey = GlobalKey<FormState>();
  String? email;
  String? password;

  var show_password = false;


  @override
  Widget build(BuildContext context) {
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
                          text: "Sign ",
                          style: TextStyle(fontSize: 64,  fontWeight: FontWeight.w900, color: dark),
                          children: <InlineSpan>[
                            TextSpan(
                                text: "In",
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
                            validator: (email) {
                              if (email!.isEmpty) {
                                return 'Email is required';
                              }

                              String pattern =
                                  r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
                                  r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
                                  r"{0,253}[a-zA-Z0-9])?)*$";
                              RegExp regex = RegExp(pattern);
                              if (email == null ||
                                  email.isEmpty ||
                                  !regex.hasMatch(email))
                                return 'Enter a valid email address';
                              else
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

                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    show_password = !show_password;

                                  });
                                }, icon: Icon(
                                show_password
                                  ? Icons.remove_red_eye_outlined
                                    : Icons.remove_red_eye, color: Colors.red,
                              ),
                              ),

                                hintStyle: TextStyle(
                                    color: Colors.grey, fontWeight: FontWeight.normal),
                                labelText: "Password",
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
                                return 'Password is required';
                              }
                              if (name.length < 3) {
                                return 'Password too short';
                              }
                              return null;
                            },
                            textInputAction: TextInputAction.next,
                            obscureText: show_password ? false : true,
                            autofocus: true,
                            onSaved: (value) {
                              setState(() {
                                password = value;
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

                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              KeyboardUtil.hideKeyboard(context);
                              signInUser(email!, password!);
                              _futureSignIn = signInUser(email!, password!);
                            }
                          },
                          child: Align(
                            child: Container(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text("Sign In", style: TextStyle(fontSize: 15, color: Colors.white),),

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

                  Align(
                    child: InkWell(
                      onTap: (){
                        Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => ResetPassword()));

                      },
                      child: Text.rich(
                          TextSpan(
                              text: "Forgot Password? ",
                              style: TextStyle(fontSize: 12,),
                              children: <InlineSpan>[
                                TextSpan(
                                  text: "Reset",
                                  style: TextStyle(color: dark, fontSize: 12, fontWeight: FontWeight.bold),

                                )
                              ]
                          )
                      ),
                    ),
                  ),

                  SizedBox(
                    height: 30,
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 170,
                        child: Divider(
                          color: dark,
                          thickness: 1,
                        ),
                      ),
                      Text("or"),

                      SizedBox(
                        width: 170,
                        child: Divider(
                          color: dark,
                          thickness: 1,
                        ),
                      ),

                    ],
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
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: dark.withOpacity(0.1))

                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: (){

                          },
                          child: Align(
                            child: Container(
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Image(image: AssetImage('assets/icons/googlee.png', )),
                                  SizedBox(
                                    width: 60,
                                  ),
                                  Text("Sign in with google", style: TextStyle(fontSize: 15, color: dark),),

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
                  Align(
                    child: Container(
                      width: 384,
                      height: 55,
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                          color: dark,
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


                                children: [
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Image(
                                      image: AssetImage('assets/icons/applee.png', )),
                                  SizedBox(
                                    width: 60,
                                  ),
                                  Text("Sign in with apple", style: TextStyle(fontSize: 15, color: Colors.white),),

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

                  Align(
                    child: InkWell(
                      onTap: (){
                        Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => SignUpScreen()));

                      },
                      child: Text.rich(
                          TextSpan(
                              text: "Don’t have an account? ",
                              style: TextStyle(fontSize: 12,),
                              children: <InlineSpan>[
                                TextSpan(
                                  text: "Sign Up here",
                                  style: TextStyle(color: dark, fontSize: 12, fontWeight: FontWeight.bold),

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

           if(data.message == "Login successful") {


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
                            Text(data.message!),
                          ],
                        ),
                        content: Text(data.data!.email!.toString()),
                      );
                    }
                );

              });
            }
           else if (data.message == "These credentials do not match our records.") {


             String? errorKey = snapshot.data!.errors!.keys.firstWhere(
                   (key) => key == "password" || key == "email",
               orElse: () => null!,
             );
             if (errorKey != null) {
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
           else if (data.message == "The selected email is invalid.") {


             String? errorKey = snapshot.data!.errors!.keys.firstWhere(
                   (key) => key == "password" || key == "email",
               orElse: () => null!,
             );
             if (errorKey != null) {
               WidgetsBinding.instance.addPostFrameCallback((timeStamp) {

                 Navigator.pushReplacement(context,
                     MaterialPageRoute(builder: (context) => SignInScreen())
                 );

                 //gipese8300@iturchia.com

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



  void dispose() {
    super.dispose();
  }



}


