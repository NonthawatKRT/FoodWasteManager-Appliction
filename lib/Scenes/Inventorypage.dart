import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:flutter/material.dart';

class InventoryPage extends StatefulWidget {
  @override
  _InventoryPageState createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  final List<Map<String, dynamic>> _allIngredients = [
    {
      "id": 1,
      "name": "beef",
      "type": "meat",
      "unit": "kg",
      "picture": "assets/images/beef.jpg"
    },
    {
      "id": 2,
      "name": "chicken",
      "type": "meat",
      "unit": "kg",
      "picture": "assets/images/chicken.jpg"
    },
    {
      "id": 3,
      "name": "fish",
      "type": "meat",
      "unit": "kg",
      "picture": "assets/images/fish.jpg"
    },
    {
      "id": 4,
      "name": "pork",
      "type": "meat",
      "unit": "kg",
      "picture": "assets/images/pork.jpg"
    },
    {
      "id": 5,
      "name": "shrimp",
      "type": "meat",
      "unit": "kg",
      "picture": "assets/images/shrimp.jpg"
    },
    {
      "id": 6,
      "name": "crab",
      "type": "meat",
      "unit": "kg",
      "picture": "assets/images/crab.jpg"
    },
    {
      "id": 7,
      "name": "cabbage",
      "type": "vegetable",
      "unit": "kg",
      "picture": "assets/images/cabbage.jpg"
    },
    {
      "id": 8,
      "name": "carrot",
      "type": "vegetable",
      "unit": "kg",
      "picture": "assets/images/carrot.jpg"
    },
    {
      "id": 9,
      "name": "tomato",
      "type": "vegetable",
      "unit": "kg",
      "picture": "assets/images/tomato.jpg"
    },
    {
      "id": 10,
      "name": "lime",
      "type": "vegetable",
      "unit": "kg",
      "picture": "assets/images/lime.jpg"
    },
    {
      "id": 11,
      "name": "onion",
      "type": "vegetable",
      "unit": "kg",
      "picture": "assets/images/onion.jpg"
    },
    {
      "id": 12,
      "name": "mushroom",
      "type": "vegetable",
      "unit": "kg",
      "picture": "assets/images/mushroom.jpg"
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
      _ingredientCounts = jsonData.map((key, value) => MapEntry(
          key, (value as Map).map((k, v) => MapEntry(k, v.toDouble()))));
      _updateTotalCounts();
      for (var entry in _ingredientCounts.entries) {
        _controllers[entry.key] = {};
        for (var dateEntry in entry.value.entries) {
          _controllers[entry.key]![dateEntry.key] =
              TextEditingController(text: dateEntry.value.toString());
        }
      }
    });
  }

  Future<void> _saveCounts() async {
    final jsonData = _ingredientCounts.map(
        (key, value) => MapEntry(key, value.map((k, v) => MapEntry(k, v))));
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
      if (_ingredientCounts[id]![date]! > 0) {
        _ingredientCounts[id]![date] = (_ingredientCounts[id]![date]! - 1.0);
        _controllers[id]![date]!.text =
            _ingredientCounts[id]![date]!.toString();
      }
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
      _showDetails[id] = !_showDetails[id]!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xFFC7E8D5),
        elevation: 0,
        title: const Text('Inventory'),
        actions: [
          TextButton.icon(
            icon: Icon(_isEditing ? Icons.check : Icons.edit,
                color: Color.fromARGB(255, 63, 63, 63)),
            label: Text(_isEditing ? 'Confirm' : 'Edit',
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
                  labelText: 'Search',
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
                                    Image.asset(
                                      _foundIngredients[index]["picture"],
                                      width: 80,
                                      height: 80,
                                      fit: BoxFit.cover,
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
                                                (_foundIngredients[index]['count'] ?? 0.0).toStringAsFixed(2),
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
                                                  Text(entry.key,
                                                      style: TextStyle(
                                                          fontSize: 15)),
                                                  SizedBox(width: 10),
                                                  Text(
                                                      entry.value
                                                          .toStringAsFixed(2),
                                                      style: TextStyle(
                                                          fontSize: 15)),
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
                        child: Text('No results found',
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
