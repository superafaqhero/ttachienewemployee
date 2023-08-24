import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:ttachienew/models/expense.dart';
import 'package:ttachienew/models/note.dart';
import 'package:ttachienew/models/future.dart';

import 'package:intl/intl.dart';
import 'package:ttachienew/utils/database_helper.dart';
class DatabaseHelper {

  static final DatabaseHelper _databaseHelper  = DatabaseHelper._createInstance();
      // Singleton DatabaseHelper
  static Database? _database;                // Singleton Database

  String noteTable = 'note_table';
  String expenseTable = 'expense_table';
  String futureTable = 'future_table';
  String nextprojectsTable = 'nextprojects_table';
  String colId = 'id';
  String colTitle = 'title';
  String colExpenseName = 'expensename';
  String colDescription = 'description';
  String colTotalprice = 'totalprice';
  String colDeposit = 'deposit';
  String colBalance = 'balance';
  String colCollectthisweek = 'collectthisweek';
  String colPriority = 'priority';
  String colDate = 'date';
  String colposition = 'position';
  String colemail = 'email';
  String colnumber = 'number';
  String coladdress = 'address';

  DatabaseHelper._createInstance(); // Named constructor to create instance of DatabaseHelper

  factory DatabaseHelper() {


    return _databaseHelper;
  }

  Future<Database?> get database async {

    if (_database != null) return _database;

    _database = await initializeDatabase();
    _database = await runOnceOnAppInstall();
    return _database;

  }

  Future<Database> initializeDatabase() async {
    // Get the directory path for both Android and iOS to store database.
    Directory directory = await getApplicationDocumentsDirectory();
    // String path = directory.path + 'notes.db';
    String path =  'notes.db';
    // Open/create the database at a given path
    var notesDatabase;
    if (await databaseExists(path)) {

    }else{
      notesDatabase  = await openDatabase(path, version: 1, onCreate: _createDb);
    }

    return notesDatabase;

  }
  Future<Database> runOnceOnAppInstall() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstRun = prefs.getBool('isFirstRun') ?? true;
    var notesDatabase;
    if (isFirstRun) {
      // Your code to run once on app install
      // ...
      Directory directory = await getApplicationDocumentsDirectory();
      // String path = directory.path + 'notes.db';
      String path =  'notes.db';

      // Delete the existing database file if it exists
      if (await databaseExists(path)) {
        await deleteDatabase(path);
      }

      // Open/create the database at a given path

      // Set the flag to false to indicate that the function has been run
      await prefs.setBool('isFirstRun', false);
    }
    Directory directory = await getApplicationDocumentsDirectory();
    // String path = directory.path + 'notes.db';
    String path =  'notes.db';
    notesDatabase = await openDatabase(path, version: 1, onCreate: _createDb);
    return notesDatabase;
  }
  void _createDb(Database db, int newVersion) async {

    await db.execute('CREATE TABLE $noteTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colTitle TEXT,$colDescription TEXT,$colemail TEXT,$colnumber TEXT,$coladdress TEXT, $colTotalprice TEXT, $colDeposit TEXT, $colBalance TEXT, $colCollectthisweek TEXT, $colPriority INTEGER,$colposition INTEGER NOT NULL DEFAULT(0), $colDate TEXT)');
    await db.execute('CREATE TABLE $expenseTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colTitle TEXT, $colExpenseName TEXT,$colTotalprice TEXT, $colPriority INTEGER,$colposition INTEGER NOT NULL DEFAULT(0), $colDate TEXT)');
    await db.execute('CREATE TABLE $futureTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colTitle TEXT,$colDescription TEXT,$colemail TEXT,$colnumber TEXT,$coladdress TEXT, $colTotalprice TEXT, $colDeposit TEXT, $colBalance TEXT, $colCollectthisweek TEXT, $colPriority INTEGER,$colposition INTEGER NOT NULL DEFAULT(0),  $colDate TEXT)');
    await db.execute('CREATE TABLE $nextprojectsTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colTitle TEXT,$colDescription TEXT,$colemail TEXT,$colnumber TEXT,$coladdress TEXT, $colTotalprice TEXT, $colDeposit TEXT, $colBalance TEXT, $colCollectthisweek TEXT, $colPriority INTEGER,$colposition INTEGER NOT NULL DEFAULT(0),  $colDate TEXT)');
  }

  // Fetch Operation: Get all note objects from database
  Future<List<Map<String, dynamic>>> getNoteMapList() async {
    Database? db = await this.database;

//		var result = await db.rawQuery('SELECT * FROM $noteTable order by $colPriority ASC');
    var result = await db!.query(noteTable, orderBy: '$colposition ASC');
    return result;
  }
  Future<List<Map<String, dynamic>>> getFutureMapList() async {
    Database? db = await this.database;

//		var result = await db.rawQuery('SELECT * FROM $noteTable order by $colPriority ASC');
    var result = await db!.query(futureTable, orderBy: '$colposition ASC');
    return result;
  }
  Future<List<Map<String, dynamic>>> getNextMapList() async {
    Database? db = await this.database;

//		var result = await db.rawQuery('SELECT * FROM $noteTable order by $colPriority ASC');
    var result = await db!.query(nextprojectsTable, orderBy: '$colposition ASC');
    return result;
  }

  Future<List<Map<String, dynamic>>> geteeeMapList() async {
    Database? db = await this.database;

//		var result = await db.rawQuery('SELECT * FROM $noteTable order by $colPriority ASC');
    var result = await db!.query(expenseTable);
    return result;
  }
//   Future<double> gettotal() async {
//     Database? db = await this.database;
//
// 		// var result = await db!.rawQuery('SELECT * FROM $noteTable order by $colPriority ASC');
// //     var result = await db!.query(noteTable, orderBy: '$colPriority ASC');
//     var result = await db!.rawQuery(
//         'select sum(totalprice) as Total from $noteTable');
//     var s = result.toString() as double;
//     return s;
//   }

  // sale projections
  Future gettotalsale() async {
    Database? dbClient = await this.database;
    var result = await dbClient!.rawQuery("SELECT SUM(totalprice) as Total FROM future_table");
    return result.toList();
  }

  updateItemPosition(int oldIndex, int newIndex) async {

    Database? db = await this.database;
    if (newIndex > oldIndex) {
      for (int i = oldIndex; i < newIndex; i++) {
        await db?.rawUpdate(
            'UPDATE note_table SET position = position - 1 WHERE position = ?',
            [i + 1]);
      }
      print([newIndex, oldIndex]);
    } else {
      for (int i = oldIndex; i > newIndex; i--) {
        await db?.rawUpdate(
            'UPDATE note_table SET position = position + 1 WHERE position = ?',
            [i - 1]);
        print([newIndex, oldIndex,'ok']);
      }
    }
    await db?.rawUpdate('UPDATE note_table SET position = ? WHERE position = ?',
        [newIndex, oldIndex]);
    print([newIndex, oldIndex,'last']);
  }

























  Future gettotalDepositsale() async {
    Database? dbClient = await this.database;
    var result = await dbClient!.rawQuery("SELECT SUM(deposit) as Total FROM future_table");
    return result.toList();
  }
  Future gettotalBalancesale() async {
    Database? dbClient = await this.database;
    var result = await dbClient!.rawQuery("SELECT SUM(balance) as Total FROM future_table");
    return result.toList();
  }


  // other









  Future gettotal() async {
    Database? dbClient = await this.database;
    var result = await dbClient!.rawQuery("SELECT SUM(totalprice) as Total FROM note_table");
    return result.toList();
  }
  Future gettotalNext() async {
    Database? dbClient = await this.database;
    var result = await dbClient!.rawQuery("SELECT SUM(totalprice) as Total FROM nextprojects_table");
    return result.toList();
  }
  Future gettotalDeposit() async {
    Database? dbClient = await this.database;
    var result = await dbClient!.rawQuery("SELECT SUM(deposit) as Total FROM note_table");
    return result.toList();
  }
  Future gettotalDepositNext() async {
    Database? dbClient = await this.database;
    var result = await dbClient!.rawQuery("SELECT SUM(deposit) as Total FROM nextprojects_table");
    return result.toList();
  }
  Future gettotalBalance() async {
    Database? dbClient = await this.database;
    var result = await dbClient!.rawQuery("SELECT SUM(balance) as Total FROM note_table");
    return result.toList();
  }
  Future gettotalBalanceNext() async {
    Database? dbClient = await this.database;
    var result = await dbClient!.rawQuery("SELECT SUM(balance) as Total FROM nextprojects_table");
    return result.toList();
  }
  Future gettotalCollect() async {
    Database? dbClient = await this.database;
    var result = await dbClient!.rawQuery("SELECT SUM(collectthisweek) as Total FROM note_table");
    return result.toList();
  }
  Future gettotalCollectNext() async {
    Database? dbClient = await this.database;
    var result = await dbClient!.rawQuery("SELECT SUM(collectthisweek) as Total FROM nextprojects_table");
    return result.toList();
  }




  // Insert Operation: Insert a Note object to database
  Future<int> insertNote(Note note) async {

    note.positiona = note.toMap().length+1;
    Database? db = await this.database;


    final count = Sqflite.firstIntValue(
        await db!.rawQuery('SELECT COUNT(*) FROM note_table'));
    note.positiona = count;
    var result = await db!.insert(noteTable, note.toMap());
    return result;
  }

  // Update Operation: Update a Note object and save it to database

  Future<int> updateNote(Note note) async {
    var db = await this.database;
    var result = await db!.update(noteTable, note.toMap(), where: '$colId = ?', whereArgs: [note.id]);
    return result;
  }
  Future<int?> updatePosi(int position,int id) async {
    var db = await this.database;
    var result =  await db?.rawUpdate('UPDATE note_table SET position = ? WHERE id = ?',
        [position, id]);
    return result;
  }
  // Delete Operation: Delete a Note object from database
  Future<int> deleteNote(int id) async {
    var db = await this.database;
    int result = await db!.rawDelete('DELETE FROM $noteTable WHERE $colId = $id');
    return result;
  }

  // Get number of Note objects in database
  Future<int?> getCount() async {
    Database? db = await this.database;
    List<Map<String, dynamic>> x = await db!.rawQuery('SELECT COUNT (*) from $noteTable');
    int? result = Sqflite.firstIntValue(x);
    return result;
  }



  // Insert Operation: Insert a future object to database
  Future<int> insertFuture(Fut note) async {
    Database? db = await this.database;
    var result = await db!.insert(futureTable, note.toMap());
    return result;
  }

  // Update Operation: Update a Note object and save it to database
  Future<int> updateFuture(Fut note) async {
    var db = await this.database;
    var result = await db!.update(futureTable, note.toMap(), where: '$colId = ?', whereArgs: [note.id]);
    return result;
  }

  // Delete Operation: Delete a Note object from database
  Future<int> deleteFuture(int id) async {
    var db = await this.database;
    int result = await db!.rawDelete('DELETE FROM $futureTable WHERE $colId = $id');
    return result;
  }

  // Insert Operation: Insert a future object to database
  Future<int> insertNext(Fut note) async {
    Database? db = await this.database;
    var result = await db!.insert(nextprojectsTable, note.toMap());
    return result;
  }

  // Update Operation: Update a Note object and save it to database
  Future<int> updateNext(Fut note) async {
    var db = await this.database;
    var result = await db!.update(nextprojectsTable, note.toMap(), where: '$colId = ?', whereArgs: [note.id]);
    return result;
  }

  // Delete Operation: Delete a Note object from database
  Future<int> deleteNext(int id) async {
    var db = await this.database;
    int result = await db!.rawDelete('DELETE FROM $nextprojectsTable WHERE $colId = $id');
    return result;
  }

  // Get number of Note objects in database
  Future<int?> getFutureCount() async {
    Database? db = await this.database;
    List<Map<String, dynamic>> x = await db!.rawQuery('SELECT COUNT (*) from $futureTable');
    int? result = Sqflite.firstIntValue(x);
    return result;
  }

  // Get the 'Map List' [ List<Map> ] and convert it to 'Note List' [ List<Note> ]
  Future<List<Note>> getNoteList() async {

    var noteMapList = await getNoteMapList(); // Get 'Map List' from database
    int count = noteMapList.length;         // Count the number of map entries in db table

    List<Note> noteList = <Note>[];
    // For loop to create a 'Note List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      noteList.add(Note.fromMapObject(noteMapList[i]));
    }

    return noteList;
  }

  Future<List<Fut>> getfutureList() async {

    var futureeMapList = await getFutureMapList(); // Get 'Map List' from database
    int count = futureeMapList.length;         // Count the number of map entries in db table

    List<Fut> noteList = <Fut>[];
    // For loop to create a 'Note List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      noteList.add(Fut.fromMapObject(futureeMapList[i]));
    }

    return noteList;
  }
  Future<List<Fut>> getnextList() async {

    var nextMapList = await getNextMapList(); // Get 'Map List' from database
    int count = nextMapList.length;         // Count the number of map entries in db table

    List<Fut> nextList = <Fut>[];
    // For loop to create a 'Note List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      nextList.add(Fut.fromMapObject(nextMapList[i]));
    }

    return nextList;
  }


  // get expense List
  Future<List<Expense>> getExpenseList(String expenseName) async {
    Database? db = await this.database;
//	var result = await db.rawQuery('SELECT * FROM $noteTable order by $colPriority ASC');
    var expenseMapList = (await db!.rawQuery('SELECT * FROM $expenseTable WHERE expensename=? order by $colposition ASC', ['$expenseName']));
    int count = expenseMapList.length;         // Count the number of map entries in db table

    List<Expense> list = <Expense>[];
    // For loop to create a 'Note List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      list.add(Expense.fromMapObject(expenseMapList[i]));
    }
    return list;
  }

  // Insert Operation: Insert a expense object to database
  Future<int> insertExpense(Expense expense) async {
    Database? db = await this.database;
    var result = await db!.insert(expenseTable, expense.toMap());
    return result;
  }


  // Update Operation: Update a Expense object and save it to database
  Future<int> updateExpense(Expense expense) async {
    var db = await this.database;
    var result = await db!.update(expenseTable, expense.toMap(), where: '$colId = ?', whereArgs: [expense.id]);
    return result;
  }


  // Delete Operation: Delete a Expense object from database
  Future<int> deleteExpense(int id) async {
    var db = await this.database;
    int result = await db!.rawDelete('DELETE FROM $expenseTable WHERE $colId = $id');
    return result;
  }

  Future gettotalExpense() async {
    Database? dbClient = await this.database;
    var result = await dbClient!.rawQuery("SELECT SUM(totalprice) as Total FROM $expenseTable");
    return result.toList();
  }

  Future getExpenseNameWise(String expenseName) async {
    Database? dbClient = await this.database;
    var result = await dbClient!.rawQuery('SELECT SUM(totalprice) as Total FROM $expenseTable WHERE expensename=?', ['$expenseName']);
    return result.toList();
  }

  void updatelist(List<Note> noteList) async {

    Database? dbClient = await this.database;


    dbClient!.rawQuery("delete from "+ noteTable);




    await dbClient?.transaction((txn) async {
      for (var i = 0; i < noteList.length; i++) {
        final item = noteList[i];
        noteList[i].positiona = i + 1;
        final id = i + 1;
        await txn.insert('note_table',noteList[i].toMap() );
        print(noteList[i].toMap());
      }

    });



  }


  void updatelistexpense(List<Expense> noteList,String type) async {

    Database? dbClient = await this.database;


    // dbClient!.rawQuery("delete from "+ noteTable);
    await dbClient?.execute('DELETE FROM expense_table WHERE expensename = ?', [type]);



    await dbClient?.transaction((txn) async {
      for (var i = 0; i < noteList.length; i++) {
        final item = noteList[i];
        noteList[i].positiona = i + 1;
        final id = i + 1;
        await txn.insert('expense_table',noteList[i].toMap() );
        print(noteList[i].toMap());
      }

    });



  }

  void updatenextlist(List<Fut> noteList) async {

    Database? dbClient = await this.database;


    dbClient!.rawQuery("delete from "+ nextprojectsTable);




    await dbClient?.transaction((txn) async {
    for (var i = 0; i < noteList.length; i++) {
    final item = noteList[i];
    noteList[i].positiona = i + 1;
    final id = i + 1;
    await txn.insert(nextprojectsTable,noteList[i].toMap() );
    print(noteList[i].toMap());
    }

    });










  }

  void updatefuturelist(List<Fut> noteList) async {

    Database? dbClient = await this.database;


    dbClient!.rawQuery("delete from "+ futureTable);




    await dbClient?.transaction((txn) async {
      for (var i = 0; i < noteList.length; i++) {
        final item = noteList[i];
        noteList[i].positiona = i + 1;
        final id = i + 1;
        await txn.insert(futureTable,noteList[i].toMap() );
        print(noteList[i].toMap());
      }

    });




  }

  getNoteLists() async {
    var noteMapList = await getNoteMapList(); // Get 'Map List' from database
    int count = noteMapList.length;         // Count the number of map entries in db table
    List<Note> noteList = <Note>[];
    // For loop to create a 'Note List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      noteList.add(Note.fromMapObject(noteMapList[i]));
    }
    return noteList;
  }
  getNextLists() async {
    var noteMapList = await getNextMapList(); // Get 'Map List' from database
    int count = noteMapList.length;         // Count the number of map entries in db table
    List<Note> noteList = <Note>[];
    // For loop to create a 'Note List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      noteList.add(Note.fromMapObject(noteMapList[i]));
    }
    return noteList;
  }
  getExpensesLists() async {
    var noteMapList = await geteeeMapList(); // Get 'Map List' from database
    int count = noteMapList.length;         // Count the number of map entries in db table
    List<Expense> noteList = <Expense>[];
    // For loop to create a 'Note List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      noteList.add(Expense.fromMapObject(noteMapList[i]));
    }
    return noteList;
  }
  getFutureLists() async {
    var noteMapList = await getFutureMapList(); // Get 'Map List' from database
    int count = noteMapList.length;         // Count the number of map entries in db table
    List<Fut> noteList = <Fut>[];
    // For loop to create a 'Note List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      noteList.add(Fut.fromMapObject(noteMapList[i]));
    }
    return noteList;
  }




}

