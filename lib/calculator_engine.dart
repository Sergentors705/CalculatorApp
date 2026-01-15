enum Operation { add, subtract, multiply, divide }

class CalculatorState {
  final String display;

  final double? first;
  final Operation? operation;

  final double? lastSecond;
  final Operation? lastOperator;

  final bool isNewInput;
  final bool hasError;

  CalculatorState({
    required this.display,
    this.first,
    this.operation,
    this.lastSecond,
    this.lastOperator,
    required this.hasError,
    required this.isNewInput,
  });

  CalculatorState copyWith({
    String? display,
    double? first,
    Operation? operation,
    double? lastSecond,
    Operation? lastOperator,
    bool? isNewInput,
    bool? hasError,
  }) {
    return CalculatorState(
      display: display ?? this.display,
      first: first ?? this.first,
      operation: operation ?? this.operation,
      lastSecond: lastSecond ?? this.lastSecond,
      lastOperator: lastOperator ?? this.lastOperator,
      hasError: hasError ?? this.hasError,
      isNewInput: isNewInput ?? this.isNewInput,
    );
  }

  CalculatorState clearOperation() {
    return CalculatorState(
      display: display,
      first: first,
      operation: null,
      lastSecond: lastSecond,
      lastOperator: lastOperator,
      hasError: hasError,
      isNewInput: isNewInput,
    );
  }

  factory CalculatorState.initial() =>
      CalculatorState(display: '0', hasError: false, isNewInput: true);
}

class CalculatorEngine {
  static const int maxDisplayLength = 9;

  // --- PUBLIC API ---
  CalculatorState input(CalculatorState state, String value) {
    if (state.hasError && value != 'AC') {
      state = CalculatorState.initial();
    }

    final s1 = _handleClear(state, value);
    if (s1 != null) return s1;
    final s2 = _handleSign(state, value);
    if (s2 != null) return s2;
    final s3 = _handlePercent(state, value);
    if (s3 != null) return s3;
    final s4 = _handleOperator(state, value);
    if (s4 != null) return s4;
    final s5 = _handleEqual(state, value);
    if (s5 != null) return s5;
    final s6 = _handleDigit(state, value);
    if (s6 != null) return s6;
    return state;
  }

  // --- HANDLERS ---

  CalculatorState? _handleClear(CalculatorState state, String value) {
    if (value != 'AC') return null;

    if (value == 'AC') {
      return CalculatorState.initial();
    }
  }

  CalculatorState? _handleSign(CalculatorState state, String value) {
    if (value != '±') return null;
    String newDisplay = state.display;
    if (state.display.startsWith('-')) {
      newDisplay = state.display.substring(1);
    } else if (state.display != '0') {
      newDisplay = '-${state.display}';
    }
    return state.copyWith(display: newDisplay);
  }

  CalculatorState? _handlePercent(CalculatorState state, String value) {
    if (value != '%') return null;

    final current = double.tryParse(state.display);

    if (current == null) return state;

    if (state.first == null || state.operation == null) {
      state = state.copyWith(display: _format(current / 100));
    } else {
      state = state.copyWith(display: _format(state.first! * current / 100));
    }

    state = state.copyWith(isNewInput: true);
    return state;
  }

  CalculatorState? _handleOperator(CalculatorState state, String value) {
    if (!'+-x/'.contains(value)) return null;

    state = state.copyWith(first: double.parse(state.display));
    switch (value) {
      case '+':
        state = state.copyWith(operation: Operation.add);
        break;
      case '-':
        state = state.copyWith(operation: Operation.subtract);
        break;
      case 'x':
        state = state.copyWith(operation: Operation.multiply);
        break;
      case '/':
        state = state.copyWith(operation: Operation.divide);
        break;
    }
    state = state.copyWith(isNewInput: true);
    return state;
  }

  CalculatorState? _handleEqual(CalculatorState state, String value) {
    if (value != '=') return null;

    if (state.first != null && state.operation != null) {
      final second = double.parse(state.display);

      state = state.copyWith(lastSecond: second, lastOperator: state.operation);

      final double? result = _calculate(state.first!, second, state.operation!);

      if (result == null) {
        state = state.copyWith(
          display: 'Error',
          hasError: true,
          isNewInput: true,
        );
        return state;
      }

      state = state.copyWith(
        display: _format(result),
        first: result,
        isNewInput: true,
      );
      state = state.clearOperation();
      return state;
    }

    if (state.first != null &&
        state.lastSecond != null &&
        state.lastOperator != null) {
      final double? result = _calculate(
        state.first!,
        state.lastSecond!,
        state.lastOperator!,
      );
      if (result == null) {
        state = state.copyWith(display: 'Error', isNewInput: true);
        state = CalculatorState.initial();
        return state;
      }
      state = state.copyWith(
        display: _format(result),
        first: result,
        isNewInput: true,
      );
      return state;
    }

    return state;
  }

  CalculatorState? _handleDigit(CalculatorState state, String value) {
    if (!'1234567890.'.contains(value)) return null;

    if (state.isNewInput) {
      state = state.copyWith(
        display: value == '.' ? '0.' : value,
        isNewInput: false,
      );
    } else {
      if (value == '.' && state.display.contains('.')) return state;
      if (state.display.length >= maxDisplayLength) return state;
      state = state.copyWith(display: state.display + value);
    }

    return state;
  }

  // --- CORE MATH ---

  double? _calculate(double a, double b, Operation op) {
    switch (op) {
      case Operation.add:
        return a + b;
      case Operation.subtract:
        return a - b;
      case Operation.multiply:
        return a * b;
      case Operation.divide:
        return b == 0 ? null : a / b;
    }
  }

  String _format(double value) {
    if (value % 1 == 0) {
      return value.toInt().toString();
    }
    return value.toString();
  }
}
