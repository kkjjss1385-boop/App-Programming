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
      title: 'Simple Calculator',
      theme: ThemeData.dark(),
      home: const CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _output = "0";
  String _expression = "";
  double _num1 = 0;
  double _num2 = 0;
  String _operand = "";

  void _buttonPressed(String buttonText) {
    if (buttonText == "C") {
      _output = "0";
      _expression = "";
      _num1 = 0;
      _num2 = 0;
      _operand = "";
    } else if (buttonText == "+" || buttonText == "-" || buttonText == "×" || buttonText == "÷") {
      _num1 = double.parse(_output);
      _operand = buttonText;
      _expression = "$_output $buttonText ";
      _output = "0";
    } else if (buttonText == ".") {
      if (_output.contains(".")) {
        return;
      } else {
        _output = _output + buttonText;
      }
    } else if (buttonText == "=") {
      _num2 = double.parse(_output);
      _expression += _output;

      if (_operand == "+") _output = (_num1 + _num2).toString();
      if (_operand == "-") _output = (_num1 - _num2).toString();
      if (_operand == "×") _output = (_num1 * _num2).toString();
      if (_operand == "÷") {
        _output = _num2 != 0 ? (_num1 / _num2).toString() : "Error";
      }

      // 소수점 .0으로 끝나는 경우 정수로 변환
      if (_output.endsWith(".0")) {
        _output = _output.substring(0, _output.length - 2);
      }
      
      _operand = "";
    } else {
      if (_output == "0") {
        _output = buttonText;
      } else {
        _output = _output + buttonText;
      }
    }

    setState(() {});
  }

  Widget _buildButton(String buttonText, Color color, Color textColor) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            padding: const EdgeInsets.all(22.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24.0),
            ),
          ),
          onPressed: () => _buttonPressed(buttonText),
          child: Text(
            buttonText,
            style: TextStyle(
              fontSize: 28.0,
              fontWeight: FontWeight.bold,
              color: textColor,
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
      body: Column(
        children: <Widget>[
          // 수식 및 결과 화면 영역
          Expanded(
            child: Container(
              alignment: Alignment.bottomRight,
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _expression,
                    style: const TextStyle(fontSize: 24.0, color: Colors.grey),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _output,
                    style: const TextStyle(fontSize: 60.0, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
          // 키패드 영역
          Column(
            children: [
              Row(
                children: [
                  _buildButton("C", Colors.grey, Colors.black),
                  _buildButton("÷", Colors.orange, Colors.white),
                ],
              ),
              Row(
                children: [
                  _buildButton("7", Colors.grey[850]!, Colors.white),
                  _buildButton("8", Colors.grey[850]!, Colors.white),
                  _buildButton("9", Colors.grey[850]!, Colors.white),
                  _buildButton("×", Colors.orange, Colors.white),
                ],
              ),
              Row(
                children: [
                  _buildButton("4", Colors.grey[850]!, Colors.white),
                  _buildButton("5", Colors.grey[850]!, Colors.white),
                  _buildButton("6", Colors.grey[850]!, Colors.white),
                  _buildButton("-", Colors.orange, Colors.white),
                ],
              ),
              Row(
                children: [
                  _buildButton("1", Colors.grey[850]!, Colors.white),
                  _buildButton("2", Colors.grey[850]!, Colors.white),
                  _buildButton("3", Colors.grey[850]!, Colors.white),
                  _buildButton("+", Colors.orange, Colors.white),
                ],
              ),
              Row(
                children: [
                  _buildButton("0", Colors.grey[850]!, Colors.white),
                  _buildButton(".", Colors.grey[850]!, Colors.white),
                  _buildButton("=", Colors.orange, Colors.white),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
