import 'package:flutter/material.dart';
import 'package:zerowastapplication/Widget/menucustom_scaffold.dart';

class InventoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MenuCustomScaffold(
      child: Text(
        'Inventory Page Content',
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}