import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:zerowastapplication/Widget/menucustom_scaffold.dart';
import 'package:zerowastapplication/Scenes/Confirmpage.dart';

class MenuScreen extends StatefulWidget {
  @override
  _MenuScreenState createState() => _MenuScreenState();
}
// id 1 : beef
// id 2 : chicken
// id 3 : fish
// id 4 : pork
// id 5 : shrimp
// id 6 : crab

// id 7 : cabbage
// id 8 : carrot
// id 9 : tomato
// id 10 : lime
// id 11 : onion
// id 12 : mushroom

class _MenuScreenState extends State<MenuScreen> {
  List<Map<String, dynamic>> _allMenu = [
    {
      "id": 1,
      "name": "กระเพราหมูสับ",
      "count": 0,
      "picture": "assets/images/kapraw.jpg",
      "ingredients": {"4": 0.2}
    },
    {
      "id": 2,
      "name": "ต้มยำกุ้ง",
      "count": 0,
      "picture": "assets/images/tomyumkung.jpg",
      "ingredients": {"5": 0.3, "10": 0.1, "12": 0.1}
    },
    {
      "id": 3,
      "name": "ข้าวผัดกุ้ง",
      "count": 0,
      "picture": "assets/images/kawpadkung.jpg",
      "ingredients": {"5": 1}
    },
    {
      "id": 4,
      "name": "ข้าวมันไก่",
      "count": 0,
      "picture": "assets/images/kawmankai.jpg",
      "ingredients": {"2": 2}
    },
    {
      "id": 5,
      "name": "ผัดไทยกุ้งสด",
      "count": 0,
      "picture": "assets/images/padtai.jpg",
      "ingredients": {"5": 1}
    },
  ];
  List<Map<String, dynamic>> _foundMenu = [];

  late File _countFile;
  Map<String, Map<String, double>> _ingredientCounts = {};

  @override
  void initState() {
    _foundMenu = _allMenu;
    super.initState();
    _initializeFile();
  }

  Future<void> _initializeFile() async {
    final directory = await getApplicationDocumentsDirectory();
    _countFile = File('${directory.path}/ingredient_counts.json');

    if (await _countFile.exists()) {
      await _loadCounts();
    } else {
      await _saveCounts();
    }
  }

  Future<void> _loadCounts() async {
  final contents = await _countFile.readAsString();
  final jsonData = json.decode(contents);
  _printFileContents();
  setState(() {
    _ingredientCounts = {};
    jsonData.forEach((key, value) {
      _ingredientCounts[key] = {};
      (value as Map<String, dynamic>).forEach((k, v) {
        _ingredientCounts[key]![k] = v.toDouble();
      });
    });
  });
}

Future<void> _printFileContents() async {
    if (await _countFile.exists()) {
      final contents = await _countFile.readAsString();
      print('File Contents: $contents');
    } else {
      print('File does not exist.');
    }
  }


  Future<void> _saveCounts() async {
    final jsonData = _ingredientCounts.map((key, value) => MapEntry(key, value.map((k, v) => MapEntry(k, v))));
    await _countFile.writeAsString(json.encode(jsonData));
    setState(() {
    });

    _printFileContents(); // Print file contents after saving
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

  bool _hasEnoughIngredients(Map<String, dynamic> menuItem, int index) {
  for (var ingredient in menuItem['ingredients'].entries) {
    final ingredientId = ingredient.key;
    final requiredQuantity = ingredient.value;
    final currentDate = DateTime.now().toIso8601String().split('T').first;

    print('Checking ingredient: $ingredientId');
    print('Required: $requiredQuantity');
    print('Available on $currentDate: ${_ingredientCounts[ingredientId]?[currentDate]}');

    if (!_ingredientCounts.containsKey(ingredientId) ||
        !_ingredientCounts[ingredientId]!.containsKey(currentDate) ||
        (_ingredientCounts[ingredientId]![currentDate] ?? 0) < requiredQuantity) {
      return false;
    }
  }
  return true;
}

  void _incrementCount(int index) {
  if (_hasEnoughIngredients(_foundMenu[index], index)) {
    setState(() {
      final String currentDate = DateTime.now().toIso8601String().split('T').first;
      final ingredientId = _foundMenu[index]['ingredients'].keys.first;
      final requiredQuantity = _foundMenu[index]['ingredients'][ingredientId];

      // Check if ingredientId and currentDate are not null and if the requiredQuantity is less than or equal to the current count
      if (ingredientId != null && currentDate != null && requiredQuantity != null && _ingredientCounts[ingredientId] != null && _ingredientCounts[ingredientId]![currentDate] != null && requiredQuantity <= _ingredientCounts[ingredientId]![currentDate]!) {
        _ingredientCounts[ingredientId]![currentDate] = _ingredientCounts[ingredientId]![currentDate]! - requiredQuantity;
        _foundMenu[index]['count']++; // Increment count
      }
    });
  } else {
    // Display warning message if there are not enough ingredients
    QuickAlert.show(
      context: context,
      type: QuickAlertType.warning,
      title: 'Warning',
      text: 'Not enough ingredients!',
      confirmBtnColor: Colors.grey[500]!,
    );
  }
}

  void _decrementCount(int index) {
  setState(() {
    if (_foundMenu[index]['count'] > 0) {
      _foundMenu[index]['count']--;

      final String currentDate = DateTime.now().toIso8601String().split('T').first;
      final ingredientId = _foundMenu[index]['ingredients'].keys.first;
      final requiredQuantity = _foundMenu[index]['ingredients'][ingredientId];

      // Check if ingredientId and currentDate are not null
      if (ingredientId != null && currentDate != null && requiredQuantity != null) {
        // Increase the ingredient count by the required quantity
        _ingredientCounts[ingredientId]![currentDate] = (_ingredientCounts[ingredientId]![currentDate] ?? 0) + requiredQuantity;
      }
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
    _saveCounts();
  }

  Future<void> _decreaseIngredients(List<Map<String, dynamic>> selectedItems) async {
    final String currentDate = DateTime.now().toIso8601String().split('T').first;

    for (var item in selectedItems) {
      for (var ingredient in item['ingredients'].entries) {
        final ingredientId = ingredient.key;
        final requiredQuantity = ingredient.value * item['count'];

        print('Decreasing ingredient: $ingredientId by $requiredQuantity');
        if (_ingredientCounts.containsKey(ingredientId)) {
          if (_ingredientCounts[ingredientId]?.containsKey(currentDate) ?? false) {
            _ingredientCounts[ingredientId]?[currentDate] =
                (_ingredientCounts[ingredientId]?[currentDate] ?? 0) - requiredQuantity;
          }
        }
      }
    }

    await _saveCounts();
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
                final selectedItems = _getSelectedItems();
                await Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => ConfirmPage(
      selectedItems: selectedItems,
      onConfirm: _resetCounts,
      ingredientCounts: _ingredientCounts,
      countFile: _countFile,
    ),
  ),
);

                _decreaseIngredients(selectedItems);
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
    final double fabX = scaffoldGeometry.scaffoldSize.width - 16.0 - 56.0;
    final double fabY = scaffoldGeometry.scaffoldSize.height - scaffoldGeometry.minInsets.bottom - 56.0 - 16.0;
    return Offset(fabX, fabY);
  }
}
