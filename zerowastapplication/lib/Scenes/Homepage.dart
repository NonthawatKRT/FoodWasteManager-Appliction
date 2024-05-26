import 'package:flutter/material.dart';
import 'package:zerowastapplication/Widget/custom_scaffold.dart';


class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
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