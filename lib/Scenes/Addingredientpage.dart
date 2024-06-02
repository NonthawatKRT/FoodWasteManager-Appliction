import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class AddIngredientsPage extends StatefulWidget {
  @override
  _AddIngredientsPageState createState() => _AddIngredientsPageState();
}

class _AddIngredientsPageState extends State<AddIngredientsPage> {
  final List<Map<String, dynamic>> _allIngredients = [
    {"id": 1, "name": "เนื้อ", "type": "meat", "count": 0.0, "picture": "assets/images/beef.jpg" ,"storageDays": 5},
    {"id": 2, "name": "ไก่", "type": "meat", "count": 0.0, "picture": "assets/images/chicken.jpg", "storageDays": 2},
    {"id": 3, "name": "ปลา", "type": "meat", "count": 0.0, "picture": "assets/images/fish.jpg", "storageDays": 2},
    {"id": 4, "name": "หมู", "type": "meat", "count": 0.0, "picture": "assets/images/pork.jpg", "storageDays": 5},
    {"id": 5, "name": "กุ้ง", "type": "meat", "count": 0.0, "picture": "assets/images/shrimp.jpg", "storageDays": 2},
    {"id": 6, "name": "ปู", "type": "meat", "count": 0.0, "picture": "assets/images/crab.jpg", "storageDays": 3},
    {"id": 7, "name": "กะหล่ำ", "type": "vegetable", "count": 0.0, "picture": "assets/images/cabbage.jpg", "storageDays": 7},
    {"id": 8, "name": "เเครอท", "type": "vegetable", "count": 0.0, "picture": "assets/images/carrot.jpg", "storageDays": 21},
    {"id": 9, "name": "มะเขือเทศ", "type": "vegetable", "count": 0.0, "picture": "assets/images/tomato.jpg", "storageDays": 14},
    {"id": 10, "name": "มะนาว", "type": "vegetable", "count": 0.0, "picture": "assets/images/lime.jpg", "storageDays": 28},
    {"id": 11, "name": "หัวหอม", "type": "vegetable", "count": 0.0, "picture": "assets/images/onion.jpg", "storageDays": 21},
    {"id": 12, "name": "เห็ด", "type": "vegetable", "count": 0.0, "picture": "assets/images/mushroom.jpg", "storageDays": 7},
  ];

  List<Map<String, dynamic>> _foundIngredients = [];
  String _selectedType = 'all';
  String _searchTerm = '';
  bool _showFab = false;
  late File _countFile;
  Map<String, Map<String, double>> _ingredientCounts = {};

  @override
  void initState() {
    super.initState();
    _foundIngredients = _allIngredients.map((ingredient) => {...ingredient}).toList();
    _initializeFile();
  }

  Future<void> _initializeFile() async {
    final directory = await getApplicationDocumentsDirectory();
    _countFile = File('${directory.path}/ingredient_counts.json');

    print('File path: ${_countFile.path}'); // Print the file path for debugging

    if (await _countFile.exists()) {
      await _loadCounts();
    } else {
      await _saveCounts();
    }
  }

  Future<void> _loadCounts() async {
    final contents = await _countFile.readAsString();
    final Map<String, dynamic> jsonData = json.decode(contents);

    setState(() {
      _ingredientCounts = jsonData.map((key, value) => MapEntry(key, (value as Map).map((k, v) => MapEntry(k, (v as num).toDouble()))));
    });

    _printFileContents(); // Print file contents after loading
  }

  Future<void> _saveCounts() async {
    final jsonData = _ingredientCounts.map((key, value) => MapEntry(key, value.map((k, v) => MapEntry(k, v))));
    await _countFile.writeAsString(json.encode(jsonData));
    setState(() {
      _showFab = false;
    });

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
    _searchTerm = enteredKeyword;
    List<Map<String, dynamic>> results = [];
    if (enteredKeyword.isEmpty) {
      results = _allIngredients.where((ingredient) => _selectedType == 'all' || ingredient['type'] == _selectedType).toList();
    } else {
      results = _allIngredients.where((ingredient) =>
        ingredient["name"].toLowerCase().contains(enteredKeyword.toLowerCase()) &&
        (_selectedType == 'all' || ingredient['type'] == _selectedType)).toList();
    }

    setState(() {
      _foundIngredients = results.map((ingredient) => {...ingredient}).toList();
    });
  }

  void _filterByType(String type) {
    setState(() {
      _selectedType = type;
      _runFilter(_searchTerm);
    });
  }

  void _incrementCount(int index) {
    setState(() {
      _foundIngredients[index]['count'] += 1.0;
      _showFab = true;
      print('Incremented count of ${_foundIngredients[index]['name']} to ${_foundIngredients[index]['count']}');
    });
  }

  void _decrementCount(int index) {
    setState(() {
      if (_foundIngredients[index]['count'] > 0) {
        _foundIngredients[index]['count'] -= 1.0;
        _showFab = true;
        print('Decremented count of ${_foundIngredients[index]['name']} to ${_foundIngredients[index]['count']}');
      }
    });
  }

  void _updateCount(int index, String value) {
    setState(() {
      double newCount = double.tryParse(value) ?? 0.0;
      _foundIngredients[index]['count'] = newCount;
      _showFab = true;
      print('Updated count of ${_foundIngredients[index]['name']} to $newCount');
    });
  }

  void _confirmSelection() {
    setState(() {
      final String currentDate = DateTime.now().toIso8601String().split('T').first; // Get the current date
      for (var ingredient in _foundIngredients) {
        final id = ingredient['id'].toString();
        if (!_ingredientCounts.containsKey(id)) {
          _ingredientCounts[id] = {};
        }
        if (_ingredientCounts[id]!.containsKey(currentDate)) {
          _ingredientCounts[id]![currentDate] = (_ingredientCounts[id]![currentDate]! + (ingredient['count'] as double)).toDouble();
        } else {
          _ingredientCounts[id]![currentDate] = ingredient['count'] as double;
        }
        print('Confirmed count of ${ingredient['name']} for date $currentDate: ${_ingredientCounts[id]![currentDate]}');
        ingredient['count'] = 0.0; // Reset the count after confirming
      }
    });
    _saveCounts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xFFC7E8D5), // Set the background color of the AppBar
        elevation: 0,
        title: const Text('เพิ่มวัตถุดิบ'),
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
                  contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
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
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () => _filterByType('all'),
                          child: const Text(
                            'ทั้งหมด',
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _selectedType == 'all'
                                ? const Color(0xFFC7E8D5)
                                : const Color.fromARGB(197, 208, 208, 208),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () => _filterByType('vegetable'),
                          child: const Text(
                            'ผัก/ผลไม้',
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _selectedType == 'vegetable'
                                ? const Color(0xFFC7E8D5)
                                : const Color.fromARGB(197, 208, 208, 208),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () => _filterByType('meat'),
                          child: const Text(
                            'เนื้อสัตว์',
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 14,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _selectedType == 'meat'
                                ? const Color(0xFFC7E8D5)
                                : const Color.fromARGB(197, 208, 208, 208),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Expanded(
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 16.0),
                                                  child: Text(
                                                    _foundIngredients[index]
                                                        ['name'],
                                                    style: const TextStyle(
                                                        fontSize: 18),
                                                  ),
                                                ),
                                                const SizedBox(height: 8),
                                                Row(
                                                  children: [
                                                    IconButton(
                                                      icon: const Icon(
                                                          Icons.remove),
                                                      onPressed: () =>
                                                          _decrementCount(
                                                              index),
                                                    ),
                                                    Container(
                                                      width: 50,
                                                      height:
                                                          30, // Set the height of the TextField
                                                      child: TextField(
                                                        keyboardType:
                                                            TextInputType
                                                                .numberWithOptions(decimal: true),
                                                        controller:
                                                            TextEditingController(
                                                                text: _foundIngredients[
                                                                            index]
                                                                        [
                                                                        "count"]
                                                                    .toString()),
                                                        onSubmitted: (value) =>
                                                            _updateCount(
                                                                index, value),
                                                        textAlign:
                                                            TextAlign.center,
                                                        textAlignVertical:
                                                            TextAlignVertical
                                                                .center,
                                                        decoration:
                                                            const InputDecoration(
                                                          border:
                                                              OutlineInputBorder(),
                                                          contentPadding:
                                                              EdgeInsets.all(
                                                                  3), // Adjust the padding
                                                        ),
                                                      ),
                                                    ),
                                                    IconButton(
                                                      icon:
                                                          const Icon(Icons.add),
                                                      onPressed: () =>
                                                          _incrementCount(
                                                              index),
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
                          : const Center(
                              child: Text(
                                'ไม่พบวัตถุดิบที่ค้นหา',
                                style: TextStyle(fontSize: 24),
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Container(
            margin: EdgeInsets.only(left: 16.0, bottom: 16.0),
            child: Visibility(
              visible: _showFab,
              child: FloatingActionButton.extended(
                onPressed: () {
                  _confirmSelection();
                  QuickAlert.show(
                    context: context,
                    type: QuickAlertType.success,
                    title: 'สำเร็จ',
                    text: 'เพิ่มวัตถุดิบลงในระบบเรียบร้อย',
                    headerBackgroundColor: Color(0xFF306754),
                    confirmBtnColor:  Colors.grey[500]!,
                    barrierColor:  Color.fromARGB(102, 62, 66, 64),
                    confirmBtnText: 'ตกลง',
                  );
                },
                label: const Text('Confirm'),
                icon: const Icon(Icons.check),
                backgroundColor: const Color(0xFFC7E8D5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class IngredientPage extends StatelessWidget {
  const IngredientPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AddIngredientsPage(),
    );
  }
}
