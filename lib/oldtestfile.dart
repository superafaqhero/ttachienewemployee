import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class ReorderableListPage extends StatefulWidget {
  @override
  _ReorderableListPageState createState() => _ReorderableListPageState();
}

class _ReorderableListPageState extends State<ReorderableListPage> {
  List<Map<String, dynamic>> items = [];

  @override
  void initState() {
    super.initState();
    getItems();
  }

  getItems() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = '${directory.path}notes.db';


    Database db = await openDatabase(path);
    items = await db.query('note_table', orderBy: 'id ASC');
    setState(() {});
  }

  updateItemPosition(int oldIndex, int newIndex) async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'notes.db';
    Database db = await openDatabase(path);
    if (newIndex > oldIndex) {
      for (int i = oldIndex; i < newIndex; i++) {
        await db.rawUpdate(
            'UPDATE note_table SET position = position - 1 WHERE position = ?',
            [i + 1]);
      }
    } else {
      for (int i = oldIndex; i > newIndex; i--) {
        await db.rawUpdate(
            'UPDATE note_table SET position = position + 1 WHERE position = ?',
            [i - 1]);
      }
    }
    await db.rawUpdate('UPDATE note_table SET position = ? WHERE position = ?',
        [newIndex, oldIndex]);
    getItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reorderable List'),
      ),
      body: ReorderableListView(
        children: items
            .map((item) => ListTile(
          key: ValueKey(item['position']),
          title: Text(item['title'], style: TextStyle(fontSize: 30,fontWeight: FontWeight.w500,color: Colors.white),),
        ))
            .toList(),
        onReorder: (oldIndex, newIndex) {


          Future.delayed(Duration(milliseconds: 200), (){
            setState(() {
              Map<String, dynamic> item = items.removeAt(oldIndex);
              items.insert(newIndex, item);
              updateItemPosition(oldIndex, newIndex);
            });
          });




        },
      ),
    );
  }
}