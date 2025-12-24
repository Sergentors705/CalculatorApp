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
    ];

    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(12),
          sliver: SliverGrid(
            delegate: SliverChildBuilderDelegate((context, index) {
              return buildButton(buttons[index]);
            }, childCount: buttons.length),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: Row(
              children: [
                Expanded(child: buildWideButton('0')),
                const SizedBox(width: 12),
                buildButton('.'),
                const SizedBox(width: 12),
                buildButton('='),
              ],
            ),
          ),
        ),
      ],
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

    return SizedBox(
      width: buttonSize,
      height: buttonSize,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: bg,
          shape: const CircleBorder(),
          padding: const EdgeInsets.all(20),
        ),
        onPressed: () => onButtonPressed(text),
        child: Text(text, style: TextStyle(fontSize: 24, color: fg)),
      ),
    );
  }

  Widget buildWideButton(String text) {
    return SizedBox(
      height: buttonSize,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey.shade800,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(buttonSize / 2),
          ),
          padding: const EdgeInsets.only(left: 28),
        ),
        onPressed: () => onButtonPressed(text),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            text,
            style: const TextStyle(fontSize: 26, color: Colors.white),
          ),
        ),
      ),
    );
  }

  void onButtonPressed(String value) {
    setState(() {
      // AC
      if (value == 'AC') {
        display = '0';
        hasError = false;
        first = null;
        second = null;
        operator = null;
        isNewInput = true;
        return;
      } else {
        display = '0';
        hasError = false;
        first = null;
        operator = null;
      }

      // equal
      if (value == '=') {
        if (first == null || operator == null) return;

        second = double.parse(display);
        double result;

        switch (operator) {
          case '+':
            result = first! + second!;
            break;
          case '-':
            result = first! - second!;
            break;
          case 'x':
            result = first! * second!;
            break;
          case '/':
            if (second == 0) {
              display = 'Error';
              hasError = true;
              first = null;
              operator = null;
              isNewInput = true;
              return;
            } else {
              result = first! / second!;
              break;
            }
          default:
            return;
        }

        display = formatResult(result);
        first = result;
        isNewInput = true;
        return;
      }

      // digits and dot
      if ('0123456789.'.contains(value)) {
        if (isNewInput) {
          display = value == '.' ? '0.' : value;
          isNewInput = false;
        } else {
          if (value == '.' && display.contains('.')) return;
          if (display.length >= maxDisplayLength) return;
          display += value;
        }
        return;
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
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerRight,
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
            ),
            Expanded(flex: 5, child: buildButtons()),
          ],
        ),
      ),
    );
  }
}
