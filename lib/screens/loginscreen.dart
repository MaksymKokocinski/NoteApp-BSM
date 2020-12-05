import 'package:flutter/material.dart';
import 'package:noteapp/screens/homescreen.dart';

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

  // These functions can self contain any user auth logic required, they all have access to  _password

  void _loginPressed() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => HomeScreen()));
    print('The user wants to login with $_password');
  }

  void _createAccountPressed() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => HomeScreen()));
    print('The user wants to create an accoutn with $_password');
  }
}
// to use when ready
//Navigator.of(context).pushAndRemoveUntil(
//        MaterialPageRoute(builder: (context) => HomeScreen()),
//        (Route<dynamic> route) => false);
