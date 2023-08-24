import 'dart:async';
import 'dart:convert';
import 'package:mysql1/mysql1.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api_constants.dart';
import '../models/future.dart';
import '../models/note.dart';
import 'package:http/http.dart' as http;

class MySqlDatabase {
  MySqlConnection? _connection;
  SharedPreferences? prefs;

  bool isLoggedIn = false;
  String userId = '';
  String username = '';
  String email = '';

  Future<void> initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    isLoggedIn = prefs?.getBool('loggedIn') ?? false;
    userId = prefs?.getString('userId') ?? '';
    username = prefs?.getString('username') ?? '';
    email = prefs?.getString('email') ?? '';
  }
  Future<MySqlConnection> connectToDatabase() async {
    _connection ??= await MySqlConnection.connect(ConnectionSettings(
        host: '65.21.134.164',
        port: 3306,
        user: 'allfreehub_allfreehub',
        db: 'allfreehub_techie',
        password: 'Taxila12345@@',
      ));

    return _connection!;
  }


  Future<void> closeConnection() async {
    if (_connection != null) {
      await _connection!.close();
      _connection = null;
    }
  }

  Future<List<Map<String, dynamic>>> getFutureMapList() async {
    final conn = await connectToDatabase();

    final results = await conn.query('SELECT * FROM futureTable ORDER BY colposition ASC');
    List<Map<String, dynamic>> list = [];

    for (var row in results) {
      Map<String, dynamic> map = row.fields.map((key, value) => MapEntry(key.toString(), value));
      list.add(map);
    }

    return list;
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



  Future<int> insertNote(dynamic note) async {
    // print(jsonEncode([note.toMap()]));
    prefs = await SharedPreferences.getInstance();
    isLoggedIn = prefs?.getBool('loggedIn') ?? false;
    userId = prefs?.getString('userId') ?? '';
    username = prefs?.getString('username') ?? '';
    email = prefs?.getString('email') ?? '';
    Map<String, dynamic> noteMap = {
      'colTitle': note["colTitle"].toString().isEmpty ? '' : note["colTitle"],
      'colDescription': note["colDescription"].toString().isEmpty ? '' : note["colDescription"],
      'colemail': note["colemail"].toString().isEmpty ? '' : note["colemail"],
      'colnumber': note["colnumber"].toString().isEmpty ? '' : note["colnumber"],
      'coladdress': note["coladdress"].toString().isEmpty ? '' : note["coladdress"],
      'colTotalprice': note["colTotalprice"] == null || note["colTotalprice"].toString().isEmpty ? 0.0 : double.parse(note["colTotalprice"].toString()),
      'colDeposit': note["colDeposit"] == null || note["colDeposit"].toString().isEmpty ? 0.0 : double.parse(note["colDeposit"].toString()),
      'colBalance': note["colBalance"] == null || note["colBalance"].toString().isEmpty ? 0.0 : double.parse(note["colBalance"].toString()),
      'colCollectthisweek': note["colCollectthisweek"] == null || note["colCollectthisweek"].toString().isEmpty ? 0.0 : double.parse(note["colCollectthisweek"].toString()),
      'colPriority': 1,
      'colposition': 1,
      'colDate': note["colDate"].toString().isEmpty ? DateTime.now().toString() : note["colDate"],
      'tabid': "0",
      'userid': int.parse(userId),
      'notetype':note["notetype"].toString().isEmpty ? 'note' : note["notetype"],
    };






    print([noteMap]);

    final response = await http.post(
      Uri.parse('${ApiConstants.baseUrl}insertnote.php'),

      body: jsonEncode([noteMap]),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['id'];
    } else {
      throw Exception('Failed to insert note: ${response.statusCode}');
    }
  }


  Future<int> insertExpense(dynamic note) async {
    print([note,1111]);
    // print(jsonEncode([note.toMap()]));
    prefs = await SharedPreferences.getInstance();
    isLoggedIn = prefs?.getBool('loggedIn') ?? false;
    userId = prefs?.getString('userId') ?? '';
    username = prefs?.getString('username') ?? '';
    email = prefs?.getString('email') ?? '';
    Map<String, dynamic> noteMap = {
      'title': note["title"].toString().isEmpty ? 'Default Title' : note["title"],
      'etype': note["etype"].toString().isEmpty ? 'Default type' : note["etype"],
      'totalprice': note["totalprice"] == null || note["totalprice"].toString().isEmpty ? 0.0 : double.parse(note["totalprice"].toString()),
      'priority':1,
      'position': 1,
      'edate': note["edate"].toString().isEmpty ? DateTime.now().toString() : note["edate"],
      'userid': int.parse(userId),
    };







    print([noteMap,3453453]);

    final request = http.MultipartRequest(
      'POST',
      Uri.parse('${ApiConstants.baseUrl}insertexpense.php'),
    );

// Set the boundary for the multipart request
    String boundary = '-----${DateTime.now().millisecondsSinceEpoch}-----';
    request.headers['Content-Type'] = 'multipart/form-data; boundary=$boundary';

// Add the noteMap fields as form fields
    request.fields['title'] = noteMap['title'];
    request.fields['etype'] = noteMap['etype'];
    request.fields['totalprice'] = noteMap['totalprice'].toString();
    request.fields['priority'] = noteMap['priority'].toString();
    request.fields['position'] = noteMap['position'].toString();
    request.fields['edate'] = noteMap['edate'];
    request.fields['userid'] = noteMap['userid'].toString();

// Send the request and get the response
    final response = await http.Response.fromStream(await request.send());

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['id'];
    } else {
      print([response.statusCode,response]);
      throw Exception('Failed to insert data: ${response.statusCode}');
    }
  }
  Future<int> updateNote(dynamic note) async {
    // print(jsonEncode([note]));

    Map<String, dynamic> noteMap = {
      'colId': note["colId"],
      'colTitle': note["colTitle"],
      'colDescription': note["colDescription"],
      'colemail': note["colemail"],
      'colnumber': note["colnumber"],
      'coladdress': note["coladdress"],
      'colTotalprice': note["colTotalprice"],
      'colDeposit': note["colDeposit"],
      'colBalance': note["colBalance"],
      'colCollectthisweek': note["colCollectthisweek"],
      'colPriority': note["colPriority"],
      'colposition': note["colposition"],
      'colDate': note["colDate"],
      'tabid': note["tabid"],
      'userid': note["userid"],
      'notetype': note["notetype"],
    };




    final response = await http.post(
      Uri.parse('${ApiConstants.baseUrl}updatenote.php'),

      body: jsonEncode([noteMap]),
      headers: {'Content-Type': 'application/json'},
    );
    print(jsonDecode(response.body)['id']);
    if (response.statusCode == 200) {
      int id = int.parse(jsonDecode(response.body)['id']);
      return id;
    } else {
      throw Exception('Failed to Update note: ${response.statusCode}');
    }
  }



}
