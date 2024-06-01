import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:zerowastapplication/Widget/custom_scaffold.dart';


class HomePage extends StatelessWidget {
  HomePage({super.key});


final List<Map<String, dynamic>> _allIngredients = [
    {"id": 1, "name": "beef", "type": "meat", "unit": "kg", "picture": "assets/images/beef.jpg"},
    {"id": 2, "name": "chicken", "type": "meat", "unit": "kg", "picture": "assets/images/chicken.jpg"},
    {"id": 3, "name": "fish", "type": "meat", "unit": "kg", "picture": "assets/images/fish.jpg"},
    {"id": 4, "name": "pork", "type": "meat", "unit": "kg", "picture": "assets/images/pork.jpg"},
    {"id": 5, "name": "shrimp", "type": "meat", "unit": "kg", "picture": "assets/images/shrimp.jpg"},
    {"id": 6, "name": "crab", "type": "meat", "unit": "kg", "picture": "assets/images/crab.jpg"},
    {"id": 7, "name": "cabbage", "type": "vegetable", "unit": "kg", "picture": "assets/images/cabbage.jpg"},
    {"id": 8, "name": "carrot", "type": "vegetable", "unit": "kg", "picture": "assets/images/carrot.jpg"},
    {"id": 9, "name": "tomato", "type": "vegetable", "unit": "kg", "picture": "assets/images/tomato.jpg"},
    {"id": 10, "name": "lime", "type": "vegetable", "unit": "kg", "picture": "assets/images/lime.jpg"},
    {"id": 11, "name": "onion", "type": "vegetable", "unit": "kg", "picture": "assets/images/onion.jpg"},
    {"id": 12, "name": "mushroom", "type": "vegetable", "unit": "kg", "picture": "assets/images/mushroom.jpg"},
  ];

Future<void> _initializeFile() async {
    final directory = await getApplicationDocumentsDirectory();
    final countFilePath = '${directory.path}/ingredient_counts.json';
    final countFile = File(countFilePath);

    if (!await countFile.exists()) {
      // File does not exist, create and initialize it
      final jsonData = _allIngredients.map((ingredient) => {
            'id': ingredient['id'],
            'count': 0, // Initializing count to zero
          }).toList();
      await countFile.writeAsString(jsonEncode(jsonData));
      print('File initialized.');
    }else{
      print('File already exists.');
    }
  }

  @override
  Widget build(BuildContext context) {
    _initializeFile(); // Call initialization method
    return CustomScaffold(
      child: Column(
        children: [
          // Transform to move the app name up
          Transform.translate(
            offset: const Offset(0, 40), // Adjust the second value to move the name up
            child: RichText(
              textAlign: TextAlign.center,
              text: const TextSpan(
                text: 'FOOD WASTE MANAGER',
                style: TextStyle(
                  fontSize: 40.0,
                  fontFamily: "JuliusSansOne",
                  fontWeight: FontWeight.bold,   
                  color: Colors.black,  
                ),
              ),
            ),
          ),
          SizedBox(height: 150), // Space between the title and first block
          Container(
  padding: const EdgeInsets.symmetric(horizontal: 20.0),
  child: DecoratedBox(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12.0),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.2),
          spreadRadius: 2,
          blurRadius: 8,
          offset: const Offset(0, 4), 
        ),
      ],
    ),
    child: const Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '•Expiration of Food',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w600,
              color: Colors.red,
            ),
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Food Name',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Apple',
                      style: TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Banana',
                      style: TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Orange',
                      style: TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Chicken',
                      style: TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Expiration Date',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.end,
                    ),
                    SizedBox(height: 8),
                    Text(
                      '2023-12-31',
                      style: TextStyle(
                        fontSize: 16.0,
                      ),
                      textAlign: TextAlign.end,
                    ),
                    SizedBox(height: 2),
                    Text(
                      '2024-01-15',
                      style: TextStyle(
                        fontSize: 16.0,
                      ),
                      textAlign: TextAlign.end,
                    ),
                    SizedBox(height: 2),
                    Text(
                      '2023-12-25',
                      style: TextStyle(
                        fontSize: 16.0,
                      ),
                      textAlign: TextAlign.end,
                    ),
                    SizedBox(height: 2),
                    Text(
                      '2023-12-10',
                      style: TextStyle(
                        fontSize: 16.0,
                      ),
                      textAlign: TextAlign.end,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  ),
),

const SizedBox(height: 35),

Container(
  padding: const EdgeInsets.symmetric(horizontal: 20.0),
  child: DecoratedBox(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12.0),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.2),
          spreadRadius: 2,
          blurRadius: 8,
          offset: const Offset(0, 4), 
        ),
      ],
    ),
    child: const Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '•Low Ingredients',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w600,
              color: Colors.orange,
            ),
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ingredient Name',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Apple',
                      style: TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Banana',
                      style: TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Orange',
                      style: TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Weight',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.end,
                    ),
                    SizedBox(height: 8),
                    Text(
                      '2.5 kg',
                      style: TextStyle(
                        fontSize: 16.0,
                      ),
                      textAlign: TextAlign.end,
                    ),
                    SizedBox(height: 2),
                    Text(
                      '1.8 kg',
                      style: TextStyle(
                        fontSize: 16.0,
                      ),
                      textAlign: TextAlign.end,
                    ),
                    SizedBox(height: 2),
                    Text(
                      '3.2 kg',
                      style: TextStyle(
                        fontSize: 16.0,
                      ),
                      textAlign: TextAlign.end,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  ),
),
        ]
      ),
    );
  }
}