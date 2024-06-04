import 'package:flutter/material.dart';
import 'package:zerowastapplication/Scenes/Addingredientpage.dart';
import 'package:zerowastapplication/Scenes/Addmenupage.dart';
import 'package:zerowastapplication/Scenes/Homepage.dart';
import 'package:zerowastapplication/Scenes/Inventorypage.dart';
import 'package:zerowastapplication/Scenes/Menupage.dart';

final List<Widget> _pages = [
  HomePage(),
  const MenuPage(),
  AddIngredientsPage(),
  AddMenuPage(),
  InventoryPage(),
];