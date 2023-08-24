
import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:auto_size_text_field/auto_size_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:ttachienew/utils/database_helper.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:ttachienew/utils/mysql.dart';
import 'NavBar.dart';
import 'bottem_bar.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_platform_interface.dart';

import 'login_page.dart';
import 'models/note.dart';
import 'note_detail.dart';

import 'dart:ui' as ui;
import 'api_constants.dart';


Map<String, double> sums = {};

SharedPreferences? prefs;

bool isLoggedIn = false;
String userId = '';
String username = '';
String email = '';








class HomeScreen extends StatefulWidget {

  String? text1;
  String? text2;
  String? text3;
  String? text4;

  HomeScreen({this.text1,this.text2, this.text3, this.text4});
  @override
  _HomeScreenState createState() => _HomeScreenState(ttt1:text1,ttt2:text2,ttt3:text3,ttt4:text4);
}

const textFieldPadding = EdgeInsets.all(8.0);
const textFieldTextStyle = TextStyle(fontSize: 30.0);
class _HomeScreenState extends State<HomeScreen> {

  Future<void> initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    isLoggedIn = prefs?.getBool('loggedIn') ?? false;
    userId = prefs?.getString('userId') ?? '';
    username = prefs?.getString('username') ?? '';
    email = prefs?.getString('email') ?? '';
    fetchSums();
  }
  final GlobalKey _textFieldKey = GlobalKey();

  double _textWidth = 0.0;
  double? _fontSize = textFieldTextStyle.fontSize;












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
  final TextEditingController _controller = TextEditingController();
  DatabaseHelper databaseHelper = DatabaseHelper();

  List<Note> noteList = [];
  Future<List<Note>>? _future;

  void _onReorder(int oldIndex, int newIndex) async {

    // print("old/n");
    // print(oldIndex);
    // print("old/n");
    // print(newIndex);

    if (newIndex > noteList!.length) newIndex = noteList!.length;
    if (oldIndex < newIndex) newIndex -= 1;

    setState(() {
      final Note item = noteList![oldIndex];
      noteList!.removeAt(oldIndex);

      // print(item.title);
      noteList!.insert(newIndex, item);




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
    DatabaseHelper().updatelist(noteList);






  }




  @override
  void initState() {
    super.initState();
    initPrefs();







    _future ??= databaseHelper.getNoteList();

    totalc.addListener(_onTextChanged);


    // sleep(Duration(seconds: 10));










    current.addListener(_printLatestValue);









  }
  void _printLatestValue() async {

    // final bank = double.tryParse(current.text.toString().replaceAll('', ''));
    // final totalprr = double.parse(totalc.text.toString().replaceAll('', ''));
    // final right = double.parse(expensc.text.toString().replaceAll('', ''));
    // String fin = (totalprr! - right! + bank!).toStringAsFixed(2);
    // afterc.text = fin;


    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    String? stringValue = prefs.getString('stringbankValue');


    prefs.setString('stringbankValue',current.text.toString());

    //
    // final nss = double.parse(stringValue??"0").toStringAsFixed(2);
    //
    //
    // // current.text = ""+nss.toString();
    //
    // var total = (await DatabaseHelper().gettotalCollect())[0]['Total'] == null ? 0:(await DatabaseHelper().gettotalCollect())[0]['Total'];;
    // var totaln = (await DatabaseHelper().gettotalCollectNext())[0]['Total'] == null ? 0:(await DatabaseHelper().gettotalCollectNext())[0]['Total'];;
    // var all = total+totaln;
    //
    //

    final bank = double.tryParse(current.text.toString().replaceAll('', ''));
    final totalprr = double.parse(sums['collectionSum'].toString().replaceAll('', ''));
    final right = double.parse(expensc.text.toString().replaceAll('', ''));
    String fin = (totalprr! - right! + bank!).toStringAsFixed(2);

afterc.text = fin;







    print([double.parse(afterc.text.toString().replaceAll('', '')),"before"]);

    // if (double.parse(afterc.text.toString().replaceAll('', '')) < 0) {
    //   print([double.parse(afterc.text.toString().replaceAll('', '')),"yes"]);
    //   double number = double.parse("0");
    //
    //   setState(() {
    //     afterc.text = number.toStringAsFixed(2);
    //   });
    // }


print("chanes");
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree
    current.dispose();
    super.dispose();
  }





  // updateItemPosition(int oldIndex, int newIndex) async {
  //   Directory directory = await getApplicationDocumentsDirectory();
  //   String path = directory.path + 'notes.db';
  //   Database db = await openDatabase(path);
  //   if (newIndex > oldIndex) {
  //     for (int i = oldIndex; i < newIndex; i++) {
  //       await db.rawUpdate(
  //           'UPDATE note_table SET position = position - 1 WHERE position = ?',
  //           [i + 1]);
  //     }
  //   } else {
  //     for (int i = oldIndex; i > newIndex; i--) {
  //       await db.rawUpdate(
  //           'UPDATE note_table SET position = position + 1 WHERE position = ?',
  //           [i - 1]);
  //     }
  //   }
  //   await db.rawUpdate('UPDATE note_table SET position = ? WHERE position = ?',
  //       [newIndex, oldIndex]);
  //   if (_future == null) {
  //     _future = databaseHelper.getNoteList();
  //
  //   }
  // }













  void _onTextChanged() {
    // substract text field padding to get available space
    final inputWidth = _textFieldKey.currentContext!.size!.width - textFieldPadding.horizontal;

    // calculate width of text using text painter
    final textPainter = TextPainter(
      textDirection: ui.TextDirection.ltr,
      text: TextSpan(
        text: totalc.text,
        style: textFieldTextStyle,
      ),
    );
    textPainter.layout();

    var textWidth = textPainter.width;
    var fontSize = textFieldTextStyle.fontSize;

    // not really efficient and doesn't find the perfect size, but you got all you need!
    while (textWidth > inputWidth && fontSize! > 1.0) {
      fontSize -= 0.5;
      textPainter.text = TextSpan(
        text: totalc.text,
        style: textFieldTextStyle.copyWith(fontSize: fontSize),
      );
      textPainter.layout();
      textWidth = textPainter.width;
    }

    setState(() {
      _textWidth = textPainter.width;
      _fontSize = fontSize!;
    });
  }














  void addStringToSF(valaue) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('stringValue',valaue);
  }
  void addStringToSFbank(valaue) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('stringbankValue',valaue);
  }

  void getStringValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    String? stringValue = prefs.getString('stringValue');




final nss = double.parse(stringValue?? "0").toStringAsFixed(2);

    statica.text = ""+nss.toString();

  }

  Future<Map<String, double>> fetchExpenseSums() async {
    final response = await http.get(Uri.parse('${ApiConstants.baseUrl}hometotals.php?userid=$userId&notetype=note'));

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

  String? _totalprice;
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
  void _calcTotal() async{
//     var total = (await DatabaseHelper().gettotal())[0]['Total'] == null ? 0:(await DatabaseHelper().gettotal())[0]['Total']??0;
//     var totaln = (await DatabaseHelper().gettotalNext())[0]['Total'] == null ? 0:(await DatabaseHelper().gettotalNext())[0]['Total']??0;
//
//     final database = MySqlDatabase();
//     final results = await database.getFutureMapList();
//     print(["here my sql result",results]);
//     await database.closeConnection();
//
//
//
//
//
// var all = total+totaln;
//     print(all);
    setState(() => _totalprice = sums['totalPriceSum']?.toStringAsFixed(2));
    totalc.text =  _totalprice.toString()  == "null" ? "":""+_totalprice.toString();           ;
  }

  String? _totalExpense;

  void _calcTotalExpense() async{


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
      expensc.text =  _totalExpense.toString()  == "null" ? "":""+_totalExpense.toString();           ;
    } else {
      // Calculation failed
      print([response.statusCode, response]);
      throw Exception('Failed to calculate total expense: ${response.statusCode}');
    }






    // var total = (await DatabaseHelper().gettotalExpense())[0]['Total'] == null ? 0:(await DatabaseHelper().gettotalExpense())[0]['Total'];;
    // print(total);
    // setState(() => _totalExpense = total.toStringAsFixed(2));
    getStringbankValuesSF();
  }



  String? _totaldeposit;

  void _calcDeposit() async{
    // var total = (await DatabaseHelper().gettotalDeposit())[0]['Total'] == null ? 0:(await DatabaseHelper().gettotalDeposit())[0]['Total']??0;;
    // var totaln = (await DatabaseHelper().gettotalDepositNext())[0]['Total'] == null ? 0:(await DatabaseHelper().gettotalDepositNext())[0]['Total']??0;;
    // var all = total+totaln;
    // print(total);
    setState(() => _totaldeposit = sums['depositSum']?.toStringAsFixed(2));
    depositc.text = _totaldeposit.toString()  == "null" ? "":""+_totaldeposit.toString();
  }
  String? _totalbalance;

  void _calcBalance() async{
    // var total = (await DatabaseHelper().gettotalBalance())[0]['Total']  == null ? 0:(await DatabaseHelper().gettotalBalance())[0]['Total']??0;
    // var totaln = (await DatabaseHelper().gettotalBalanceNext())[0]['Total']  == null ? 0:(await DatabaseHelper().gettotalBalanceNext())[0]['Total']??0;
    // var all = total+totaln;
    // print(total);
    setState(() => _totalbalance = sums['balanceSum']?.toStringAsFixed(2));
    balancec.text = _totalbalance.toString()  == "null" ? "":""+_totalbalance.toString();
  }
  String? _totalcollect;

  void _calcCollect() async{
    // var total = (await DatabaseHelper().gettotalCollect())[0]['Total'] == null ? 0:(await DatabaseHelper().gettotalCollect())[0]['Total'];;
    // var totaln = (await DatabaseHelper().gettotalCollectNext())[0]['Total'] == null ? 0:(await DatabaseHelper().gettotalCollectNext())[0]['Total'];;
    // var all = total+totaln;
    // print(total);
    setState(() => _totalcollect = sums['collectionSum']?.toStringAsFixed(2));
    collectionc.text =_totalcollect.toString()  == "null" ? "":""+_totalcollect.toString();
  }

  int count = 0;

  void getStringbankValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    String? stringValue = prefs.getString('stringbankValue');




    final nss = double.parse(stringValue??="0").toStringAsFixed(2);

print([stringValue,nss,"bansktest"]);

  //    final bank = double.tryParse(stringValueb);
  // var tonow =  _totalcollect==null?0:_totalcollect;
  // var exnoew =  expensc.text.toString()==""?"0":expensc.text.toString();
  //
  //   final totalprr = double.parse(tonow.toString().replaceAll('', ''));
  //   final right = double.parse(exnoew.toString().replaceAll('', ''));
  //   String fin = (totalprr! - right! + bank!).toStringAsFixed(2);
  //   afterc.text = fin;






    current.text = ""+nss.toString();

    // var total = (await DatabaseHelper().gettotalCollect())[0]['Total'] == null ? 0:(await DatabaseHelper().gettotalCollect())[0]['Total'];;
    // var totaln = (await DatabaseHelper().gettotalCollectNext())[0]['Total'] == null ? 0:(await DatabaseHelper().gettotalCollectNext())[0]['Total'];;
    // var all = total+totaln;



    final bank = double?.tryParse(current.text.toString().replaceAll('', ''));
    final totalprr = double.parse(sums['collectionSum'].toString().replaceAll('', ''));
    final right = double.tryParse(expensc.text.toString().replaceAll('', ''));
    String fin = (totalprr! - right! + bank!).toStringAsFixed(2);


    // if(double.parse(fin) < 0){
    //
    //
    //   double number = double.parse("0");
    //
    //   setState(() {
    //     afterc.text = number.toStringAsFixed(2);
    //   });
    //
    //
    //   // afterc.text = fin;
    //
    // }else{
      afterc.text = fin;
    // }



    print([stringValue,"this",totalprr,bank.toString(),right.toString()]);




  }

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

        title: Text("Home",style: TextStyle(fontSize: 30.0,fontWeight: FontWeight.w600,color: Colors.white),),
        centerTitle: true,
      ),

      backgroundColor: Color.fromARGB(255,55, 69, 80),
      body:  WillPopScope(
    onWillPop: () async {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
      return false;
    },


      child: SingleChildScrollView(

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
                           child: Text("Total Sales",textAlign: TextAlign.center,style: TextStyle(fontSize: 34.0,fontWeight: FontWeight.w600,color: Colors.white),),
                         ),




                         // Padding(
                         //   padding: EdgeInsets.all(16.0),
                         //   child: Column(
                         //     crossAxisAlignment: CrossAxisAlignment.stretch,
                         //     children: <Widget>[
                         //       TextField(
                         //         key: _textFieldKey,
                         //         controller: totalc,
                         //         decoration: InputDecoration(
                         //           border: InputBorder.none,
                         //           fillColor: Colors.orange,
                         //           filled: true,
                         //           contentPadding: textFieldPadding,
                         //         ),
                         //         style: textFieldTextStyle.copyWith(fontSize: _fontSize),
                         //       ),
                         //
                         //     ],
                         //   ),
                         // ),
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
                                 key: _textFieldKey,
                                 minLines: 1,
                                 maxLines: 1,
                                 readOnly: true,
                                 controller: totalc,
                                 onTap: () => _calcTotal(),
                                 keyboardType: TextInputType.number,
                                 textAlign: TextAlign.center,
                                 decoration: InputDecoration
                                   (
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
                                     hintStyle: TextStyle(color: Color.fromARGB(255,255, 255, 0),fontSize:  30.0,fontWeight: FontWeight.w900,)
                                 ),
                                 style: TextStyle(color: Color.fromARGB(255,255, 255, 0),fontSize:   30.0,fontWeight: FontWeight.w900,),
                               )),
                             ),
                           ),
                         ),
                         SizedBox(height: 70,),

                         // Row(
                         //   children: <Widget>[
                         //     Expanded( // Constrains AutoSizeTextField to the width of the Row
                         //         child: AutoSizeTextField(
                         //           controller: totalc,
                         //
                         //         )
                         //     ),
                         //   ],
                         // )
                         // ,
                         // ConstrainedBox(
                         //   constraints: BoxConstraints(
                         //     maxHeight: 250,
                         //
                         //     maxWidth:  200,
                         //
                         //   ),
                         //   child:  AutoSizeTextField(
                         //     decoration: InputDecoration
                         //       (
                         //       isDense: true,
                         //     contentPadding:  EdgeInsets.all(3.0),),
                         //       controller: _controller,
                         //       minFontSize: 2,
                         //       style: TextStyle(fontSize: 64),
                         //     ),
                         //   ),
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






                                 ConstrainedBox(

                                   constraints: BoxConstraints(


                                     maxWidth:  MediaQuery.of(context).size.width,

                                   ),
                                   child:
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
                                     padding:  EdgeInsets.symmetric(horizontal: 24.0),

                                     child: Center(child: AutoSizeTextField(
                                       minFontSize: 1,
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
                                 ), ),
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
                                     child: Text("Total Balance",style: TextStyle(fontSize: 21.0,fontWeight: FontWeight.w600,color: Colors.white),),
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
                                         controller: balancec,
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
                                     child: Text("Total Collections",textAlign: TextAlign.center,style: TextStyle(fontSize: 21.0,fontWeight: FontWeight.w600,color: Colors.white),),
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
                                         controller: collectionc,
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
                         Row(
                           mainAxisAlignment: MainAxisAlignment.spaceAround,
                           crossAxisAlignment: CrossAxisAlignment.center ,
                           children: [

                             Column(
                                 mainAxisAlignment: MainAxisAlignment.start,
                                 children:<Widget>[
                                   Padding(
                                     padding:  EdgeInsets.all(15),

                                     child: Text("Total Expenses",textAlign: TextAlign.center,style: TextStyle(fontSize: 21.0,fontWeight: FontWeight.w600,color: Colors.white),),
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
                                       child: Center(child: Focus(
                                         child: AutoSizeTextField(
                                           controller: expensc,
                                           readOnly: true,
                                           inputFormatters: <TextInputFormatter>[
                                             // for below version 2 use this
                                             FilteringTextInputFormatter.allow(RegExp('[0-9.]')),
                                           ],
                                           keyboardType: TextInputType.numberWithOptions(decimal: true),
                                           textAlign: TextAlign.center,
                                           onChanged: (value){

                                             final right = double.tryParse(value.toString().replaceAll('', ''));
                                             final totalprr = double.parse(_totalprice.toString().replaceAll('', ''));
                                             print(totalprr);
                                             final bank = double.parse(current.text.toString().replaceAll('', ''));
                                             String fin = (totalprr! - right! + bank!).toStringAsFixed(2);
                                             afterc.text = fin;

                                             // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                             //   content: Text(fin),
                                             // ));

                                           },
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
                                         ),
                                         onFocusChange: (hasFocus) {
                                           if (hasFocus) {

                                             if(current.text.isNotEmpty){
                                               final value = double.tryParse(current.text.replaceAll('', '')) ?? 0;
                                               current.text = (value.toStringAsFixed(2));
                                             }

                                           }
                                         },
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







                         SizedBox(height: 50,),


                         Center(



                           child:  Text("Enter",style: TextStyle(fontSize: 24,fontWeight: FontWeight.w500,color: Colors.white),),

                         ),
                         Center(



                           child:  Text("Amount currently in your bank",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500,color: Colors.white),),

                         ),
                         SizedBox(height: 20,),

                         Row(
                           mainAxisSize: MainAxisSize.max,
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           crossAxisAlignment: CrossAxisAlignment.center,

                           children: [



                             Container(
                               height: 30.0,

                               decoration: BoxDecoration(
                                   color: Color.fromARGB(255,255, 255, 0),
                                   shape: BoxShape.circle
                               ),
                               child: IconButton(
                                 icon: Icon(Icons.remove),
                                 onPressed: () {
                                   double currentValue = double.parse(current.text.replaceAll('', ''));
                                   setState(() {
                                     print("Setting state");
                                     currentValue--;
                                     current.text = (currentValue).toStringAsFixed(2); // decrementing value

                                     if(double.parse(current.text .toString()).toInt() <  0){

                                       double number = double.parse("0");

                                       setState(() {
                                         current.text  = number.toStringAsFixed(2); 
                                       });


                                     }




                                     //
                                     // final bank = double.tryParse(current.text.toString().replaceAll('', ''));
                                     // final totalprr = double.parse(_totalcollect.toString().replaceAll('', ''));
                                     // final right = double.parse(expensc.text.toString().replaceAll('', ''));
                                     // String fin = (totalprr! - right! + bank!).toStringAsFixed(2);
                                     // afterc.text = fin;
                                   });
                                 },
                                 iconSize: 15,
                               ),
                             ),
                             SizedBox(width: 10,),
                             Container(
                               height: 80,
                               width: MediaQuery.of(context).size.width * 0.60,
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
                                 child: Center(child: Focus(
                                   child: AutoSizeTextField(
                                     controller: current,
                                     onChanged: (value){
                                       addStringToSFbank(value);
                                       // final bank = double.tryParse(value.toString().replaceAll('', ''));
                                       // final totalprr = double.parse(_totalcollect.toString().replaceAll('', ''));
                                       // final right = double.parse(expensc.text.toString().replaceAll('', ''));
                                       // String fin = (totalprr! - right! + bank!).toStringAsFixed(2);
                                       // afterc.text = fin;

                                       // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                       //   content: Text(fin),
                                       // ));

                                     },
                                     inputFormatters: <TextInputFormatter>[
                                       // for below version 2 use this
                                       FilteringTextInputFormatter.allow(RegExp('[0-9.]')),
                                     ],
                                     keyboardType: TextInputType.numberWithOptions(decimal: true),
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
                                   ),
                                   onFocusChange: (hasFocus) {
                                     if (hasFocus) {

                                       if(expensc.text.isNotEmpty){
                                         final value = double.tryParse(expensc.text.replaceAll('', '')) ?? 0;
                                         expensc.text = (value.toStringAsFixed(2));
                                       }

                                     }
                                   },
                                 )),
                               ),

                             ),
                             SizedBox(width: 10,),
                             Container(

                               height: 30.0,

                               decoration: BoxDecoration(
                                   color: Color.fromARGB(255,255, 255, 0),
                                   shape: BoxShape.circle
                               ),

                               child: IconButton(
                                 icon: Icon(Icons.add),
                                 onPressed: () {
                                   print(current.text);
                                   double currentValue = current.text.isEmpty ? 0 : double.parse(current.text.replaceAll('', ''));
                                   print(currentValue);
                                   setState(() {
                                     print("Setting state");
                                     currentValue++;
                                     current.text = (currentValue).toStringAsFixed(2); // decrementing value

                                     // final bank = double.tryParse(current.text.toString().replaceAll('', ''));
                                     // final totalprr = double.parse(_totalcollect.toString().replaceAll('', ''));
                                     // final right = double.parse(expensc.text.toString().replaceAll('', ''));
                                     // String fin = (totalprr! - right! + bank!).toStringAsFixed(2);
                                     // afterc.text = fin;
                                   });
                                 },
                                 iconSize: 15,
                               ),
                             ),
                           ],
                         ),

                         SizedBox(height: 50,),
                         Center(


                           child:   Text("Bottom Line",   textAlign: TextAlign.center, style: TextStyle(fontSize: 21,fontWeight: FontWeight.w500,color: Colors.white),),


                         ),              Center(


                           child:   Text("After expenses",   textAlign: TextAlign.center, style: TextStyle(fontSize: 19,fontWeight: FontWeight.w500,color: Colors.white),),


                         ),            Center(


                           child:   Text("are paid Are you UP? or DOWN this week?",textAlign: TextAlign.center,style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500,color: Colors.white),),


                         ),
                         SizedBox(height: 20,),
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
                               padding:  EdgeInsets.all(1),

                               child: Center(child: AutoSizeTextField(
                                 keyboardType: TextInputType.number,
                                 textAlign: TextAlign.center,
                                 controller: afterc,
                                 readOnly: true,
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
                                   hintStyle: TextStyle(color: Color.fromARGB(255,255, 255, 0),fontSize: 30.0,fontWeight: FontWeight.w900),

                                 ),

                                 style: TextStyle(color: Color.fromARGB(255,255, 255, 0),fontSize: 30.0,fontWeight: FontWeight.w900,),
                               )),
                             ),
                           ),
                         ),

                         // SizedBox(height: 50,),
                         // Center(
                         //
                         //
                         //   child:   Text("At the end of this week",   textAlign: TextAlign.center, style: TextStyle(fontSize: 21,fontWeight: FontWeight.w500,color: Colors.white),),
                         //
                         //
                         // ),              Center(
                         //
                         //
                         //   child:   Text("How much would you like",   textAlign: TextAlign.center, style: TextStyle(fontSize: 19,fontWeight: FontWeight.w500,color: Colors.white),),
                         //
                         //
                         // ),        Center(
                         //
                         //
                         //   child:   Text("After expenses?",   textAlign: TextAlign.center, style: TextStyle(fontSize: 19,fontWeight: FontWeight.w500,color: Colors.white),),
                         //
                         //
                         // ),                 Center(
                         //
                         //
                         //   child:   Text("Be generous with yourself!",textAlign: TextAlign.center,style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500,color: Colors.white),),
                         //
                         //
                         // ),






                         // SizedBox(height:20,),
                         // Center(
                         //
                         //   child: Container(
                         //
                         //     height: 80,
                         //     width: MediaQuery.of(context).size.width * 0.80,
                         //     decoration: BoxDecoration(
                         //       boxShadow: <BoxShadow>[
                         //         BoxShadow(color: Colors.white10, offset: Offset(0, -4)),
                         //         BoxShadow(color: Colors.white10, offset: Offset(0, 4)),
                         //         BoxShadow(color: Colors.black, offset: Offset(-4, -4)),
                         //         BoxShadow(color: Colors.black, offset: Offset(-4, -4)),
                         //       ],
                         //       color: Color.fromARGB(255,55, 69, 80),
                         //
                         //       borderRadius: BorderRadius.circular(17),
                         //     ),
                         //     child: Padding(
                         //       padding:  EdgeInsets.all(1),
                         //
                         //       child: Center(child: AutoSizeTextField(
                         //         keyboardType: TextInputType.number,
                         //         textAlign: TextAlign.center,
                         //         controller: statica,
                         //
                         //         decoration: InputDecoration(
                         //           isDense: true,
                         //           contentPadding:  EdgeInsets.all(3.0),
                         //           border: OutlineInputBorder(
                         //             borderRadius: BorderRadius.circular(10),
                         //             borderSide:  BorderSide(
                         //               width: 0,
                         //               style: BorderStyle.none,
                         //             ),
                         //           ),
                         //           hintText: "0.00",
                         //           hintStyle: TextStyle(color: Color.fromARGB(255,255, 255, 0),fontSize: 30.0,fontWeight: FontWeight.w900),
                         //
                         //         ),
                         //         onChanged: (value){
                         //           addStringToSF(value);
                         //
                         //         },
                         //         // onFieldSubmitted: (value){
                         //         //   addStringToSF(value);
                         //         // },
                         //         style: TextStyle(color: Color.fromARGB(255,255, 255, 0),fontSize: 30.0,fontWeight: FontWeight.w900,),
                         //       )),
                         //     ),
                         //   ),
                         // ),

                       ],
                     ),

                   ),

                 ),
               ),













               SizedBox(height:20,),

    // Text("Runnings Jobs",   textAlign: TextAlign.center, style: TextStyle(fontSize: 34.0,fontWeight: FontWeight.w500,color: Colors.white),),
    //
    //            SizedBox(height:20,),


    //
    // ConstrainedBox(
    //                constraints: BoxConstraints(
    //                  maxHeight: 250,
    //
    //
    //
    //                ),
    //
    //                            child: FutureBuilder(
    //                                future: _future,
    //                                builder: (BuildContext context, AsyncSnapshot
    //                                snapshot) {
    //                                  if (snapshot.data == null) {
    //                                    return Text('Loading');
    //                                  } else {
    //                                    if (snapshot.data.length < 1) {
    //                                      return Center(
    //                                        child: Text('No Messages, Create New   one'),
    //                                      );
    //                                    }
    //
    //                                    noteList = snapshot.data;
    //                                    return ReorderableListView(
    //                                      children: List.generate(
    //                                        snapshot.data.length,
    //                                            (index) {
    //                                          return  Card(
    //                                              color: Color.fromARGB(255, 102, 116, 128),
    //                                              elevation: 2.0,
    //                                            key: ValueKey(this.noteList![index]),
    //                                            child:
    //
    //                                            ListTile(
    //                                            key: Key('$index'),
    //                                            leading: CircleAvatar(
    //                                              backgroundColor: getPriorityColor(this.noteList![index].priority!),
    //                                              child: getPriorityIcon(this.noteList![index].priority!),
    //                                            ),
    //
    //                                            title: Text(this.noteList![index].title!, style: TextStyle(fontSize: 30,fontWeight: FontWeight.w500,color: Colors.white),),
    //
    //                                            subtitle:  Row(
    //                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                                              children: [
    //                                                Text("Sold: "+getFormatedDate(this.noteList![index].date!)+"",style: TextStyle(color: Color.fromARGB(250, 250, 250,  0) , fontSize: 14, fontWeight: FontWeight.bold ),),
    //                                                Text(double.parse(this.noteList![index].totalprice!).toStringAsFixed(2),style: TextStyle(color: Color.fromARGB(250, 250, 250,  0), fontSize: 14, fontWeight: FontWeight.bold ),),
    //                                              ],
    //                                            ),
    //
    //
    //
    //                                            // Text(getFormatedDate(this.noteList![index].date!)+"           "+this.noteList![index].totalprice!,style:TextStyle(fontSize: 15,fontWeight: FontWeight.w500,color: Color.fromARGB(250, 250, 250,  0)),),
    //
    //                                            trailing: GestureDetector(
    //                                              child: Icon(Icons.delete, color: Colors.red,),
    //                                              onTap: () {
    //                                                _delete(context, noteList![index]);
    //                                              },
    //                                            ),
    //
    //                                            onTap: () {
    //                                              navigateToDetail(this.noteList![index],'Edit Client');
    //                                            },
    //                                          ),);
    //                                        },
    //                                      ).toList(),
    //                                      onReorder: _onReorder,
    //                                    );
    //                                  }
    //                                }
    //                                ),
    // )
    //                    ,

               // Container(
               //   height: 30,
               //   // color: Colors.grey[300],
               //   child: Row(
               //     mainAxisAlignment: MainAxisAlignment.center,
               //     children: [
               //       Text(
               //         'Brought to you by',
               //         style: TextStyle(
               //           color: Color.fromARGB(255,255, 255, 0),
               //           fontSize: 16,
               //           fontWeight: FontWeight.bold,
               //         ),
               //       ),
               //       // SizedBox(width: 5),
               //       // Image.asset(
               //       //   'assets/logonew.png',
               //       //   height: 30,
               //       // ),
               //
               //     ],
               //   ),
               // ),
               BottomBar()





















































             ]),






      ),),

      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: Color.fromARGB(255,55, 69, 80),
      //   onPressed: () {
      //     debugPrint('FAB clicked');
      //     navigateToDetail(Note('', '',0, '','','','',2), 'Add Client');
      //   },
      //
      //   tooltip: 'Add Note',
      //
      //   child: Icon(Icons.add),
      //
      // ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,



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
  ListView getNoteListView() {

    TextStyle? titleStyle = Theme.of(context).textTheme.subtitle1;

    return ListView.builder(

      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: Color.fromARGB(255, 102, 116, 128),
          elevation: 2.0,
          child: ListTile(

            leading: CircleAvatar(
              backgroundColor: getPriorityColor(this.noteList![position].priority!),
              child: getPriorityIcon(this.noteList![position].priority!),
            ),

            title: Text(this.noteList![position].title!, style: TextStyle(fontSize: 30,fontWeight: FontWeight.w500,color: Colors.white),),

            subtitle: Text(getFormatedDate(this.noteList![position].date!)+"           "+this.noteList![position].totalprice!,style:TextStyle(fontSize: 15,fontWeight: FontWeight.w500,color: Color.fromARGB(250, 250, 250,  0)),),

            trailing: GestureDetector(
              child: Icon(Icons.delete, color: Colors.grey,),
              onTap: () {
                _delete(context, noteList![position]);
              },
            ),


            onTap: () {
              debugPrint("ListTile Tapped");
              navigateToDetail(this.noteList![position],'Edit Client');
            },

          ),
        );
      },
    );
  }
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

  void _delete(BuildContext context, Note note) async {

    int result = await databaseHelper.deleteNote(note.id!);
    if (result != 0) {
      _showSnackBar(context, 'Note Deleted Successfully');
      updateListView();
      // Navigator.of(context).pushReplacement(
      //     MaterialPageRoute(builder: (context) => HomeScreen()));
    }

  }

  void _showSnackBar(BuildContext context, String message) {

    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void  navigateToDetail(Note note, String title) async {
    bool result = await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return NoteDetail(note, title);
    }));

    if (result == true) {
      updateListView();
    }
  }
  void updateListView() {

    // final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    // dbFuture.then((database) {
    //
    //   Future<List<Note>> noteListFuture = databaseHelper.getNoteList();
    //   noteListFuture.then((noteList) {
        setState(() {
          _future = databaseHelper.getNoteList();
          _calcTotal();
          _calcDeposit();
          _calcBalance();
          _calcCollect();
          _calcTotalExpense();
          getStringValuesSF();
          getStringbankValuesSF();
          // this._future = noteList as Future<List<Note>>?;
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