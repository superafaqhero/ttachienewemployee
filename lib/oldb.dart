import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class ReorderableListPage extends StatefulWidget {
  @override
  _ReorderableListPageState createState() => _ReorderableListPageState();
}

class _ReorderableListPageState extends State<ReorderableListPage> {
  List<String> items = ['Item 1', 'Item 2', 'Item 3', 'Item 4', 'Item 5', 'Item 6'];
  final GlobalKey<_ReorderableListPageState> _reorderableKey = GlobalKey<_ReorderableListPageState>();


  @override
  void initState() {
    super.initState();
    loadItems();
  }
  void saveItems() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('itemOrder', items);
  }
  Future<void> loadItems() async {
    final prefs = await SharedPreferences.getInstance();
    final savedItems = prefs.getStringList('itemOrder');
    if (savedItems != null) {
      setState(() {
        items = savedItems;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Reorderable List'),
        ),
        body:ReorderableListView(
          key: _reorderableKey,
          onReorder: (int oldIndex, int newIndex) {
            setState(() {
              if (newIndex > oldIndex) {
                newIndex -= 1;
              }
              final item = items.removeAt(oldIndex);
              items.insert(newIndex, item);
              saveItems();
            });
          },
          children: items
              .map((item) => ListTile(
            key: Key(item),
            title: Text(item),
          ))
              .toList(),
        )

    );
  }
}