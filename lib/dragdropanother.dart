import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:ttachienew/utils/database_helper.dart';


class ReorderableListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reorderable List Demo',
      home: MyHomePages(),
    );
  }
}

class MyHomePages extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePages> {
  List<String> _items = [
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 4',
    'Item 5',
  ];

  late Database _database;

  @override
  void initState() {
    super.initState();
    _openDatabase();
  }

  Future<void> _openDatabase() async {
    final path = join(await getDatabasesPath(), 'my_database.db');
    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        db.execute(
          'CREATE TABLE IF NOT EXISTS items (id INTEGER PRIMARY KEY AUTOINCREMENT, position INTEGER, value TEXT)',
        );
      },
    );
    _loadItems();
  }

  Future<void> _loadItems() async {
    final items = await _database.query('items', orderBy: 'position ASC');
    setState(() {
      _items = items.map((item) => item['value'] as String).toList();
    });
  }

  Future<void> _savePosition(int oldIndex, int newIndex) async {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    // print(2);
    await _database.transaction((txn) async {
      final batch = txn.batch();
      var db = await this._database;
      for (var i = 0; i < _items.length; i++) {
        print(_items);
        db!.update(
          'items',
          {'position': i},
          where: 'id = ?',
          whereArgs: [i + 1],
        );
      }
      await batch.commit(noResult: false);
      setState(() {});
      // _loadItems();
    });
  }

  Future<void> _addItem() async {
    final newItem = 'New Item ${_items.length + 1}';
    await _database.insert('items', {
      'position': _items.length+1,
      'value': newItem,
    });
    setState(() {
      _items.add(newItem);
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Reorderable List Demo'),
      ),
      body: ReorderableListView(
        onReorder: (oldIndex, newIndex) async {
          setState(() {
            final item = _items.removeAt(oldIndex);
            _items.insert(newIndex, item);
          });
          await _savePosition(oldIndex, newIndex);
          // for (int i = 0; i < _items.length; i++) {
          //   print(_items['positsion']);
          //   // await DatabaseHelper.instance.update(items[i]);
          // }



        },
        children: [
          for (final item in _items)
            ListTile(
              key: ValueKey(item),
              title: Text(item),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addItem,
        child: Icon(Icons.add),
      ),
    );
  }
}