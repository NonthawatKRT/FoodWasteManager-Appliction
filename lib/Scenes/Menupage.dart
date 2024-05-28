import 'package:flutter/material.dart';
import 'package:zerowastapplication/Widget/menucustom_scaffold.dart';
import 'package:zerowastapplication/Scenes/Confirmpage.dart';

class MenuScreen extends StatefulWidget {
  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  List<Map<String, dynamic>> _allMenu = [
    {"id": 1, "name": "กระเพราหมูสับ", "count": 0, "picture": "assets/images/kapraw.jpg"},
    {"id": 2, "name": "ต้มยำกุ้ง", "count": 0, "picture": "assets/images/tomyumkung.jpg"},
    {"id": 3, "name": "ข้าวผัดกุ้ง", "count": 0, "picture": "assets/images/kawpadkung.jpg"},
    {"id": 4, "name": "ข้าวมันไก่", "count": 0, "picture": "assets/images/kawmankai.jpg"},
    {"id": 5, "name": "ผัดไทยกุ้งสด", "count": 0, "picture": "assets/images/padtai.jpg"},
  ];
  List<Map<String, dynamic>> _foundMenu = [];

  @override
  void initState() {
    _foundMenu = _allMenu;
    super.initState();
  }

  void _runFilter(String enteredKeyword) {
    List<Map<String, dynamic>> results = [];
    if (enteredKeyword.isEmpty) {
      results = _allMenu;
    } else {
      results = _allMenu
          .where((menu) =>
              menu["name"].toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
    }

    setState(() {
      _foundMenu = results;
    });
  }

  void _incrementCount(int index) {
    setState(() {
      _foundMenu[index]['count']++;
    });
  }

  void _decrementCount(int index) {
    setState(() {
      if (_foundMenu[index]['count'] > 0) {
        _foundMenu[index]['count']--;
      }
    });
  }

  bool _hasSelectedItems() {
    return _foundMenu.any((menu) => menu['count'] > 0);
  }

  List<Map<String, dynamic>> _getSelectedItems() {
    return _foundMenu.where((menu) => menu['count'] > 0).toList();
  }

  void _resetCounts() {
    setState(() {
      _allMenu.forEach((menu) {
        menu['count'] = 0;
      });
      _foundMenu = List.from(_allMenu);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: TextField(
                onChanged: (value) => _runFilter(value),
                decoration: InputDecoration(
                  labelText: 'Search',
                  suffixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                ),
              ),
            ),
            Expanded(
              child: _foundMenu.isNotEmpty
                  ? ListView.builder(
                      itemCount: _foundMenu.length,
                      itemBuilder: (context, index) => Card(
                        key: ValueKey(_foundMenu[index]["id"]),
                        color: Colors.grey[200],
                        elevation: 4,
                        margin: EdgeInsets.symmetric(vertical: 10),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 13),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Image.asset(
                                    _foundMenu[index]["picture"],
                                    width: 80,
                                    height: 80,
                                    fit: BoxFit.cover,
                                  ),
                                  SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(left: 16.0),
                                          child: Text(
                                            _foundMenu[index]['name'],
                                            style: TextStyle(fontSize: 18),
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        Row(
                                          children: [
                                            IconButton(
                                              icon: Icon(Icons.remove),
                                              onPressed: () => _decrementCount(index),
                                            ),
                                            Text(
                                              '${_foundMenu[index]["count"].toString()}',
                                              style: TextStyle(fontSize: 16),
                                            ),
                                            IconButton(
                                              icon: Icon(Icons.add),
                                              onPressed: () => _incrementCount(index),
                                            ),
                                          ],
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
                    )
                  : Text(
                      'No results found',
                      style: TextStyle(fontSize: 24),
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: _hasSelectedItems()
          ? FloatingActionButton(
              child: Icon(
                Icons.shopping_basket,
                color: const Color.fromARGB(221, 48, 43, 43),
              ),
              backgroundColor: Color.fromARGB(255, 199, 232, 213),
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ConfirmPage(
                      selectedItems: _getSelectedItems(),
                      onConfirm: _resetCounts, // Pass the reset function
                    ),
                  ),
                );
                // The reset counts function is no longer called here
              },
            )
          : null,
      floatingActionButtonLocation: const CustomFabLocation(),
    );
  }
}

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MenuCustomScaffold(
      child: MenuScreen(),
    );
  }
}

class CustomFabLocation extends FloatingActionButtonLocation {
  const CustomFabLocation();

  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    final double fabX = scaffoldGeometry.scaffoldSize.width - 16.0 - 56.0; // 16 is the margin and 56 is the FAB width
    final double fabY = scaffoldGeometry.scaffoldSize.height - scaffoldGeometry.minInsets.bottom - 56.0 - 16.0; // 56 is the FAB height and 16 is the margin from the bottom
    return Offset(fabX, fabY);
  }
}
