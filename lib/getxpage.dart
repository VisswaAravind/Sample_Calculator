import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:math_expressions/math_expressions.dart';

import 'commoncalc.dart';
import 'main.dart';

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
