import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SimpleCalculator(),
    );
  }
}

class SimpleCalculator extends StatefulWidget {
  const SimpleCalculator({super.key});

  @override
  State<SimpleCalculator> createState() => _SimpleCalculatorState();
}

class _SimpleCalculatorState extends State<SimpleCalculator> {
  String _display = '0';
  double? _firstValue;
  String? _operator;

  void _appendDigit(String digit) {
    setState(() {
      if (_display == '0') {
        _display = digit;
      } else {
        _display += digit;
      }
    });
  }

  void _clear() {
    setState(() {
      _display = '0';
      _firstValue = null;
      _operator = null;
    });
  }

  void _chooseOperator(String op) {
    setState(() {
      if (_firstValue == null) {
        _firstValue = double.parse(_display);
        _operator = op;
        _display = '0';
        return;
      }

      if (_operator != null) {
        _calculate();
      }

      _operator = op;
      _display = '0';
    });
  }

  void _calculate() {
    if (_firstValue == null || _operator == null) return;

    final current = double.parse(_display);
    double result;

    switch (_operator) {
      case '+':
        result = _firstValue! + current;
        break;
      case '-':
        result = _firstValue! - current;
        break;
      case '×':
        result = _firstValue! * current;
        break;
      case '÷':
        result = current == 0 ? double.nan : _firstValue! / current;
        break;
      default:
        return;
    }

    setState(() {
      _display = result.isNaN ? 'Error' : result.toString();
      _firstValue = null;
      _operator = null;
    });
  }

  Widget _buildButton(String label, {
    Color color = const Color(0xFF2C2C2E),
    Color textColor = Colors.white,
    VoidCallback? onPressed,
  }) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: SizedBox(
          height: 62,
          child: ElevatedButton(
            onPressed: onPressed ?? () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: color,
              foregroundColor: textColor,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: Text(
              label,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
            ),
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
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  _display,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 52,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  _buildButton('C', color: const Color(0xFFD4D4D2), textColor: Colors.black, onPressed: _clear),
                  _buildButton('÷', color: const Color(0xFFFF9500), onPressed: () => _chooseOperator('÷')),
                  _buildButton('×', color: const Color(0xFFFF9500), onPressed: () => _chooseOperator('×')),
                  _buildButton('-', color: const Color(0xFFFF9500), onPressed: () => _chooseOperator('-')),
                ],
              ),
              Row(
                children: [
                  _buildButton('7', onPressed: () => _appendDigit('7')),
                  _buildButton('8', onPressed: () => _appendDigit('8')),
                  _buildButton('9', onPressed: () => _appendDigit('9')),
                  _buildButton('+', color: const Color(0xFFFF9500), onPressed: () => _chooseOperator('+')),
                ],
              ),
              Row(
                children: [
                  _buildButton('4', onPressed: () => _appendDigit('4')),
                  _buildButton('5', onPressed: () => _appendDigit('5')),
                  _buildButton('6', onPressed: () => _appendDigit('6')),
                  _buildButton('=', color: const Color(0xFFFF9500), onPressed: _calculate),
                ],
              ),
              Row(
                children: [
                  _buildButton('1', onPressed: () => _appendDigit('1')),
                  _buildButton('2', onPressed: () => _appendDigit('2')),
                  _buildButton('3', onPressed: () => _appendDigit('3')),
                ],
              ),
              Row(
                children: [
                  _buildButton('0', onPressed: () => _appendDigit('0')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
