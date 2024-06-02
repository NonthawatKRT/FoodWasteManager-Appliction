import 'package:flutter/material.dart';

class ExpPage extends StatelessWidget {
  final String title;
  final List<Map<String, dynamic>> items;
  final bool showCount;

  ExpPage({required this.title, required this.items, required this.showCount});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(title),
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return ListTile(
            leading: Image.asset(
              item['picture'],
              width: 50,
              height: 50,
            ),
            title: Text(item['name']),
            subtitle: title == 'Expiring Soon'
                ? Text('Expires on: ${_formatDate(item['expirationDate'])}')
                : showCount
                    ? Text(
                        'Total Count: ${item['count'] ?? 'N/A'}') // Display 'N/A' if count is null
                    : SizedBox.shrink(), // Hide the count if not applicable
          );
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}/${_formatTwoDigits(date.month)}/${_formatTwoDigits(date.day)}';
  }

  String _formatTwoDigits(int value) {
    return value < 10 ? '0$value' : '$value';
  }
}
