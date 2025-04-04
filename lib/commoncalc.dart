import 'package:flutter/material.dart';

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
