import 'package:flutter/material.dart';
import 'package:noteapp/models/notesoperation.dart';
import 'package:provider/provider.dart';

class AddScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String descriptionText;

    return Scaffold(
      backgroundColor: Colors.lightBlue,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Enter Description',
                    hintStyle: TextStyle(fontSize: 18, color: Colors.white)),
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
                //adding value which will be displayed in homescreen
                onChanged: (value) {
                  descriptionText = value;
                },
              ),
            ),
            FlatButton(
                onPressed: () {
                  //adding button which will send data
                  Provider.of<NotesOperation>(context, listen: false)
                      .addNewNote(descriptionText);
                  //sends value to homescreen
                  Navigator.pop(context);
                },
                color: Colors.white,
                child: Text('Add Note',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.lightBlue)))
          ],
        ),
      ),
    );
  }
}
