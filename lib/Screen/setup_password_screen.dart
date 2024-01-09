import 'package:flutter/material.dart';
import '../Utils/encryption.dart';
import '../Screen/calculator_screen.dart';
class SetupPasswordScreen extends StatefulWidget {
  const SetupPasswordScreen({super.key});
  @override
  _SetupPasswordScreenState createState() => _SetupPasswordScreenState();
}
class _SetupPasswordScreenState extends State<SetupPasswordScreen> {
  String _password = '';
  void _onButtonPressed(String text) {
    setState(() {
      if (text == 'Del') {
        _clearPassword();
      } else if (text == 'OK') {
        _onConfirmPressed();
      }
      else if (text == '<') {
        _handleBackspace();
      }
      else {
        _onDigitPressed(text);
      }
    });
  }
  void _handleBackspace() {
    setState(() {
      if (_password.isNotEmpty) {
        _password = _password.substring(0, _password.length - 1);
      }
    });
  }
  void _onDigitPressed(String digit) {
    setState(() {
      _password += digit;
    });
  }
  void _clearPassword() {
    setState(() {
      _password = '';
    });
  }
  void _onConfirmPressed() async {
    await EncryptionUtils.generateEncryptedFile(_password);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const CalculatorScreen(),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Setup Password'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Enter Password:',
            style: TextStyle(fontSize: 20.0),
          ),
          const SizedBox(height: 16.0),
          Text(
            _password,
            style: const TextStyle(fontSize: 24.0),
          ),
          const SizedBox(height: 16.0),
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
              _buildButton('Del'),
              _buildButton('OK'),
            ],
          ),
        ],
      ),
    );
  }
  Widget _buildButton(String text) {
    return TextButton(
      onPressed: () {
        _onButtonPressed(text);
      },
      child: Text(
        text,
        style: const TextStyle(fontSize: 17.0),
      ),
    );
  }
}