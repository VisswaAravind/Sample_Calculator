import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:math_expressions/math_expressions.dart';

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
            title: Text(
              "Radical Start",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            leading: Padding(
              padding:
                  EdgeInsets.only(left: 10), // Adjust left padding if needed
              child: Image.network(
                "https://res.cloudinary.com/dfpzh53td/f_auto,q_auto/radicalstart/schedulePage/Logo_ahxiux.png",
                width: 50, // Adjust size if necessary
                height: 50,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
      body: [
        CalculatorProviderScreen(),
        CalculatorGetXScreen(),
        ImagePickerScreen(), // Added ImagePickerScreen correctly
      ][_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined), label: 'Provider'),
          BottomNavigationBarItem(
              icon: Icon(Icons.radio_button_on_outlined), label: 'GetX'),
          BottomNavigationBarItem(
              icon: Icon(Icons.image),
              label: 'Image Selection'), // Changed icon to match images
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

class ImagePickerScreen extends StatefulWidget {
  @override
  _ImagePickerScreenState createState() => _ImagePickerScreenState();
}

class _ImagePickerScreenState extends State<ImagePickerScreen> {
  File? _image;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() => _image = File(pickedFile.path));
    }
    Navigator.pop(context); // Close popup after selection
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(10))),
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Align(
                alignment: Alignment.center,
                child: Icon(Icons.image, color: Colors.blue, size: 30),
              ),
              onTap: () => _pickImage(ImageSource.gallery),
            ),
            ListTile(
              title: Align(
                alignment: Alignment.center,
                child: Icon(Icons.camera, color: Colors.green, size: 30),
              ),
              onTap: () => _pickImage(ImageSource.camera),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _image == null
              ? GestureDetector(
                  onTap: _showImageSourceDialog,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                        color: Colors.grey[300], shape: BoxShape.circle),
                    child: Icon(Icons.add, size: 50, color: Colors.black54),
                  ),
                )
              : Column(
                  children: [
                    Image.file(_image!,
                        width: 200, height: 200, fit: BoxFit.cover),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: _showImageSourceDialog,
                          icon: Icon(Icons.edit),
                        ),
                        SizedBox(width: 10),
                        IconButton(
                          onPressed:
                              () {}, // You can define the OK button action
                          icon: Icon(Icons.check, color: Colors.green),
                        ),
                      ],
                    ),
                  ],
                ),
        ],
      ),
    );
  }
}

// ---------------- GetX Implementation ----------------
class CalculatorGetXController extends GetxController {
  var input = ''.obs;
  var result = '0'.obs;

  void appendValue(String value) => input.value += value;
  void clear() => {input.value = '', result.value = '0'};
  void delete() => input.value = input.value.isNotEmpty
      ? input.value.substring(0, input.value.length - 1)
      : '';
  void calculate() => result.value = _evaluate(input.value);

  String _evaluate(String expression) {
    try {
      expression = expression.replaceAll('×', '*').replaceAll('÷', '/');
      Parser p = Parser();
      Expression exp = p.parse(expression);
      return exp.evaluate(EvaluationType.REAL, ContextModel()).toString();
    } catch (e) {
      return 'Error';
    }
  }
}

class CalculatorGetXScreen extends StatelessWidget {
  final controller = Get.put(CalculatorGetXController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => CalculatorWidget(
          onButtonPressed: _onButtonPressed,
          input: controller.input.value,
          result: controller.result.value,
        ));
  }

  void _onButtonPressed(String value) {
    if (value == 'Cc')
      controller.clear();
    else if (value == 'C')
      controller.delete();
    else if (value == '=')
      controller.calculate();
    else
      controller.appendValue(value);
  }
}

// ---------------- Provider Implementation ----------------
class CalculatorProvider with ChangeNotifier {
  String _input = '';
  String _result = '0';

  String get input => _input;
  String get result => _result;

  void appendValue(String value) {
    _input += value;
    notifyListeners();
  }

  void clear() {
    _input = '';
    _result = '0';
    notifyListeners();
  }

  void delete() {
    if (_input.isNotEmpty) _input = _input.substring(0, _input.length - 1);
    notifyListeners();
  }

  void calculate() {
    try {
      _result = _evaluate(_input);
    } catch (e) {
      _result = 'Error';
    }
    notifyListeners();
  }

  String _evaluate(String expression) {
    try {
      expression = expression.replaceAll('×', '*').replaceAll('÷', '/');
      Parser p = Parser();
      Expression exp = p.parse(expression);
      return exp.evaluate(EvaluationType.REAL, ContextModel()).toString();
    } catch (e) {
      return 'Error';
    }
  }
}

class CalculatorProviderScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<CalculatorProvider>(
      builder: (context, provider, child) {
        return CalculatorWidget(
          onButtonPressed: (value) => _onButtonPressed(value, provider),
          input: provider.input,
          result: provider.result,
        );
      },
    );
  }

  void _onButtonPressed(String value, CalculatorProvider provider) {
    if (value == 'Cc')
      provider.clear();
    else if (value == 'C')
      provider.delete();
    else if (value == '=')
      provider.calculate();
    else
      provider.appendValue(value);
  }
}

// ---------------- Common Calculator UI ----------------
class CalculatorWidget extends StatelessWidget {
  final Function(String) onButtonPressed;
  final String input;
  final String result;

  final List<String> buttons = [
    'Cc',
    '%',
    'C',
    '÷',
    '7',
    '8',
    '9',
    '×',
    '4',
    '5',
    '6',
    '-',
    '1',
    '2',
    '3',
    '+',
    '.',
    '0',
    '00',
    '='
  ];

  CalculatorWidget(
      {required this.onButtonPressed,
      required this.input,
      required this.result});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(16),
          child: GridView.builder(
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4, crossAxisSpacing: 10, mainAxisSpacing: 10),
            itemCount: buttons.length,
            itemBuilder: (context, index) {
              return ElevatedButton(
                onPressed: () => onButtonPressed(buttons[index]),
                style: ElevatedButton.styleFrom(
                  shape: CircleBorder(),
                  backgroundColor: _getButtonColor(buttons[index]),
                  padding: EdgeInsets.all(20),
                ),
                child: Text(buttons[index],
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
              );
            },
          ),
        ),
        Expanded(
          child: Container(
            alignment: Alignment.bottomRight,
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(input, style: TextStyle(fontSize: 24, color: Colors.grey)),
                Text(result,
                    style:
                        TextStyle(fontSize: 36, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Color _getButtonColor(String value) => (value == '=')
      ? Colors.orange
      : (['+', '-', '×', '÷'].contains(value)
          ? Colors.orange
          : Colors.grey[200]!);
}
