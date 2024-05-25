import 'package:flutter/material.dart';
import 'package:zerowastapplication/Widget/wavebar.dart';

class MenuScreen extends StatelessWidget{
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
            children: [
                wavebar()
            ],
        ),
      ),
    );
  }
}