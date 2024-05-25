import 'package:flutter/material.dart';
import 'package:zerowastapplication/Widget/wavebarclipper.dart';

class wavebar extends StatelessWidget{
  @override
  Widget build(BuildContext context) {

      Size size = MediaQuery.of(context).size;

      return Positioned(
        bottom: 0,
        child: ClipPath(
          clipper: Wavebarclipper(),
          child: Container(
            height: size.height*0.9,
            width: size.width,
            color: Color(0xFFC7E8D5),
            padding: EdgeInsets.only(top: 4),
          ),
        ),
      );
  }
}