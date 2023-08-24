
import 'package:flutter/material.dart';
import 'package:ttachienew/splash_screen.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'NoteKeeper',
      debugShowCheckedModeBanner: false,

theme: ThemeData(
  inputDecorationTheme: const InputDecorationTheme(

    filled: true, //<-- SEE HERE
    fillColor: Color.fromARGB(255,55, 69, 80),
    //<-- SEE HERE




  ),
    scaffoldBackgroundColor:Color.fromARGB(255,55, 69, 80),
),
      home: SplashScreen(),
    );
  }
}