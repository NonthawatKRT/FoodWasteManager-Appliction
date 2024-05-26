import 'package:flutter/material.dart';
import 'package:zerowastapplication/Widget/custom_scaffold.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  int _currentIndex = 0;

  // Define a list of widgets to show for each tab
  // final List<Widget> _pages = [
  //   // Placeholder widgets for each tab
  //   const Text('หน้าเเรก', style: TextStyle(fontSize: 24)),
  //   const Text('เลือกเมนู', style: TextStyle(fontSize: 24)),
  //   const Text('เพิ่มวัตถุดิบ', style: TextStyle(fontSize: 24)),
  //   const Text('เพิ่มเมนู', style: TextStyle(fontSize: 24)),
  //   const Text('คลัง', style: TextStyle(fontSize: 24)),
  // ];

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: Column(
        children: [
          // Transform to move the app name up
          Transform.translate(
            offset: const Offset(0, -25), // Adjust the second value to move the name up
            child: RichText(
              textAlign: TextAlign.center,
              text: const TextSpan(
                text: 'FOOD WASTE MANAGER',
                style: TextStyle(
                  fontSize: 40.0,
                  fontFamily: "JuliusSansOne",
                  fontWeight: FontWeight.w900,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          SizedBox(height: 60), // Space between the title and first block

          // First block of information with shadow and rounded corners
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
                    offset: const Offset(0, 4), // changes position of shadow
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
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
                    SizedBox(height: 10), // Space between the title and table
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Food Name',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8), // Space between rows
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
                            children: const [
                              Text(
                                'Expiration Date',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.end,
                              ),
                              SizedBox(height: 8), // Space between rows
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

          SizedBox(height: 35), // Space between the first and second block

          // Second block of information with shadow and rounded corners
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
                    offset: const Offset(0, 4), // changes position of shadow
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
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
                    SizedBox(height: 10), // Space between the title and table
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Ingredient Name',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8), // Space between rows
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
                            children: const [
                              Text(
                                'Weight',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.end,
                              ),
                              SizedBox(height: 8), // Space between rows
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
        ],
      ),
       bottomNavigationBar: Container(
        color: Color(0xFFC7E8D5), // Set the background color of the container to green
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent, // Set to transparent to show the container's color
          currentIndex: _currentIndex,
          selectedItemColor: const Color.fromARGB(255, 0, 0, 0), // Set the selected item color to white
          unselectedItemColor: Colors.black54, // Set the unselected item color to a darker color
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'หน้าเเรก',
              backgroundColor: _currentIndex == 0 ? Color(0xFFC7E8D5) : Colors.transparent, // Change color if selected
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.menu_book),
              label: 'เลือกเมนู',
              backgroundColor: _currentIndex == 1 ? Color(0xFFC7E8D5) : Colors.transparent, // Change color if selected
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_shopping_cart),
              label: 'เพิ่มวัตถุดิบ',
              backgroundColor: _currentIndex == 2 ? Color(0xFFC7E8D5) : Colors.transparent, // Change color if selected
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add),
              label: 'เพิ่มเมนู',
              backgroundColor: _currentIndex == 3 ? Color(0xFFC7E8D5) : Colors.transparent, // Change color if selected
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.inventory),
              label: 'คลัง',
              backgroundColor: _currentIndex == 4 ? Color(0xFFC7E8D5) : Colors.transparent, // Change color if selected
            ),
          ],
        ),
      ),
    );
  }
}
