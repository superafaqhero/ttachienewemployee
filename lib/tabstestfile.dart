import 'dart:convert';

import 'package:auto_size_text_field/auto_size_text_field.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'NavBar.dart';
import 'bottem_bar.dart';
import 'home_screen.dart';
import 'models/note.dart';
import 'note_detail.dart';
import 'notedetailapi.dart';
import 'api_constants.dart';
List<String> data = ["Running's job"];
bool isIdNotExists(int id, List<dynamic> array) {
  if (id <= array.length) {
    return array[id - 1] != null;
  }
  return true;
}

List<dynamic> _data = [];
// saveDataToPrefs() async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   String dataJson = jsonEncode(data);
//   await prefs.setString('data', dataJson);
// }
//
// loadDataFromPrefs() async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   String? dataJson = prefs.getString('data');
//   if (dataJson != null) {
//     data = List<String>.from(jsonDecode(dataJson));
//   }
// }



SharedPreferences? prefs;

bool isLoggedIn = false;
String userId = '';
String username = '';
String email = '';
String role = '';


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {

  void initState(){
    _fetchData();
    initPrefs();
  }

  Future<void> initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    isLoggedIn = prefs?.getBool('loggedIn') ?? false;
    userId = prefs?.getString('userId') ?? '';
    username = prefs?.getString('username') ?? '';
    email = prefs?.getString('email') ?? '';


    role = prefs?.getString('role') ?? '';
    loadDataFromPrefs();


  }
  saveDataToPrefs() async {
    print("saving");
    String dataJson = jsonEncode(data);

    var response = await http.post(Uri.parse('${ApiConstants.baseUrl}update_tabs.php?type=2'), body: {
      'user_id': userId,
      'data_json': dataJson,
      'type': 'running',
    });
    print(response.body);
    if (response.statusCode == 200) {
      // Data saved successfully
    } else {
      // Handle error
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('Error updating data'),
              actions: <Widget>[
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                ),
              ],
            );});
    }
  }
  loadDataFromPrefs() async {


    var response = await http.get(Uri.parse('${ApiConstants.baseUrl}get_tabs.php?type=running&userid='+userId));

    if (response.statusCode == 200) {
      print([jsonDecode(response.body),"holahu"]);
      final er = jsonDecode(response.body)["running"];
      print(er);
      final jsonData = jsonDecode(response.body);
      final namesJsonString = jsonData['running'];
      final List<dynamic> namesJson = jsonDecode(namesJsonString);
      // Update your app's state with loadedData
      setState(() {
        data = List<String>.from(namesJson);
      });
    } else {
      // Handle error
      print("anaaa");
    }
  }

  int initPosition = 0;
  Future<void> _fetchData() async {
    final response = await http.get(Uri.parse('${ApiConstants.baseUrl}api.php?type=1'));
    final jsonData = json.decode(response.body);
    setState(() {
      _data = jsonData;
      print(_data);

    });
    print(jsonData);
    List<dynamic> filteredData = _data.where((element) => element['colId'] == 1).toList();
    print(filteredData);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavBar(),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Color.fromARGB(255, 255, 255, 0)),
        backgroundColor: Colors.black45,
        centerTitle: true,
        // leading: IconButton(
        //   icon: Icon(Icons.arrow_back),
        //   onPressed: () {
        //     Navigator.of(context).pushReplacement(
        //         MaterialPageRoute(builder: (context) => HomeScreen()));
        //   },
        // ),
        title: Text('Running Jobs'),
        actions: [
          PopupMenuButton(
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                    child: Text('Delete Tab'),
                    onTap: () {
                      Future<void>.delayed(
                          const Duration(), // OR const Duration(milliseconds: 500),
                              () =>
                              showDeleteItemsDialog(context, data)


                      );
                    }

                ),

                PopupMenuItem(
                  child: Text('Add New tab'),
                  onTap: () {
                    Future<void>.delayed(
                        const Duration(),  // OR const Duration(milliseconds: 500),
                            () =>
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {

                                String newPage = '';

                                return Theme(
                                  data: ThemeData(
                                    dialogBackgroundColor: Colors.grey[500],
                                    textTheme: TextTheme(
                                      headline6: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  child:AlertDialog(
                                    title: Text('Add New Page'),
                                    content:   Container(
                                      width: MediaQuery.of(context).size.width * 0.85,

                                      child: TextField(
                                        onChanged: (value) {
                                          newPage = value;
                                        },
                                        cursorColor: Color.fromARGB(255,255, 255, 0),
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Colors.grey[500],

                                          border: OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                            borderRadius: BorderRadius.circular(10.0),
                                          ),
                                          labelText: 'Page Name',
                                          floatingLabelAlignment: FloatingLabelAlignment.center,
                                          labelStyle: TextStyle(
                                              color: Color.fromARGB(255,255, 255, 0)
                                          ),
                                          hintText: "Page Name",
                                          alignLabelWithHint: true,


                                          hintStyle: TextStyle(color: Color.fromARGB(255,255, 255, 0),fontSize: 14.0,fontWeight: FontWeight.w900,),
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(color: Color.fromARGB(255,255, 255, 0)),
                                          ),
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(color: Color.fromARGB(255,255, 255, 0)),
                                          ),
                                        ),
                                        style: TextStyle(color: Color.fromARGB(255,255, 255, 0),fontSize: 18.0,fontWeight: FontWeight.w900,),

                                      ),),
                                    actions: <Widget>[
                                      TextButton(
                                        style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty.all<Color>(Colors.yellow), // set button background color
                                        ),
                                        child: Text('Cancel'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      TextButton(
                                        style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty.all<Color>(Colors.yellow), // set button background color
                                        ),
                                        child: Text('Save'),
                                        onPressed: () {
                                          setState(() {
                                            if (newPage != null && newPage.isNotEmpty) {
                                              data.add(newPage);
                                              saveDataToPrefs();
                                            }
                                          });
                                          Navigator.of(context).pop();
                                        },
                                      ),

                                    ],
                                  ),);
                              },
                            )

                    );



                  },
                ),












                // PopupMenuItem(
                //   child: Text('Option 2'),
                // ),
                // PopupMenuItem(
                //   child: Text('Option 3'),
                // ),
              ];
            },
            icon: Icon(Icons.more_vert),
          ),
        ],
      ),

      body: SafeArea(
        child: CustomTabView(
          initPosition: initPosition,
          itemCount: data.length,
          tabBuilder: (context, index) => Tab(text: data[index]),
          pageBuilder: (context, index) => Center(child: Text(data[index])),
          onPositionChange: (index) {
            print('current position: $index');
            initPosition = index;
          },
          onScroll: (position) => print('$position'),
        ),
      ),






      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromARGB(255,55, 69, 80),
        onPressed: () {
          List<dynamic> _datab = [
            {
              'colId': '',
              'colTitle': '',
              'colDescription': '',
              'colemail': '',
              'colnumber': '',
              'coladdress': '',
              'colTotalprice': '',
              'colDeposit': '',
              'colBalance': '',
              'colCollectthisweek': '',
              'colPriority': '',
              'colposition': '',
              'colDate': '',
              'tabid': '',
              'userid': '',
            },
          ];

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NoteDetailapi(_datab[0], "Edit CLient","","note"),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),

    );
  }
  void showDeleteItemsDialog(BuildContext context, List<String> data) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Tab'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(data.length, (index) {

              if (index != 0) {
                return ListTile(
                  title: Text(data[index]),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Confirm Deletion'),
                          content: Text('Are you sure you want to delete this item?'),
                          actions: <Widget>[
                            TextButton(
                              child: Text('Cancel'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              child: Text('Delete'),
                              onPressed: () {
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();

                                setState(() {
                                  // Remove the item from the list
                                  data.removeAt(index);
                                  updateRows(index);
                                  saveDataToPrefs();
                                });
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                );
              } else {
                return Container(); // Empty container for the excluded item
              }


            }),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  void updateRows(int id) async {
    var url = Uri.parse('${ApiConstants.baseUrl}update_rows.php?id=$id&userid=$userId');

    print(url);
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        print('Rows updated successfully');
      } else {
        print('Error updating rows: ${response.statusCode}');
      }
    } catch (e) {
      print('Error updating rows: $e');
    }
  }

}

class CustomTabView extends StatefulWidget {
  const CustomTabView({
    super.key,
    required this.itemCount,
    required this.tabBuilder,
    required this.pageBuilder,
    this.stub,
    this.onPositionChange,
    this.onScroll,
    this.initPosition,
  });

  final int itemCount;
  final IndexedWidgetBuilder tabBuilder;
  final IndexedWidgetBuilder pageBuilder;
  final Widget? stub;
  final ValueChanged<int>? onPositionChange;
  final ValueChanged<double>? onScroll;
  final int? initPosition;

  @override
  CustomTabsState createState() => CustomTabsState();
}

class CustomTabsState extends State<CustomTabView>
    with TickerProviderStateMixin {
  late TabController controller;
  late int _currentCount;
  late int _currentPosition;
  List<dynamic> imagesfirst = [];

  @override
  void initState() {
    _fetchData();

    _currentPosition = widget.initPosition ?? 0;
    controller = TabController(
      length: widget.itemCount,
      vsync: this,
      initialIndex: _currentPosition,
    );
    controller.addListener(onPositionChange);
    controller.animation!.addListener(onScroll);
    _currentCount = widget.itemCount;

    super.initState();
    fetchimagesforfirst();
  }
  Future<void> fetchimagesforfirst() async {
    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}first_image_of_note.php?userID=$userId'),
    );

    if (response.statusCode == 200) {
      setState(() {
        imagesfirst = json.decode(response.body);


      });
      if(imagesfirst.isNotEmpty){
        List<dynamic> filteredList = imagesfirst
            .where((element) => element['note_id'] == "12")
            .toList();
        print([filteredList[0]["image_path"],"filteredimages"]);}
      print([imagesfirst,"keraha"]);
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> _fetchData() async {
    final response = await http.get(Uri.parse('${ApiConstants.baseUrl}api.php?type=1'));
    final jsonData = json.decode(response.body);
    setState(() {
      _data = jsonData;
    });
  }
  @override
  void didUpdateWidget(CustomTabView oldWidget) {
    if (_currentCount != widget.itemCount) {
      controller.animation!.removeListener(onScroll);
      controller.removeListener(onPositionChange);
      controller.dispose();

      if (widget.initPosition != null) {
        _currentPosition = widget.initPosition!;
      }

      if (_currentPosition > widget.itemCount - 1) {
        _currentPosition = widget.itemCount - 1;
        _currentPosition = _currentPosition < 0 ? 0 : _currentPosition;
        if (widget.onPositionChange is ValueChanged<int>) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted && widget.onPositionChange != null) {
              widget.onPositionChange!(_currentPosition);
            }
          });
        }
      }

      _currentCount = widget.itemCount;
      setState(() {
        controller = TabController(
          length: widget.itemCount,
          vsync: this,
          initialIndex: _currentPosition,
        );
        controller.addListener(onPositionChange);
        controller.animation!.addListener(onScroll);
      });
    } else if (widget.initPosition != null) {
      controller.animateTo(widget.initPosition!);
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    controller.animation!.removeListener(onScroll);
    controller.removeListener(onPositionChange);
    controller.dispose();
    super.dispose();
  }
  int _selectedTabIndex = 0;
  bool _hasShownContainer = false;
  @override
  Widget build(BuildContext context) {
    if (widget.itemCount < 1) return widget.stub ?? Container();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Container(
          alignment: Alignment.center,
          child: TabBar(
            isScrollable: true,
            controller: controller,
            labelColor: Colors.yellow,
            unselectedLabelColor: Theme.of(context).hintColor,
            indicator: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.yellowAccent,
                  width: 2,
                ),
              ),
            ),
            tabs: List.generate(
              widget.itemCount,
                  (index) => widget.tabBuilder(context, index),
            ),
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: controller,
            children: List.generate(
                widget.itemCount,
                    (indexa)
                {


                  List<dynamic> matchedElements = _data.where((element) => element['userid'] == userId).toList();


                  return Container(
                    alignment: Alignment.center,

                    child: Column(

                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child:
                          ConstrainedBox(
                            constraints: BoxConstraints(
                              maxHeight: MediaQuery.of(context).size.height,
                            ),
                            child: ReorderableListView(
                              onReorder: (oldIndex, newIndex) {
                                setState(() {
                                  if (newIndex > oldIndex) {
                                    newIndex -= 1;
                                  }
                                  final item = matchedElements.removeAt(oldIndex);
                                  matchedElements.insert(newIndex, item);
                                });
                              },
                              children: List.generate(matchedElements.length, (index) {
                                // if(_data[index]['tabid']==0){

                                // }
                                // print(_data);
                                final item = matchedElements[index];
                                print([indexa,"indexe"]);


                                if (int.parse(item['tabid']) < data.length) {
                                  if (int.parse(item['tabid']) == indexa) {
                                    String  imagePath="";
                                    List<dynamic> filteredList=[];
                                    int tabIdssss = int.parse(item['colId']);
                                    int resultsss = tabIdssss - 1;
                                    print(["first",resultsss]);
                                    if(imagesfirst.isNotEmpty){
                                      filteredList = imagesfirst
                                          .where((element) => element['note_id'] == int.parse(item['colId']).toString())
                                          .toList();
                                      if (filteredList.isNotEmpty && filteredList[0].containsKey("image_path")) {
                                        imagePath = filteredList[0]["image_path"];
                                        // Now you can work with imagePath
                                        print("Image Path: $imagePath");
                                      } else {
                                        print("Index 0 not available or 'image_path' key not found.");
                                      }
                                      // print([filteredList[0]["image_path"],"filteredimages"]);
                                    }
                                    print(item['colId']);
                                    return  Card(

                                      key: Key(matchedElements[index]['colId']),
                                      color: Color.fromARGB(255, 102, 116, 128),
                                      elevation: 2.0,
                                      child: Column(
                                          children: <Widget>[
                                            // Image.network(
                                            //   "${ApiConstants.baseUrl}"+filteredList[0]["image_path"],
                                            //   width: double.infinity, // Make the image as wide as its parent
                                            //   fit: BoxFit.cover, // Adjust the BoxFit as needed
                                            // ),
                                            if(imagePath.isNotEmpty)
                                              FadeInImage.assetNetwork(
                                                placeholder: 'assets/spinner2.gif',
                                                image:"${ApiConstants.baseUrl}"+imagePath,
                                              ),
                                            // Text("filteredList[0].toString()"),
                                            ListTile(
                                              key: Key(matchedElements[index]['colId']),

                                              title: Text(matchedElements[index]['colTitle']!, style: TextStyle(color: Colors.white , fontSize: 16, fontWeight: FontWeight.bold ),),

                                              subtitle: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text("Due: "+matchedElements[index]['colDate']!+"",style: TextStyle(color: Color.fromARGB(250, 250, 250,  0), fontSize: 14, fontWeight: FontWeight.bold ),),
                                                  if (role == "owner")
                                                    Text(double.tryParse(matchedElements[index]['colTotalprice'])!.toStringAsFixed(2),style: TextStyle(color: Color.fromARGB(250, 250, 250,  0) , fontSize: 14, fontWeight: FontWeight.bold ),),
                                                ],
                                              ),

                                              trailing: PopupMenuButton(
                                                itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                                                  PopupMenuItem(
                                                    child: Text('Move to other tab'),
                                                    onTap: () {
                                                      Future<void>.delayed(
                                                          const Duration(),  // OR const Duration(milliseconds: 500),
                                                              () => _showTabListDialog(context, widget.itemCount,matchedElements[index]['colId'],indexa)

                                                      );



                                                    },
                                                  ),
                                                  PopupMenuItem(
                                                    child: Text('Delete'),
                                                    onTap: () {
                                                      Future<void>.delayed(
                                                          const Duration(),  // OR const Duration(milliseconds: 500),
                                                              () => delete_job(context,_data[index]['colId'])

                                                      );



                                                    },
                                                  ),
                                                ],
                                                icon: Icon(Icons.more_vert),
                                              ),



                                              onTap: () {
                                                // debugPrint("ListTile Tapped");
                                                // print([_data[index]['colTitle']]);
                                                // Map<String, dynamic> noteMap = {
                                                //   // 'colId': note.colId,
                                                //   'colTitle': _data[index]['colTitle'],
                                                //   'colDescription': _data[index]['colDescription'],
                                                //   'colemail': _data[index]['colemail'],
                                                //   'colnumber': _data[index]['colnumber'],
                                                //   'coladdress': _data[index]['coladdress'],
                                                //   'colTotalprice': _data[index]['colTotalprice'],
                                                //   'colDeposit': _data[index]['colDeposit'],
                                                //   'colBalance': _data[index]['colBalance'],
                                                //   'colCollectthisweek': _data[index]['colCollectthisweek'],
                                                //   'colPriority': _data[index]['colPriority'],
                                                //   'colposition': _data[index]['colposition'],
                                                //   'colDate': _data[index]['colDate'],
                                                // };
                                                // print(Note.fromMapObject(_data[index]).title);
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => NoteDetailapi(matchedElements[index], "Edit CLient","edit","note"),
                                                  ),
                                                );

                                              },

                                            )]),
                                    );
                                  }else if (!_hasShownContainer) {
                                    _hasShownContainer = true;
                                    return Container(
                                      key:     Key(matchedElements[index]['colId']),
                                      child: Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    ); // or any other widget if you don't want to show the item
                                  } else {
                                    return SizedBox.shrink(  key:     Key(matchedElements[index]['colId']),); // return an empty widget to take up no space
                                  }
                                } else {
                                  if (indexa == 0) {
                                    print([item['tabid'],"tabid"]);
                                    String  imagePath="";
                                    List<dynamic> filteredList=[];
                                    int tabIdssss = int.parse(item['colId']);
                                    int resultsss = tabIdssss - 1;
                                    print(["first",resultsss]);
                                    if(imagesfirst.isNotEmpty){
                                      filteredList = imagesfirst
                                          .where((element) => element['note_id'] == int.parse(item['colId']).toString())
                                          .toList();
                                      if (filteredList.isNotEmpty && filteredList[0].containsKey("image_path")) {
                                        imagePath = filteredList[0]["image_path"];
                                        // Now you can work with imagePath
                                        print("Image Path: $imagePath");
                                      } else {
                                        print("Index 0 not available or 'image_path' key not found.");
                                      }
                                      // print([filteredList[0]["image_path"],"filteredimages"]);
                                    }
                                    print([item['colId'],"noteitd"]);
                                    return  Card(

                                      key: Key(matchedElements[index]['colId']),
                                      color: Color.fromARGB(255, 102, 116, 128),
                                      elevation: 2.0,
                                      child: Column(
                                          children: <Widget>[
                                            // Image.network(
                                            //   "${ApiConstants.baseUrl}"+filteredList[0]["image_path"],
                                            //   width: double.infinity, // Make the image as wide as its parent
                                            //   fit: BoxFit.cover, // Adjust the BoxFit as needed
                                            // ),
                                            if(imagePath.isNotEmpty)
                                              FadeInImage.assetNetwork(
                                                placeholder: 'assets/spinner2.gif',
                                                image:"${ApiConstants.baseUrl}"+imagePath,
                                              ),
                                            ListTile(
                                              key: Key(matchedElements[index]['colId']),

                                              title: Text(matchedElements[index]['colTitle']!, style: TextStyle(color: Colors.white , fontSize: 16, fontWeight: FontWeight.bold ),),

                                              subtitle: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text("Due: "+matchedElements[index]['colDate']!+"",style: TextStyle(color: Color.fromARGB(250, 250, 250,  0), fontSize: 14, fontWeight: FontWeight.bold ),),
                                                  if (role == "owner")
                                                    Text(double.tryParse(matchedElements[index]['colTotalprice'])!.toStringAsFixed(2),style: TextStyle(color: Color.fromARGB(250, 250, 250,  0) , fontSize: 14, fontWeight: FontWeight.bold ),),
                                                ],
                                              ),

                                              trailing: PopupMenuButton(
                                                itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                                                  PopupMenuItem(
                                                    child: Text('Move to other tab'),
                                                    onTap: () {
                                                      Future<void>.delayed(
                                                          const Duration(),  // OR const Duration(milliseconds: 500),
                                                              () => _showTabListDialog(context, widget.itemCount,matchedElements[index]['colId'],indexa)

                                                      );



                                                    },
                                                  ),
                                                  PopupMenuItem(
                                                    child: Text('Delete'),
                                                    onTap: () {
                                                      Future<void>.delayed(
                                                          const Duration(),  // OR const Duration(milliseconds: 500),
                                                              () => delete_job(context,_data[index]['colId'])

                                                      );



                                                    },
                                                  ),
                                                ],
                                                icon: Icon(Icons.more_vert),
                                              ),



                                              onTap: () {
                                                // debugPrint("ListTile Tapped");
                                                // print([_data[index]['colTitle']]);
                                                // Map<String, dynamic> noteMap = {
                                                //   // 'colId': note.colId,
                                                //   'colTitle': _data[index]['colTitle'],
                                                //   'colDescription': _data[index]['colDescription'],
                                                //   'colemail': _data[index]['colemail'],
                                                //   'colnumber': _data[index]['colnumber'],
                                                //   'coladdress': _data[index]['coladdress'],
                                                //   'colTotalprice': _data[index]['colTotalprice'],
                                                //   'colDeposit': _data[index]['colDeposit'],
                                                //   'colBalance': _data[index]['colBalance'],
                                                //   'colCollectthisweek': _data[index]['colCollectthisweek'],
                                                //   'colPriority': _data[index]['colPriority'],
                                                //   'colposition': _data[index]['colposition'],
                                                //   'colDate': _data[index]['colDate'],
                                                // };
                                                // print(Note.fromMapObject(_data[index]).title);
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => NoteDetailapi(matchedElements[index], "Edit CLient","edit","note"),
                                                  ),
                                                );

                                              },

                                            )]),
                                    );
                                  }else if (!_hasShownContainer) {
                                    _hasShownContainer = true;
                                    return Container(
                                      key:     Key(matchedElements[index]['colId']),
                                      child: Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    ); // or any other widget if you don't want to show the item
                                  } else {
                                    return SizedBox.shrink(  key:     Key(matchedElements[index]['colId']),); // return an empty widget to take up no space
                                  }
                                }





                              }),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );

                }
            ),
          ),
        ),

      ],
    );
  }

  void onPositionChange() {
    if (!controller.indexIsChanging) {
      _currentPosition = controller.index;
      if (widget.onPositionChange is ValueChanged<int>) {
        widget.onPositionChange!(_currentPosition);
      }
    }
  }

  void onScroll() {
    if (widget.onScroll is ValueChanged<double>) {
      widget.onScroll!(controller.animation!.value);
    }
  }

  void _showTabListDialog(BuildContext context,count,id, int indexa) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Tab'),
          content: Container(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: count,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(data[index]),
                  onTap: () {
                    setState(() {
                      _selectedTabIndex = index;
                      _updateData(int.parse(id), index.toString());
                      Navigator.of(context).pop();
                    });
                  },
                );
              },
            ),

          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  void delete_job(BuildContext context,id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Item'),
          content: Text('Are you sure you want to delete this item?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                // Perform delete operation
                Navigator.of(context).pop();
                _deleteData(int.parse(id));
              },
            ),
          ],
        );
      },
    );


  }
  void _deleteData(int id) async {
    print(id);
    final username = 'code';
    final password = 'codep';
    final basicAuth = 'Basic ' + base64Encode(utf8.encode('$username:$password'));

    final url = '${ApiConstants.baseUrl}note_delete.php';
    final response = await http.post(Uri.parse(url), headers: {
      'authorization': basicAuth,
    }, body: {
      'table_name': 'noteTable',
      'id': id.toString(),
    });

    if (response.statusCode == 200) {
      // Refresh data after successful delete
      _fetchData();
    } else {
      // Handle error
      print('Failed to delete data.');
    }
  }

  Future<void> _updateData(int id, String tabid) async {
    final username = 'your_username';
    final password = 'your_password';
    final basicAuth = 'Basic ' + base64Encode(utf8.encode('$username:$password'));
    final url = '${ApiConstants.baseUrl}update_note_tabid.php';

    final response = await http.post(Uri.parse(url), headers: {
      'authorization': basicAuth,
    }, body: {
      'id': id.toString(),
      'tabid': tabid,
      'table_name': 'noteTable',
    });

    if (response.statusCode == 200) {
      // Refresh data after successful update
      _fetchData();
    } else {
      // Handle error
      print('Failed to update data.');
    }
  }



}

