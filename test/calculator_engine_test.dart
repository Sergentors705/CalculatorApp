import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_test/flutter_test.dart';
import '../lib/calculator_engine.dart';

void main() {
  group('CalculatorEngine basic operations', () {
    late CalculatorEngine engine;
    late CalculatorState state;

    setUp(() {
      engine = CalculatorEngine();
      state = CalculatorState.initial();
    });

    test('initial display is 0', () {
      expect(state.display, '0');
    });
    test('5 + 2 = 7', () {
      state = engine.input(state, '5');
      state = engine.input(state, '+');
      state = engine.input(state, '2');
      state = engine.input(state, '=');

      expect(state.display, '7');
    });
    test('10 - 3 = 7', () {
      state = engine.input(state, '1');
      state = engine.input(state, '0');
      state = engine.input(state, '-');
      state = engine.input(state, '3');
      state = engine.input(state, '=');

      expect(state.display, '7');
    });
    test('6 x 4 = 24', () {
      state = engine.input(state, '6');
      state = engine.input(state, 'x');
      state = engine.input(state, '4');
      state = engine.input(state, '=');

      expect(state.display, '24');
    });

    test('8 / 2 = 4', () {
      state = engine.input(state, '8');
      state = engine.input(state, '/');
      state = engine.input(state, '2');
      state = engine.input(state, '=');

      expect(state.display, '4');
    });
    test('division by zero shows Error', () {
      state = engine.input(state, '5');
      state = engine.input(state, '/');
      state = engine.input(state, '0');
      state = engine.input(state, '=');

      expect(state.display, 'Error');
    });
    test('50 % = 0.5', () {
      state = engine.input(state, '5');
      state = engine.input(state, '0');
      state = engine.input(state, '%');

      expect(state.display, '0.5');
    });
    test('200 + 10 % = 220', () {
      state = engine.input(state, '2');
      state = engine.input(state, '0');
      state = engine.input(state, '0');
      state = engine.input(state, '+');
      state = engine.input(state, '1');
      state = engine.input(state, '0');
      state = engine.input(state, '%');
      state = engine.input(state, '=');

      expect(state.display, '220');
    });
    test('5 + 2 = = = gives 11', () {
      state = engine.input(state, '5');
      state = engine.input(state, '+');
      state = engine.input(state, '2');
      state = engine.input(state, '=');
      state = engine.input(state, '=');
      state = engine.input(state, '=');

      expect(state.display, '11');
    });

    test('percent with operator: 200 + 10 % = gives 220', () {
      final engine = CalculatorEngine();

      state = engine.input(state, '2');
      state = engine.input(state, '0');
      state = engine.input(state, '0');
      state = engine.input(state, '+');
      state = engine.input(state, '1');
      state = engine.input(state, '0');
      state = engine.input(state, '%');
      state = engine.input(state, '=');

      expect(state.display, '220');
    });

    test('5 + = = gives 15', () {
      final engine = CalculatorEngine();

      state = engine.input(state, '5');
      state = engine.input(state, '+');
      state = engine.input(state, '=');
      state = engine.input(state, '=');

      expect(state.display, '15');
    });

    test('AC clears error state', () {
      final engine = CalculatorEngine();

      state = engine.input(state, '5');
      state = engine.input(state, '/');
      state = engine.input(state, '0');
      state = engine.input(state, '=');

      expect(state.display, 'Error');

      state = engine.input(state, 'AC');
      expect(state.display, '0');

      state = engine.input(state, '8');
      expect(state.display, '8');
    });

    test('percent after equals works', () {
      final engine = CalculatorEngine();

      state = engine.input(state, '5');
      state = engine.input(state, '0');
      state = engine.input(state, '=');
      state = engine.input(state, '%');
    });
  });
}
