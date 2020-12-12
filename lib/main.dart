import 'package:flutter/material.dart';
import 'package:noteapp/screens/loginscreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //changenotifierprovider need to be done to notify if changes are made in values
    return MaterialApp(home: LoginPage());
  }
}
