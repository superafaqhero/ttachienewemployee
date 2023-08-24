
import 'dart:collection';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_constants.dart';
import 'package:auto_size_text_field/auto_size_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/utils/utils.dart';
import 'package:ttachienew/models/expense.dart';
import 'package:ttachienew/utils/database_helper.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:ttachienew/utils/mysql.dart';
import 'bottem_bar.dart';
import 'NavBar.dart';
import 'editexpense.dart';
String payrollText = "payroll";
String rentText = "rent";
String utlilitiesText = "utility";
String otherText = "other";


class ExpenseDetail extends StatefulWidget {
  ExpenseDetail();

  @override
  ExpenseDetailState createState() => ExpenseDetailState();
}

class ExpenseDetailState extends State<ExpenseDetail> {

  Future<bool> onbackpress() async{
    Navigator.pop(context, true);
    return true;
  }

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Expense>? payrollExpenseList;
  Future<List<Expense>>? _futureModels;


  List<Expense>? rentExpenseList;
  List<Expense>? utlilitiesExpenseList;
  List<Expense>? otherExpenseList;
  int payrollCount = 0;
  int rentCount = 0;
  int utlityCount = 0;
  int otherCount = 0;

  ExpenseDetailState();
  FocusNode myFocusNode = new FocusNode();

  TextEditingController payrollNameController = TextEditingController();
  TextEditingController payrollDateController = TextEditingController();
  TextEditingController payrollPriceController = TextEditingController();

  TextEditingController rentNameController = TextEditingController();
  TextEditingController rentDateController = TextEditingController();
  TextEditingController rentNamePriceController = TextEditingController();

  TextEditingController utlityNameController = TextEditingController();
  TextEditingController utlityDateController = TextEditingController();
  TextEditingController utlityPriceController = TextEditingController();

  TextEditingController otherNameController = TextEditingController();
  TextEditingController otherDateController = TextEditingController();
  TextEditingController otherPriceController = TextEditingController();



  TextEditingController totalPriceController = TextEditingController();
  bool isLoggedIn = false;
  String userId = '';
  String username = '';
  String email = '';
  SharedPreferences? prefs;
  Future<void> initPrefs() async {

    prefs = await SharedPreferences.getInstance();
    isLoggedIn = prefs?.getBool('loggedIn') ?? false;
    userId = prefs?.getString('userId') ?? '';
    username = prefs?.getString('username') ?? '';
    email = prefs?.getString('email') ?? '';
    _calcTotalExpense();

    updatePieChart();
    updatePayrollListView();
    updateRentListView();
    updateUtlityListView();
    updateOtherListView();

  }
  @override
  void initState() {
    super.initState();
    initPrefs();



  }


  String? _totalExpense;


  Map<String, double> dataMap = {
    "Payroll": 0,
    "Rent": 0,
    "Utilities": 0,
    "Other Expense": 0,
  };



  final colorList = <Color>[
    Colors.greenAccent,
    Colors.redAccent,
    Colors.blueGrey,
    Colors.lightGreen,
  ];



  @override
  Widget build(BuildContext context) {

    if (payrollExpenseList == null) {
      payrollExpenseList = <Expense>[];
      updatePayrollListView();
    }

    if (rentExpenseList == null) {
      rentExpenseList = <Expense>[];
      updateRentListView();
    }

    if (utlilitiesExpenseList == null) {
      utlilitiesExpenseList = <Expense>[];
      updateUtlityListView();
    }

    if (otherExpenseList == null) {
      otherExpenseList = <Expense>[];
      updateOtherListView();
    }

    return WillPopScope(
      onWillPop: onbackpress,
      child: Scaffold(
        drawer: NavBar(),
        key: _scaffoldKey,
        appBar: AppBar(
          iconTheme: IconThemeData(color:  Color.fromARGB(255,255, 255, 0),),

          backgroundColor: Colors.black45,

          title: Text("Expenses",style: TextStyle(fontSize: 30.0,fontWeight: FontWeight.w600,color: Colors.white),),
          centerTitle: true,
        ),
        backgroundColor: Color.fromARGB(255,55, 69, 80),
        body: SingleChildScrollView(

          child: Column(

            children: [
              Center(

                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(

                    child: Column(

                      mainAxisAlignment: MainAxisAlignment.center ,
                      crossAxisAlignment: CrossAxisAlignment.center ,
                      children: [
                        SizedBox(height: 10,),
                        Center(
                          child: Image.asset('assets/logonew.png'),
                        ),

                        SizedBox(height: 60,),
                        Padding(
                          padding:  EdgeInsets.all(15),
                          child: Text("Total Expenses",textAlign: TextAlign.center,style: TextStyle(fontSize: 34.0,fontWeight: FontWeight.w600,color: Colors.white),),
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
                              padding: const EdgeInsets.all(8.0),
                              child: Center(child:  AutoSizeTextField(
                                readOnly: true,
                                controller: totalPriceController,
                                onTap: () =>  _calcTotalExpense(),
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                    isDense: true,
                                    contentPadding:  EdgeInsets.all(3.0),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
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
                        ),
                        SizedBox(height: 60,),
                        PieChart(
                          dataMap: dataMap,
                          animationDuration: Duration(milliseconds: 800),
                          chartLegendSpacing: 32,
                          chartRadius: MediaQuery.of(context).size.width / 2.0,
                          colorList: colorList,
                          initialAngleInDegree: 0,
                          chartType: ChartType.disc,
                          ringStrokeWidth: 32,
                          centerText: "",
                          legendOptions: LegendOptions(
                            showLegendsInRow: false,
                            legendPosition: LegendPosition.right,
                            showLegends: true,
                            legendShape: BoxShape.circle,
                            legendTextStyle: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          chartValuesOptions: ChartValuesOptions(
                            showChartValueBackground: false,
                            showChartValues: true,
                            showChartValuesInPercentage: true,
                            showChartValuesOutside: false,
                            decimalPlaces: 2,
                          ),
                          totalValue: 100,
                          // gradientList: ---To add gradient colors---
                          // emptyColorGradient: ---Empty Color gradient---
                        ),


                        SizedBox(height: 50,),
                        Center(
                          child:   Text("Payroll",style: TextStyle(fontSize: 30,fontWeight: FontWeight.w500,color: Colors.white),),
                        ),
                        SizedBox(height: 30,),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center ,
                          children: [

                            Container(
                              width: MediaQuery.of(context).size.width * 0.85,
                              child:TextField(
                                controller: payrollNameController,
                                cursorColor: Color.fromARGB(255,255, 255, 0),
                                onChanged: (value) {
                                  debugPrint('Something changed in Title Text Field');
                                  //updateTitle();
                                },
                                textAlign: TextAlign.center,
                                textAlignVertical: TextAlignVertical.center,
                                decoration: InputDecoration(
                                  labelText: 'Enter Name',
                                  floatingLabelAlignment: FloatingLabelAlignment.center,
                                  labelStyle: TextStyle(
                                    color: myFocusNode.hasFocus ? Colors.blue :Color.fromARGB(255,255, 255, 0),
                                  ),
                                  hintText: "Enter Name",
                                  alignLabelWithHint: true,


                                  hintStyle: TextStyle(color: Color.fromARGB(255,255, 255, 0),fontSize: 18.0,fontWeight: FontWeight.w900,),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Color.fromARGB(255,255, 255, 0)),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Color.fromARGB(255,255, 255, 0)),
                                  ),
                                ),
                                style: TextStyle(color: Color.fromARGB(255,255, 255, 0),fontSize: 18.0,fontWeight: FontWeight.w900,),



                              ),
                            ),
                            ]
                        ),
                        SizedBox(height: 30,),
                            Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center ,
                          children: [




                            Container(
                              width: MediaQuery.of(context).size.width * 0.40,
                              child:
                              TextField(
                                readOnly: true,
                                controller: payrollDateController,
                                decoration: InputDecoration(
                                  labelText: 'Due Date',
                                  labelStyle: TextStyle(
                                    color: myFocusNode.hasFocus ? Colors.blue :Color.fromARGB(255,255, 255, 0),
                                  ),
                                  hintText: "Due Date",
                                  hintStyle: TextStyle(color: Color.fromARGB(255,255, 255, 0),fontSize: 18.0,fontWeight: FontWeight.w900,),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Color.fromARGB(255,255, 255, 0)),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Color.fromARGB(255,255, 255, 0)),
                                  ),
                                ),
                                style: TextStyle(color: Color.fromARGB(255,255, 255, 0),fontSize: 18.0,fontWeight: FontWeight.w900,),

                                onTap: () async {
                                  var date = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(1900),
                                      lastDate: DateTime(2100),
                                      builder: (context, child) {
                                        return Theme(
                                          data: Theme.of(context).copyWith(
                                            colorScheme: ColorScheme.light(
                                              primary: Colors.amberAccent,
                                              // <-- SEE HERE
                                              onPrimary: Colors.black,
                                              // <-- SEE HERE
                                              onSurface: Colors
                                                  .black54, // <-- SEE HERE
                                            ),
                                            textButtonTheme: TextButtonThemeData(
                                              style: TextButton.styleFrom(
                                                primary: Colors
                                                    .black, // button text color
                                              ),
                                            ),
                                          ),
                                          child:Column(
                                            children: <Widget>[
                                              Padding(
                                                padding: const EdgeInsets.only(top: 50.0),
                                                child: Container(
                                                  // height: 400,
                                                  // width: MediaQuery.of(context).size.width * 0.80,
                                                  child: child,
                                                ),
                                              ),
                                            ],
                                          ),
                                        );

                                      }


                                  );
                                  if (date != null) {
                                    payrollDateController.text = DateFormat('MM-dd-yyyy').format(date);
                                  }
                                }
                              ),
                                  ),
                            // SizedBox(width: 14,),
                            Center(

                              child: Container(
                                height: 70,
                                width: MediaQuery.of(context).size.width * 0.40,
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
                                  padding: const EdgeInsets.all(4.0),
                                  child: Center(child: TextFormField(
                                    readOnly: false,
                                    controller: payrollPriceController,
                                    inputFormatters: <TextInputFormatter>[
                                      // for below version 2 use this
                                      FilteringTextInputFormatter.allow(RegExp('[0-9.]')),
                                    ],
                                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                                    textAlign: TextAlign.center,
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10),
                                          borderSide: const BorderSide(
                                            width: 0,
                                            style: BorderStyle.none,
                                          ),
                                        ),
                                        hintText: "0.00",
                                        hintStyle: TextStyle(color: Color.fromARGB(255,255, 255, 0),fontSize: 18.0,fontWeight: FontWeight.w900,)
                                    ),
                                    style: TextStyle(color: Color.fromARGB(255,255, 255, 0),fontSize: 18.0,fontWeight: FontWeight.w900,),
                                  )),
                                ),
                              ),
                            ),
                          ],
                        ),
                        // Fourth Element
                        Padding(
                          padding: EdgeInsets.only(top: 20.0, bottom: 15.0),
                          child: Center(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color.fromARGB(255,255, 255, 0),
                                foregroundColor: Theme.of(context).primaryColorLight,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20), // <-- Radius
                                ),
                              ),
                              child: Text(
                                " + Add New",style: TextStyle(color: Colors.black),
                                textScaleFactor: 1.5,
                              ),

                              onPressed: () {

                                setState(() {
                                  debugPrint("Save button clicked");

                                  if(payrollNameController.text.isNotEmpty && payrollPriceController.text.isNotEmpty){

                                    _save(payrollText, payrollNameController.text, payrollPriceController.text,payrollDateController.text);
                                    updatePayrollListView();
                                    payrollNameController.clear();
                                    payrollPriceController.clear();
                                    payrollDateController.clear();
                                  }else{
                                    _showSnackBar(context, "please fill fields");
                                  }


                                });
                              },
                            ),
                          ),
                        ),
                        ConstrainedBox(
                            constraints: BoxConstraints(
                              maxHeight: 250,


                            ),
                            child:getPayrollListView()

                        ),
                        SizedBox(height: 20,),
                        Divider(color: Color.fromARGB(255,255, 255, 0)),

                        SizedBox(height: 50,),
                        Center(
                          child:   Text("Rent / Mortgage",style: TextStyle(fontSize: 30,fontWeight: FontWeight.w500,color: Colors.white),),
                        ),
                        SizedBox(height: 30,),

                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center ,
                            children: [

                              Container(
                                width: MediaQuery.of(context).size.width * 0.85,
                                child:TextField(
                                  controller: rentNameController,
                                  cursorColor: Color.fromARGB(255,255, 255, 0),
                                  onChanged: (value) {
                                    debugPrint('Something changed in Title Text Field');
                                    //updateTitle();
                                  },
                                  textAlign: TextAlign.center,
                                  textAlignVertical: TextAlignVertical.center,
                                  decoration: InputDecoration(
                                    labelText: 'Enter Name',
                                    floatingLabelAlignment: FloatingLabelAlignment.center,
                                    labelStyle: TextStyle(
                                      color: myFocusNode.hasFocus ? Colors.blue :Color.fromARGB(255,255, 255, 0),
                                    ),
                                    hintText: "Enter Name",
                                    alignLabelWithHint: true,


                                    hintStyle: TextStyle(color: Color.fromARGB(255,255, 255, 0),fontSize: 18.0,fontWeight: FontWeight.w900,),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Color.fromARGB(255,255, 255, 0)),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Color.fromARGB(255,255, 255, 0)),
                                    ),
                                  ),
                                  style: TextStyle(color: Color.fromARGB(255,255, 255, 0),fontSize: 18.0,fontWeight: FontWeight.w900,),



                                ),
                              ),
                            ]
                        ),

                        SizedBox(height: 30,),



                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center ,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.40,
                              child:
                              TextField(
                                  readOnly: true,
                                  controller: rentDateController,
                                  decoration: InputDecoration(
                                    labelText: 'Due Date',
                                    labelStyle: TextStyle(
                                      color: myFocusNode.hasFocus ? Colors.blue :Color.fromARGB(255,255, 255, 0),
                                    ),
                                    hintText: "Due Date",
                                    hintStyle: TextStyle(color: Color.fromARGB(255,255, 255, 0),fontSize: 18.0,fontWeight: FontWeight.w900,),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Color.fromARGB(255,255, 255, 0)),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Color.fromARGB(255,255, 255, 0)),
                                    ),
                                  ),
                                  style: TextStyle(color: Color.fromARGB(255,255, 255, 0),fontSize: 18.0,fontWeight: FontWeight.w900,),

                                  onTap: () async {
                                    var date = await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(1900),
                                        lastDate: DateTime(2100),
                                        builder: (context, child) {
                                          return Theme(
                                            data: Theme.of(context).copyWith(
                                              colorScheme: ColorScheme.light(
                                                primary: Colors.amberAccent,
                                                // <-- SEE HERE
                                                onPrimary: Colors.black,
                                                // <-- SEE HERE
                                                onSurface: Colors
                                                    .black54, // <-- SEE HERE
                                              ),
                                              textButtonTheme: TextButtonThemeData(
                                                style: TextButton.styleFrom(
                                                  primary: Colors
                                                      .black, // button text color
                                                ),
                                              ),
                                            ),
                                            child:Column(
                                              children: <Widget>[
                                                Padding(
                                                  padding: const EdgeInsets.only(top: 50.0),
                                                  child: Container(
                                                    // height: 400,
                                                    // width: MediaQuery.of(context).size.width * 0.80,
                                                    child: child,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );

                                        }


                                    );
                                    if (date != null) {
                                      rentDateController.text = DateFormat('MM-dd-yyyy').format(date);
                                    }
                                  }
                              ),
                            ),
                            // SizedBox(width: 14,),
                            Center(

                              child: Container(
                                height: 70,
                                width: MediaQuery.of(context).size.width * 0.40,
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
                                  padding: const EdgeInsets.all(4.0),
                                  child: Center(child: TextFormField(
                                    readOnly: false,
                                    controller: rentNamePriceController,
                                    inputFormatters: <TextInputFormatter>[
                                      // for below version 2 use this
                                      FilteringTextInputFormatter.allow(RegExp('[0-9.]')),
                                    ],
                                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                                    textAlign: TextAlign.center,
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10),
                                          borderSide: const BorderSide(
                                            width: 0,
                                            style: BorderStyle.none,
                                          ),
                                        ),
                                        hintText: "0.00",
                                        hintStyle: TextStyle(color: Color.fromARGB(255,255, 255, 0),fontSize: 18.0,fontWeight: FontWeight.w900,)
                                    ),
                                    style: TextStyle(color: Color.fromARGB(255,255, 255, 0),fontSize: 18.0,fontWeight: FontWeight.w900,),
                                  )),
                                ),
                              ),
                            ),
                          ],
                        ),

                        Padding(
                          padding: EdgeInsets.only(top: 20, bottom: 15.0),
                          child: Center(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color.fromARGB(255,255, 255, 0),
                                foregroundColor: Theme.of(context).primaryColorLight,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20), // <-- Radius
                                ),
                              ),
                              child: Text(
                                " + Add New",style: TextStyle(color: Colors.black),
                                textScaleFactor: 1.5,
                              ),

                              onPressed: () {

                                setState(() {
                                  debugPrint("Save button clicked");

                                  if(rentNameController.text.isNotEmpty && rentNamePriceController.text.isNotEmpty){

                                    _save(rentText, rentNameController.text, rentNamePriceController.text,rentDateController.text);
                                    updateRentListView();

                                    rentNameController.clear();
                                    rentNamePriceController.clear();
                                    rentDateController.clear();

                                  }else{
                                    _showSnackBar(context, "please fill fields");
                                  }

                                });
                              },
                            ),
                          ),
                        ),
                        ConstrainedBox(
                            constraints: BoxConstraints(
                              maxHeight: 250,

                            ),
                            child:getRentListView()

                        ),

                        SizedBox(height: 20,), // Fourth Element
                        Divider(color: Color.fromARGB(255,255, 255, 0)),


                        SizedBox(height: 50,),
                        Center(
                          child:   Text("Utilities",style: TextStyle(fontSize: 30,fontWeight: FontWeight.w500,color: Colors.white),),
                        ),
                        SizedBox(height: 30,),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center ,
                            children: [

                              Container(
                                width: MediaQuery.of(context).size.width * 0.85,
                                child:TextField(
                                  controller: utlityNameController,
                                  cursorColor: Color.fromARGB(255,255, 255, 0),
                                  onChanged: (value) {
                                    debugPrint('Something changed in Title Text Field');
                                    //updateTitle();
                                  },
                                  textAlign: TextAlign.center,
                                  textAlignVertical: TextAlignVertical.center,
                                  decoration: InputDecoration(
                                    labelText: 'Enter Name',
                                    floatingLabelAlignment: FloatingLabelAlignment.center,
                                    labelStyle: TextStyle(
                                      color: myFocusNode.hasFocus ? Colors.blue :Color.fromARGB(255,255, 255, 0),
                                    ),
                                    hintText: "Enter Name",
                                    alignLabelWithHint: true,


                                    hintStyle: TextStyle(color: Color.fromARGB(255,255, 255, 0),fontSize: 18.0,fontWeight: FontWeight.w900,),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Color.fromARGB(255,255, 255, 0)),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Color.fromARGB(255,255, 255, 0)),
                                    ),
                                  ),
                                  style: TextStyle(color: Color.fromARGB(255,255, 255, 0),fontSize: 18.0,fontWeight: FontWeight.w900,),



                                ),
                              ),
                            ]
                        ),
                        SizedBox(height: 30,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center ,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.40,
                              child:
                              TextField(
                                  readOnly: true,
                                  controller: utlityDateController,
                                  decoration: InputDecoration(
                                    labelText: 'Due Date',
                                    labelStyle: TextStyle(
                                      color: myFocusNode.hasFocus ? Colors.blue :Color.fromARGB(255,255, 255, 0),
                                    ),
                                    hintText: "Due Date",
                                    hintStyle: TextStyle(color: Color.fromARGB(255,255, 255, 0),fontSize: 18.0,fontWeight: FontWeight.w900,),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Color.fromARGB(255,255, 255, 0)),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Color.fromARGB(255,255, 255, 0)),
                                    ),
                                  ),
                                  style: TextStyle(color: Color.fromARGB(255,255, 255, 0),fontSize: 18.0,fontWeight: FontWeight.w900,),

                                  onTap: () async {
                                    var date = await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(1900),
                                        lastDate: DateTime(2100),
                                        builder: (context, child) {
                                          return Theme(
                                            data: Theme.of(context).copyWith(
                                              colorScheme: ColorScheme.light(
                                                primary: Colors.amberAccent,
                                                // <-- SEE HERE
                                                onPrimary: Colors.black,
                                                // <-- SEE HERE
                                                onSurface: Colors
                                                    .black54, // <-- SEE HERE
                                              ),
                                              textButtonTheme: TextButtonThemeData(
                                                style: TextButton.styleFrom(
                                                  primary: Colors
                                                      .black, // button text color
                                                ),
                                              ),
                                            ),
                                            child:Column(
                                              children: <Widget>[
                                                Padding(
                                                  padding: const EdgeInsets.only(top: 50.0),
                                                  child: Container(
                                                    // height: 400,
                                                    // width: MediaQuery.of(context).size.width * 0.80,
                                                    child: child,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );

                                        }


                                    );
                                    if (date != null) {
                                      utlityDateController.text = DateFormat('MM-dd-yyyy').format(date);
                                    }
                                  }
                              ),
                            ),
                            // SizedBox(width: 14,),
                            Center(

                              child: Container(
                                height: 70,
                                width: MediaQuery.of(context).size.width * 0.40,
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
                                  padding: const EdgeInsets.all(4.0),
                                  child: Center(child: TextFormField(
                                    readOnly: false,
                                    controller: utlityPriceController,
                                    inputFormatters: <TextInputFormatter>[
                                      // for below version 2 use this
                                      FilteringTextInputFormatter.allow(RegExp('[0-9.]')),
                                    ],
                                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                                    textAlign: TextAlign.center,
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10),
                                          borderSide: const BorderSide(
                                            width: 0,
                                            style: BorderStyle.none,
                                          ),
                                        ),
                                        hintText: "0.00",
                                        hintStyle: TextStyle(color: Color.fromARGB(255,255, 255, 0),fontSize: 18.0,fontWeight: FontWeight.w900,)
                                    ),
                                    style: TextStyle(color: Color.fromARGB(255,255, 255, 0),fontSize: 18.0,fontWeight: FontWeight.w900,),
                                  )),
                                ),
                              ),
                            ),
                          ],
                        ),
                        // Fourth Element
                        Padding(
                          padding: EdgeInsets.only(top:20, bottom: 15.0),
                          child: Center(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color.fromARGB(255,255, 255, 0),
                                foregroundColor: Theme.of(context).primaryColorLight,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20), // <-- Radius
                                ),
                              ),
                              child: Text(
                                " + Add New",style: TextStyle(color: Colors.black),
                                textScaleFactor: 1.5,
                              ),

                              onPressed: () {

                                setState(() {
                                  debugPrint("Save button clicked");

                                  if(utlityNameController.text.isNotEmpty && utlityPriceController.text.isNotEmpty){

                                    _save(utlilitiesText, utlityNameController.text, utlityPriceController.text,utlityDateController.text);
                                    updateUtlityListView();

                                    utlityNameController.clear();
                                    utlityPriceController.clear();
                                    utlityDateController.clear();

                                  }else{
                                    _showSnackBar(context, "please fill fields");
                                  }
                                });
                              },
                            ),
                          ),
                        ),
                        ConstrainedBox(
                            constraints: BoxConstraints(
                              maxHeight: 250,

                            ),
                            child:getUtilityListView()

                        ),

                        SizedBox(height: 20,),
                        Divider(color: Color.fromARGB(255,255, 255, 0)),


                        SizedBox(height: 50,),
                        Center(
                          child:   Text("Other Expenses",style: TextStyle(fontSize: 30,fontWeight: FontWeight.w500,color: Colors.white),),
                        ),
                        SizedBox(height: 30,),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center ,
                            children: [

                              Container(
                                width: MediaQuery.of(context).size.width * 0.85,
                                child:TextField(
                                  controller: otherNameController,
                                  cursorColor: Color.fromARGB(255,255, 255, 0),
                                  onChanged: (value) {
                                    debugPrint('Something changed in Title Text Field');
                                    //updateTitle();
                                  },
                                  textAlign: TextAlign.center,
                                  textAlignVertical: TextAlignVertical.center,
                                  decoration: InputDecoration(
                                    labelText: 'Enter Name',
                                    floatingLabelAlignment: FloatingLabelAlignment.center,
                                    labelStyle: TextStyle(
                                      color: myFocusNode.hasFocus ? Colors.blue :Color.fromARGB(255,255, 255, 0),
                                    ),
                                    hintText: "Enter Name",
                                    alignLabelWithHint: true,


                                    hintStyle: TextStyle(color: Color.fromARGB(255,255, 255, 0),fontSize: 18.0,fontWeight: FontWeight.w900,),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Color.fromARGB(255,255, 255, 0)),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Color.fromARGB(255,255, 255, 0)),
                                    ),
                                  ),
                                  style: TextStyle(color: Color.fromARGB(255,255, 255, 0),fontSize: 18.0,fontWeight: FontWeight.w900,),



                                ),
                              ),
                            ]
                        ),
                        SizedBox(height: 30,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center ,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.40,
                              child:
                              TextField(
                                  readOnly: true,
                                  controller: otherDateController,
                                  decoration: InputDecoration(
                                    labelText: 'Due Date',
                                    labelStyle: TextStyle(
                                      color: myFocusNode.hasFocus ? Colors.blue :Color.fromARGB(255,255, 255, 0),
                                    ),
                                    hintText: "Due Date",
                                    hintStyle: TextStyle(color: Color.fromARGB(255,255, 255, 0),fontSize: 18.0,fontWeight: FontWeight.w900,),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Color.fromARGB(255,255, 255, 0)),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Color.fromARGB(255,255, 255, 0)),
                                    ),
                                  ),
                                  style: TextStyle(color: Color.fromARGB(255,255, 255, 0),fontSize: 18.0,fontWeight: FontWeight.w900,),

                                  onTap: () async {
                                    var date = await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(1900),
                                        lastDate: DateTime(2100),
                                        builder: (context, child) {
                                          return Theme(
                                            data: Theme.of(context).copyWith(
                                              colorScheme: ColorScheme.light(
                                                primary: Colors.amberAccent,
                                                // <-- SEE HERE
                                                onPrimary: Colors.black,
                                                // <-- SEE HERE
                                                onSurface: Colors
                                                    .black54, // <-- SEE HERE
                                              ),
                                              textButtonTheme: TextButtonThemeData(
                                                style: TextButton.styleFrom(
                                                  primary: Colors
                                                      .black, // button text color
                                                ),
                                              ),
                                            ),
                                            child:Column(
                                              children: <Widget>[
                                                Padding(
                                                  padding: const EdgeInsets.only(top: 50.0),
                                                  child: Container(
                                                    // height: 400,
                                                    // width: MediaQuery.of(context).size.width * 0.80,
                                                    child: child,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );

                                        }


                                    );
                                    if (date != null) {
                                      otherDateController.text = DateFormat('MM-dd-yyyy').format(date);
                                    }
                                  }
                              ),
                            ),
                            // SizedBox(width: 14,),
                            Center(

                              child: Container(
                                height: 70,
                                width: MediaQuery.of(context).size.width * 0.40,
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
                                  padding: const EdgeInsets.all(4.0),
                                  child: Center(child: TextFormField(
                                    readOnly: false,
                                    controller: otherPriceController,
                                    inputFormatters: <TextInputFormatter>[
                                      // for below version 2 use this
                                      FilteringTextInputFormatter.allow(RegExp('[0-9.]')),
                                    ],
                                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                                    textAlign: TextAlign.center,
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10),
                                          borderSide: const BorderSide(
                                            width: 0,
                                            style: BorderStyle.none,
                                          ),
                                        ),
                                        hintText: "0.00",
                                        hintStyle: TextStyle(color: Color.fromARGB(255,255, 255, 0),fontSize: 18.0,fontWeight: FontWeight.w900,)
                                    ),
                                    style: TextStyle(color: Color.fromARGB(255,255, 255, 0),fontSize: 18.0,fontWeight: FontWeight.w900,),
                                  )),
                                ),
                              ),
                            ),
                          ],
                        ),
// Fourth Element
                        Padding(
                          padding: EdgeInsets.only(top: 20, bottom: 15.0),
                          child: Center(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color.fromARGB(255,255, 255, 0),
                                foregroundColor: Theme.of(context).primaryColorLight,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20), // <-- Radius
                                ),
                              ),
                              child: Text(
                                " + Add New",style: TextStyle(color: Colors.black),
                                textScaleFactor: 1.5,
                              ),

                              onPressed: () {

                                setState(() {
                                  debugPrint("Save button clicked");
                                  if(otherNameController.text.isNotEmpty && otherPriceController.text.isNotEmpty){

                                    _save(otherText, otherNameController.text, otherPriceController.text,otherDateController.text);
                                    updateOtherListView();

                                    otherNameController.clear();
                                    otherPriceController.clear();
                                    otherDateController.clear();
                                  }else{
                                    _showSnackBar(context, "please fill fields");
                                  }
                                });
                              },
                            ),
                          ),
                        ),

                        ConstrainedBox(
                            constraints: BoxConstraints(
                              maxHeight: 250,

                            ),
                            child:getOtherListView()

                        ),
                        SizedBox(height: 20,),

                      ],
                    ),
                  ),
                ),
              ),
              BottomBar()
            ],
          ) ,

        ),

        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,


      ),
    );
  }


  ReorderableListView getPayrollListView() {

    TextStyle? titleStyle = Theme.of(context).textTheme.subtitle1;

    return  ReorderableListView(
      onReorder: _onReorderpayroll,
      children: this.payrollExpenseList!.map((Expense item) {
        return  Card(
          key: Key(item.id.toString()),
          color: Color.fromARGB(255, 102, 116, 128),
          elevation: 2.0,
          child: ListTile(
            key: Key(item.id.toString()),

            title: Text(item.title!, style: TextStyle(color: Colors.white , fontSize: 16, fontWeight: FontWeight.bold ),),

            subtitle: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Due: "+item.date!+"",style: TextStyle(color: Color.fromARGB(250, 250, 250,  0) , fontSize: 14, fontWeight: FontWeight.bold ),),
                Text(double.parse(item.totalprice!).toStringAsFixed(2),style: TextStyle(color: Color.fromARGB(250, 250, 250,  0), fontSize: 14, fontWeight: FontWeight.bold ),),
              ],
            ),

            trailing: GestureDetector(
              child: Icon(Icons.delete, color: Colors.red,),
              onTap: () {
                _delete(context, item);
              },
            ),


            onTap: () {
              debugPrint("ListTile Tapped");
              print(item.toMap());
              // navigateToDetail(this.noteList![position],'Edit Client');
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditExpensePage(
                    expenseName: item.title.toString(),
                    expenseDate:item.date.toString(),
                    expensePrice: double.parse(item.totalprice.toString()),
                  ),

                ),
              );

            },

          ),
        );
      }).toList(),
    );




      // ListView.builder(
      //   scrollDirection: Axis.vertical,
      //   shrinkWrap: true,
      //   itemCount: payrollCount,
      //   itemBuilder: (BuildContext context, int position) {
      //     return Card(
      //       color: Color.fromARGB(255, 102, 116, 128),
      //       elevation: 2.0,
      //       child: ListTile(
      //
      //
      //         title: Text(this.payrollExpenseList![position].title!, style: TextStyle(color: Colors.white , fontSize: 16, fontWeight: FontWeight.bold ),),
      //
      //         subtitle: Text("        Due: "+this.payrollExpenseList![position].date!+"                 "+double.parse(this.payrollExpenseList![position].totalprice!).toStringAsFixed(2),style: TextStyle(color: Colors.white , fontSize: 14, fontWeight: FontWeight.bold ),),
      //
      //         trailing: GestureDetector(
      //           child: Icon(Icons.delete, color: Colors.red,),
      //           onTap: () {
      //             _delete(context, payrollExpenseList![position]);
      //           },
      //         ),
      //
      //
      //         onTap: () {
      //           debugPrint("ListTile Tapped");
      //           // navigateToDetail(this.noteList![position],'Edit Client');
      //         },
      //
      //       ),
      //     );
      //   },
      // );
  }

  ReorderableListView getRentListView() {

    TextStyle? titleStyle = Theme.of(context).textTheme.subtitle1;

    return  ReorderableListView(
      onReorder: _onReorderrent,
      children: this.rentExpenseList!.map((Expense item) {
        return  Card(
          key: Key(item.id.toString()),
          color: Color.fromARGB(255, 102, 116, 128),
          elevation: 2.0,
          child: ListTile(
            key: Key(item.id.toString()),

            title: Text(item.title!, style: TextStyle(color: Colors.white , fontSize: 16, fontWeight: FontWeight.bold ),),

            subtitle: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Due: "+item.date!+"",style: TextStyle(color: Color.fromARGB(250, 250, 250,  0), fontSize: 14, fontWeight: FontWeight.bold ),),
                Text(double.parse(item.totalprice!).toStringAsFixed(2),style: TextStyle(color: Color.fromARGB(250, 250, 250,  0) , fontSize: 14, fontWeight: FontWeight.bold ),),
              ],
            ),

            trailing: GestureDetector(
              child: Icon(Icons.delete, color: Colors.red,),
              onTap: () {
                _delete(context, item);
              },
            ),


            onTap: () {
              debugPrint("ListTile Tapped");
              // navigateToDetail(this.noteList![position],'Edit Client');
            },

          ),
        );
      }).toList(),
    );
  }

  ReorderableListView getUtilityListView() {

    TextStyle? titleStyle = Theme.of(context).textTheme.subtitle1;

    return  ReorderableListView(
      onReorder: _onReorderutility,
      children: this.utlilitiesExpenseList!.map((Expense item) {
        return  Card(
          key: Key(item.id.toString()),
          color: Color.fromARGB(255, 102, 116, 128),
          elevation: 2.0,
          child: ListTile(
            key: Key(item.id.toString()),

            title: Text(item.title!, style: TextStyle(color: Colors.white , fontSize: 16, fontWeight: FontWeight.bold ),),

            subtitle:Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Due: "+item.date!+"",style: TextStyle(color: Color.fromARGB(250, 250, 250,  0), fontSize: 14, fontWeight: FontWeight.bold ),),
                Text(double.parse(item.totalprice!).toStringAsFixed(2),style: TextStyle(color: Color.fromARGB(250, 250, 250,  0), fontSize: 14, fontWeight: FontWeight.bold ),),
              ],
            ),

            trailing: GestureDetector(
              child: Icon(Icons.delete, color: Colors.red,),
              onTap: () {
                _delete(context, item);
              },
            ),


            onTap: () {
              debugPrint("ListTile Tapped");
              // navigateToDetail(this.noteList![position],'Edit Client');
            },

          ),
        );
      }).toList(),
    );
  }

  ReorderableListView getOtherListView() {

    TextStyle? titleStyle = Theme.of(context).textTheme.subtitle1;

    return  ReorderableListView(
      onReorder: _onReorderother,
      children: this.otherExpenseList!.map((Expense item) {
        return  Card(
          key: Key(item.id.toString()),
          color: Color.fromARGB(255, 102, 116, 128),
          elevation: 2.0,
          child: ListTile(
            key: Key(item.id.toString()),

            title: Text(item.title!, style: TextStyle(color: Colors.white , fontSize: 16, fontWeight: FontWeight.bold ),),

            subtitle: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Due: "+item.date!+"",style: TextStyle(color: Color.fromARGB(250, 250, 250,  0) , fontSize: 14, fontWeight: FontWeight.bold ),),
                Text(double.parse(item.totalprice!).toStringAsFixed(2),style: TextStyle(color: Color.fromARGB(250, 250, 250,  0), fontSize: 14, fontWeight: FontWeight.bold ),),
              ],
            ),



            // Text("Due: "+item.date!+"                       "+double.parse(item.totalprice!).toStringAsFixed(2),style: TextStyle(color: Colors.white , fontSize: 14, fontWeight: FontWeight.bold ),),

            trailing: GestureDetector(
              child: Icon(Icons.delete, color: Colors.red,),
              onTap: () {
                _delete(context, item);
              },
            ),


            onTap: () {
              debugPrint("ListTile Tapped");
              // navigateToDetail(this.noteList![position],'Edit Client');
            },

          ),
        );
      }).toList(),
    );
  }

  void _delete(BuildContext context, Expense expense) async {
    // Make an HTTP POST request to the PHP API
    final response = await http.post(
      Uri.parse('${ApiConstants.baseUrl}deleteexpense.php'),
      body: {'expenseId': expense.id.toString()},
    );

    if (response.statusCode == 200) {
      // Deletion successful
      _showSnackBar(context, 'Deleted Successfully');
      updatePayrollListView();
      updateRentListView();
      updateUtlityListView();
      updateOtherListView();
      _calcTotalExpense();
      updatePieChart();
    } else {
      // Deletion failed
      print([response.statusCode, response]);
      throw Exception('Failed to delete data: ${response.statusCode}');
    }
  }


  void _showSnackBar(BuildContext context, String message) {

    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void updatePayrollListView() {

    final Future<List<Expense>> expenseListFuture = fetchExpenseListFromAPI(payrollText);
    expenseListFuture.then((list) {
      print([list,"this"]);
      setState(() {
        this.payrollExpenseList = list;
        this.payrollCount = list.length;
      });
    });
  }
  void updateRentListView() {
    final Future<List<Expense>> expenseListFuture = fetchExpenseListFromAPI(rentText);
    expenseListFuture.then((list) {
      print([list,"this"]);
      setState(() {
        this.rentExpenseList = list;
        this.rentCount = list.length;
      });
    });
  }

  Future<List<Expense>> fetchExpenseListFromAPI(String rentText) async {
    final response = await http.get(Uri.parse('${ApiConstants.baseUrl}expensebytype.php?rentText=$rentText&userid=$userId'));
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.map((item) => Expense.fromMapObject(item)).toList();
    } else {
      throw Exception('Failed to fetch expense list from API: ${response.statusCode}');
    }
  }



  void updateUtlityListView() {

    final Future<List<Expense>> expenseListFuture = fetchExpenseListFromAPI(utlilitiesText);
    expenseListFuture.then((list) {
      print([list,"this"]);
      setState(() {
        this.utlilitiesExpenseList = list;
        this.utlityCount = list.length;
      });
    });
  }


  void updateOtherListView() {

    final Future<List<Expense>> expenseListFuture = fetchExpenseListFromAPI(otherText);
    expenseListFuture.then((list) {
      print([list,"this"]);
      setState(() {
        this.otherExpenseList = list;
        this.otherCount = list.length;
      });
    });
  }





  // Save data to database
  void _save(String expenseName , String title , String totalPrice,String date) async {
    Expense expense = new Expense("", "",1 ,"", 1, "");

    expense.date = date;
    expense.expensename = expenseName;
    expense.title = title;
    expense.totalprice = totalPrice;
print([expense.toMap(),4545]);
    Map<String, dynamic> dynamicObject = {
      'expense': expense.toMap(),
      'otherValue': 4545,
    };

    print(dynamicObject['expense']['title']);

    int result= await MySqlDatabase().insertExpense(expense.toMap());


    // int result = await databaseHelper.insertExpense(expense);


    if (result != 0) {  // Success
      _showSnackBar(context, 'Saved Successfully');
      _calcTotalExpense();
       updatePieChart();
      updatePayrollListView();
      updateRentListView();
      updateUtlityListView();
      updateOtherListView();
    } else {  // Failure
      _showSnackBar(context, 'Problem Saving');
    }

  }
// Function to fetch the total expense
  Future<double> getTotalExpense() async {
    final response = await http.get(Uri.parse('${ApiConstants.baseUrl}calculateTotalExpense.php?userid=$userId'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return double.parse(data['totalExpense']);
    } else {
      throw Exception('Failed to fetch total expense');
    }
  }

// Function to fetch the total expense for a specific expense type
  Future<double> getTotalExpenseByType(String expenseType) async {
    final response = await http.get(Uri.parse('${ApiConstants.baseUrl}getExpenseTotalByType.php?expenseType=$expenseType&userid=$userId'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final total = data['Total'];
      return double.parse(total ?? '0.0');
    } else {
      throw Exception('Failed to fetch total expense for $expenseType');
    }
  }

  void _calcTotalExpense() async {
    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}calculateTotalExpense.php?userid=$userId'),
    );

    if (response.statusCode == 200) {
      // Parse the JSON response
      final data = jsonDecode(response.body);
      var total = double.parse(data['totalExpense']);

      setState(() {
        _totalExpense = total.toStringAsFixed(2);
      });
      totalPriceController.text = _totalExpense ?? "";
    } else {
      // Calculation failed
      print([response.statusCode, response]);
      throw Exception('Failed to calculate total expense: ${response.statusCode}');
    }
  }





  void updatePieChart() async{

    var total = await getTotalExpense();
    var totalPayroll = await getTotalExpenseByType('payroll');
    var totalRent = await getTotalExpenseByType('rent');
    var totalUtility = await getTotalExpenseByType('utility');
    var totalOther = await getTotalExpenseByType('other');

    setState(() {

      if(totalPayroll != null){
        dataMap.update("Payroll", (value) => (totalPayroll /  total) * 100.0);
      }

      if(totalRent !=null){
        dataMap.update("Rent", (value) => (totalRent /  total) * 100.0);
      }

      if(totalUtility !=null){
        dataMap.update("Utilities", (value) => (totalUtility /  total) * 100.0);
      }


      if(totalOther !=null){
        dataMap.update("Other Expense", (value) => (totalOther /  total) * 100.0);
      }

    });

  }
  void _onReorderpayroll(int oldIndex, int newIndex) async {
    // print("old/n");
    // print(oldIndex);
    // print("old/n");
    // print(newIndex);
    if (newIndex > this.payrollExpenseList!.length) newIndex = this.payrollExpenseList!.length;
    if (oldIndex < newIndex) newIndex -= 1;

    setState(() {
      final Expense item = this.payrollExpenseList![oldIndex];
      this.payrollExpenseList!.removeAt(oldIndex);
      // print(item.title);
      this.payrollExpenseList!.insert(newIndex, item);
  // for (var i = 0; i < noteList!.length; i++) {
      //   print(noteList![i].positiona!);
      //   print(noteList![i].id!);
      //   DatabaseHelper().updatePosi(noteList![i].positiona!,noteList![i].id!);
      //
      //
      //   // db.update(
      //   //   'items',
      //   //   {'position': i},
      //   //   where: 'id = ?',
      //   //   whereArgs: [i + 1],
      //   // );
      // }

    });
    // DatabaseHelper().updateItemPosition(oldIndex, newIndex);
    DatabaseHelper().updatelistexpense(this.payrollExpenseList!,payrollText);

  }
  void _onReorderrent(int oldIndex, int newIndex) async {
    // print("old/n");
    // print(oldIndex);
    // print("old/n");
    // print(newIndex);
    if (newIndex > this.rentExpenseList!.length) newIndex = this.rentExpenseList!.length;
    if (oldIndex < newIndex) newIndex -= 1;

    setState(() {
      final Expense item = this.rentExpenseList![oldIndex];
      this.rentExpenseList!.removeAt(oldIndex);
      // print(item.title);
      this.rentExpenseList!.insert(newIndex, item);
      // for (var i = 0; i < noteList!.length; i++) {
      //   print(noteList![i].positiona!);
      //   print(noteList![i].id!);
      //   DatabaseHelper().updatePosi(noteList![i].positiona!,noteList![i].id!);
      //
      //
      //   // db.update(
      //   //   'items',
      //   //   {'position': i},
      //   //   where: 'id = ?',
      //   //   whereArgs: [i + 1],
      //   // );
      // }

    });
    // DatabaseHelper().updateItemPosition(oldIndex, newIndex);
    DatabaseHelper().updatelistexpense(this.rentExpenseList!,rentText);

  }
  void _onReorderutility(int oldIndex, int newIndex) async {
    // print("old/n");
    // print(oldIndex);
    // print("old/n");
    // print(newIndex);
    if (newIndex > this.utlilitiesExpenseList!.length) newIndex = this.utlilitiesExpenseList!.length;
    if (oldIndex < newIndex) newIndex -= 1;

    setState(() {
      final Expense item = this.utlilitiesExpenseList![oldIndex];
      this.utlilitiesExpenseList!.removeAt(oldIndex);
      // print(item.title);
      this.utlilitiesExpenseList!.insert(newIndex, item);
      // for (var i = 0; i < noteList!.length; i++) {
      //   print(noteList![i].positiona!);
      //   print(noteList![i].id!);
      //   DatabaseHelper().updatePosi(noteList![i].positiona!,noteList![i].id!);
      //
      //
      //   // db.update(
      //   //   'items',
      //   //   {'position': i},
      //   //   where: 'id = ?',
      //   //   whereArgs: [i + 1],
      //   // );
      // }

    });
    // DatabaseHelper().updateItemPosition(oldIndex, newIndex);
    DatabaseHelper().updatelistexpense(this.utlilitiesExpenseList!,utlilitiesText);

  }
  void _onReorderother(int oldIndex, int newIndex) async {
    // print("old/n");
    // print(oldIndex);
    // print("old/n");
    // print(newIndex);
    if (newIndex > this.otherExpenseList!.length) newIndex = this.otherExpenseList!.length;
    if (oldIndex < newIndex) newIndex -= 1;

    setState(() {
      final Expense item = this.otherExpenseList![oldIndex];
      this.otherExpenseList!.removeAt(oldIndex);
      // print(item.title);
      this.otherExpenseList!.insert(newIndex, item);
      // for (var i = 0; i < noteList!.length; i++) {
      //   print(noteList![i].positiona!);
      //   print(noteList![i].id!);
      //   DatabaseHelper().updatePosi(noteList![i].positiona!,noteList![i].id!);
      //
      //
      //   // db.update(
      //   //   'items',
      //   //   {'position': i},
      //   //   where: 'id = ?',
      //   //   whereArgs: [i + 1],
      //   // );
      // }

    });
    // DatabaseHelper().updateItemPosition(oldIndex, newIndex);
    DatabaseHelper().updatelistexpense(this.otherExpenseList!,otherText);

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