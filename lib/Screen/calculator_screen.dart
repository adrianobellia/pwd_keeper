import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:pwd_keeper/Models/service_data.dart';
import '../Utils/encryption.dart';
import 'decrypted_data_screen.dart';
import '../Utils/timer.dart';
class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});
  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}
class _CalculatorScreenState extends State<CalculatorScreen> with TickerProviderStateMixin{
  String _expression = '';
  dynamic _result;
  late Timer t;
  void _onButtonPressed(String text) {
    if (text == 'C') {
      _clearExpression();
    } else if (text == '=') {
      _handleEqualsPressed();
    } else if (text == '<') {
      _handleBackspace();
    } else {
      setState(() {
        _result2expression();
        _expression += text;
      });
    }
  }
  @override
  void initState() {
    super.initState();
    t = Timer(vsync: this, durationInSeconds: 7);
    t.start();
  }
  Future<void> _tryToDecrypt() async {
    if (!t.started){
      t.start();
      try{
        List<ServiceData>? s = await EncryptionUtils.decryptFile(_expression);
        if (s!=null){
          t.dispose();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => DecryptedDataScreen(decryptedData: s, expression: _expression),
            ),);
        }
      }
      catch (e) {}
    }
    else{
      t.reset();
    }
  }
  Future<void> _handleEqualsPressed() async {
      _tryToDecrypt();
      _evaluateExpression();
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
  void _result2expression() {
    if (_result != null)
    {
      _expression = _result;
      _result = null;
    }
  }
  void _handleBackspace() {
    setState(() {
      _result2expression();
      if (_expression.isNotEmpty) {
        _expression = _expression.substring(0, _expression.length - 1);
      }
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
              _buildButton('('), // Tasto Backspace
              _buildButton('0'),
              _buildButton('.'),
              _buildButton('+'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildButton(')'),
              _buildButton('<'),
              _buildButton('C'),
              _buildButton('='),
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