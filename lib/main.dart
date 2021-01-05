import 'package:flutter/material.dart';
import 'package:noteapp/screens/biometricscreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: BiometricPage());
  }
}
