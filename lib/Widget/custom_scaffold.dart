import 'package:flutter/material.dart';

class CustomScaffold extends StatelessWidget {
  const CustomScaffold({super.key, required this.child, this.bottomNavigationBar});

  final Widget? child;
  final Widget? bottomNavigationBar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   iconTheme: const IconThemeData(color: Colors.white),
      //   backgroundColor: Color.fromARGB(255, 255, 0, 0),
      //   elevation: 0,
      // ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Positioned.fill(
            top: 0, // Move the image up by 50 pixels
            child: Image.asset(
              'assets/images/menubg2.jpg',
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: child!,
          ),
        ],
      ),
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
