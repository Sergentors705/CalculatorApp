import 'package:flutter/material.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const CalculatorPage(),
    );
  }
}

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  String display = '0';

  double? firstNumber;
  String? operation;

  bool shouldClearDisplay = false;

  String formatResult(double value) {
    if (value % 1 == 0) {
      return value.toInt().toString();
    }
    return value.toString();
  }

  Widget buildButtons() {
    final buttons = [
      'AC',
      '±',
      '%',
      '/',
      '7',
      '8',
      '9',
      'x',
      '4',
      '5',
      '6',
      '-',
      '1',
      '2',
      '3',
      '+',
      '0',
      '.',
      '=',
    ];

    return GridView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: buttons.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1,
      ),
      itemBuilder: (context, index) {
        final label = buttons[index];

        if (label == '0') return buildWideButton(label);
        return buildButton(label);
      },
    );
  }

  Widget buildButton(String text) {
    Color bg = Colors.grey.shade800;
    Color fg = Colors.white;

    if ('/x-+'.contains(text)) bg = Colors.orange;
    if ('AC±%'.contains(text)) {
      bg = Colors.grey.shade400;
      fg = Colors.black;
    }

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: bg,
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(20),
      ),
      onPressed: () => onButtonPressed(text),
      child: Text(text, style: TextStyle(fontSize: 24, color: fg)),
    );
  }

  Widget buildWideButton(String text) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.grey.shade800,
        borderRadius: BorderRadius.circular(40),
      ),
      onPressed: () => onButtonPressed(text),
      child: Text(
        text,
        style: const TextStyle(fontSize: 24, color: Colors.white),
      ),
    );
  }

  void onButtonPressed(String value) {
    setState(() {
      // AC
      if (value == 'AC') {
        display = '0';
        firstNumber = null;
        operation = null;
        return;
      }

      // operation
      if ('/x-+'.contains(value)) {
        firstNumber = double.parse(display);
        operation = value;
        shouldClearDisplay = true;
        return;
      }

      // equal
      if (value == '=') {
        if (firstNumber == null || operation == null) return;

        final second = double.parse(display);
        double result;

        switch (operation) {
          case '+':
            result = firstNumber! + second;
            break;
          case '-':
            result = firstNumber! - second;
            break;
          case 'x':
            result = firstNumber! * second;
            break;
          case '/':
            if (second == 0) {
              display = "Cannot divide by zero";
              firstNumber = null;
              operation = null;
              shouldClearDisplay = true;
              return;
            } else {
              result = firstNumber! / second;
              break;
            }
          default:
            return;
        }

        display = formatResult(result);
        firstNumber = null;
        operation = null;
        return;
      }

      // digits and dot
      if (shouldClearDisplay) {
        display = value;
        shouldClearDisplay = false;
      } else {
        display = display == '0' ? value : display + value;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                alignment: Alignment.bottomRight,
                padding: const EdgeInsets.all(24),
                child: Text(
                  display,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 64,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
            ),
            Expanded(flex: 5, child: buildButtons()),
          ],
        ),
      ),
    );
  }
}
