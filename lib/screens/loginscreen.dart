import 'package:flutter/material.dart';
import 'package:noteapp/screens/homescreen.dart';
import 'package:encrypt/encrypt.dart' as enc;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crypt/crypt.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

// Used for controlling whether the user is loggin or creating an account
enum FormType { login, register }

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _passwordFilter = TextEditingController();

  String _password = "";

  bool _started = false;

  FormType _form = FormType.login;
  // our default setting is to login, and we should switch to creating an account when the user chooses to

  _LoginPageState() {
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
  void _formChange() async {
    setState(() {
      if (_form == FormType.register) {
        _form = FormType.login;
      } else {
        _form = FormType.register;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Simple Login Example"),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Container(
              child: TextField(
                controller: _passwordFilter,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
            ),
            _buildButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildButtons() {
    if (_form == FormType.login) {
      return Container(
        child: Column(
          children: <Widget>[
            RaisedButton(
              child: Text('Login'),
              onPressed: _loginPressed,
            ),
            FlatButton(
              child: Text('Dont have an account? Tap here to register.'),
              onPressed: _formChange,
            ),
          ],
        ),
      );
    } else {
      return Container(
        child: Column(
          children: <Widget>[
            RaisedButton(
              child: Text('Create an Account'),
              onPressed: _createAccountPressed,
            ),
            FlatButton(
              child: Text('Have an account? Click here to login.'),
              onPressed: _formChange,
            )
          ],
        ),
      );
    }
  }
////
  ///
  ///
  ///
  // These functions can self contain any user auth logic required, they all have access to  _password

  Future<int> _getIntFromSharedPref() async {
    final prefs = await SharedPreferences.getInstance();
    final startupNumber = prefs.getInt('startupNumber');
    if (startupNumber == null) {
      return 0;
    }
    return startupNumber;
  }

  Future<String> _getStringFromSharedPref() async {
    final prefs = await SharedPreferences.getInstance();
    final passStored = prefs.getString(_password);
    //await prefs.setString('startupNumber', _password);
    print('password stored : $passStored and $_password');
    return passStored;
  }

  Future<void> _resetCounter() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('startupNumber', 0);
  }

  Future<void> _incrementStartup() async {
    final prefs = await SharedPreferences.getInstance();

    int lastStartupNumber = await _getIntFromSharedPref();
    int currentStartupNumber = ++lastStartupNumber;

    await prefs.setInt('startupNumber', currentStartupNumber);

    if (currentStartupNumber == 1) {
      _started = true;
      print('started 1 time');
    } else {
      print('$currentStartupNumber');
      await _resetCounter();
    }
  }

  Future<void> _notincrementStartup() async {
    final prefs = await SharedPreferences.getInstance();

    int lastStartupNumber = await _getIntFromSharedPref();
    int currentStartupNumber = lastStartupNumber;

    await prefs.setInt('startupNumber', currentStartupNumber);

    if (currentStartupNumber == 0) {
      _started = false;
      print('You need to register first');
      await _resetCounter();
      if (currentStartupNumber == 5) {
        await _resetCounter();
        print('counter reseted');
      }
    } else {
      int currentStartupNumber = ++lastStartupNumber;
      print('logged number $currentStartupNumber');
      _started = false;
      //await _resetCounter();
    }
  }

  void _loginPressed() {
    //_notincrementStartup();
    if (_started = false) {
      print('Error you cant login without creating an account');
    } else {
      _encryption();
      _getStringFromSharedPref();
      //static final d1 = Crypt.sha512('password');

      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomeScreen()));
      print('The user wants to login with $_password');
    }
  }

  void _createAccountPressed() {
    if (_started = true) {
      print('You cant register you already have an account');
    } else {
      _incrementStartup();
      _getStringFromSharedPref();
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomeScreen()));
      print('The user wants to create an accoutn with $_password');
    }
  }

  void _encryption() async {
    final key = enc.Key.fromLength(32);
    final iv = enc.IV.fromLength(16);
    final encrypter = enc.Encrypter(enc.AES(key));

    final encrypted = encrypter.encrypt(_password, iv: iv);
    final decrypted = encrypter.decrypt(encrypted, iv: iv);

    print(decrypted);
    //print(encrypted.bytes);
    print(encrypted.base64);
  }
}
// to use when ready
//Navigator.of(context).pushAndRemoveUntil(
//        MaterialPageRoute(builder: (context) => HomeScreen()),
//        (Route<dynamic> route) => false);
