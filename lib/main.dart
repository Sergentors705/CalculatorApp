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
  final TextEditingController _num2Controller = TextEditingController();
  final TextEditingController _num1Controller = TextEditingController();
  final List<String> buttons = [
    '7', '8', '9', '/',
    '4', '5', '6', '*',
    '1', '2', '3', '-',
    '0', '.', '=', '+',
  ];
  String _operation = '+';
  String _result = '';
  bool editingFirst = true;


  Widget buildNumberButton(String value) {
    return SizedBox(
      width: 60,
      height: 60,
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            if (editingFirst) {
              _num1Controller.text += value;
            } else {
              _num2Controller.text += value;
            }
          });
        },
        child: Text(value, style: TextStyle(fontSize: 22)),
      ),
    );
  }


  Widget buildOperationButton(String op) {
    return SizedBox(
      width: 60,
      height: 60,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: _operation == op ? Colors.orange : Colors.grey.shade700,
        ),
        onPressed: () {
          setState(() {
            _operation = op;
            editingFirst = false;
          });
        },
        child: Text(op, style: TextStyle(fontSize: 22, color: Colors.white)),
      ),
    );
  }


  Widget buildEqualsButton(String _) {
    return SizedBox(
      width: 60,
      height: 60,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
        ),
        onPressed: calculate,
        child: const Text('=', style: TextStyle(fontSize: 22, color: Colors.white)),
      ),
    );
  }


  void calculate() {
    final String n1 = _num1Controller.text;
    final String n2 = _num2Controller.text;

    if (n1.isEmpty || n2.isEmpty) {
      setState(() {
        _result = "Please enter both values.";
      });
      return;
    }


    final double a = double.tryParse(n1) ?? double.nan;
    final double b = double.tryParse(n2) ?? double.nan;


    if (a.isNaN || b.isNaN) {
      setState(() {
        _result = "Invalid number format.";
      });
      return;
    }


    double res;

    switch (_operation) {
      case '+':
        res = a + b;
        break;
      case '-':
        res = a - b;
        break;
      case '*':
        res = a * b;
        break;
      case '/':
        if (b == 0) {
          setState(() {
            _result = "Cannot divide by zero!";
          });
          return;
        }
        res = a / b;
        break;
      default:
        res = double.nan;
    }


    setState(() {
      _result = "Result: $res";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Calculator"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              readOnly: true,
              controller: _num1Controller,
              decoration: InputDecoration(
                labelText: "First number",
                filled: editingFirst,
                fillColor: Colors.blue.shade50,
                border: OutlineInputBorder(),
              ),
              onTap: () => setState(()  {editingFirst = true;}),
            ),
            const SizedBox(height: 16),
            TextField(
              readOnly: true,
              controller: _num2Controller,
              decoration: InputDecoration(
                labelText: "Second number",
                filled: !editingFirst,
                fillColor: Colors.blue.shade50,
                border: OutlineInputBorder(),
              ),
              onTap: () => setState(() { editingFirst = false;}),
            ),

            const SizedBox(height: 16),

            Expanded(
              child: GridView.builder(
                itemCount: buttons.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1,
                ),
                itemBuilder: (context, index) {
                  final button = buttons[index];

                  if ('0123456789.'.contains(button)) {
                    return buildNumberButton(button);
                  }

                  if (button == '=') {
                    return buildEqualsButton(button);
                  }

                  return buildOperationButton(button);
                },
              ),
            ),

            
            Column(

            ),

            const SizedBox(height: 24),
            Row( 
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _num1Controller.text = '';
                    _num2Controller.text = '';
                    setState(() {editingFirst = true;});
                  },
                  child: const Text('Clear'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              _result,
              style: const TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}