import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import '../Utils/encryption.dart';

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: CalculatorScreen(),
    );
  }
}
class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});
  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}
class _CalculatorScreenState extends State<CalculatorScreen> {
  String _expression = '';
  dynamic _result;
  void _onButtonPressed(String text) {
    if (text == 'C') {
      _clearExpression();
    } else if (text == '=') {
      _handleEqualsPressed();
    } else {
      setState(() {
        if( _result != null)_result = null;
        _expression += text;
      });
    }
  }
  Future<void> _handleEqualsPressed() async {
    try {
      await EncryptionUtils.decryptFile(_expression, context);
      _evaluateExpression();
    } catch (e) {
      _evaluateExpression();
    }
  }
  void _evaluateExpression() {
    try{
      Parser p = Parser();
      Expression exp = p.parse(_expression);
      ContextModel cm = ContextModel();
      dynamic result = exp.evaluate(EvaluationType.REAL, cm);
      String resultString = result.toString();
      if (resultString.endsWith('.0')) {
        resultString = resultString.substring(0, resultString.length - 2);
      }
      setState(() {
        _result = resultString;
        _expression ='';
      });
    }
    catch(e){}
  }
  void _clearExpression() {
    setState(() {
      _expression = '';
      _result = null;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculator'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              alignment: Alignment.bottomRight,
              child: Text(
                _result != null ? '$_result' : _expression,
                style: const TextStyle(fontSize: 24.0),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildButton('7'),
              _buildButton('8'),
              _buildButton('9'),
              _buildButton('/'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildButton('4'),
              _buildButton('5'),
              _buildButton('6'),
              _buildButton('*'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildButton('1'),
              _buildButton('2'),
              _buildButton('3'),
              _buildButton('-'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildButton('0'),
              _buildButton('C'),
              _buildButton('='),
              _buildButton('+'),
            ],
          ),
        ],
      ),
    );
  }
  Widget _buildButton(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: () {
          _onButtonPressed(text);
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.grey[300]),
          shape: MaterialStateProperty.all(RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          )),
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 20.0, color: Colors.black),
        ),
      ),
    );
  }
}