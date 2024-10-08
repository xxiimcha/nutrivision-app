import 'package:flutter/material.dart';
import 'package:sjq/customs/customs.dart';
import 'package:sjq/themes/themes.dart';
import '_widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0;

  void _onSelect(int index) {
    setState(() {
      _index = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _index != 4 ? const CustomAppbar() : null,
      body: bodies.elementAt(_index),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: colorLightBlue,
        elevation: 3,
        items: items,
        currentIndex: _index,
        selectedItemColor: Colors.black,
        onTap: _onSelect,
      ),
    );
  }
}
