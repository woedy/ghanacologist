import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ghanacologist/Screens/Onboarding/onboarding_screen.dart';

import '../../constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>  with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation<double>? _animation;


  initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
      value: 0.5,
    )..repeat(reverse: true);
    _animation = CurvedAnimation(
      parent: _controller!,
      curve: Curves.easeIn,
    );
  }
  @override
  Widget build(BuildContext context) {

    Timer(
      Duration(seconds: 3),
        ()=> Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => OnboardingScreen()))
    );

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Container(
        margin: EdgeInsets.all(0),
        child: Stack(
          children: [
            Positioned(
              right: -20,
                child: Image(image: AssetImage('assets/images/BG2.png')
                )
            ),
            Positioned(
              top: 0,
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  child: ScaleTransition(
                    scale: _animation!,
                    child: Image(image: AssetImage('assets/images/ghanaco-logo.png'), height: 150,),
                  ),
                ),
            )
          ],
        ),

      ),
    );
  }


  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

}
