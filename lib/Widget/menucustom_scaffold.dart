import 'package:flutter/material.dart';

class MenuCustomScaffold extends StatelessWidget {
  const MenuCustomScaffold({super.key, required this.child, this.bottomNavigationBar});

  final Widget? child;
  final Widget? bottomNavigationBar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Color(0xFFC7E8D5), // Set the background color of the AppBar
        elevation: 0,
        title: Text('เมนู'),
      ),
      extendBodyBehindAppBar: false, // Ensure body does not extend behind the AppBar
      body: Stack(
        children: [
          // Positioned.fill(
          //   child: Image.asset(
          //     'assets/images/menubg2.jpg',
          //     fit: BoxFit.cover,
          //   ),
          // ),
          SafeArea(
            child: child!,
          ),
        ],
      ),
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
