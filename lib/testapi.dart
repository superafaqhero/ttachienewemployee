import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'api_constants.dart';
class ApiNote {
  String? id;
  String? title;
  String? description;
  String? email;
  String? number;
  String? address;
  String? totalprice;
  String? deposit;
  String? balance;
  String? collectthisweek;
  String? priority;
  String? position;
  String? date;

  ApiNote({
    this.id,
    this.title,
    this.description,
    this.email,
    this.number,
    this.address,
    this.totalprice,
    this.deposit,
    this.balance,
    this.collectthisweek,
    this.priority,
    this.position,
    this.date,
  });

  factory ApiNote.fromJson(Map<String, dynamic> json) {
    return ApiNote(
      id: json['colId'],
      title: json['colTitle'],
      description: json['colDescription'],
      email: json['colemail'],
      number: json['colnumber'],
      address: json['coladdress'],
      totalprice: json['colTotalprice'],
      deposit: json['colDeposit'],
      balance: json['colBalance'],
      collectthisweek: json['colCollectthisweek'],
      priority: json['colPriority'],
      position: json['colposition'],
      date: json['colDate'],
    );
  }
}

class ApiNotesScreen extends StatefulWidget {
  @override
  _ApiNotesScreenState createState() => _ApiNotesScreenState();
}

class _ApiNotesScreenState extends State<ApiNotesScreen> {
  List<ApiNote> _data = [];

  Future<void> _fetchData() async {
    final response = await http.get(Uri.parse('${ApiConstants.baseUrl}api.php'));
    final jsonData = json.decode(response.body);
    List<ApiNote> notes = [];
    for (var noteMap in jsonData) {
      ApiNote note = ApiNote.fromJson(noteMap);
      notes.add(note);
    }
    setState(() {
      _data = notes;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('API Notes'),
      ),
      body: ListView.builder(
        itemCount: _data.length,
        itemBuilder: (BuildContext context, int index) {
          ApiNote note = _data[index];
          return ListTile(
            title: Text(note.title ?? ''),
            subtitle: Text(note.description ?? ''),
          );
        },
      ),
    );
  }
}
