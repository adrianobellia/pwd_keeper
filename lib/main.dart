import 'package:flutter/material.dart';
import 'Utils/encryption.dart';
import 'Screen/calculator_screen.dart';
import 'Screen/setup_password_screen.dart';
void main() {
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Calculator',
      home: MyHomePage(),
    );
  }
}
class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: EncryptionUtils.doesFileExist(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else {
          if (snapshot.data == true) {
            return const CalculatorScreen();
          } else {
            return const SetupPasswordScreen();
          }
        }
      },
    );
  }
}