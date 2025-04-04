import 'package:flutter/cupertino.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:provider/provider.dart';
import 'commoncalc.dart';

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
      double result = exp.evaluate(EvaluationType.REAL, ContextModel());

      // Return integer if there's no decimal value
      return result == result.toInt()
          ? result.toInt().toString()
          : result.toString();
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
