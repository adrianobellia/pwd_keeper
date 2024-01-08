import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'dart:io';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:path_provider/path_provider.dart';
import '../Models/service_data.dart';

class EncryptionUtils {
  static const _ivString = 'IVIVIVIVIVIVIVIV'; // <-- Customize the Initialization Vector string with an 16-character string
  static const _filename = 'data.calc'; // <-- Customize the dataSave filename
  static const _salt = 'SALT'; // <-- Customize the salt
  static const _startTag = '[Decrypted]\n';
  static const _endTag = '\n[Decrypted]';

  static Future<bool> doesFileExist() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/${_filename}');
    return await file.exists();
  }
  static Future<String> readFileContent() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/${_filename}');
    return await file.readAsString();
  }
  static Future<void> writeFileContent(String content) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/${_filename}');
    await file.writeAsString(content);
  }
  static String generateSha256(String input) {
    return sha256.convert(utf8.encode(_salt + input)).toString();
  }
  static String encryptData(String data, String password) {
    final key = encrypt.Key.fromBase16(generateSha256(password));
    final iv = encrypt.IV.fromUtf8(_ivString);
    final encrypter = encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));
    final encryptedData = encrypter.encrypt(data, iv: iv);
    return encryptedData.base64;
  }
  static Future<void> updateEncryptedFile(String jsonString, String key) async {
    final encryptedContent = encryptData(_startTag + jsonString + _endTag, key);
    await writeFileContent(encryptedContent);
  }
  static Future<void> generateEncryptedFile(String password) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/${_filename}');
    final fileExists = await file.exists();
    if (!fileExists) {
      const dataToEncrypt = _startTag + _endTag;
      final encryptedContent = encryptData(dataToEncrypt, password);
      await file.writeAsString(encryptedContent);
    }
  }
  static Future<List<ServiceData>?> decryptFile(String expression) async {
    final encryptedContent = await readFileContent();
    final key = encrypt.Key.fromBase16(generateSha256(expression));
    final iv = encrypt.IV.fromUtf8(_ivString);
    final encrypter = encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));
    String decryptedData = encrypter.decrypt64(encryptedContent, iv: iv);
    final hasStartTag = decryptedData.startsWith(_startTag);
    final hasEndTag = decryptedData.endsWith(_endTag);
    List<ServiceData> serviceDataList = [];
    if (hasStartTag && hasEndTag) {
      decryptedData = decryptedData.replaceAll(_startTag, '').replaceAll(_endTag, '');
      if (decryptedData != '') {
        final List<dynamic> decodedData = jsonDecode(decryptedData);
        serviceDataList = decodedData.map((json) => ServiceData.fromJson(json)).toList();
      }
      return serviceDataList;
    }
    else {
      return null;
    }
  }
  static String generateRandomPassword() {
    const uppercaseLetters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const lowercaseLetters = 'abcdefghijklmnopqrstuvwxyz';
    const symbols = '!@#\$%^&*()-_=+[]{}|;:,.<>?';
    const numbers = '0123456789';
    final random = Random.secure();
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
}