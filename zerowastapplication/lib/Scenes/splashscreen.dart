import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:zerowastapplication/Scenes/Mainmenu.dart';

class SplashScreen extends StatelessWidget{
  const SplashScreen({super.key});

  get splash => null;

  @override
  Widget build(BuildContext context){
    return AnimatedSplashScreen(splash: 
    Column(
      children: [
        Center(
          child: LottieBuilder.asset("assets/lottie/startloading.json"),
        )
      ],
    ), nextScreen: const MenuScreen(),
    splashIconSize: 400,
    backgroundColor: Color(0xFFC7E8D5),);
  }
}