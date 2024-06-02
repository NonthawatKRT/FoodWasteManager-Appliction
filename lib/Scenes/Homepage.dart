import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'exppage.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> _expiringSoon = [];
  List<Map<String, dynamic>> _lowStock = [];

  @override
  void initState() {
    super.initState();
    _initializeFile().then((_) => _loadCounts());
  }

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
      "storageDays": 2
    },
    {
      "id": 3,
      "name": "ปลา",
      "type": "meat",
      "count": 0.0,
      "picture": "assets/images/fish.jpg",
      "storageDays": 2
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
      "storageDays": 2
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

  Future<void> _initializeFile() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final countFilePath = '${directory.path}/ingredient_counts.json';
      final countFile = File(countFilePath);

      if (!await countFile.exists()) {
        final jsonData = _allIngredients
            .map((ingredient) => {
                  'id': ingredient['id'],
                  'count': ingredient['count'],
                  'addedDate': DateTime.now().toIso8601String(),
                })
            .toList();
        await countFile.writeAsString(jsonEncode(jsonData));
        print('File initialized.');
      } else {
        print('File already exists.');
      }
    } catch (e) {
      print('Error initializing file: $e');
    }
  }

  Future<void> _loadCounts() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final countFilePath = '${directory.path}/ingredient_counts.json';
      final countFile = File(countFilePath);

      final contents = await countFile.readAsString();
      print('File contents: $contents'); // Print the contents for debugging
      final jsonData = json.decode(contents);

      final now = DateTime.now();

      setState(() {
        _expiringSoon = [];
        _lowStock = [];

        jsonData.forEach((id, data) {
          final count = data[now.toString()] ?? 0.0;
          final ingredient =
              _allIngredients.firstWhere((ing) => ing['id'] == int.parse(id));
          final expirationDate =
              now.add(Duration(days: ingredient['storageDays']));
          final remainingDays = expirationDate.difference(now).inDays;

          if (remainingDays <= 2) {
            _expiringSoon.add({
              'name': ingredient['name'],
              'expirationDate': expirationDate,
              'picture': ingredient['picture'],
            });
          }

          if (count <= 1) {
            _lowStock.add({
              'name': ingredient['name'],
              'count': count,
              'picture': ingredient['picture'],
            });
          }
        });
      });
    } catch (e) {
      print('Error loading counts: $e');
    }
  }

  void _navigateToDetails(String title, List<Map<String, dynamic>> items) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ExpPage(
          title: title,
          items: items,
          showCount: title !=
              'Expiring Soon', // Pass a boolean indicating whether to show count
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'assets/images/menubg2.jpg',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                Text(
                  textAlign: TextAlign.center,
                  'FOOD WAST MANAGER',
                  style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontFamily: "JuliusSansOne"),
                ),
                const SizedBox(height: 60),
                GestureDetector(
                  onTap: () =>
                      _navigateToDetails('Expiring Soon', _expiringSoon),
                  child: Card(
                    elevation: 2,
                    child: ListTile(
                      leading: Icon(Icons.warning, color: Colors.orange),
                      title: Text(
                        'Expiring Soon',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: _buildSummaryList(
                            _expiringSoon), // Display summary list
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () => _navigateToDetails('Low Stock', _lowStock),
                  child: Card(
                    elevation: 2,
                    child: ListTile(
                      leading: Icon(Icons.warning, color: Colors.red),
                      title: Text(
                        'Low Stock',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: _buildSummaryList(
                            _lowStock), // Display summary list
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildSummaryList(List<Map<String, dynamic>> items) {
    final List<Widget> summaryList = [];
    for (int i = 0; i < items.length && i < 5; i++) {
      final item = items[i];
      summaryList.add(
        Text(
          '${item['name']} - ${item['count']}',
          style: TextStyle(fontSize: 16),
        ),
      );
    }
    if (items.length > 5) {
      summaryList.add(
        GestureDetector(
          onTap: () {
            // Navigate to the detailed view
            _navigateToDetails(
                items == _expiringSoon ? 'Expiring Soon' : 'Low Stock', items);
          },
          child: Text(
            'See more...',
            style: TextStyle(fontSize: 16, color: Colors.blue),
          ),
        ),
      );
    }
    return summaryList;
  }
}
