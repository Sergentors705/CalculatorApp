import 'package:flutter/material.dart';

class CalculatorEngine {
  String display = '0';

  double? first;
  String? operator;

  double? lastSecond;
  String? lastOperator;

  bool isNewInput = true;
  bool hasError = false;

  static const int maxDisplayLength = 9;

  // --- PUBLIC API ---
  void input(String value) {
    if (hasError && value != 'AC') {
      _reset();
    }

    if (_handleClear(value)) return;
    if (_handleSign(value)) return;
    if (_handlePercent(value)) return;
    if (_handleOperator(value)) return;
    if (_handleEqual(value)) return;
    if (_handleDigit(value)) return;
  }

  // --- HANDLERS ---

  bool _handleClear(String value) {
    if (value == 'AC') {
      _reset();
      return true;
    }
    return false;
  }

  bool _handleSign(String value) {
    if (value == '±') {
      if (display.startsWith('-')) {
        display = display.substring(1);
      } else if (display != '0') {
        display = '-$display';
      }
      return true;
    }
    return false;
  }

  bool _handlePercent(String value) {
    if (value != '%') return false;

    final current = double.tryParse(display);

    if (current == null) return true;

    if (first == null || operator == null) {
      display = _format(current / 100);
    } else {
      display = _format(first! * current / 100);
    }

    isNewInput = true;
    return true;
  }

  bool _handleOperator(String value) {
    if (!'+-x/'.contains(value)) return false;

    first = double.parse(display);
    operator = value;
    isNewInput = true;
    return true;
  }

  bool _handleEqual(String value) {
    if (value != '=') return false;

    if (first != null && operator != null) {
      final second = double.parse(display);

      lastSecond = second;
      lastOperator = operator;

      final double? result = _calculate(first!, second, operator!);

      if (result == null) {
        display = 'Error';
        hasError = true;
        isNewInput = true;
        return true;
      }

      display = _format(result);
      first = result;
      operator = null;
      isNewInput = true;
      return true;
    }

    if (first != null && lastSecond != null && lastOperator != null) {
      final double? result = _calculate(first!, lastSecond!, lastOperator!);
      if (result == null) {
        display = 'Error';
        _reset();
        isNewInput = true;
        return true;
      }
      display = _format(result);
      first = result;
      isNewInput = true;
      return true;
    }

    return false;
  }

  bool _handleDigit(String value) {
    if (!'1234567890.'.contains(value)) return false;

    if (isNewInput) {
      display = value == '.' ? '0.' : value;
      isNewInput = false;
    } else {
      if (value == '.' && display.contains('.')) return true;
      if (display.length >= maxDisplayLength) return true;
      display += value;
    }

    return true;
  }

  // --- CORE MATH ---

  double? _calculate(double a, double b, String op) {
    switch (op) {
      case '+':
        return a + b;
      case '-':
        return a - b;
      case 'x':
        return a * b;
      case '/':
        return b == 0 ? null : a / b;
      default:
        return null;
    }
  }

  String _format(double value) {
    if (value % 1 == 0) {
      return value.toInt().toString();
    }
    return value.toString();
  }

  void _reset() {
    display = '0';
    first = null;
    operator = null;
    lastOperator = null;
    lastSecond = null;
    isNewInput = true;
    hasError = false;
  }
}
