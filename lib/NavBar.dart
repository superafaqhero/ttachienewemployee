import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ttachienew/salesprojectionswithtabs.dart';
import 'package:ttachienew/tabstestfile.dart';

import 'package:ttachienew/test.dart';
import 'package:ttachienew/pdfapi.dart';
import 'package:ttachienew/testapi.dart';
import 'dart:io' show Platform, exit;

import 'expense_tab.dart';
import 'exportpdf.dart';
import 'futureprojects.dart';
import 'home_screen.dart';
import 'log_in.dart';
import 'login_page.dart';
import 'nextinline.dart';
import 'note_list.dart';
import 'salesprojects.dart';
import 'expense_detail.dart';

class NavBar extends StatefulWidget {
  @override
  _NavBarState createState() => _NavBarState();
}


class _NavBarState extends State<NavBar> {
  SharedPreferences? prefs;
  bool _isLoading = false;
  bool isLoggedIn = false;
  String userId = '';
  String username = '';
  String email = '';
  String role = '';

  Future<void> initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    isLoggedIn = prefs?.getBool('loggedIn') ?? false;
    userId = prefs?.getString('userId') ?? '';
    username = prefs?.getString('username') ?? '';
    email = prefs?.getString('email') ?? '';
    setState(() {
      role = prefs?.getString('role') ?? '';
    });


    print([role,"roleis"]);

  }









  @override
  void initState() {
    super.initState();
    initPrefs();

    // Initialize any state or perform actions you want to do when the widget is created.
  }

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // clear all the data stored in shared preferences

    // navigate the user to the login screen and prevent them from returning to the previous screens
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Container(color:  Color.fromARGB(255,55, 69, 80),
      child: ListView(

        padding: EdgeInsets.zero,

        children: [
      Padding(padding: EdgeInsets.only(top: 40),

          child:
 ListTile(
            trailing: ClipOval(
              child: Container(
                color: Color.fromARGB(255, 255,255, 110),
                width: 40,
                height: 40,
                child: Center(

                  child: Icon(Icons.arrow_back),
                ),
              ),
            ),
   onTap: () =>  Navigator.pop(context),
          ),  ),


Padding(padding: EdgeInsets.only(left: 12,right: 12,bottom: 12,top: 30),

child:     Center(
    child: Image.asset('assets/logonew.png'),
    ),



),
          SizedBox(height: 40,),
          Divider(),


          Container(
            color: Color.fromARGB(255,255, 255, 0),
            child:
            ListTile(
              leading: Icon(Icons.run_circle),
              title: Text('Running Jobs'),
              onTap: (){
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => MyHomePage()));
              },          ),

          ),

          Divider(),
    // Container(
    // color: Color.fromARGB(255,255, 255, 0),
    // child:
    //       ListTile(
    //
    //         leading: Icon(Icons.work),
    //         title: Text('Running Jobs'),
    //         onTap: (){
    //           Navigator.of(context).pushReplacement(
    //               MaterialPageRoute(builder: (context) => NoteList()));
    //         },          ), ),
    //       Divider(),

      Column(
        children: <Widget>[
          if (role == "owner")
            Container(
              color: Color.fromARGB(255, 255, 255, 0),
              child: ListTile(
                leading: Icon(Icons.home),
                title: Text('Bottom Line'),
                onTap: () {
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => HomeScreen())
                  );
                },
              ),
            ),
          if (role == "owner")
          Divider(),
          if (role == "owner")
          Container(
            color: Color.fromARGB(255,255, 255, 0),
            child:
            ListTile(
              leading: Icon(Icons.assured_workload_rounded),
              title: Text('Expenses'),
              onTap: (){
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => ExpenseDetail()));
              },          ), ),


          // Container(
          //   color: Color.fromARGB(255,255, 255, 0),
          //   child:
          // ListTile(
          //   leading: Icon(Icons.assured_workload_rounded),
          //   title: Text('Expenses'),
          //   onTap: (){
          //     Navigator.of(context).pushReplacement(
          //         MaterialPageRoute(builder: (context) => GeneratePage()));
          //   },
          // ),
          // ),
          // if (role == "owner")
          // Divider(),

          // if (role == "owner")
          //
          // Container(
          //   color: Color.fromARGB(255,255, 255, 0),
          //   child:
          //   ListTile(
          //     leading: Icon(Icons.point_of_sale),
          //     title: Text('Sales prospects'),
          //     onTap: (){
          //       Navigator.of(context).pushReplacement(
          //           MaterialPageRoute(builder: (context) => Futuretabs()));
          //     },
          //   ),  ),
          // if (role == "owner")
          //
          // Divider(),
          // if (role == "owner")
          // Container(
          //   color: Color.fromARGB(255,255, 255, 0),
          //   child:
          //   ListTile(
          //     leading: Icon(Icons.perm_device_info),
          //     title: Text('Sales Projections'),
          //     onTap: (){
          //       Navigator.of(context).pushReplacement(
          //           MaterialPageRoute(builder: (context) => Salesproject()));
          //     },
          //   ),  ),

          if (role == "owner")
          Divider(),
          // Container(
          //   color: Color.fromARGB(255,255, 255, 0),
          //   child:
          // ListTile(
          //   leading: Icon(Icons.run_circle),
          //   title: Text('test'),
          //   onTap: (){
          //     Navigator.of(context).pushReplacement(
          //         MaterialPageRoute(builder: (context) => ApiNotesScreen()));
          //   },          ), ),
          if (role == "owner")
          Container(
            color: Color.fromARGB(255,255, 255, 0),
            child:
            ListTile(
              leading: Icon(Icons.new_label_outlined),
              title: Text('Export'),
              onTap: (){
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => GeneratePage()));
              },          ), ),
          // Divider(),
          // Container(
          //   color: Color.fromARGB(255,255, 255, 0),
          //   child:
          //   ListTile(
          //     leading: Icon(Icons.next_plan),
          //     title: Text('Next Projects'),
          //     onTap: (){
          //       Navigator.of(context).pushReplacement(
          //           MaterialPageRoute(builder: (context) => Nextin()));
          //     },
          //   ),),
          if (role == "owner")
          Divider(),


        ]),
          // Container(
          //   color: Color.fromARGB(255,255, 255, 0),
          //   child:
          //   ListTile(
          //     leading: Icon(Icons.home),
          //     title: Text('Bottom Line'),
          //     onTap: (){
          //       Navigator.of(context).pushReplacement(
          //           MaterialPageRoute(builder: (context) => HomeScreen()));
          //     },          ), ),


          Container(
            color: Color.fromARGB(255,255, 255, 0),
            child:
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: (){


                _logout(context);


              },
            ),),
          Divider(),
    // Container(
    // color: Color.fromARGB(255,255, 255, 0),
    // child:
    //       ListTile(
    //         title: Text('Exit'),
    //         leading: Icon(Icons.exit_to_app),
    //         onTap: (){
    //           if (Platform.isAndroid) {
    //             SystemNavigator.pop();
    //           } else if (Platform.isIOS) {
    //             exit(0);
    //           }
    //
    //
    //         },
    //       ),),


        ],
      ),  ),

    );
  }
}
//Running Projects
//Bottom Line replace to home
//Expenses
//Sales Projections
//Next Projects
//Export
//logout