import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:zerowastapplication/Widget/menucustom_scaffold.dart';
import 'package:zerowastapplication/Scenes/Confirmpage.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  _MenuScreenState createState() => _MenuScreenState();
}

// Ingredient IDs
// 1: beef, 2: chicken, 3: fish, 4: pork, 5: shrimp, 6: crab
// 7: cabbage, 8: carrot, 9: tomato, 10: lime, 11: onion, 12: mushroom

class _MenuScreenState extends State<MenuScreen> {
  final List<Map<String, dynamic>> _allIngredients = [
    {
      "id": 1,
      "name": "เนื้อ",
      "type": "meat",
      "count": 0.0,
      "picture": "assets/images/beef.jpg",
      "storageDays": 5
    },
    {
      "id": 2,
      "name": "ไก่",
      "type": "meat",
      "count": 0.0,
      "picture": "assets/images/chicken.jpg",
      "storageDays": 3
    },
    {
      "id": 3,
      "name": "ปลา",
      "type": "meat",
      "count": 0.0,
      "picture": "assets/images/fish.jpg",
      "storageDays": 3
    },
    {
      "id": 4,
      "name": "หมู",
      "type": "meat",
      "count": 0.0,
      "picture": "assets/images/pork.jpg",
      "storageDays": 5
    },
    {
      "id": 5,
      "name": "กุ้ง",
      "type": "meat",
      "count": 0.0,
      "picture": "assets/images/shrimp.jpg",
      "storageDays": 3
    },
    {
      "id": 6,
      "name": "ปู",
      "type": "meat",
      "count": 0.0,
      "picture": "assets/images/crab.jpg",
      "storageDays": 3
    },
    {
      "id": 7,
      "name": "กะหล่ำ",
      "type": "vegetable",
      "count": 0.0,
      "picture": "assets/images/cabbage.jpg",
      "storageDays": 7
    },
    {
      "id": 8,
      "name": "เเครอท",
      "type": "vegetable",
      "count": 0.0,
      "picture": "assets/images/carrot.jpg",
      "storageDays": 21
    },
    {
      "id": 9,
      "name": "มะเขือเทศ",
      "type": "vegetable",
      "count": 0.0,
      "picture": "assets/images/tomato.jpg",
      "storageDays": 14
    },
    {
      "id": 10,
      "name": "มะนาว",
      "type": "vegetable",
      "count": 0.0,
      "picture": "assets/images/lime.jpg",
      "storageDays": 28
    },
    {
      "id": 11,
      "name": "หัวหอม",
      "type": "vegetable",
      "count": 0.0,
      "picture": "assets/images/onion.jpg",
      "storageDays": 21
    },
    {
      "id": 12,
      "name": "เห็ด",
      "type": "vegetable",
      "count": 0.0,
      "picture": "assets/images/mushroom.jpg",
      "storageDays": 7
    },
  ];

  final List<Map<String, dynamic>> _allMenu = [
    {
      "id": 1,
      "name": "กระเพราหมูสับ",
      "count": 0,
      "picture": "assets/images/kapraw.jpg",
      "ingredients": {"4": 0.4, "8": 0.1}
    },
    {
      "id": 2,
      "name": "ต้มยำกุ้ง",
      "count": 0,
      "picture": "assets/images/tomyumkung.jpg",
      "ingredients": {"5": 0.6, "10": 0.03, "12": 0.1}
    },
    {
      "id": 3,
      "name": "ข้าวผัดกุ้ง",
      "count": 0,
      "picture": "assets/images/kawpadkung.jpg",
      "ingredients": {"5": 0.4, "8": 0.05, "10": 0.02}
    },
    {
      "id": 4,
      "name": "ข้าวมันไก่",
      "count": 0,
      "picture": "assets/images/kawmankai.jpg",
      "ingredients": {"2": 0.4, "10": 0.02}
    },
    {
      "id": 5,
      "name": "ผัดไทยกุ้งสด",
      "count": 0,
      "picture": "assets/images/padtai.jpg",
      "ingredients": {"5": 1.0}
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
    try {
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
    } catch (e) {
      print('Error loading counts: $e');
    }
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
    try {
      final Map<String, dynamic> jsonData = {};

      _ingredientCounts.forEach((key, value) {
        final ingredient = _allIngredients.firstWhere((ingredient) => ingredient['id'].toString() == key);
        final storageDays = ingredient['storageDays'];
        final filteredValue = value..removeWhere((date, count) => _isExpiredAndZeroCount(date, count, storageDays));

        if (filteredValue.isNotEmpty) {
          jsonData[key] = filteredValue;
        }
      });

      await _countFile.writeAsString(json.encode(jsonData));
      // _updateTotalCounts();
      _printFileContents(); // Print file contents after saving
    } catch (e) {
      print('Error saving counts: $e');
    }
  }

  bool _isExpiredAndZeroCount(String date, double count, int storageDays) {
    final expirationDate = DateTime.parse(date).add(Duration(days: storageDays));
    return count == 0.0 && expirationDate.isBefore(DateTime.now());
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

      if (!_ingredientCounts.containsKey(ingredientId)) {
        _showWarning('มีวัตถุดิบไม่เพียงพอ');
        return false;
      }

      double totalAvailable = 0;
      final dates = _ingredientCounts[ingredientId]!.keys.toList()..sort();

      for (var date in dates) {
        totalAvailable += _ingredientCounts[ingredientId]![date]!;
        if (totalAvailable >= requiredQuantity) break;
      }

      if (totalAvailable < requiredQuantity) {
        _showWarning('มีวัตถุดิบไม่เพียงพอ');
        return false;
      }
    }
    return true;
  }

  void _showWarning(String message) {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.warning,
      title: 'คำเตือน!',
      text: message, 
      confirmBtnColor: Colors.grey[500]!,
      confirmBtnText: 'ตกลง',
    );
  }

  void _incrementCount(int index) {
    if (_hasEnoughIngredients(_foundMenu[index], index)) {
      setState(() {
        final ingredients = _foundMenu[index]['ingredients'];

        ingredients.forEach((ingredientId, requiredQuantity) {
          double remainingQuantity = requiredQuantity;
          final dates = _ingredientCounts[ingredientId]!.keys.toList()..sort();

          for (var date in dates) {
            final availableQuantity = _ingredientCounts[ingredientId]![date]!;
            if (availableQuantity >= remainingQuantity) {
              _ingredientCounts[ingredientId]![date] = availableQuantity - remainingQuantity;
              break;
            } else {
              _ingredientCounts[ingredientId]![date] = 0;
              remainingQuantity -= availableQuantity;
            }
          }
        });

        _foundMenu[index]['count']++;
      });
    }
  }

  void _decrementCount(int index) {
    setState(() {
      if (_foundMenu[index]['count'] > 0) {
        _foundMenu[index]['count']--;

        final String currentDate = DateTime.now().toIso8601String().split('T').first;
        final ingredientId = _foundMenu[index]['ingredients'].keys.first;
        final requiredQuantity = _foundMenu[index]['ingredients'][ingredientId];

        if (ingredientId != null && currentDate != null && requiredQuantity != null) {
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
      for (var menu in _allMenu) {
        menu['count'] = 0;
      }
      _foundMenu = List.from(_allMenu);
    });
    _saveCounts();
  }

  Future<void> _decreaseIngredients(List<Map<String, dynamic>> selectedItems) async {
    for (var item in selectedItems) {
      for (var ingredient in item['ingredients'].entries) {
        final ingredientId = ingredient.key;
        final requiredQuantity = ingredient.value * item['count'];

        if (_ingredientCounts.containsKey(ingredientId)) {
          double remainingQuantity = requiredQuantity;
          final dates = _ingredientCounts[ingredientId]!.keys.toList()..sort();

          for (var date in dates) {
            final availableQuantity = _ingredientCounts[ingredientId]![date]!;
            if (availableQuantity >= remainingQuantity) {
              _ingredientCounts[ingredientId]![date] = availableQuantity - remainingQuantity;
              break;
            } else {
              _ingredientCounts[ingredientId]![date] = 0;
              remainingQuantity -= availableQuantity;
            }
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
                decoration: const InputDecoration(
                  labelText: 'ค้นหาเมนู',
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
                        margin: const EdgeInsets.symmetric(vertical: 10),
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
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(left: 16.0),
                                          child: Text(
                                            _foundMenu[index]['name'],
                                            style: const TextStyle(fontSize: 18),
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            IconButton(
                                              icon: const Icon(Icons.remove),
                                              onPressed: () => _decrementCount(index),
                                            ),
                                            Text(
                                              _foundMenu[index]["count"].toString(),
                                              style: const TextStyle(fontSize: 16),
                                            ),
                                            IconButton(
                                              icon: const Icon(Icons.add),
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
                  : const Text(
                      'ไม่พบเมนูที่ค้นหา',
                      style: TextStyle(fontSize: 24),
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: _hasSelectedItems()
          ? FloatingActionButton(
              backgroundColor: const Color.fromARGB(255, 199, 232, 213),
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
              child: const Icon(
                Icons.shopping_basket,
                color: Color.fromARGB(221, 48, 43, 43),
              ),
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
    return const MenuCustomScaffold(
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
