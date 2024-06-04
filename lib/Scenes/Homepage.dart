import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> _expiringSoon = [];
  List<Map<String, dynamic>> _lowStock = [];
  Map<int, Map<String, double>> _ingredientCounts = {};

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
      "storageDays": 5
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
      "storageDays": 7
    },
    {
      "id": 9,
      "name": "มะเขือเทศ",
      "type": "vegetable",
      "count": 0.0,
      "picture": "assets/images/tomato.jpg",
      "storageDays": 7
    },
    {
      "id": 10,
      "name": "มะนาว",
      "type": "vegetable",
      "count": 0.0,
      "picture": "assets/images/lime.jpg",
      "storageDays": 10
    },
    {
      "id": 11,
      "name": "หัวหอม",
      "type": "vegetable",
      "count": 0.0,
      "picture": "assets/images/onion.jpg",
      "storageDays": 10
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
                  'counts': {
                    DateTime.now().toIso8601String(): ingredient['count'],
                  },
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
      final Map<String, dynamic> jsonData =
          json.decode(contents) as Map<String, dynamic>;

      final now = DateTime.now();

      setState(() {
        _expiringSoon = [];
        _lowStock = [];
        _ingredientCounts = {};

        for (var item in jsonData.entries) {
          final id = int.parse(item.key); // Convert the key to int
          final counts = item.value as Map<String, dynamic>;

          _ingredientCounts[id] = counts
              .map((key, value) => MapEntry(key, (value as num).toDouble()));

          final ingredient =
              _allIngredients.firstWhere((ing) => ing['id'] == id);

          double totalCount = 0.0;

          for (var entry in counts.entries) {
            final addedDate = DateTime.parse(entry.key);
            final count = (entry.value as num)
                .toDouble(); // Ensure value is converted to double
            totalCount += count;

            final expirationDate =
                addedDate.add(Duration(days: ingredient['storageDays']));
            final remainingDays = expirationDate.difference(now).inDays;

            if (remainingDays <= 0) {
              _expiringSoon.add({
                'name': ingredient['name'],
                'expirationDate': expirationDate,
                'count': count,
                'picture': ingredient['picture'],
              });
            }
          }

          if (totalCount <= 2.0) {
            _lowStock.add({
              'name': ingredient['name'],
              'count': totalCount,
              'picture': ingredient['picture'],
            });
          }
        }
      });
    } catch (e) {
      print('Error loading counts: $e');
    }
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
                  'FOOD WASTE MANAGER',
                  style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontFamily: "JuliusSansOne"),
                ),
                const SizedBox(height: 55),
                Expanded(
                  child: ListView(
                    children: [
                      _buildInfoCard(
                          'วัตถุดิบใกล้หมดอายุ', _expiringSoon, Colors.orange),
                      const SizedBox(height: 10),
                      _buildInfoCard(
                          'วัตถุดิบเหลือน้อย', _lowStock, Colors.red),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(
      String title, List<Map<String, dynamic>> items, Color iconColor) {
    return Card(
      color: Colors.grey[300],
      elevation: 0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: Icon(Icons.warning, color: iconColor),
            title: Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            dense: true,
          ),
          Divider(),
          Container(
            color: Colors.grey[200],
            height: 165, // Set a fixed height for the scrollable area
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Image.asset(
                      item['picture'],
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(item['name']),
                  subtitle: Text(title == 'วัตถุดิบใกล้หมดอายุ'
                      ? 'หมดอายุ : ${DateFormat('dd/MM/yy').format(item['expirationDate'] as DateTime)} \nเหลือ : ${(item['count'] as double).toStringAsFixed(2)} kg'
                      : 'เหลือ : ${(item['count'] as double).toStringAsFixed(2)} kg'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
