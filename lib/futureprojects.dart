import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:ttachienew/utils/database_helper.dart';
import 'NavBar.dart';
import 'bottem_bar.dart';
import 'futuredetails.dart';
import 'home_screen.dart';
import 'models/future.dart';
import 'note_detail.dart';



class FutureProjects extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {

    return NoteListState();
  }
}

class NoteListState extends State<FutureProjects> {
  Future<bool> onbackpress() async{
    Navigator.pop(context, true);
    return true;
  }
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Fut>? noteList;
  int count = 0;

  @override
  Widget build(BuildContext context) {

    if (noteList == null) {
      noteList = <Fut>[];
      updateListView();
    }

    return WillPopScope(
      onWillPop: onbackpress,
      child: Scaffold(
        drawer: NavBar(),
        appBar: AppBar(
          iconTheme: IconThemeData(color:  Color.fromARGB(255,255, 255, 0),),

          backgroundColor:  Colors.black45,
          centerTitle: true,

          title: Text('Future Projects'),
        ),

        body: getNoteListView(),

        floatingActionButton: FloatingActionButton(
          backgroundColor: Color.fromARGB(255,55, 69, 80),
          onPressed: () {
            debugPrint('FAB clicked');
            navigateToDetail(Fut('', '', 0,'','','','',2), 'Add Client');
          },

          tooltip: 'Add Note',

          child: Icon(Icons.add),

        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

      ),
    );
  }

  ListView getNoteListView() {

    TextStyle? titleStyle = Theme.of(context).textTheme.subtitle1;

    return ListView.builder(

      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: Color.fromARGB(255, 102, 116, 128),
          elevation: 2.0,
          child: ListTile(

            leading: CircleAvatar(
              backgroundColor: getPriorityColor(this.noteList![position].priority!),
              child: getPriorityIcon(this.noteList![position].priority!),
            ),

            title: Text(this.noteList![position].title!, style: titleStyle,),

            subtitle: Text(this.noteList![position].date!),

            trailing: GestureDetector(
              child: Icon(Icons.delete, color: Colors.grey,),
              onTap: () {
                _delete(context, noteList![position]);
              },
            ),


            onTap: () {
              debugPrint("ListTile Tapped");
              navigateToDetail(this.noteList![position],'Edit Client');
            },

          ),
        );
      },
    );
  }

  // Returns the priority color
  Color getPriorityColor(int priority) {
    switch (priority) {
      case 1:
        return Colors.red;
        break;
      case 2:
        return Colors.yellow;
        break;

      default:
        return Colors.yellow;
    }
  }

  // Returns the priority icon
  Icon getPriorityIcon(int priority) {
    switch (priority) {
      case 1:
        return Icon(Icons.play_arrow);
        break;
      case 2:
        return Icon(Icons.keyboard_arrow_right);
        break;

      default:
        return Icon(Icons.keyboard_arrow_right);
    }
  }

  void _delete(BuildContext context, Fut note) async {

    int result = await databaseHelper.deleteNote(note.id!);
    if (result != 0) {
      _showSnackBar(context, 'Future Deleted Successfully');
      updateListView();
    }
  }

  void _showSnackBar(BuildContext context, String message) {

    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void navigateToDetail(Fut note, String title) async {
    bool result = await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return Futuredetails(note, title);
    }));

    if (result == true) {
      updateListView();
    }
  }

  void updateListView() {

    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {

      Future<List<Fut>> noteListFuture = databaseHelper.getnextList() as Future<List<Fut>>;
      noteListFuture.then((noteList) {
        setState(() {
          this.noteList = noteList.cast<Fut>();
          this.count = noteList.length;
        });
      });
    });
  }
}
