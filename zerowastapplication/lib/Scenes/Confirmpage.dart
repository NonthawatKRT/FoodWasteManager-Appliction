import 'package:flutter/material.dart';

class ConfirmPage extends StatelessWidget {
  final List<Map<String, dynamic>> selectedItems;
  final VoidCallback onConfirm;

  ConfirmPage({required this.selectedItems, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Confirm Order'),
        backgroundColor: Color.fromARGB(255, 199, 232, 213),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: selectedItems.length,
                itemBuilder: (context, index) => Card(
                  key: ValueKey(selectedItems[index]["id"]),
                  color: Colors.grey[200],
                  elevation: 4,
                  margin: EdgeInsets.symmetric(vertical: 10),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Image.asset(
                          selectedItems[index]["picture"],
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                selectedItems[index]['name'],
                                style: TextStyle(fontSize: 18),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Count: ${selectedItems[index]["count"].toString()}',
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Reset the counts
                  selectedItems.forEach((item) {
                    item['count'] = 0;
                  });

                  // Call the onConfirm callback
                  onConfirm();

                  // Navigate back to the MenuPage
                  Navigator.pop(context);
                },
                child: Text(
                  'Confirm',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  backgroundColor: Color.fromARGB(255, 199, 232, 213), // Button color
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
