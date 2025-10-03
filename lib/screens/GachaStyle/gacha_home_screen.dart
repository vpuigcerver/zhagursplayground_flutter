import 'package:flutter/material.dart';
import 'package:zhagurplayground/screens/GachaStyle/screens/collection/colection_screen.dart';
import 'package:zhagurplayground/screens/GachaStyle/screens/gacha/gacha_screen.dart';
import 'package:zhagurplayground/screens/GachaStyle/screens/shop/shop_screen.dart';

class GachaHomeScreen extends StatefulWidget {
  final ValueNotifier<int> themeMode;
  const GachaHomeScreen({super.key, required this.themeMode});

  @override
  State<GachaHomeScreen> createState() => _GachaHomeScreenState();
}

class _GachaHomeScreenState extends State<GachaHomeScreen> {
  int _selectedPageIndex = 0;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget activePage = GachaScreen();
    var activePageTitle = 'Gacha';

    if (_selectedPageIndex == 1) {
      activePage = ColectionScreen();
      activePageTitle = 'Coleccion';
    }

    if (_selectedPageIndex == 2) {
      activePage = ShopScreen();
      activePageTitle = 'Tienda';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(activePageTitle),
        actions: [
          IconButton(
            icon: Icon(Icons.nightlight_round),
            onPressed: () {
              widget.themeMode.value = widget.themeMode.value == 1 ? 2 : 1;
            },
          ),
        ],
      ),
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        currentIndex: _selectedPageIndex,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.app_shortcut), label: 'Gacha',),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Colección'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_basket), label: 'Tienda'),
        ],
      ),
    );
  }
}
