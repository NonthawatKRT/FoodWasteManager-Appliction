import 'package:flutter/material.dart';

class AddMenuPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ปรับเเต่งรายการอาหาร'),
        backgroundColor: Color.fromARGB(255, 199, 232, 213),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 50,),
              Icon(Icons.construction, size: 100, color: Colors.yellow[800]),
              Text(
                'This page is under development',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'อยู่ระหว่างการพัฒนา',
                style: TextStyle(fontSize: 19),
              ),
              SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
                child: Text(
                  'ขออภัยในความไม่สะดวก',
                  style: TextStyle(fontSize: 20,
                      color: Colors.black54,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
