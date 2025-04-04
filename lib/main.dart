import 'package:calculator/providerpage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'getxpage.dart';
import 'imageselectionpage.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CalculatorProvider()),
      ],
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false, // Hide debug banner
        home: CalculatorApp(),
      ),
    ),
  );
}

// Main App with Bottom Navigation
class CalculatorApp extends StatefulWidget {
  @override
  _CalculatorAppState createState() => _CalculatorAppState();
}

class _CalculatorAppState extends State<CalculatorApp> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: SafeArea(
          child: AppBar(
            backgroundColor: Colors.grey,
            title: Padding(
              padding: EdgeInsets.only(top: 20), // Adds space from top
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start, // Align to left
                children: [
                  Image.network(
                    "https://res.cloudinary.com/dfpzh53td/f_auto,q_auto/radicalstart/schedulePage/Logo_ahxiux.png",
                    width: 40,
                    height: 30,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(width: 10), // Space between logo & title
                  Text(
                    "Radical Start",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            centerTitle: false,
          ),
        ),
      ),
      body: [
        CalculatorProviderScreen(),
        CalculatorGetXScreen(),
        ImagePickerScreen(),
      ][_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined), label: 'Provider'),
          BottomNavigationBarItem(
              icon: Icon(Icons.radio_button_on_outlined), label: 'GetX'),
          BottomNavigationBarItem(
              icon: Icon(Icons.image), label: 'Image Selection'),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
