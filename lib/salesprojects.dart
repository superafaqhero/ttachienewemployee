
import 'dart:collection';
import 'dart:convert';

import 'package:auto_size_text_field/auto_size_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:ttachienew/utils/database_helper.dart';
import 'package:pie_chart/pie_chart.dart';
import 'NavBar.dart';
import 'bottem_bar.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_platform_interface.dart';
import 'api_constants.dart';
import 'futuredetails.dart';
import 'home_screen.dart';
import 'models/future.dart';
import 'package:http/http.dart' as http;
import 'note_detail.dart';

SharedPreferences? prefs;

bool isLoggedIn = false;
String userId = '';
String username = '';
String email = '';

Map<String, double> sums = {};


class Salesproject extends StatefulWidget {



  String? text1;
  String? text2;
  String? text3;
  String? text4;

  Salesproject({this.text1,this.text2, this.text3, this.text4});
  @override
  _HomeScreenState createState() => _HomeScreenState(ttt1:text1,ttt2:text2,ttt3:text3,ttt4:text4);
}

class _HomeScreenState extends State<Salesproject> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String? ttt1;
  String? ttt2;
  String? ttt3;
  String? ttt4;
  _HomeScreenState({required this.ttt1,required this.ttt2,required this.ttt3,required this.ttt4});

  TextEditingController current = TextEditingController();
  TextEditingController totalc = TextEditingController();
  TextEditingController depositc = TextEditingController();
  TextEditingController balancec = TextEditingController();
  TextEditingController collectionc = TextEditingController();
  TextEditingController expensc = TextEditingController();
  TextEditingController bacnkc = TextEditingController();
  TextEditingController afterc = TextEditingController();
  TextEditingController statica = TextEditingController();

  DatabaseHelper databaseHelper = DatabaseHelper();

  List<Fut> noteList = [];
  Future<List<Fut>>? _future;

  void _onReorder(int oldIndex, int newIndex) async {
    if (newIndex > noteList!.length) newIndex = noteList!.length;
    if (oldIndex < newIndex) newIndex -= 1;

    setState(() {
      final Fut item = noteList![oldIndex];
      noteList!.removeAt(oldIndex);

      print(item.title);
      noteList!.insert(newIndex, item);



    });
    DatabaseHelper().updatefuturelist(noteList);
  }



  Future<void> initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    isLoggedIn = prefs?.getBool('loggedIn') ?? false;
    userId = prefs?.getString('userId') ?? '';
    username = prefs?.getString('username') ?? '';
    email = prefs?.getString('email') ?? '';
    fetchSums();
  }


  Future<Map<String, double>> fetchExpenseSums() async {
    final response = await http.get(Uri.parse('${ApiConstants.baseUrl}hometotals.php?userid=$userId&notetype=future'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return {
        'totalPriceSum': double.parse(data['totalPriceSum'] ?? '0'),
        'balanceSum': double.parse(data['balanceSum'] ?? '0'),
        'depositSum': double.parse(data['depositSum'] ?? '0'),
        'collectionSum': double.parse(data['collectionSum'] ?? '0'),
      };
    } else {
      throw Exception('Failed to fetch expense sums');
    }
  }


  void fetchSums() async {
    try {
      sums = await fetchExpenseSums();
      print('Total Price Sum: ${sums['totalPriceSum']}');
      print('Balance Sum: ${sums['balanceSum']}');
      print('Deposit Sum: ${sums['depositSum']}');
      print('Collection Sum: ${sums['collectionSum']}');

      _calcTotal();
      _calcDeposit();
      _calcBalance();
      _calcCollect();
      _calcTotalExpense();
      getStringValuesSF();




    } catch (e) {
      print('Error: $e');
    }
  }
















  @override
  void initState() {
    super.initState();

    initPrefs();












    // if (_future == null) {
    //   _future = databaseHelper.getfutureList();
    //
    // }







  }










  void addStringToSF(valaue) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('stringValueb',valaue);
  }

  void getStringValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    String? stringValue = prefs.getString('stringValueb');



    String? stringValueb = stringValue.toString().replaceAll('', '');
    final nss = double.parse(stringValueb).toStringAsFixed(2);

    statica.text = ""+nss.toString();

  }

  String? _totalprice;

  void _calcTotal() async{
    var total =  double?.tryParse(sums['totalPriceSum'].toString()) ;
    print(total);
    setState(() => _totalprice = total?.toStringAsFixed(2));
    totalc.text =  _totalprice.toString()  == "null" ? "":""+_totalprice.toString();           ;
  }

  String? _totalExpense;

  void _calcTotalExpense() async{
    var total = (await DatabaseHelper().gettotalExpense())[0]['Total'];
    print(total);
    setState(() => _totalExpense = total.toStringAsFixed(2));
    expensc.text =  _totalExpense.toString()  == "null" ? "":""+_totalExpense.toString();           ;
  }



  String? _totaldeposit;

  void _calcDeposit() async{
    var total = double?.tryParse(sums['depositSum'].toString()) ;
    print(total);
    setState(() => _totaldeposit = total?.toStringAsFixed(2));
    depositc.text = _totaldeposit.toString()  == "null" ? "":""+_totaldeposit.toString();
  }
  String? _totalbalance;

  void _calcBalance() async{
    // var total = (await DatabaseHelper().gettotalBalancesale())[0]['Total'] == null ? 0:(await DatabaseHelper().gettotalBalancesale())[0]['Total'];;
    var total = double?.tryParse(sums['balanceSum'].toString()) ;

    print(total);
    setState(() => _totalbalance = total?.toStringAsFixed(2));
    balancec.text = _totalbalance.toString()  == "null" ? "":""+_totalbalance.toString();
  }
  String? _totalcollect;

  void _calcCollect() async{
    var total = (await DatabaseHelper().gettotalCollect())[0]['Total'] == null ? 0:(await DatabaseHelper().gettotalCollect())[0]['Total'];;
    print(total);
    setState(() => _totalcollect = total.toStringAsFixed(2));
    collectionc.text =_totalcollect.toString()  == "null" ? "":""+_totalcollect.toString();
  }

  int count = 0;



  @override
  Widget build(BuildContext context) {

    TextStyle? titleStyle = Theme.of(context).textTheme.subtitle1;


















    final textScale=MediaQuery.of(context).size.height * 0.01;
    final screenHeight=MediaQuery.of(context).size.height;

    double getHeight(double sysVar,double size){
      double calc=size/1000;
      return sysVar *calc;
    }

    double getTextSize(double sysVar,double size){
      double calc=size/10;
      return sysVar *calc;
    }
    return Scaffold(
      drawer: NavBar(),
      key: _scaffoldKey,
      appBar: AppBar(
        iconTheme: IconThemeData(color:  Color.fromARGB(255,255, 255, 0),),


        backgroundColor: Colors.black45,

        title: Text("Sales Projections",style: TextStyle(fontSize: 30.0,fontWeight: FontWeight.w600,color: Colors.white),),
        centerTitle: true,
      ),

      backgroundColor: Color.fromARGB(255,55, 69, 80),
      body: WillPopScope(
    onWillPop: () async {
    Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => HomeScreen()),
    );
    return false;
    },


    child:

      SingleChildScrollView(

        child: Column(
            children: [
              Center(


                child: Padding(
                  padding:  EdgeInsets.all(16.0),
                  child: Container(

                    child: Column(

                      mainAxisAlignment: MainAxisAlignment.center ,
                      crossAxisAlignment: CrossAxisAlignment.center ,
                      children: [
                        SizedBox(height: 19,),
                        Center(
                          child: Image.asset('assets/logonew.png'),
                        ),
                        SizedBox(height: 80,),
                        Padding(
                          padding:  EdgeInsets.all(15),
                          child: Text("This Week's Goal",textAlign: TextAlign.center,style: TextStyle(fontSize: 34.0,fontWeight: FontWeight.w600,color: Colors.white),),
                        ),

                        Center(
                          child: Container(
                            height: 80,
                            width: MediaQuery.of(context).size.width * 0.80,
                            decoration: BoxDecoration(
                              boxShadow: <BoxShadow>[
                                BoxShadow(color: Colors.white10, offset: Offset(0, -4)),
                                BoxShadow(color: Colors.white10, offset: Offset(0, 4)),
                                BoxShadow(color: Colors.black, offset: Offset(-4, -4)),
                                BoxShadow(color: Colors.black, offset: Offset(-4, -4)),
                              ],
                              color: Color.fromARGB(255,55, 69, 80),

                              borderRadius: BorderRadius.circular(17),
                            ),
                            child: Padding(
                              padding:  EdgeInsets.all(8.0),
                              child: Center(child: AutoSizeTextField(

                                controller: statica,
                                onTap: () => _calcTotal(),
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                    isDense: true,
                                    contentPadding:  EdgeInsets.all(3.0),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide:  BorderSide(

                                        width: 0,
                                        style: BorderStyle.none,
                                      ),
                                    ),
                                    hintText: "0.00",
                                    hintStyle: TextStyle(color: Color.fromARGB(255,255, 255, 0),fontSize: 30.0,fontWeight: FontWeight.w900,)
                                ),
                                onChanged: (value){
                                  addStringToSF(value);

                                },
                                style: TextStyle(color: Color.fromARGB(255,255, 255, 0),fontSize:  30.0,fontWeight: FontWeight.w900,),
                              )),
                            ),
                          ),
                        ),
                        SizedBox(height: 70,),


                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center ,
                          children: [

                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children:<Widget>[
                                Padding(
                                  padding:  EdgeInsets.all(15),
                                  child: Text("Total Projections",style: TextStyle(fontSize: 21.0,fontWeight: FontWeight.w600,color: Colors.white),),
                                ),

                                Container(
                                  height: 80,
                                  width: MediaQuery.of(context).size.width * 0.80,
                                  decoration: BoxDecoration(
                                    boxShadow: <BoxShadow>[
                                      BoxShadow(color: Colors.white10, offset: Offset(0, -4)),
                                      BoxShadow(color: Colors.white10, offset: Offset(0, 4)),
                                      BoxShadow(color: Colors.black, offset: Offset(-4, -4)),
                                      BoxShadow(color: Colors.black, offset: Offset(-4, -4)),
                                    ],
                                    color: Color.fromARGB(255,55, 69, 80),

                                    borderRadius: BorderRadius.circular(17),
                                  ),
                                  child: Padding(
                                    padding:  EdgeInsets.all(4.0),
                                    child: Center(child: AutoSizeTextField(
                                      readOnly: true,
                                      controller: totalc,
                                      keyboardType: TextInputType.number,
                                      textAlign: TextAlign.center,
                                      decoration: InputDecoration(
                                          isDense: true,
                                          contentPadding:  EdgeInsets.all(3.0),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(10),
                                            borderSide:  BorderSide(
                                              width: 0,
                                              style: BorderStyle.none,
                                            ),
                                          ),
                                          hintText: "0.00",
                                          hintStyle: TextStyle(color: Color.fromARGB(255,255, 255, 0),fontSize: 30.0,fontWeight: FontWeight.w900,)
                                      ),
                                      style: TextStyle(color: Color.fromARGB(255,255, 255, 0),fontSize: 30.0,fontWeight: FontWeight.w900,),
                                    )),
                                  ),
                                ),
                              ],
                            ),
                            // SizedBox(width: 14,),

                          ],
                        ),
                        SizedBox(height: 40,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center ,
                          children: [

                            Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children:<Widget>[
                                  Padding(
                                    padding:  EdgeInsets.all(15),
                                    child: Text("Total Deposits",style: TextStyle(fontSize: 21.0,fontWeight: FontWeight.w600,color: Colors.white),),
                                  ),


                                  Container(
                                    height: 80,
                                    width: MediaQuery.of(context).size.width * 0.80,
                                    decoration: BoxDecoration(
                                      boxShadow: <BoxShadow>[
                                        BoxShadow(color: Colors.white10, offset: Offset(0, -4)),
                                        BoxShadow(color: Colors.white10, offset: Offset(0, 4)),
                                        BoxShadow(color: Colors.black, offset: Offset(-4, -4)),
                                        BoxShadow(color: Colors.black, offset: Offset(-4, -4)),
                                      ],
                                      color: Color.fromARGB(255,55, 69, 80),

                                      borderRadius: BorderRadius.circular(17),
                                    ),
                                    child: Padding(
                                      padding:  EdgeInsets.all(4.0),
                                      child: Center(child: AutoSizeTextField(
                                        readOnly: true,
                                        controller: depositc,
                                        keyboardType: TextInputType.number,
                                        textAlign: TextAlign.center,
                                        decoration: InputDecoration(
                                            isDense: true,
                                            contentPadding:  EdgeInsets.all(3.0),
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(10),
                                              borderSide:  BorderSide(
                                                width: 0,
                                                style: BorderStyle.none,
                                              ),
                                            ),
                                            hintText: "0.00",
                                            hintStyle: TextStyle(color: Color.fromARGB(255,255, 255, 0),fontSize: 30.0,fontWeight: FontWeight.w900,)
                                        ),
                                        style: TextStyle(color: Color.fromARGB(255,255, 255, 0),fontSize: 30.0,fontWeight: FontWeight.w900,),
                                      )),
                                    ),
                                  ),]
                            ),
                            // SizedBox(width: 14,),

                          ],
                        ),
                        SizedBox(height: 40,),
                        // Row(
                        //
                        //   mainAxisAlignment: MainAxisAlignment.center ,
                        //   crossAxisAlignment: CrossAxisAlignment.center ,
                        //   children: [
                        //     Center(
                        //
                        //       child: Text("Total Balance",style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.w600,color: Colors.white),),
                        //     ),
                        //
                        //   ],
                        // ),
                        // SizedBox(height: 20,),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.center ,
                        //   crossAxisAlignment: CrossAxisAlignment.center ,
                        //   children: [
                        //     Center(
                        //
                        //       child: Container(
                        //         height: 80,
                        //         width: MediaQuery.of(context).size.width * 0.80,
                        //         decoration: BoxDecoration(
                        //           boxShadow: <BoxShadow>[
                        //             BoxShadow(color: Colors.white10, offset: Offset(0, -4)),
                        //             BoxShadow(color: Colors.white10, offset: Offset(0, 4)),
                        //             BoxShadow(color: Colors.black, offset: Offset(-4, -4)),
                        //             BoxShadow(color: Colors.black, offset: Offset(-4, -4)),
                        //           ],
                        //           color: Color.fromARGB(255,55, 69, 80),
                        //
                        //           borderRadius: BorderRadius.circular(17),
                        //         ),
                        //         child: Padding(
                        //           padding:  EdgeInsets.all(4.0),
                        //           child: Center(child: TextFormField(
                        //             readOnly: true,
                        //             controller: balancec,
                        //             keyboardType: TextInputType.number,
                        //             textAlign: TextAlign.center,
                        //             decoration: InputDecoration(
                        //                 border: OutlineInputBorder(
                        //                   borderRadius: BorderRadius.circular(10),
                        //                   borderSide:  BorderSide(
                        //                     width: 0,
                        //                     style: BorderStyle.none,
                        //                   ),
                        //                 ),
                        //                 hintText: "0.00",
                        //                 hintStyle: TextStyle(color: Color.fromARGB(255,255, 255, 0),fontSize: 18.0,fontWeight: FontWeight.w900,)
                        //             ),
                        //             style: TextStyle(color: Color.fromARGB(255,255, 255, 0),fontSize: 18.0,fontWeight: FontWeight.w900,),
                        //           )),
                        //         ),
                        //       ),
                        //     ),
                        //   ],
                        // ),



                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center ,
                          children: [

                            Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children:<Widget>[
                                  Padding(
                                    padding:  EdgeInsets.all(15),
                                    child: Text("Balance",textAlign: TextAlign.center,style: TextStyle(fontSize: 21.0,fontWeight: FontWeight.w600,color: Colors.white),),
                                  ),


                                  Container(
                                    height: 80,
                                    width: MediaQuery.of(context).size.width * 0.80,
                                    decoration: BoxDecoration(
                                      boxShadow: <BoxShadow>[
                                        BoxShadow(color: Colors.white10, offset: Offset(0, -4)),
                                        BoxShadow(color: Colors.white10, offset: Offset(0, 4)),
                                        BoxShadow(color: Colors.black, offset: Offset(-4, -4)),
                                        BoxShadow(color: Colors.black, offset: Offset(-4, -4)),
                                      ],
                                      color: Color.fromARGB(255,55, 69, 80),

                                      borderRadius: BorderRadius.circular(17),
                                    ),
                                    child: Padding(

                                      padding:  EdgeInsets.all(4.0),
                                      child: Center(child: AutoSizeTextField(
                                        readOnly: true,
                                        keyboardType: TextInputType.number,
                                        textAlign: TextAlign.center,
                                        controller: balancec,
                                        decoration: InputDecoration(
                                            isDense: true,
                                            contentPadding:  EdgeInsets.all(3.0),
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(10),
                                              borderSide:  BorderSide(
                                                width: 0,
                                                style: BorderStyle.none,
                                              ),
                                            ),
                                            hintText: "0.00",
                                            hintStyle: TextStyle(color: Color.fromARGB(255,255, 255, 0),fontSize: 30.0,fontWeight: FontWeight.w900,)
                                        ),
                                        style: TextStyle(color: Color.fromARGB(255,255, 255, 0),fontSize: 30.0,fontWeight: FontWeight.w900,),
                                      )),
                                    ),
                                  ),]
                            ),
                            // SizedBox(width: 14,),

                          ],
                        ),


                        // SizedBox(height: 20,),
                        // Row(
                        //
                        //   mainAxisAlignment: MainAxisAlignment.center ,
                        //   crossAxisAlignment: CrossAxisAlignment.center ,
                        //   children: [
                        //     Center(
                        //
                        //       child: Text("Total Expenses",style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.w600,color: Colors.white),),
                        //     ),
                        //
                        //   ],
                        // ),
                        // SizedBox(height: 20,),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.center ,
                        //   crossAxisAlignment: CrossAxisAlignment.center ,
                        //   children: [
                        //     Center(
                        //
                        //       child: Container(
                        //         height: 80,
                        //         width: MediaQuery.of(context).size.width * 0.80,
                        //         decoration: BoxDecoration(
                        //           boxShadow: <BoxShadow>[
                        //             BoxShadow(color: Colors.white10, offset: Offset(0, -4)),
                        //             BoxShadow(color: Colors.white10, offset: Offset(0, 4)),
                        //             BoxShadow(color: Colors.black, offset: Offset(-4, -4)),
                        //             BoxShadow(color: Colors.black, offset: Offset(-4, -4)),
                        //           ],
                        //           color: Color.fromARGB(255,55, 69, 80),
                        //
                        //           borderRadius: BorderRadius.circular(17),
                        //         ),
                        //         child: Padding(
                        //           padding:  EdgeInsets.all(4.0),
                        //           child: Center(child: TextFormField(
                        //             controller: expensc,
                        //             keyboardType: TextInputType.number,
                        //             textAlign: TextAlign.center,
                        //             onChanged: (value){
                        //
                        //               final right = int.tryParse(value.toString());
                        //               final totalprr = int.tryParse(_totalprice.toString());
                        //               final bank = int.tryParse(current.text.toString());
                        //               String fin = (totalprr! - right! + bank!).toStringAsFixed(2);
                        //               afterc.text = fin;
                        //
                        //               // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        //               //   content: Text(fin),
                        //               // ));
                        //
                        //             },
                        //             decoration: InputDecoration(
                        //                 border: OutlineInputBorder(
                        //                   borderRadius: BorderRadius.circular(10),
                        //                   borderSide:  BorderSide(
                        //                     width: 0,
                        //                     style: BorderStyle.none,
                        //                   ),
                        //                 ),
                        //                 hintText: "0.00",
                        //                 hintStyle: TextStyle(color: Color.fromARGB(255,255, 255, 0),fontSize: 18.0,fontWeight: FontWeight.w900,)
                        //             ),
                        //             style: TextStyle(color: Color.fromARGB(255,255, 255, 0),fontSize: 18.0,fontWeight: FontWeight.w900,),
                        //           )),
                        //         ),
                        //       ),
                        //     ),
                        //   ],
                        // ),





















                      ],
                    ),

                  ),

                ),
              ),













              SizedBox(height:20,),

              // Text("Future Prospect",   textAlign: TextAlign.center, style: TextStyle(fontSize: 34.0,fontWeight: FontWeight.w500,color: Colors.white),),
              //
              // SizedBox(height:20,),
              //

              //
              // ConstrainedBox(
              //   constraints: BoxConstraints(
              //     maxHeight: 250,
              //
              //
              //
              //   ),
              //   child:FutureBuilder(
              //                   future: _future,
              //                   builder: (BuildContext context, AsyncSnapshot
              //                   snapshot) {
              //                     if (snapshot.data == null) {
              //                       return Text('Loading');
              //                     } else {
              //                       if (snapshot.data.length < 1) {
              //                         return Center(
              //                           child: Text('No Messages, Create New   one'),
              //                         );
              //                       }
              //
              //                       noteList = snapshot.data;
              //                       return ReorderableListView(
              //                         children: List.generate(
              //                           snapshot.data.length,
              //                               (index) {
              //                             return  Card(
              //                               color: Color.fromARGB(255, 102, 116, 128),
              //                               elevation: 2.0,
              //                               key: ValueKey(noteList[index]),
              //                               child:
              //
              //                               ListTile(
              //                                 key: Key('$index'),
              //                                 leading: CircleAvatar(
              //                                   backgroundColor: getPriorityColor(this.noteList![index].priority!),
              //                                   child: getPriorityIcon(this.noteList![index].priority!),
              //                                 ),
              //
              //                                 title: Text(this.noteList![index].title!, style: TextStyle(fontSize: 30,fontWeight: FontWeight.w500,color: Colors.white),),
              //
              //                                 subtitle:Row(
              //                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //                                   children: [
              //                                     Text("Sold: "+getFormatedDate(this.noteList![index].date!)+"",style: TextStyle(color: Color.fromARGB(250, 250, 250,  0) , fontSize: 14, fontWeight: FontWeight.bold ),),
              //                                     Text(double.parse(this.noteList![index].totalprice!).toStringAsFixed(2),style: TextStyle(color: Color.fromARGB(250, 250, 250,  0), fontSize: 14, fontWeight: FontWeight.bold ),),
              //                                   ],
              //                                 ),
              //
              //                                 trailing: GestureDetector(
              //                                   child: Icon(Icons.delete, color: Colors.red,),
              //                                   onTap: () {
              //                                     _delete(context, noteList![index]);
              //                                   },
              //                                 ),
              //
              //                                 onTap: () {
              //                                   navigateToDetail(this.noteList![index],'Edit Client');
              //                                 },
              //                               ),);
              //                           },
              //                         ).toList(),
              //                         onReorder: _onReorder,
              //                       );
              //                     }
              //                   }),
              //
              // ),
              //

















































                 BottomBar()







            ]),






      ),),

      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: Color.fromARGB(255,55, 69, 80),
      //   onPressed: () {
      //     debugPrint('FAB clicked');
      //     navigateToDetail(Fut('', '', 0,'','','','',2), 'Add Client');
      //   },
      //
      //   tooltip: 'Add Note',
      //
      //   child: Icon(Icons.add),
      //
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      //


    );

  }
  //  total() {
  //
  //   // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //   //   content: Text("Sending Message"),
  //   // ));
  //
  //    var total = (gettotal())[0]['Total'];
  //
  //   totalc.text = total.toString();
  //
  //
  //
  //   // print(total);
  // }
  // ListView getNoteListView() {
  //
  //   TextStyle? titleStyle = Theme.of(context).textTheme.subtitle1;
  //
  //   return ListView.builder(
  //
  //     itemCount: count,
  //     itemBuilder: (BuildContext context, int position) {
  //       return Card(
  //         color: Color.fromARGB(255, 102, 116, 128),
  //         elevation: 2.0,
  //         child: ListTile(
  //
  //           leading: CircleAvatar(
  //             backgroundColor: getPriorityColor(this.noteList![position].priority!),
  //             child: getPriorityIcon(this.noteList![position].priority!),
  //           ),
  //
  //           title: Text(this.noteList![position].title!, style: TextStyle(fontSize: 30,fontWeight: FontWeight.w500,color: Colors.white),),
  //
  //           subtitle: Text(getFormatedDate(this.noteList![position].date!)+"           "+this.noteList![position].totalprice!,style:TextStyle(fontSize: 15,fontWeight: FontWeight.w500,color: Color.fromARGB(250, 250, 250,  0)),),
  //
  //           trailing: GestureDetector(
  //             child: Icon(Icons.delete, color: Colors.grey,),
  //             onTap: () {
  //               _delete(context, noteList![position]);
  //             },
  //           ),
  //
  //
  //           onTap: () {
  //             debugPrint("ListTile Tapped");
  //             navigateToDetail(this.noteList![position],'Edit Client');
  //           },
  //
  //         ),
  //       );
  //     },
  //   );
  // }
  Color getPriorityColor(int priority) {
    switch (priority) {
      case 1:
        return Colors.red;
        break;
      case 2:
        return Colors.yellow;
        break;

      default:
        return Colors.yellow;
    }
  }

  // Returns the priority icon
  Icon getPriorityIcon(int priority) {
    switch (priority) {
      case 1:
        return Icon(Icons.play_arrow);
        break;
      case 2:
        return Icon(Icons.keyboard_arrow_right);
        break;

      default:
        return Icon(Icons.keyboard_arrow_right);
    }
  }

  void _delete(BuildContext context, Fut note) async {

    int result = await databaseHelper.deleteFuture(note.id!);
    if (result != 0) {
      _showSnackBar(context, 'Note Deleted Successfully');
      updateListView();
    }
  }

  void _showSnackBar(BuildContext context, String message) {

    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void navigateToDetail(Fut note, String title) async {
    bool result = await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return Futuredetails(note, title);
    }));

    if (result == true) {
      updateListView();
    }
  }
  void updateListView() {

    // final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    // dbFuture.then((database) {
    //
    //   Future<List<Fut>> noteListFuture = databaseHelper.getfutureList();
    //   noteListFuture.then((noteList) {
        setState(() {
          _future = databaseHelper.getfutureList();
          _calcTotal();
          _calcDeposit();
          _calcBalance();
          _calcCollect();
          _calcTotalExpense();
          getStringValuesSF();


          // this._future = noteList as Future<List<Fut>>?;
          this.count = noteList.length;
        });
    //   });
    // });
  }


  getFormatedDate(_date) {
    var inputFormat = DateFormat('yyyy-MM-dd HH:mm');
    var inputDate = inputFormat.parse(_date);
    var outputFormat = DateFormat('MM-dd-yyyy');
    return outputFormat.format(inputDate);
  }













}

List<Shadow> outlinedText({double strokeWidth = 2, Color strokeColor = Colors.black, int precision = 5}) {
  Set<Shadow> result = HashSet();
  for (int x = 1; x < strokeWidth + precision; x++) {
    for(int y = 1; y < strokeWidth + precision; y++) {
      double offsetX = x.toDouble();
      double offsetY = y.toDouble();
      result.add(Shadow(offset: Offset(-strokeWidth / offsetX, -strokeWidth / offsetY), color: strokeColor));
      result.add(Shadow(offset: Offset(-strokeWidth / offsetX, strokeWidth / offsetY), color: strokeColor));
      result.add(Shadow(offset: Offset(strokeWidth / offsetX, -strokeWidth / offsetY), color: strokeColor));
      result.add(Shadow(offset: Offset(strokeWidth / offsetX, strokeWidth / offsetY), color: strokeColor));
    }
  }
  return result.toList();
}