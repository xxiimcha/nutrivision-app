import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sjq/customs/customs.dart';
import 'package:sjq/themes/themes.dart';
import '_widgets.dart';
import '../../call.notifier.dart'; // Import CallNotifier

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0;

  @override
  void initState() {
    super.initState();
    // Start polling for calls as soon as HomeScreen is initialized
    Provider.of<CallNotifier>(context, listen: false).startPolling(context);
  }

  // Handle navigation tab selection
  void _onSelect(int index) {
    setState(() {
      _index = index;
      debugPrint('Selected index: $_index');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _index != 4 
          ? const CustomAppbar() 
          : null,
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
