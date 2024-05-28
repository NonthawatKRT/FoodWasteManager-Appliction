import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart'; // Import shimmer package
import 'package:zerowastapplication/Scenes/Addingredientpage.dart';
import 'package:zerowastapplication/Scenes/Addmenupage.dart';
import 'package:zerowastapplication/Scenes/Homepage.dart';
import 'package:zerowastapplication/Scenes/Inventorypage.dart';
import 'package:zerowastapplication/Scenes/Menupage.dart';
import 'package:zerowastapplication/Widget/custom_scaffold.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  int _currentIndex = 0;
  bool _isLoading = false;

  final List<Widget> _pages = [
    const HomePage(),
    const MenuPage(),
    AddIngredientsPage(),
    AddMenuPage(),
    InventoryPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: _isLoading
          ? _buildShimmer(_currentIndex) // Show shimmer if loading
          : _pages[_currentIndex],
      bottomNavigationBar: Container(
        color: const Color(0xFFC7E8D5),
        child: BottomNavigationBar(
          backgroundColor: const Color(0xFFC7E8D5),
          currentIndex: _currentIndex,
          selectedItemColor: const Color.fromARGB(255, 0, 0, 0),
          unselectedItemColor: Colors.black54,
          onTap: (index) {
            setState(() {
              _isLoading = true;
              _currentIndex = index;
            });
            // Simulate loading delay
            Future.delayed(const Duration(seconds: 1), () {
              setState(() {
                _isLoading = false;
              });
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.home),
              label: 'หน้าแรก',
              backgroundColor: _currentIndex == 0
                  ? const Color(0xFFC7E8D5)
                  : Colors.transparent,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.menu_book),
              label: 'เลือกเมนู',
              backgroundColor: _currentIndex == 1
                  ? const Color(0xFFC7E8D5)
                  : Colors.transparent,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.add_shopping_cart),
              label: 'เพิ่มวัตถุดิบ',
              backgroundColor: _currentIndex == 2
                  ? const Color(0xFFC7E8D5)
                  : Colors.transparent,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.add),
              label: 'เพิ่มเมนู',
              backgroundColor: _currentIndex == 3
                  ? const Color(0xFFC7E8D5)
                  : Colors.transparent,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.inventory),
              label: 'คลัง',
              backgroundColor: _currentIndex == 4
                  ? const Color(0xFFC7E8D5)
                  : Colors.transparent,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmer(int index) {
    switch (index) {
      case 0:
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            color: Colors.grey[300],
            child: Center(child: Text('Loading Home Page...')),
          ),
        );
      case 1:
  return Container(
    color: Colors.grey[200], // Grey background
    padding: const EdgeInsets.only(top: 0), // Add padding to start below the app bar
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            height: 56.0, // Height of the app bar
            color: Colors.grey[300],
            child: Center(child: Text('Loading App Bar...')),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              height: 50, // 50% height of a typical box (more space)
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: 6, // Number of shimmer items
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 35.0, vertical: 8.0),
                child: Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          color: Colors.grey[300],
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: double.infinity,
                                height: 25,
                                color: Colors.grey[300],
                              ),
                              const SizedBox(height: 15),
                              Container(
                                width: 100,
                                height: 16,
                                color: Colors.grey[300],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Container(
                          width: 50, // Adjust width according to your design
                          height: 50, // Adjust height according to your design
                          color: Colors.grey[300],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    ),
  );



      case 2:
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 0),
          color: Colors.grey[200], // Grey background
          child: Column(
            children: [
              Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  height: 56.0,
                  width: double.infinity,
                  color: Colors.grey[300],
                  child: Center(child: Text('Loading App Bar...')),
                ),
              ),
              SizedBox(height: 8),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                child: Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    height: 50.0,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 4), // Apply padding
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8.0),
                      color: const Color.fromARGB(197, 208, 208, 208),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical:
                                  30), // Apply vertical padding to the row
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: Container(
                                  width: 90.0,
                                  height: 36.0,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(50.0),
                                  ),
                                ),
                              ),
                              Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: Container(
                                  width: 90.0,
                                  height: 36.0,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(50.0),
                                  ),
                                ),
                              ),
                              Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: Container(
                                  width: 90.0,
                                  height: 36.0,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(50.0),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // const SizedBox(height: 8),
                        Expanded(
                          child: ListView.builder(
                            itemCount: 6,
                            itemBuilder: (context, index) => Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8.0,
                                  horizontal: 16), // Apply vertical padding
                              child: Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: Container(
                                  height: 100.0,
                                  width: double.infinity, // Ensure full width
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );

      case 3:
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            color: Colors.grey[300],
            child: Center(child: Text('Loading Add Menu Page...')),
          ),
        );
      case 4:
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 0),
          color: Colors.grey[200], // Grey background
          child: Column(
            children: [
              Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  height: 56.0,
                  width: double.infinity,
                  color: Colors.grey[300],
                  child: Center(child: Text('Loading App Bar...')),
                ),
              ),
              SizedBox(height: 8),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                child: Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    height: 50.0,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 4), // Apply padding
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8.0),
                      color: const Color.fromARGB(197, 208, 208, 208),
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            itemCount: 6,
                            itemBuilder: (context, index) => Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8.0,
                                  horizontal: 16), // Apply vertical padding
                              child: Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: Container(
                                  height: 100.0,
                                  width: double.infinity, // Ensure full width
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );

      default:
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            color: Colors.grey[300],
          ),
        );
    }
  }
}
