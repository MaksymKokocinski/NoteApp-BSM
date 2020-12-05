import 'package:flutter/material.dart';
import 'package:noteapp/models/notesoperation.dart';
import 'package:noteapp/screens/homescreen.dart';
import 'package:noteapp/screens/loginscreen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //changenotifierprovider need to be done to notify if changes are made in values
    return ChangeNotifierProvider<NotesOperation>(
        create: (context) =>
            NotesOperation(), //providing notesoperation to everyone
        child: MaterialApp(home: LoginPage()));
  }
}
