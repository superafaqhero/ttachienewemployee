import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ttachienew/First_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(
        Duration(seconds: 6),
        () =>
            Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => FirstScreen()

            )

            )

    );
  }
  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        width: _width,
        height: _height,
        color: Colors.black45,

        child: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  Expanded(flex : 1 ,child: Column(
                    children: [
                      SizedBox(
                        height: _height * 0.025,
                      ),

                      SizedBox(height: 60,),
                      Center(
                        child: Image.asset('assets/logonew.png'),
                      ),
                      SizedBox(height: 150,),
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        backgroundColor: Color.fromARGB(255,255, 255, 0),
                      ),
                      SizedBox(height: 30,),
                      Text(
                        "Loading....",
                        style: TextStyle(
                            color: Color.fromARGB(255,255, 255, 0),
                            fontWeight: FontWeight.w500,
                            fontSize: 30.0),
                      ),

                    ],
                  )),

                  Container(
                    height: 90,
                    // color: Colors.grey[300],
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Text(
                        //   'Brought to you by',
                        //   style: TextStyle(
                        //     color: Color.fromARGB(255,255, 255, 0),
                        //     fontSize: 16,
                        //     fontWeight: FontWeight.bold,
                        //   ),
                        // ),
                        SizedBox(width: 5),
                        Image.asset(
                          'assets/bottomlogo.png',
                          height: 50,
                        ),

                      ],
                    ),
                  )


                ],
              ),
            )),
      ),
    );
  }
}
