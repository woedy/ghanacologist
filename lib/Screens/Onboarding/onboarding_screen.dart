import 'package:flutter/material.dart';
import 'package:ghanacologist/Screens/Authentication/SignIn/sign_in_screen.dart';

import '../../constants.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Container(
        margin: EdgeInsets.all(0),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Image(
                  image: AssetImage('assets/images/BG2.png')),
            ),

            Positioned(
              top: 40,
              child: Container(
                margin: EdgeInsets.only(left: 15),
                child: Image(
                    height: 60,
                    image: AssetImage('assets/images/ghanaco-logo.png', )),
              ),),
            Positioned(
              child: Container(
                margin: EdgeInsets.only(left: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [


                    Text.rich(
                      TextSpan(
                        text: "Welcome to ",
                    style: TextStyle(fontSize: 20),
                    children: <InlineSpan>[
                          TextSpan(
                            text: "Ghanacologist",
                            style: TextStyle(color: ghanaPrimary, fontSize: 20)
                          )
                        ]
                      )
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Text("Get", style: TextStyle(
                          fontSize: 84, fontWeight: FontWeight.w900, fontFamily: 'Montserrat',),),
                        Text("Ready", style: TextStyle(fontSize: 84, fontWeight: FontWeight.w900, fontFamily: 'Montserrat',),),
                        Text("to", style: TextStyle(fontSize: 84, fontWeight: FontWeight.w900, fontFamily: 'Montserrat',),),
                        Text("Explore", style: TextStyle(fontSize: 84, fontWeight: FontWeight.w900, fontFamily: 'Montserrat', color: ghanaPrimary),),
                      ],

                    ),

                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 20,
              right: 10,
              child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  width: 260,
                  height: 55,
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      color: ghanaPrimary,
                      borderRadius: BorderRadius.circular(10)

                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: (){
                        Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => SignInScreen()));

                      },
                      child: Align(
                        child: Container(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text("Let’s get started", style: TextStyle(fontSize: 20, color: Colors.white),),
                              SizedBox(
                                width: 20,
                              ),
                              Icon(Icons.arrow_forward_ios_sharp, size: 15, color: Colors.white,)
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 20,
                )
              ],
            ),
            )

          ],
        ),

      ),
    );
  }
}
