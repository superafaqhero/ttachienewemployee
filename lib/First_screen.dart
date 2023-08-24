
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/services.dart';
import 'package:ttachienew/widgets/custom_dialog.dart';

import 'login_page.dart';

class FirstScreen extends StatelessWidget {
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
                  Text(
                    "WELCOME",
                    style: TextStyle(
                        fontSize: 35.0,
                        color: Color.fromARGB(255,255, 255, 0),
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 60,),
                  Center(
                    child: Image.asset('assets/logonew.png'),
                  ),



                ],
              )),
              Expanded(flex : 1 ,child: Column(children: [
                AutoSizeText(
                  "Let's Start Proceeding Into My Application",
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  style: TextStyle(
                      fontSize: 22.0,
                      color: Color.fromARGB(255,255, 255, 0),
                      fontWeight: FontWeight.w400),
                ),
                SizedBox(
                  height: _height * 0.1,
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(25.0),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color:  Color.fromARGB(255,255, 255, 0),
                        spreadRadius: 2,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(

                        backgroundColor: Color.fromARGB(255,255, 255, 0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100.0),

                        ),
                        elevation: 15.0,

                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 10.0, bottom: 10.0, right: 25.0, left: 25.0),
                        child: Text(
                          "Get Started",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 30.0,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginPage(),
                          ),
                        );



                        // showDialog(context: context,
                        //     builder: (BuildContext context) => CustomDialog(
                        //       backgroundColor: Colors.green,
                        //       title: "Would you like to create a free account?",
                        //       desc: "With an account your data will be securely saved, allowing you to access it from multiple devices",
                        //       primaryButtonText: "Login to My Account",
                        //       primaryButtonRoute: "/signup",
                        //       seconderyButtonText: "back",
                        //       seconderyButtonRoute: "/home",
                        //     ));
                      }
                  ),
                ),
                SizedBox(
                  height: _height * 0.05,
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(25.0),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color:  Color.fromARGB(255,255, 255, 0),
                        spreadRadius: 1,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 15.0,
                        backgroundColor: Color.fromARGB(255,255, 255, 0),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 5.0, bottom: 5.0, right: 15.0, left: 15.0),
                        child: Text(
                          "EXIT",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      onPressed: () {
                        SystemNavigator.pop();
                      }),
                ),
              ],))


            ],
          ),
        )),
      ),
    );
  }
}
