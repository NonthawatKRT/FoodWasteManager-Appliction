import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:zerowastapplication/Scenes/Mainmenu.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: LottieBuilder.asset("assets/lottie/loading.json"),
          ),
        ],
      ),
      nextScreen: const MainPageContainer(),
      splashIconSize: 400,
      backgroundColor: const Color(0xFFC7E8D5),
      duration: 4700, // Set this to the duration of your Lottie animation in milliseconds
      splashTransition: SplashTransition.fadeTransition, // Optional: choose your preferred transition
      animationDuration: const Duration(seconds: 1), // Optional: animation duration for the transition
    );
  }
}
