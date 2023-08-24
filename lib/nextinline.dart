import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:ttachienew/nextdetails.dart';
import 'package:ttachienew/utils/database_helper.dart';

import 'bottem_bar.dart';
import 'home_screen.dart';
import 'models/future.dart';

import 'note_detail.dart';
import 'NavBar.dart';


class Nextin extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {

    return NoteListState();
  }
}

class NoteListState extends State<Nextin> {
  Future<bool> onbackpress() async{
    Navigator.pop(context, true);
    return true;
  }
  DatabaseHelper databaseHelper = DatabaseHelper();

  int count = 0;


  List<Fut> noteList = [];
  Future<List<Fut>>? _future;

  void _onReorder(int oldIndex, int newIndex) async {
    if (newIndex > noteList!.length) newIndex = noteList!.length;
    if (oldIndex < newIndex) newIndex -= 1;

    setState(() {
      final Fut item = noteList![oldIndex];
      noteList!.removeAt(oldIndex);

      print(item.title);
      noteList!.insert(newIndex, item);



    });

    DatabaseHelper().updatenextlist(noteList);


  }




  @override
  void initState() {
    super.initState();


    if (_future == null) {
      _future = databaseHelper.getnextList();

    }







  }

  @override
  Widget build(BuildContext context) {
    //
    // if (noteList == null) {
    //   noteList = <Fut>[];
    //   updateListView();
    // }

    return WillPopScope(
      onWillPop: onbackpress,
      child: Scaffold(
        drawer: NavBar(),
        appBar: AppBar(
          iconTheme: IconThemeData(color:  Color.fromARGB(255,255, 255, 0),),

          backgroundColor:  Colors.black45,
          centerTitle: true,

          title: Text('Next Projects'),
        ),

        body:WillPopScope(
    onWillPop: () async {
    Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => HomeScreen()),
    );
    return false;
    },


    child:
        Column(
          children: [
            Expanded(
            flex: 1,
            child:FutureBuilder(
            future: _future,
            builder: (BuildContext context, AsyncSnapshot
            snapshot) {
              if (snapshot.data == null) {
                return Text('Loading');
              } else {
                if (snapshot.data.length < 1) {
                  return Center(
                    child: Text('No Messages, Create New   one'),
                  );
                }

                noteList = snapshot.data;
                return ReorderableListView(
                  children: List.generate(
                    snapshot.data.length,
                        (index) {
                      return  Card(
                        color: Color.fromARGB(255, 102, 116, 128),
                        elevation: 2.0,
                        key: ValueKey(noteList[index]),
                        child:

                        ListTile(
                          key: Key('$index'),
                          leading: CircleAvatar(
                            backgroundColor: getPriorityColor(this.noteList![index].priority!),
                            child: getPriorityIcon(this.noteList![index].priority!),
                          ),

                          title: Text(this.noteList![index].title!, style: TextStyle(fontSize: 30,fontWeight: FontWeight.w500,color: Colors.white),),

                          subtitle: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Sold: "+getFormatedDate(this.noteList![index].date!)+"",style: TextStyle(color: Color.fromARGB(250, 250, 250,  0) , fontSize: 14, fontWeight: FontWeight.bold ),),
                              Text(double.parse(this.noteList![index].totalprice!).toStringAsFixed(2),style: TextStyle(color: Color.fromARGB(250, 250, 250,  0), fontSize: 14, fontWeight: FontWeight.bold ),),
                            ],
                          ),

                          trailing: GestureDetector(
                            child: Icon(Icons.delete, color: Colors.red,),
                            onTap: () {
                              _delete(context, noteList![index]);
                            },
                          ),

                          onTap: () {
                            navigateToDetail(this.noteList![index],'Edit Client');
                          },
                        ),);
                    },
                  ).toList(),
                  onReorder: _onReorder,
                );
              }
            }),

        ),
            BottomBar()

        ],
        ) ),

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
  getFormatedDate(_date) {
    var inputFormat = DateFormat('yyyy-MM-dd HH:mm');
    var inputDate = inputFormat.parse(_date);
    var outputFormat = DateFormat('MM-dd-yyyy');
    return outputFormat.format(inputDate);
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

    int result = await databaseHelper.deleteNext(note.id!);
    if (result != 0) {
      _showSnackBar(context, 'Note Deleted Successfully');
      updateListView();
    }
  }

  void _showSnackBar(BuildContext context, String message) {

    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void navigateToDetail(Fut note, String title) async {
    bool result = await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return Nextdetails(note, title);
    }));

    if (result == true) {
      updateListView();
    }
  }

  void updateListView() {

    // final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    // dbFuture.then((database) {
    //
    //   Future<List<Fut>> noteListFuture = databaseHelper.getnextList();
    //   noteListFuture.then((noteList) {
        setState(() {
          _future = databaseHelper.getnextList();
          // this.noteList = noteList;
          this.count = noteList.length;
        });
    //   });
    // });
  }
}
