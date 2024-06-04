import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class InventoryPage extends StatefulWidget {
  @override
  _InventoryPageState createState() => _InventoryPageState();
}

// "detail": "beef id: 1 can stay in refrigerator for 3-5 days"
// "detail": "chicken id: 2 can stay in refrigerator for 1-2 days"
// "detail": "fish id: 3 can stay in refrigerator for 2 days"
// "detail": "pork id: 4 can stay in refrigerator for 3-5 days"
// "detail": "shrimp id: 5 can stay in refrigerator for 1-2 days"
// "detail": "crab id: 6 can stay in refrigerator for 2-3 days"
// "detail": "cabbage id: 7 can stay in refrigerator for 7 days"
// "detail": "carrot id: 8 can stay in refrigerator for 21 days"
// "detail": "tomato id: 9 can stay in refrigerator for 7-14 days"
// "detail": "lime id: 10 can stay in refrigerator for 14-28 days"
// "detail": "onion id: 11 can stay in refrigerator for 7-21 days"
// "detail": "mushroom id: 12 can stay in refrigerator for 5-7 days"

class _InventoryPageState extends State<InventoryPage> {
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

  List<Map<String, dynamic>> _foundIngredients = [];
  bool _isEditing = false;
  late File _countFile;
  Map<String, Map<String, double>> _ingredientCounts = {};
  Map<String, bool> _showDetails = {};
  Map<String, Map<String, TextEditingController>> _controllers = {};

  @override
  void initState() {
    super.initState();
    _foundIngredients = _allIngredients;
    _initializeFile();
    for (var ingredient in _allIngredients) {
      _showDetails[ingredient['id'].toString()] = false;
    }
  }

  Future<void> _initializeFile() async {
    final directory = await getApplicationDocumentsDirectory();
    _countFile = File('${directory.path}/ingredient_counts.json');

    if (await _countFile.exists()) {
      _loadCounts();
    } else {
      _saveCounts();
    }
  }

  Future<void> _loadCounts() async {
    final contents = await _countFile.readAsString();
    final Map<String, dynamic> jsonData = json.decode(contents);

    setState(() {
      _ingredientCounts = {};

      jsonData.forEach((key, value) {
        final ingredient = _allIngredients
            .firstWhere((ingredient) => ingredient['id'].toString() == key);
        final storageDays = ingredient['storageDays'];

        value.forEach((date, count) {
          if (!_isExpiredAndZeroCount(date, count, storageDays)) {
            _ingredientCounts.putIfAbsent(key, () => {});
            _ingredientCounts[key]![date] = count.toDouble();
          }
        });

        if (_ingredientCounts.containsKey(key)) {
          _controllers[key] = {};
          _ingredientCounts[key]!.forEach((date, count) {
            _controllers[key]![date] =
                TextEditingController(text: count.toString());
          });
        }
      });

      _updateTotalCounts();
    });
  }

  bool _isExpiredAndZeroCount(String date, double count, int storageDays) {
    final expirationDate =
        DateTime.parse(date).add(Duration(days: storageDays));
    return count == 0.0 && expirationDate.isBefore(DateTime.now());
  }

  Future<void> _saveCounts() async {
    final Map<String, dynamic> jsonData = {};

    _ingredientCounts.forEach((key, value) {
      final ingredient = _allIngredients
          .firstWhere((ingredient) => ingredient['id'].toString() == key);
      final storageDays = ingredient['storageDays'];
      final filteredValue = value
        ..removeWhere(
            (date, count) => _isExpiredAndZeroCount(date, count, storageDays));

      if (filteredValue.isNotEmpty) {
        jsonData[key] = filteredValue;
      }
    });

    await _countFile.writeAsString(json.encode(jsonData));
    _updateTotalCounts();
    _printFileContents(); // Print file contents after saving
  }

  Future<void> _printFileContents() async {
    if (await _countFile.exists()) {
      final contents = await _countFile.readAsString();
      print('File Contents: $contents');
    } else {
      print('File does not exist.');
    }
  }

  void _runFilter(String enteredKeyword) {
    setState(() {
      _foundIngredients = enteredKeyword.isEmpty
          ? _allIngredients
          : _allIngredients
              .where((ingredient) => ingredient["name"]
                  .toLowerCase()
                  .contains(enteredKeyword.toLowerCase()))
              .toList();
    });
  }

  void _incrementCount(int index, String date) {
    setState(() {
      final id = _foundIngredients[index]['id'].toString();
      _ingredientCounts[id]![date] = (_ingredientCounts[id]![date]! + 1.0);
      _controllers[id]![date]!.text = _ingredientCounts[id]![date]!.toString();
    });
  }

  void _decrementCount(int index, String date) {
    setState(() {
      final id = _foundIngredients[index]['id'].toString();
      if (_ingredientCounts[id]![date]! > 0 &&
          _ingredientCounts[id]![date]! >= 1.0) {
        _ingredientCounts[id]![date] = (_ingredientCounts[id]![date]! - 1.0);
      } else {
        _ingredientCounts[id]![date] = 0.0; // Keep it at zero
      }
      _controllers[id]![date]!.text = _ingredientCounts[id]![date]!.toString();
    });
  }

  void _updateCount(int index, String date, String value) {
    setState(() {
      final id = _foundIngredients[index]['id'].toString();
      _ingredientCounts[id]![date] = double.tryParse(value) ?? 0.0;
    });
  }

  void _updateTotalCounts() {
    for (var ingredient in _allIngredients) {
      final id = ingredient['id'].toString();
      ingredient['count'] = _ingredientCounts.containsKey(id)
          ? _ingredientCounts[id]!.values.reduce((a, b) => a + b)
          : 0.0;
    }
  }

  void _toggleEditMode() {
    setState(() {
      _isEditing = !_isEditing;
      if (!_isEditing) {
        _saveCounts();
        _updateTotalCounts();
        QuickAlert.show(
          context: context,
          type: QuickAlertType.loading,
          title: 'กำลังโหลด...',
          text: 'กำลังบันทึกการเปลี่ยนแปลง',
        );

        Future.delayed(Duration(seconds: 3), () {
          _saveCounts();
          _updateTotalCounts();
          Navigator.pop(context);
        });
      } else {
        for (var entry in _ingredientCounts.entries) {
          for (var dateEntry in entry.value.entries) {
            _controllers[entry.key]![dateEntry.key]!.text =
                dateEntry.value.toString();
          }
        }
      }
    });
  }

  void _toggleDetails(int index) {
    setState(() {
      final id = _foundIngredients[index]['id'].toString();
      // final daysRemaining =
      //     _calculateDaysRemaining(_foundIngredients[index]['storageDays']);
      _showDetails[id] = !_showDetails[id]!;
    });
  }

  // int _calculateDaysRemaining(int storageDays) {
  //   final today = DateTime.now();
  //   final expirationDate = today.add(Duration(days: storageDays));
  //   final difference = expirationDate.difference(today);
  //   print('Expiration Date: $expirationDate');
  //   print('Today: $today');
  //   print('Difference: ${difference.inDays} days');
  //   return difference.inDays;
  // }

  final int greenThreshold =
      2; // Days remaining before expiration to consider as green

  Color _getColorForExpiration(DateTime expirationDate) {
    final today = DateTime.now();
    final difference = expirationDate.difference(today);
    final daysRemaining = difference.inDays;

    print('Expiration Date: $expirationDate');
    print('Today: $today');
    print('Difference: ${difference.inDays} days');

    if (daysRemaining >= greenThreshold) {
      return Colors.green; // Not close to expiration
    } else if (daysRemaining < 1 && daysRemaining >= 0) {
      return Colors.red; // Close to expiration or expired
    } else {
      return Colors.orange; // Nearing expiration
    }
  }

  DateTime _calculateExpirationDate(int storageDays, String date) {
    final parsedDate = DateTime.parse(date);
    return parsedDate.add(Duration(days: storageDays));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xFFC7E8D5),
        elevation: 0,
        title: const Text('คลังวัตถุดิบ'),
        actions: [
          TextButton.icon(
            icon: Icon(_isEditing ? Icons.check : Icons.edit,
                color: Color.fromARGB(255, 63, 63, 63)),
            label: Text(_isEditing ? 'ยืนยัน' : 'เเก้ไข',
                style: TextStyle(color: Color.fromARGB(255, 63, 63, 63))),
            style: TextButton.styleFrom(backgroundColor: Colors.transparent),
            onPressed: _toggleEditMode,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0, top: 5),
              child: TextField(
                onChanged: (value) => _runFilter(value),
                decoration: const InputDecoration(
                  labelText: 'ค้นหาวัตถุดิบ',
                  suffixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8.0),
                  color: const Color.fromARGB(197, 208, 208, 208),
                ),
                child: _foundIngredients.isNotEmpty
                    ? ListView.builder(
                        itemCount: _foundIngredients.length,
                        itemBuilder: (context, index) => Card(
                          key: ValueKey(_foundIngredients[index]["id"]),
                          color: Colors.grey[200],
                          elevation: 1,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 13, horizontal: 13),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.asset(
                                        _foundIngredients[index]["picture"],
                                        width: 80,
                                        height: 80,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 16.0),
                                            child: Text(
                                              _foundIngredients[index]['name'],
                                              style:
                                                  const TextStyle(fontSize: 18),
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          if (!_isEditing)
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 16.0),
                                              child: Text(
                                                (_foundIngredients[index]
                                                                ['count'] ??
                                                            0.0)
                                                        .toStringAsFixed(2) +
                                                    '  kg.',
                                                style: const TextStyle(
                                                    fontSize: 16),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                    if (!_isEditing)
                                      TextButton(
                                        onPressed: () => _toggleDetails(index),
                                        child: Text(
                                          _showDetails[_foundIngredients[index]
                                                      ['id']
                                                  .toString()]!
                                              ? '▲'
                                              : '▼',
                                        ),
                                        style: TextButton.styleFrom(
                                          foregroundColor: Colors.black54,
                                          textStyle:
                                              const TextStyle(fontSize: 16),
                                        ),
                                      ),
                                  ],
                                ),
                                if (_showDetails[_foundIngredients[index]['id']
                                        .toString()]! &&
                                    !_isEditing)
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 50.0, top: 8),
                                    child: SingleChildScrollView(
                                      child: Column(
                                        children: _ingredientCounts[
                                                _foundIngredients[index]['id']
                                                    .toString()]!
                                            .entries
                                            .map(
                                              (entry) => Row(
                                                children: [
                                                  Text(
                                                      DateFormat('dd/MM/yy')
                                                              .format(DateTime
                                                                  .parse(entry
                                                                      .key)) +
                                                          '  : ',
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                        color: _getColorForExpiration(
                                                            _calculateExpirationDate(
                                                                _foundIngredients[
                                                                        index][
                                                                    "storageDays"],
                                                                entry.key)),
                                                      )),
                                                  SizedBox(width: 10),
                                                  Text(
                                                    entry.value.toStringAsFixed(
                                                            2) +
                                                        '  kg.',
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      color: _getColorForExpiration(
                                                          _calculateExpirationDate(
                                                              _foundIngredients[
                                                                      index][
                                                                  "storageDays"],
                                                              entry.key)),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                            .toList(),
                                      ),
                                    ),
                                  ),
                                if (_isEditing)
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 50.0, top: 8),
                                    child: SingleChildScrollView(
                                      child: Column(
                                        children: _ingredientCounts[
                                                _foundIngredients[index]['id']
                                                    .toString()]!
                                            .entries
                                            .map(
                                              (entry) => Row(
                                                children: [
                                                  Text(entry.key,
                                                      style: TextStyle(
                                                          fontSize: 15)),
                                                  SizedBox(width: 10),
                                                  IconButton(
                                                    icon: Icon(Icons.remove),
                                                    onPressed: () =>
                                                        _decrementCount(
                                                            index, entry.key),
                                                  ),
                                                  SizedBox(
                                                    width: 50,
                                                    height: 30,
                                                    child: TextField(
                                                      controller: _controllers[
                                                          _foundIngredients[
                                                                  index]['id']
                                                              .toString()]![entry
                                                          .key],
                                                      keyboardType: TextInputType
                                                          .numberWithOptions(
                                                              decimal: true),
                                                      textAlign:
                                                          TextAlign.center,
                                                      inputFormatters: [
                                                        FilteringTextInputFormatter
                                                            .allow(RegExp(
                                                                r'^\d+\.?\d{0,2}')), // Limit to 2 decimal places
                                                      ],
                                                      onChanged: (value) =>
                                                          _updateCount(index,
                                                              entry.key, value),
                                                    ),
                                                  ),
                                                  IconButton(
                                                    icon: Icon(Icons.add),
                                                    onPressed: () =>
                                                        _incrementCount(
                                                            index, entry.key),
                                                  ),
                                                ],
                                              ),
                                            )
                                            .toList(),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      )
                    : Center(
                        child: Text('ไม่พบวัตถุดิบที่ค้นหา',
                            style: TextStyle(fontSize: 20)),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
