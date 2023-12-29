import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:path_provider/path_provider.dart';
import '../Models/service_data.dart';
import '../Screen/decrypted_data_screen.dart';

class EncryptionUtils {
  static Future<void> writeFileContent(String content) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/data.calc');
    await file.writeAsString(content);
  }
  static String encryptData(String data, String password) {
    final iv = encrypt.IV.fromUtf8("ANTANI12");
    final key = encrypt.Key.fromUtf8(generateMd5(password));
    final encrypter = encrypt.Encrypter(encrypt.Salsa20(key));
    final encryptedData = encrypter.encrypt(data, iv: iv);
    return encryptedData.base64;
  }
  static Future<void> updateEncryptedFile(String jsonString,String key) async {
    final encryptedContent = encryptData('[Decrypted]\n$jsonString[Decrypted]',key);
    await writeFileContent(encryptedContent);
  }
  static String generateMd5(String input) {
    const salt = '@#[6-6-6]#@';
    return md5.convert(utf8.encode(salt+input)).toString();
  }
  static String generateRandomPassword() {
    final random = Random.secure();
    const String uppercaseLetters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const String lowercaseLetters = 'abcdefghijklmnopqrstuvwxyz';
    const String symbols = '!@#\$%^&*()-_=+[]{}|;:,.<>?';
    const String numbers = '0123456789';
    final oneUppercase = uppercaseLetters[random.nextInt(uppercaseLetters.length)];
    final oneLowercase = lowercaseLetters[random.nextInt(lowercaseLetters.length)];
    final oneSymbol = symbols[random.nextInt(symbols.length)];
    final oneNumber = numbers[random.nextInt(numbers.length)];
    const String allChars = uppercaseLetters + lowercaseLetters + symbols + numbers;
    const int remainingChars = 12;
    final randomChars = List.generate(remainingChars, (index) => allChars[random.nextInt(allChars.length)]);
    final passwordChars = [oneUppercase, oneLowercase, oneSymbol, oneNumber, ...randomChars];
    passwordChars.shuffle();
    final password = passwordChars.join();
    return password;
  }
  static Future<void> generateEncryptedFile(String password) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/data.calc');
    final fileExists = await file.exists();
    if (!fileExists) {
      const dataToEncrypt = '[Decrypted]\n[Decrypted]';
      final encryptedContent = encryptData(dataToEncrypt, password);
      await file.writeAsString(encryptedContent);
    }
  }
  static Future<String> readFileContent() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/data.calc');
    if (await file.exists()) {
      return await file.readAsString();
    }
    return '';
  }
  static Future<void> decryptFile(String expression ,BuildContext context) async {
    final encryptedContent = await readFileContent();
    final password = generateMd5(expression);
    final iv = encrypt.IV.fromUtf8("ANTANI12");
    final key = encrypt.Key.fromUtf8(password);
    final encrypter = encrypt.Encrypter(encrypt.Salsa20(key));
    String decryptedData = encrypter.decrypt64(encryptedContent, iv: iv);
    final hasStartTag = decryptedData.startsWith('[Decrypted]\n');
    final hasEndTag = decryptedData.endsWith('[Decrypted]');
    List<ServiceData> serviceDataList = [];
    if (hasStartTag && hasEndTag) {
      decryptedData = decryptedData.replaceAll('[Decrypted]\n', '').replaceAll('[Decrypted]', '');

      if (decryptedData != ''){
        final List<dynamic> decodedData = jsonDecode(decryptedData);
        serviceDataList = decodedData
            .map((json) => ServiceData.fromJson(json))
            .toList();
      }
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => DecryptedDataScreen(decryptedData: serviceDataList, expression: expression),
        ),
      );
    }
  }
  static Future<bool> doesFileExist() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/data.calc');
    if (await file.exists()) {
      return true;
    }
    return false;
  }
}