import 'package:flutter/material.dart';
import 'package:noteapp/screens/homescreen.dart';
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

  ///
  ///Start appki
  ///
  @override
  void initState() {
    _resetPassword();
    //_getThingsOnStartup().then((value){
    super.initState();
    print('Async done');
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
  Future<void> _resetPassword() async {
    final prefs = await SharedPreferences.getInstance();
    final passStored = prefs.setString('passwordStored', null);
    print('password reseted $passStored');
  }

  Future<bool> _setPasswordFromSharedPref() async {
    final prefs = await SharedPreferences.getInstance();
    final passStored = prefs.setString('passwordStored', _password);
    //await prefs.setString('startupNumber', _password);
    print('password stored : $passStored and $_password');
    return prefs.commit();
  }

  Future<String> _getPasswordFromSharedPref() async {
    final prefs = await SharedPreferences.getInstance();
    final passStored = prefs.getString('passwordStored');
    //await prefs.setString('startupNumber', _password);
    print('password recived : $passStored and $_password');
    return passStored;
  }

  Future<bool> _checkPasswordFromSharedPref() async {
    final prefs = await SharedPreferences.getInstance();
    final passStored = prefs.getString('passwordStored');
    //await prefs.setString('startupNumber', _password);
    print('password recived : $passStored and $_password');
    if (passStored == _password) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> _isPasswordStored() async {
    final prefs = await SharedPreferences.getInstance();
    final passStored = prefs.getString('passwordStored');
    if (passStored == null) {
      print('true');
      return true;
    } else {
      print('false');
      return false;
    }
  }

  ///
  ///Loging and registering
  ///
  ///
  void _createAccountPressed() async {
    if (await (_isPasswordStored()) == false) {
      print('You cant register you already have an account');
    } else {
      _hashing();
      _setPasswordFromSharedPref();
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomeScreen()));
      print('The user wants to create an account with $_password');
    }
  }

  void _loginPressed() async {
    if (await (_isPasswordStored()) == true) {
      print('Error you cant login without creating an account');
    } else {
      _hashing();
      if (await (_checkPasswordFromSharedPref()) == false) {
        print('Error passwords dont match ');
      } else {
        print('passwords match');
        //_getPasswordFromSharedPref();
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomeScreen()));
        print('The user wants to login with $_password');
      }
    }
  }

  ///
  ///Hashing used to hash passwords
  ///
  void _hashing() async {
    final hashed =
        Crypt.sha256(_password, rounds: 10000, salt: 'abcdefghijklmop');
    String hashed2 = hashed.toString();
    _password = hashed2;
  }
}
// to use when ready
//Navigator.of(context).pushAndRemoveUntil(
//        MaterialPageRoute(builder: (context) => HomeScreen()),
//        (Route<dynamic> route) => false);
