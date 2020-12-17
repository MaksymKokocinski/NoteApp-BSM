import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crypt/crypt.dart';

class NewPassword extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _NewPasswordState();
}

// Used for controlling whether the user is loggin or creating an account
enum FormType { register }

class _NewPasswordState extends State<NewPassword> {
  final TextEditingController _passwordFilter = TextEditingController();

  String _password = "";
  // our default setting is to login, and we should switch to creating an account when the user chooses to

  _NewPasswordState() {
    _passwordFilter.addListener(_passwordListen);
  }
  void _passwordListen() {
    if (_passwordFilter.text.isEmpty) {
      _password = "";
    } else {
      _password = _passwordFilter.text;
    }
  }

  // Swap in between our two forms, registering and logging in

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Change password"),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Container(
              child: TextField(
                controller: _passwordFilter,
                decoration: InputDecoration(labelText: 'New Password'),
                obscureText: true,
              ),
            ),
            Container(
              child: Column(
                children: <Widget>[
                  RaisedButton(
                    child: Text('Change password'),
                    onPressed: _createAccountPressed,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // These functions can self contain any user auth logic required, they all have access to  _password

  void _createAccountPressed() {
    _hashing();
    _setPasswordFromSharedPref();
    Navigator.pop(context);
    print('The user wants to change password with $_password');
  }

  Future<bool> _setPasswordFromSharedPref() async {
    final prefs = await SharedPreferences.getInstance();
    final passStored = prefs.setString('passwordStored', _password);
    //await prefs.setString('startupNumber', _password);
    print('password stored : $passStored and $_password');
    return prefs.commit();
  }

  void _hashing() async {
    final hashed =
        Crypt.sha256(_password, rounds: 10000, salt: 'abcdefghijklmop');
    String hashed2 = hashed.toString();
    _password = hashed2;
  }
}
