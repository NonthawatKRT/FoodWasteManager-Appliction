import 'package:flutter/material.dart';
import 'package:zerowastapplication/Widget/menucustom_scaffold.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MenuCustomScaffold(
      child: Column(
        children: [
          SizedBox(height: 30,),
          // Padding(
          //   padding: const EdgeInsets.only(top: 0, left: 20.0, right: 20.0 ,bottom: 30 ), // Adjusted padding
          //   child: Align(
          //     alignment: Alignment.centerLeft,
          //     child: RichText(
          //       textAlign: TextAlign.start,
          //       text: const TextSpan(
          //         text: 'เลือกเมนู',
          //         style: TextStyle(
          //           fontSize: 20.0,
          //           fontFamily: "JuliusSansOne",
          //           fontWeight: FontWeight.normal,
          //           color: Colors.black,
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
          // const SizedBox(height: 20), // Adjusted space between the title and first block
          // // First Block - Expiration of Food
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
                                style: TextStyle(fontSize: 16.0),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Banana',
                                style: TextStyle(fontSize: 16.0),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Orange',
                                style: TextStyle(fontSize: 16.0),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Chicken',
                                style: TextStyle(fontSize: 16.0),
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
                                style: TextStyle(fontSize: 16.0),
                                textAlign: TextAlign.end,
                              ),
                              SizedBox(height: 2),
                              Text(
                                '2024-01-15',
                                style: TextStyle(fontSize: 16.0),
                                textAlign: TextAlign.end,
                              ),
                              SizedBox(height: 2),
                              Text(
                                '2023-12-25',
                                style: TextStyle(fontSize: 16.0),
                                textAlign: TextAlign.end,
                              ),
                              SizedBox(height: 2),
                              Text(
                                '2023-12-10',
                                style: TextStyle(fontSize: 16.0),
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
          const SizedBox(height: 35), // Space between the two blocks
          // Second Block - Low Ingredients
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
                                style: TextStyle(fontSize: 16.0),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Banana',
                                style: TextStyle(fontSize: 16.0),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Orange',
                                style: TextStyle(fontSize: 16.0),
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
                                style: TextStyle(fontSize: 16.0),
                                textAlign: TextAlign.end,
                              ),
                              SizedBox(height: 2),
                              Text(
                                '1.8 kg',
                                style: TextStyle(fontSize: 16.0),
                                textAlign: TextAlign.end,
                              ),
                              SizedBox(height: 2),
                              Text(
                                '3.2 kg',
                                style: TextStyle(fontSize: 16.0),
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
        ],
      ),
    );
  }
}
