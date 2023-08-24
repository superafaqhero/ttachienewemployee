
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:ttachienew/expense_detail.dart';

import 'expense_tab.dart';
import 'home_screen.dart';
import 'log_in.dart';
import 'nextinline.dart';
import 'note_list.dart';
import 'salesprojects.dart';



class BottomBar extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 6.0,
        color: Colors.transparent,
        elevation: 9.0,
        clipBehavior: Clip.antiAlias,

        child:       Container(
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

    //Container(
//             height:100,
//             decoration: BoxDecoration(
//                 borderRadius: BorderRadius.only(
//                     topLeft: Radius.circular(25.0),
//                     topRight: Radius.circular(25.0)),
//                 color: Color.fromARGB(255, 91, 109, 122),
//
//
//
//
//             ),
//
//
//           child: Column(
//
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Padding(padding: EdgeInsets.only(top: 12)),
//                   Padding(padding: EdgeInsets.only(left: 8,right: 8),
// child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//
//                     children: [
//
//  GestureDetector(
//
//                           child: Container(
//                             padding: EdgeInsets.all(8),
//                             decoration: BoxDecoration(
// //remove color to make it transpatent
//
//                                 borderRadius: BorderRadius.all(
//                                   Radius.circular(5),
//                                 ),
//
//                               color:Color.fromARGB(255,255, 255, 0),
//                             ),
//
//                             child: Text("Home",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black,fontSize: 12),),
//
//
//
//
//                           ),                          onTap: (){
//                             Navigator.of(context).pushReplacement(
//                                 MaterialPageRoute(builder: (context) => HomeScreen()));
//                           },),
//
//
//
//
//
//
//                       //
//                       // Container(
//                       //   margin: EdgeInsets.all(8),
//                       //   padding: EdgeInsets.all(5),
//                       //   alignment: Alignment.center,
//                       //   decoration: BoxDecoration(
//                       //       color: Colors.transparent,
//                       //       border: Border.all(
//                       //           color: Colors.white, // Set border color
//                       //           width: 3.0),   // Set border width
//                       //       borderRadius: BorderRadius.all(
//                       //           Radius.circular(10.0)), // Set rounded corner radius
//                       //       boxShadow: [BoxShadow(blurRadius: 10,color: Colors.black,offset: Offset(1,3))] // Make rounded corner of border
//                       //   ),
//                       //   child:
//                   GestureDetector(
//                             child: Container(
//                               padding: EdgeInsets.all(8),
//                               decoration: BoxDecoration(
// //remove color to make it transpatent
//
//                                   borderRadius: BorderRadius.all(
//                                     Radius.circular(5),
//                                   ),
//
//                                 color:Color.fromARGB(255,255, 255, 0),),
//
//                               child: Text("Running Jobs",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black,fontSize: 12),),
//
//
//
//
//                             ),                            onTap: () {
//                               Navigator.of(context).push(
//                                   MaterialPageRoute(builder: (context) =>NoteList()));
//                             }),
//
//                       // ),
//                     GestureDetector(
//                             child: Container(
//                               padding: EdgeInsets.all(8),
//                               decoration: BoxDecoration(
// //remove color to make it transpatent
//
//                                   borderRadius: BorderRadius.all(
//                                     Radius.circular(5),
//                                   ),
//
//                                 color:Color.fromARGB(255,255, 255, 0),),
//
//                               child: Text("Expenses",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black,fontSize: 12),),
//
//
//
//
//                             ),                            onTap: () {
//                               Navigator.of(context).push(
//                                   MaterialPageRoute(builder: (context) =>ExpenseDetail()));
//                             }),
//
//
//
//                       GestureDetector(
//   child: Container(
//                               padding: EdgeInsets.all(8),
//                               decoration: BoxDecoration(
//
// //remove color to make it transpatent
//                                   borderRadius: BorderRadius.all(
//                                     Radius.circular(5),
//                                   ),
//
//                                 color:Color.fromARGB(255,255, 255, 0),),
//
//                               child: Text("Next in Line",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black,fontSize: 12),),
//
//
//
//
//                             ),                            onTap: () {
//                               Navigator.of(context).push(
//                                   MaterialPageRoute(builder: (context) =>Nextin()));
//                             }),
//
//                     ],
//
//
//
//
//                   ),
//
//
//
//     ),                  Padding(padding: EdgeInsets.only(left: 8,right: 8 , bottom: 7),
// child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//
//                     children: [
// Center(
//
//
//       child: GestureDetector(
// child: Container(
//   padding: EdgeInsets.all(8),
// decoration: BoxDecoration(
// //remove color to make it transpatent
//     borderRadius: BorderRadius.all(
//       Radius.circular(5),
//     ),
//
//   color:Color.fromARGB(255,255, 255, 0),),
//
//         child: Text("Sales Projects",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black,fontSize: 12),),
//
//
//
//
// ),
//
//
//
//         onTap: (){
//           Navigator.of(context).pushReplacement(
//               MaterialPageRoute(builder: (context) => Salesproject()));
//         },),
//      ),
//
//
//
//                     ],
//
//
//
//
//                   ),
//
//
//
//     ),
//
//
//     ],
//             ),
//
//         )

    );
  }
}
