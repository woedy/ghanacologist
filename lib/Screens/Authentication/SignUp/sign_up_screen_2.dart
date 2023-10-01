import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ghanacologist/Screens/Authentication/SignIn/sign_in_screen.dart';
import 'package:ghanacologist/Screens/Authentication/SignUp/sign_up_model.dart';
import 'package:ghanacologist/Screens/Authentication/SignUp/sign_up_screen_orig.dart';
import 'package:ghanacologist/Screens/Authentication/SignUp/verify_email_otp.dart';
import 'package:ghanacologist/constants.dart';
import 'package:http/http.dart' as http;

import '../../Components/keyboard_utils.dart';

Future<SignUpModel> signUpUser(data) async {
  //Uri.parse(hostName + "/api/accounts/login-user"),

  final response = await http.post(
    Uri.parse(hostName + "/register"),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json'
    },
    body: jsonEncode(data)
  /*  body: jsonEncode({
      "first_name": "Liwwewelre",
      "last_name": "Feneqwr",
      "username": "Ywwewwnwsaa",
      "email": "geeipeqq800@iturchia.com",
      "phone": "+233245676599",
      "dob": "2020-02-11",
      "country": "Gh",
      "phone_country": "Gh",
      "password": "Dela123Ping!"
    }),*/
  );

  if (response.statusCode == 201) {
    print(jsonDecode(response.body));
    return SignUpModel.fromJson(jsonDecode(response.body));
  } else if (response.statusCode == 422) {
    print(jsonDecode(response.body));
    return SignUpModel.fromJson(jsonDecode(response.body));
  }  else {

    throw Exception('Failed to Sign Up');
  }
}




class SignUp2Screen extends StatefulWidget {
  final data;

  const SignUp2Screen({Key? key, required this.data}) : super(key: key);

  @override
  State<SignUp2Screen> createState() => _SignUp2ScreenState();
}

class _SignUp2ScreenState extends State<SignUp2Screen> {

  Future<SignUpModel>? _futureSignUp;
  final _formKey = GlobalKey<FormState>();

  String? email;
  String? username;
  String? password;
  String? password2;

  var show_password = false;





  @override
  Widget build(BuildContext context) {
    //print(widget.data.toString());
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
                    height: 15,
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image(
                          height: 167,
                          image: AssetImage('assets/icons/signup-logo.png', )),
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
                              keyboardType: TextInputType.emailAddress,
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
                              onSaved: (value) {
                                setState(() {
                                  username = value;
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
                                //hintText: 'Enter Password',


                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        show_password = !show_password;
                                      });
                                    },
                                    icon: Icon(
                                      show_password
                                          ? Icons.remove_red_eye_outlined
                                          : Icons.remove_red_eye,
                                      color: Colors.grey,
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

                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Password is required';
                                }
                                if (!RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$%^&*])')
                                    .hasMatch(value)) {

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text("- Password must be at least 8 characters long\n- Must include at least one uppercase letter,\n- One lowercase letter, one digit,\n- And one special character"),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                  return '';
                                }
                                return null;
                              },
                              onChanged: (value) {
                                setState(() {
                                  password = value;
                                });
                              },
                              textInputAction: TextInputAction.next,
                              autofocus: true,
                              obscureText: show_password ? false : true,

                              onSaved: (value) {

                                setState(() {
                                  password = value;

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
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        show_password = !show_password;
                                      });
                                    },
                                    icon: Icon(
                                      show_password
                                          ? Icons.remove_red_eye_outlined
                                          : Icons.remove_red_eye,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  hintStyle: TextStyle(
                                      color: Colors.grey, fontWeight: FontWeight.normal),
                                  labelText: "Re-enter Password",
                                  labelStyle: TextStyle(fontSize: 13, color: bodyText2),
                                  enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.white)),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.white)),
                                  border: UnderlineInputBorder(
                                      borderSide: BorderSide(color: bodyText2))),
                              inputFormatters: [LengthLimitingTextInputFormatter(225)],
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Password is required';
                                }

                                if (value != password) {
                                  return 'Passwords do not match';
                                }
                                return null;
                              },
                              onChanged: (value) {
                                setState(() {
                                  password2 = value;
                                });
                              },
                              textInputAction: TextInputAction.next,
                              autofocus: true,
                              obscureText: show_password ? false : true,

                              onSaved: (value) {

                                setState(() {
                                  password2 = value;

                                });



                              },
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),


                        ],
                      )
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


                              widget.data['email'] = email;
                              widget.data['username'] = username;
                              widget.data['password'] = password;

                              print(widget.data);




                              _futureSignUp = signUpUser(widget.data!);

                            }
                          },
                          child: Align(
                            child: Container(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text("Sign Up", style: TextStyle(fontSize: 15, color: Colors.white),),

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

            if(data.message == "User registration succesful") {
              WidgetsBinding.instance.addPostFrameCallback((timeStamp) {



                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => VerifyEmailOTP(token: data.meta!.token!.toString())));

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
                            Expanded(child: Text(data.message!)),
                          ],
                        ),
                        content: Text("User account registered successfully."),
                      );
                    }
                );

              });
            } else if (data.message == "User authentication failed") {
              String? errorKey = snapshot.data!.errors!.keys.firstWhere(
                    (key) => key == "password" || key == "email",
                orElse: () => null!,
              );
              if (errorKey != null) {

                WidgetsBinding.instance.addPostFrameCallback((timeStamp) {

                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => SignUpScreen())
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

            else {

              WidgetsBinding.instance.addPostFrameCallback((timeStamp) {

                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => SignUpScreen())
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



}
