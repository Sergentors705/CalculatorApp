import 'package:flutter/material.dart';
import 'calculator_engine.dart';

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
  static const double buttonSize = 72;

  final engine = CalculatorEngine();

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
        onPressed: () {
          setState(() {
            engine.input(text);
          });
        },
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
        onPressed: () {
          setState(() {
            engine.input(text);
          });
        },
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
                    engine.display,
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
