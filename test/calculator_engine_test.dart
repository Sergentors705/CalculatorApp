import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_test/flutter_test.dart';
import '../lib/calculator_engine.dart';

void main() {
  group('CalculatorEngine basic operations', () {
    late CalculatorEngine engine;

    setUp(() {
      engine = CalculatorEngine();
    });

    test('initial display is 0', () {
      expect(engine.display, '0');
    });
    test('5 + 2 = 7', () {
      engine.input('5');
      engine.input('+');
      engine.input('2');
      engine.input('=');

      expect(engine.display, '7');
    });
    test('10 - 3 = 7', () {
      engine.input('1');
      engine.input('0');
      engine.input('-');
      engine.input('3');
      engine.input('=');

      expect(engine.display, '7');
    });
    test('6 x 4 = 24', () {
      engine.input('6');
      engine.input('x');
      engine.input('4');
      engine.input('=');

      expect(engine.display, '24');
    });

    test('8 / 2 = 4', () {
      engine.input('8');
      engine.input('/');
      engine.input('2');
      engine.input('=');

      expect(engine.display, '4');
    });
    test('division by zero shows Error', () {
      engine.input('5');
      engine.input('/');
      engine.input('0');
      engine.input('=');

      expect(engine.display, 'Error');
    });
    test('50 % = 0.5', () {
      engine.input('5');
      engine.input('0');
      engine.input('%');

      expect(engine.display, '0.5');
    });
    test('200 + 10 % = 220', () {
      engine.input('2');
      engine.input('0');
      engine.input('0');
      engine.input('+');
      engine.input('1');
      engine.input('0');
      engine.input('%');
      engine.input('=');

      expect(engine.display, '220');
    });
    test('5 + 2 = = = gives 11', () {
      engine.input('5');
      engine.input('+');
      engine.input('2');
      engine.input('=');
      engine.input('=');
      engine.input('=');

      expect(engine.display, '11');
    });

    test('percent with operator: 200 + 10 % = gives 220', () {
      final engine = CalculatorEngine();

      engine.input('2');
      engine.input('0');
      engine.input('0');
      engine.input('+');
      engine.input('1');
      engine.input('0');
      engine.input('%');
      engine.input('=');

      expect(engine.display, '220');
    });

    test('5 + = = gives 15', () {
      final engine = CalculatorEngine();

      engine.input('5');
      engine.input('+');
      engine.input('=');
      engine.input('=');

      expect(engine.display, '15');
    });

    test('AC clears error state', () {
      final engine = CalculatorEngine();

      engine.input('5');
      engine.input('/');
      engine.input('0');
      engine.input('=');

      expect(engine.display, 'Error');

      engine.input('AC');
      expect(engine.display, '0');

      engine.input('8');
      expect(engine.display, '8');
    });

    test('percent after equals works', () {
      final engine = CalculatorEngine();

      engine.input('5');
      engine.input('0');
      engine.input('=');
      engine.input('%');
    });
  });
}
