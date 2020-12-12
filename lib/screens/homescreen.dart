import 'package:flutter/material.dart';
import 'package:noteapp/models/note.dart';
import 'package:noteapp/providers/Databasehelper.dart';
import 'package:noteapp/screens/changelogin.dart';
import 'package:noteapp/models/note.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key, this.note}) : super(key: key);
  final String note;
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //zmienne
  TextEditingController textController = new TextEditingController();
  List<Note> notesList = new List();

  @override
  void initState() {
    super.initState();

    DatabaseHelper.instance.queryAllRows().then((value) {
      setState(() {
        value.forEach((element) {
          notesList.add(Note(id: element['id'], note: element["note"]));
        });
      });
    }).catchError((error) {
      print(error);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //logging out
          print('Logged out');
        },
        child: Icon(
          Icons.logout,
          size: 30,
          color: Colors.white,
        ),
      ),
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: Icon(
              Icons.settings,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => NewPassword()));
            },
          )
        ],
      ),
      body: Container(
        margin: EdgeInsets.all(15),
        padding: EdgeInsets.all(15),
        height: 200.0,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(15)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: TextFormField(
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Enter Note',
                    hintStyle: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                    )),
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                ),
                controller: textController,
                //adding value which will be displayed in homescreen
                // onChanged: (value) {
                //  note = value;
                // },
              ),
            ),
            FlatButton(
                onPressed: (_addToDb),
                color: Colors.white,
                child: Text('Save Note',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.lightBlue))),
            SizedBox(
              height: 20.0,
            ),
            Expanded(
                child: Container(
              child: notesList.isEmpty
                  ? Container()
                  : ListView.builder(
                      itemBuilder: (context, index) {
                        if (index == notesList.length) return null;
                        return ListTile(
                            title: Text(notesList[index].note),
                            leading: Text(notesList[index].id.toString()),
                            trailing: IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () => _deleteTask(notesList[index].id),
                            ));
                      },
                    ),
            ))
          ],
        ),
      ),
    );
  }

  void _deleteTask(int id) async {
    await DatabaseHelper.instance.delete(id);
    setState(() {
      notesList.removeWhere((element) => element.id == id);
    });
  }

  void _addToDb() async {
    String note = textController.text;
    var id = await DatabaseHelper.instance.insert(Note(note: note));
    setState(() {
      notesList.insert(0, Note(id: id, note: note));
    });
  }
}
