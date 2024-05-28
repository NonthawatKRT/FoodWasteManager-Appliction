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
          ? _buildShimmer() // Show shimmer if loading
          : _pages[_currentIndex],
      bottomNavigationBar: Container(
        color: const Color(0xFFC7E8D5),
        child: BottomNavigationBar(
          backgroundColor: Color(0xFFC7E8D5),
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
                  ? Color(0xFFC7E8D5)
                  : Colors.transparent,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.menu_book),
              label: 'เลือกเมนู',
              backgroundColor: _currentIndex == 1
                  ? Color(0xFFC7E8D5)
                  : Colors.transparent,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.add_shopping_cart),
              label: 'เพิ่มวัตถุดิบ',
              backgroundColor: _currentIndex == 2
                  ? Color(0xFFC7E8D5)
                  : Colors.transparent,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.add),
              label: 'เพิ่มเมนู',
              backgroundColor: _currentIndex == 3
                  ? Color(0xFFC7E8D5)
                  : Colors.transparent,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.inventory),
              label: 'คลัง',
              backgroundColor: _currentIndex == 4
                  ? Color(0xFFC7E8D5)
                  : Colors.transparent,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        color: Colors.grey[300],
      ),
    );
  }
}
