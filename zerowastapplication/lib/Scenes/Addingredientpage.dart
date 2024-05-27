import 'package:flutter/material.dart';

class AddIngredientsPage extends StatefulWidget {
  @override
  _AddIngredientPageState createState() => _AddIngredientPageState();
}

class _AddIngredientPageState extends State<AddIngredientsPage> {
  final List<Map<String, dynamic>> _allIngredients = [
    {"id": 1, "name": "beef", "type": "meat", "count": 0, "picture": "assets/images/beef.jpg"},
    {"id": 2, "name": "chicken", "type": "meat", "count": 0, "picture": "assets/images/chicken.jpg"},
    {"id": 3, "name": "fish", "type": "meat", "count": 0, "picture": "assets/images/fish.jpg"},
    {"id": 4, "name": "pork", "type": "meat", "count": 0, "picture": "assets/images/pork.jpg"},
    {"id": 5, "name": "shrimp", "type": "meat", "count": 0, "picture": "assets/images/shrimp.jpg"},
    {"id": 6, "name": "crab", "type": "meat", "count": 0, "picture": "assets/images/crab.jpg"},
    {"id": 7, "name": "cabbage", "type": "vegetable", "count": 0, "picture": "assets/images/cabbage.jpg"},
    {"id": 8, "name": "carrot", "type": "vegetable", "count": 0, "picture": "assets/images/carrot.jpg"},
    {"id": 9, "name": "tomato", "type": "vegetable", "count": 0, "picture": "assets/images/tomato.jpg"},
    {"id": 10, "name": "lime", "type": "vegetable", "count": 0, "picture": "assets/images/lime.jpg"},
    {"id": 11, "name": "onion", "type": "vegetable", "count": 0, "picture": "assets/images/onion.jpg"},
    {"id": 12, "name": "mushroom", "type": "vegetable", "count": 0, "picture": "assets/images/mushroom.jpg"},
  ];
  List<Map<String, dynamic>> _foundIngredients = [];
  String _selectedType = 'all';
  String _searchTerm = '';

  @override
  void initState() {
    _foundIngredients = _allIngredients;
    super.initState();
  }

  void _runFilter(String enteredKeyword) {
    _searchTerm = enteredKeyword;
    List<Map<String, dynamic>> results = [];
    if (enteredKeyword.isEmpty) {
      results = _allIngredients.where((ingredient) => _selectedType == 'all' || ingredient['type'] == _selectedType).toList();
    } else {
      results = _allIngredients
          .where((ingredient) =>
              ingredient["name"].toLowerCase().contains(enteredKeyword.toLowerCase()) &&
              (_selectedType == 'all' || ingredient['type'] == _selectedType))
          .toList();
    }

    setState(() {
      _foundIngredients = results;
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
      _foundIngredients[index]['count']++;
    });
  }

  void _decrementCount(int index) {
    setState(() {
      if (_foundIngredients[index]['count'] > 0) {
        _foundIngredients[index]['count']--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xFFC7E8D5), // Set the background color of the AppBar
        elevation: 0,
        title: const Text('Add Ingredients'),
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
                            'All',
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 16,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _selectedType == 'all' ? const Color(0xFFC7E8D5) : const Color.fromARGB(197, 208, 208, 208),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () => _filterByType('vegetable'),
                          child: const Text(
                            'Vegetables',
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 16,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _selectedType == 'vegetable' ? const Color(0xFFC7E8D5) : const Color.fromARGB(197, 208, 208, 208),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () => _filterByType('meat'),
                          child: const Text(
                            'Meat',
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 16,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _selectedType == 'meat' ? const Color(0xFFC7E8D5) : const Color.fromARGB(197, 208, 208, 208),
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
                                elevation: 0,
                                margin: const EdgeInsets.symmetric(vertical: 8),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 13),
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
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.only(left: 16.0),
                                                  child: Text(
                                                    _foundIngredients[index]['name'],
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
                                                      '${_foundIngredients[index]["count"].toString()}',
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
                          : const Center(
                              child: Text(
                                'No results found',
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
