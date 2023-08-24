import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:open_file_plus/open_file_plus.dart';

// import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'api_constants.dart';

import 'models/expense.dart';
import 'models/future.dart';
import 'models/note.dart';


class PdfApi {
  static Future<File> generateTable() async {

    SharedPreferences? prefs;

    bool isLoggedIn = false;
    String userId = '';
    String username = '';
    String email = '';


      prefs = await SharedPreferences.getInstance();
      isLoggedIn = prefs?.getBool('loggedIn') ?? false;
      userId = prefs?.getString('userId') ?? '';
      username = prefs?.getString('username') ?? '';
      email = prefs?.getString('email') ?? '';

    // print(userId);


    final pdf = Document();
    List<Map<String, dynamic>> noteLists;
    String? _totalExpense;
    List<Map<String, dynamic>> futureLists;
    List<Map<String, dynamic>> expenseLists;
    // List<Note> noteList = [];
    // List<Note> nextlist = [];
    // List<Expense> expenses = [];
    // List<Fut> sales = [];
    // Future<List<Note>>? _future;

    Future<List<Map<String, dynamic>>> fetchNoteLists({required String notetype}) async {
      final response = await http.get(Uri.parse(
          '${ApiConstants.baseUrl}getnoteslistpdf.php?userid=$userId'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Filter the note lists based on notetype
        if (notetype != null) {
          return List<Map<String, dynamic>>.from(data)
              .where((item) => item['notetype'] == notetype)
              .toList();
        } else {
          return List<Map<String, dynamic>>.from(data);
        }
      } else {
        throw Exception('Failed to fetch note lists');
      }
    }
    Future<List<Map<String, dynamic>>> fetchExpenseLists({required String notetype}) async {
      final response = await http.get(Uri.parse(
          '${ApiConstants.baseUrl}getexpense.php?userid=$userId'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Filter the note lists based on notetype

          print(data);
          return List<Map<String, dynamic>>.from(data);

      } else {
        throw Exception('Failed to fetch note lists');
      }
    }

    print([fetchExpenseLists(notetype: ''),6767]);
    expenseLists = await fetchExpenseLists(notetype: '');
    print(expenseLists.asMap());
    final  datac = expenseLists.map((item) {
      return [
        item['title'],
        item['totalprice'],
        item['etype'],
      ];
    }).toList();



    noteLists = await fetchNoteLists(notetype: 'note');



      // print([noteLists,"enmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm"]);
     final  data = noteLists.map((item) {
        return [
          item['colTitle'],
          item['colTotalprice'],
          item['colemail'],
          item['colnumber'],
          item['coladdress'],
          item['colDeposit'],
          item['colBalance'],
          item['colCollectthisweek'],
       item['colDate'],
        ];
      }).toList();
     futureLists = await fetchNoteLists(notetype: 'future');
      // print([noteLists,"enmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm"]);
     final  datab = futureLists.map((item) {
        return [
          item['colTitle'],
          item['colTotalprice'],
          item['colemail'],
          item['colnumber'],
          item['coladdress'],
          item['colDeposit'],
          item['colBalance'],
          item['colCollectthisweek'],
       item['colDate'],
        ];
      }).toList();

      // Process the note lists
      // print(data);










      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}calculateTotalExpense.php?userid=$userId'),
      );

      if (response.statusCode == 200) {
        // Parse the JSON response
        final data = jsonDecode(response.body);
        var total = double.tryParse(data['totalExpense'] ?? '0.0') ?? 0.0;


          _totalExpense = total.toStringAsFixed(2);


      } else {
        // Calculation failed
        print([response.statusCode, response]);
        throw Exception('Failed to calculate total expense: ${response.statusCode}');
      }






      // var total = (await DatabaseHelper().gettotalExpense())[0]['Total'] == null ? 0:(await DatabaseHelper().gettotalExpense())[0]['Total'];;
      // print(total);
      // setState(() => _totalExpense = total.toStringAsFixed(2));















    final headers = ['Title', 'Total price','Email','Number','Address','Deposit', 'Balance', 'Total Collection', 'Date'];
 //    DatabaseHelper databaseHelper = DatabaseHelper();
 //    noteList = await databaseHelper.getNoteLists();
 //    if (noteList == null) {
 //      noteList = await databaseHelper.getNoteLists();
 // }
 //    final data = noteLists.map((item) => [item.title, item.totalprice,item.email,item.number,item.address, item.deposit, item.balance, item.collectthisweek,   getFormatedDate(item.date) ]).toList();

 //    nextlist = await databaseHelper.getNextLists();
 //    if (nextlist == null) {
 //      nextlist = await databaseHelper.getNextLists();
 // }
 //    final datanextlist = nextlist.map((item) => [item.title, item.totalprice,item.email,item.number,item.address, item.deposit, item.balance, item.collectthisweek,   getFormatedDate(item.date) ]).toList();


    final expensesheaders = ['Title', 'Total price',  'Name'];

 //    expenses = await databaseHelper.getExpensesLists();
 //    if (expenses == null) {
 //      expenses = await databaseHelper.getExpensesLists();
 // }
 //    final dataexpenses = expenses.map((item) => [item.title, item.totalprice, item.expensename, ]).toList();


    final salesheaders = ['Title', 'Total price','Email','Number','Address', 'Deposit', 'Balance', 'Total Collection', 'Date'];

 //    sales = await databaseHelper.getFutureLists();
 //    if (sales == null) {
 //      sales = await databaseHelper.getFutureLists();
 // }
 //    final datasales = sales.map((item) => [item.title, item.totalprice,item.email,item.number,item.address, item.deposit, item.balance, item.collectthisweek,   getFormatedDate(item.date) ]).toList();







      // var total = (await DatabaseHelper().gettotal())[0]['Total'] == null ? 0:(await DatabaseHelper().gettotal())[0]['Total'];
      // var totaln = (await DatabaseHelper().gettotalNext())[0]['Total'] == null ? 0:(await DatabaseHelper().gettotalNext())[0]['Total'];
      // var all = total+totaln ?? 0.0;
      //
      //        ;













    pdf.addPage(MultiPage(
      build: (context) => [
        Center(child: Text("Runnings Jobs", style: TextStyle(fontSize: 24)))
     ,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Total Sales: ",style: TextStyle(fontSize: 24)),
            Text(double.parse((noteLists.length).toString() ?? '0.0').toStringAsFixed(2),style:TextStyle(fontSize: 24),),
          ],
        ),
        Table.fromTextArray(
        headers: headers,
        data: data,
      ),]
    ));
//     pdf.addPage(MultiPage(
//         build: (context) => [
//           Center(child: Text("Next Projects", style: TextStyle(fontSize: 24)))
//           ,
//
//           Table.fromTextArray(
//             headers: headers,
//             data: datanextlist,
//           ),]
//     ));
//
//
//     var totalexpense = (await DatabaseHelper().gettotalExpense())[0]['Total']?? 0.0;
    pdf.addPage(MultiPage(
        build: (context) => [
          Center(child: Text("Expenses", style: TextStyle(fontSize: 24)))
          ,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Total Expenses: ",style: TextStyle(fontSize: 24)),
              Text(double.parse(_totalExpense.toString()  ?? '0.0').toStringAsFixed(2),style:TextStyle(fontSize: 24),),
            ],
          ),
          Table.fromTextArray(
            headers: expensesheaders,
            data: datac,
          ),]
    ));
//
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     //Return String
//     String? stringValue = prefs.getString('stringValueb') ?? "0.0";
//
//
//
//     // String? stringValueb = stringValue.toString() ?? "0.0";
//
//
//
//     pdf.addPage(MultiPage(
//         build: (context) => [
//           Center(child: Text("Sales Projections", style: TextStyle(fontSize: 24)))
//           ,
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text("Total Sales: ",style: TextStyle(fontSize: 24)),
//               Text(double.parse(futureLists.length.toString() ?? '0.0').toStringAsFixed(2),style:TextStyle(fontSize: 24),),
//             ],
//           ),
//           Table.fromTextArray(
//             headers: salesheaders,
//             data: datab,
//           ),]
//     ));
//
// print(data);
    return saveDocument(name: 'Tachie.pdf', pdf: pdf);
  }

  static Future<File> generateImage() async {
    final pdf = Document();

    final imageSvg = await rootBundle.loadString('assets/fruit.svg');
    final imageJpg =
    (await rootBundle.load('assets/person.jpg')).buffer.asUint8List();

    final pageTheme = PageTheme(
      pageFormat: PdfPageFormat.a4,
      buildBackground: (context) {
        if (context.pageNumber == 1) {
          return FullPage(
            ignoreMargins: true,
            child: Image(MemoryImage(imageJpg), fit: BoxFit.cover),
          );
        } else {
          return Container();
        }
      },
    );

    pdf.addPage(
      MultiPage(
        pageTheme: pageTheme,
        build: (context) => [
          Container(
            height: pageTheme.pageFormat.availableHeight - 1,
            child: Center(
              child: Text(
                'Foreground Text',
                style: TextStyle(color: PdfColors.white, fontSize: 48),
              ),
            ),
          ),
          SvgImage(svg: imageSvg),
          Image(MemoryImage(imageJpg)),
          Center(
            child: ClipRRect(
              horizontalRadius: 32,
              verticalRadius: 32,
              child: Image(
                MemoryImage(imageJpg),
                width: pageTheme.pageFormat.availableWidth / 2,
              ),
            ),
          ),
          GridView(
            crossAxisCount: 3,
            childAspectRatio: 1,
            children: [
              SvgImage(svg: imageSvg),
              SvgImage(svg: imageSvg),
              SvgImage(svg: imageSvg),
              SvgImage(svg: imageSvg),
              SvgImage(svg: imageSvg),
              SvgImage(svg: imageSvg),
            ],
          )
        ],
      ),
    );

    return saveDocument(name: 'my_example.pdf', pdf: pdf);
  }

  static Future<File> saveDocument({
    required String name,
    required Document pdf,
  }) async {
    final bytes = await pdf.save();

    final dir = await getExternalStorageDirectory();
    final file = File('${dir?.path}/$name');

    await file.writeAsBytes(bytes);

    return file;
  }

  static Future openFile(File file) async {
    var permissionStatus = await Permission.storage.status;

    switch (permissionStatus) {
      case PermissionStatus.denied:
      case PermissionStatus.permanentlyDenied:
        await Permission.storage.request();
        break;
      default:
    }
    final url = file.absolute.path;
    final status = await Permission.storage.request();
    if (status.isGranted) {
    if (await File(url).existsSync()) {



      final result= await OpenFile.open(url);
      print(result.type);

    } else {
      print('File not found.');
    }}
    // OpenAppFile.open(url);


print(url);

  }
  static getFormatedDate(_date) {
    var inputFormat = DateFormat('yyyy-MM-dd HH:mm');
    var inputDate = inputFormat.parse(_date);
    var outputFormat = DateFormat('MM-dd-yyyy');
    return outputFormat.format(inputDate);
  }
}