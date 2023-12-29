import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../Utils/encryption.dart';
import 'dart:convert';
import '../Models/service_data.dart';
import '../Screen/calculator_screen.dart';

class DecryptedDataScreen extends StatefulWidget {
  final List<ServiceData> decryptedData;
  final String expression;

  const DecryptedDataScreen({
    Key? key,
    required this.decryptedData,
    required this.expression,
  }) : super(key: key);

  @override
  _DecryptedDataScreenState createState() => _DecryptedDataScreenState();
}
class _DecryptedDataScreenState extends State<DecryptedDataScreen> with WidgetsBindingObserver {
  final _serviceNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  String _generatedPassword = '';
  bool newServiceVisiblePwd  = true;
  List<bool> isPasswordVisibleList = [];
  @override
  void initState() {
    super.initState();
    isPasswordVisibleList = List.generate(widget.decryptedData.length, (index) => false);
    WidgetsBinding.instance.addObserver(this);
  }
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.inactive) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const CalculatorScreen(),
        ),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Decrypted Data'),
          actions: [
            IconButton(
              icon: const Icon(Icons.calculate),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CalculatorScreen(),
                  ),
                );
              },
            ),
          ],
        ),
        body: ListView.builder(
          itemCount: widget.decryptedData.length,
          itemBuilder: (context, index) {
            final serviceData = widget.decryptedData[index];
            return Dismissible(
              key: Key(serviceData.serviceName),
              confirmDismiss: (DismissDirection direction) async {
                return await _showDeleteConfirmationDialog();
              },
              onDismissed: (direction) {
                _removeService(index);
              },
              background: Container(
                color: Colors.red,
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: const Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
              ),
              child: ListTile(
                title: Text("${serviceData.serviceName} - ${serviceData.username}"),
                subtitle: Row(
                  children: [
                    Expanded(
                      child: Text(
                        isPasswordVisibleList[index] ? serviceData.password : '********',
                      ),
                    ),
                    IconButton(
                      icon: Icon(isPasswordVisibleList[index] ? Icons.visibility : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          isPasswordVisibleList[index] = !isPasswordVisibleList[index];
                        });
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.copy),
                      onPressed: () {
                        _copyToClipboard(serviceData.password);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        _showServiceDialog(context, serviceData, index);
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            newServiceVisiblePwd = false;
            _showServiceDialog(context, null, -1);
          },
          child: const Icon(Icons.add),
        ),
      );
  }
  void _copyToClipboard(String password) {
    Clipboard.setData(ClipboardData(text: password));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Password copied to clipboard'),
      ),
    );
  }
  void _update() {
    setState(() {});
  }
  Future<void> _showServiceDialog(BuildContext context, ServiceData? s, int i) async {

    String serviceName = _serviceNameController.text = (s != null) ? s.serviceName : '';
    String username = _usernameController.text = (s != null) ? s.username : '';
    String password = _passwordController.text = (s != null) ? s.password : '';

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text((i > -1) ? 'Edit Service' : 'Add New Service'),
              content: Column(
                children: [
                  TextField(
                    controller: _serviceNameController,
                    onChanged: (value) {
                      serviceName = value;
                    },
                    decoration: const InputDecoration(labelText: 'Service Name'),
                  ),
                  TextField(
                    controller: _usernameController,
                    onChanged: (value) {
                      username = value;
                    },
                    decoration: const InputDecoration(labelText: 'Username'),
                  ),
                  TextField(
                    controller: _passwordController,
                    onChanged: (value) {
                      password = value;
                    },
                    obscureText: (i > -1) ? !isPasswordVisibleList[i] : !newServiceVisiblePwd,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      suffixIcon: IconButton(
                        icon: Icon((i > -1) ? isPasswordVisibleList[i] ? Icons.visibility : Icons.visibility_off : newServiceVisiblePwd ? Icons.visibility : Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            if (i>-1){
                              isPasswordVisibleList[i] = !isPasswordVisibleList[i];
                              _update();
                            }
                            else{
                              newServiceVisiblePwd = !newServiceVisiblePwd;
                            }
                          });
                        },
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _generatedPassword = EncryptionUtils.generateRandomPassword();
                        password = _passwordController.text = _generatedPassword;
                      });
                    },
                    child: const Text('Generate Password'),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      if (i > -1) {
                        widget.decryptedData[i] = ServiceData(
                          serviceName: serviceName,
                          username: username,
                          password: password,
                        );
                      } else {
                        widget.decryptedData.add(ServiceData(
                          serviceName: serviceName,
                          username: username,
                          password: password,
                        ));
                        isPasswordVisibleList.add(false);
                      }
                    });
                    _saveData();
                    _update();
                    Navigator.of(context).pop();
                  },
                  child: Text((i > -1) ? 'Confirm' : 'Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }
  Future<bool?> _showDeleteConfirmationDialog() async {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Confirmation'),
          content: const Text('Are you sure you want to delete this data? This action cannot be undone.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
  void _saveData() {
    EncryptionUtils.updateEncryptedFile(
      jsonEncode(widget.decryptedData.map((serviceData) => serviceData.toJson()).toList()),
      widget.expression,
    );
  }
  void _removeService(int index) {
    setState(() {
      widget.decryptedData.removeAt(index);
      isPasswordVisibleList.removeAt(index);
    });
    _saveData();
  }
}