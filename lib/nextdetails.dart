import 'dart:async';
import 'package:auto_size_text_field/auto_size_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:map_autocomplete_field/map_autocomplete_field.dart';
import 'package:ttachienew/nextinline.dart';
import 'package:ttachienew/salesprojects.dart';
import 'package:ttachienew/utils/database_helper.dart';
import 'package:url_launcher/url_launcher.dart';
import 'NavBar.dart';
import 'bottem_bar.dart';
import 'futureprojects.dart';
import 'home_screen.dart';
import 'models/future.dart';
import 'package:flutter/cupertino.dart';



class Nextdetails extends StatefulWidget {

  final String appBarTitle;
  final Fut note;

  Nextdetails(this.note, this.appBarTitle);

  @override
  State<StatefulWidget> createState() {

    return NoteDetailState(this.note, this.appBarTitle);
  }
}

class NoteDetailState extends State<Nextdetails> {
  Future<bool> onbackpress() async{
    Navigator.pop(context, true);
    return true;
  }
  static var _priorities = ['High', 'Low'];

  DatabaseHelper helper = DatabaseHelper();

  String appBarTitle;
  Fut note;
  TextEditingController field1 = TextEditingController();
  TextEditingController field2 = TextEditingController();
  TextEditingController field3 = TextEditingController();
  TextEditingController field4 = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _numberController = TextEditingController();

  final TextEditingController addressCtrl = TextEditingController();

  final String yourMapApiKey = 'AIzaSyDxG0RL36UO7jWJ2vXQGHUk8O4qakRafzE';

  bool _isVisible = false;


  double a = 0;
  double b = 0;
  double c = 0;
  String? text1;
  String? text2;
  String? text3;
  String? text4;
  var counter =0;
  List<String> field1list= [];
  List<int> field2list= [];

  List<int> field3list= [];
  FocusNode myFocusNode = new FocusNode();
  double x =  0;
  NoteDetailState(this.note, this.appBarTitle);
  @override
  void initState() {
    super.initState();
    titleController.text = note.title.toString();
    descriptionController.text = note.description.toString()  == "null" ? "":note.description.toString();
    _emailController.text = note.email.toString()== "null" ?  "" : (note.email.toString());
    _numberController.text = note.number.toString()== "null" ? "" : (note.number.toString());
    addressCtrl.text = note.address.toString()== "null" ?  "" : (note.address.toString());
    field1.text = note.totalprice.toString().isEmpty ?  note.totalprice.toString() : (note.totalprice.toString());
    field2.text = note.deposit.toString().isEmpty ?  note.deposit.toString() : note.deposit.toString();
    field3.text = note.balance.toString().isEmpty ?  note.balance.toString() : note.balance.toString();
    field4.text = note.collectthisweek.toString().isEmpty ?  note.collectthisweek.toString() : note.collectthisweek.toString();

    print(note.totalprice.toString().isEmpty);
    a = (note.totalprice.toString().isEmpty ? 0 : double.tryParse(note.totalprice.toString()))!;
    b = (note.deposit.toString().isEmpty ? 0 : double.tryParse(note.deposit.toString()))!;
    if (note.date.toString().isEmpty) {
      note.date = DateTime.now().toString();
    }
  }
  @override
  Widget build(BuildContext context) {

    TextStyle? textStyle = Theme.of(context).textTheme.headline6;

    return WillPopScope(

        onWillPop: onbackpress,

        child: Scaffold(
          drawer: NavBar(),
          appBar: AppBar(
            iconTheme: IconThemeData(color:  Color.fromARGB(255,255, 255, 0),),

            backgroundColor: Color.fromARGB(255,55, 69, 80),
            title: Text("Add Next Projects"),

          ),

          body:  Padding(
            padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),

            child: ListView(

              children: <Widget>[
                SizedBox(height: 40.0,),
                Container(
                  height: 180,

                  width: MediaQuery.of(context).size.width * 0.80,
                  decoration: BoxDecoration(

                    color: Color.fromARGB(226, 255, 255, 80),

                    borderRadius: BorderRadius.circular(17),
                  ),
                  // First element

                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.dateAndTime,
                    initialDateTime:DateTime.now(),
                    onDateTimeChanged: (DateTime newDateTime) {
                      updateDate(newDateTime);
                    },
                    use24hFormat: false,
                    minuteInterval: 1,
                  ),
                ),

                SizedBox(height: 40.0,),
                // Second Element
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: AutoSizeTextField(
                    controller: titleController,

                    onChanged: (value) {
                      debugPrint('Something changed in Title Text Field');
                      updateTitle();
                    },
                    decoration: InputDecoration(
                        isDense: true,
                        contentPadding:  EdgeInsets.only(top: 40.0, left: 9),
                        labelText: 'Enter Name',
                        labelStyle: TextStyle(
                          color: myFocusNode.hasFocus ? Colors.blue :Color.fromARGB(255,255, 255, 0),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            width: 1,

                          ),
                        ),
                        hintText: "Enter Name",
                        hintStyle: TextStyle(color: Color.fromARGB(255,255, 255, 0),fontSize: 25.0,fontWeight: FontWeight.w900,)
                    ),
                    style: TextStyle(color: Color.fromARGB(255,255, 255, 0),fontSize: 30.0,fontWeight: FontWeight.w900,),
                  ),
                ),
                SizedBox(height: 40.0,),
                // Third Element
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: AutoSizeTextField(
                    controller: descriptionController,

                    onChanged: (value) {
                      debugPrint('Something changed in Description Text Field');
                      updateDescription();
                    },
                    decoration: InputDecoration(
                        isDense: true,
                        contentPadding:  EdgeInsets.only(top: 40.0, left: 9),
                        labelText: 'Description',
                        labelStyle: TextStyle(
                          color: myFocusNode.hasFocus ? Colors.blue :Color.fromARGB(255,255, 255, 0),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            width: 1,

                          ),
                        ),
                        hintText: "Description",
                        hintStyle: TextStyle(color: Color.fromARGB(255,255, 255, 0),fontSize: 25.0,fontWeight: FontWeight.w900,)
                    ),
                    style: TextStyle(color: Color.fromARGB(255,255, 255, 0),fontSize: 30.0,fontWeight: FontWeight.w900,),
                  ),
                ),
                SizedBox(height:40,),
                Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _isVisible = !_isVisible;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          color: Color.fromARGB(255,255, 255, 0),
                        ),


                        child: Text(
                          "Add New",style: TextStyle(color: Colors.black),
                          textScaleFactor: 1.5,
                        ),







                      ),
                    ),
                    SizedBox(height:40,),
                    Visibility(
                      visible: _isVisible,
                      child:Container(
                        padding: EdgeInsets.all(16.0), // set the padding for the container
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey.shade300, // set the color of the border
                            width: 2.0, // set the width of the border
                          ),
                          borderRadius: BorderRadius.circular(10.0), // set the radius of the border
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5), // set the shadow color
                              spreadRadius: 2.0, // set the spread radius
                              blurRadius: 5.0, // set the blur radius
                              offset: Offset(0, 2), // set the offset
                            ),
                          ],
                        ),



                        child:    Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                              child: AutoSizeTextField(
                                controller: _emailController,

                                onChanged: (value) {
                                  debugPrint('Something changed in Title Text Field');
                                  updateEmail(value);
                                },
                                decoration: InputDecoration(
                                    isDense: true,
                                    contentPadding:  EdgeInsets.only(top: 40.0, left: 9),
                                    labelText: 'Email',
                                    labelStyle: TextStyle(
                                      color: myFocusNode.hasFocus ? Colors.blue :Color.fromARGB(255,255, 255, 0),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                        width: 1,

                                      ),
                                    ),
                                    hintText: "Email",
                                    hintStyle: TextStyle(color: Color.fromARGB(255,255, 255, 0),fontSize: 25.0,fontWeight: FontWeight.w900,)
                                ),
                                style: TextStyle(color: Color.fromARGB(255,255, 255, 0),fontSize: 30.0,fontWeight: FontWeight.w900,),
                              ),
                            ),
                            ElevatedButton.icon(
                              onPressed: () async {
                                final Uri emailLaunchUri = Uri(
                                    scheme: 'mailto',
                                    path: _emailController.text,
                                    queryParameters: {
                                      'subject': 'Techie Contractor',
                                      'body': '...'
                                    }
                                );

                                await launch(emailLaunchUri.toString());
                              },
                              icon: Icon(Icons.mail,color: Colors.black,),
                              label: Text('Send Email',style: TextStyle(color: Colors.black)),
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<Color>(
                                    Color.fromARGB(255, 255, 255, 0)),


                              ),
                            ),


                            SizedBox(height:40,),
                            Padding(
                              padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                              child: AutoSizeTextField(
                                controller: _numberController,

                                onChanged: (value) {
                                  debugPrint('Something changed in Title Text Field');
                                  updateNumber(value);
                                },
                                decoration: InputDecoration(
                                    isDense: true,
                                    contentPadding:  EdgeInsets.only(top: 40.0, left: 9),
                                    labelText: 'Number',
                                    labelStyle: TextStyle(
                                      color: myFocusNode.hasFocus ? Colors.blue :Color.fromARGB(255,255, 255, 0),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                        width: 1,

                                      ),
                                    ),
                                    hintText: "Number",
                                    hintStyle: TextStyle(color: Color.fromARGB(255,255, 255, 0),fontSize: 25.0,fontWeight: FontWeight.w900,)
                                ),
                                style: TextStyle(color: Color.fromARGB(255,255, 255, 0),fontSize: 30.0,fontWeight: FontWeight.w900,),
                              ),
                            ),
                            ElevatedButton.icon(
                              onPressed: () async {
                                final Uri phoneCallUri = Uri(
                                  scheme: 'tel',
                                  path: _numberController.text, // Replace with your phone number
                                );
                                await launch(phoneCallUri.toString());
                              },
                              icon: Icon(Icons.phone, color: Colors.black),
                              label: Text('Call', style: TextStyle(color: Colors.black)),
                              style: ButtonStyle(
                                backgroundColor:
                                MaterialStateProperty.all<Color>(Color.fromARGB(255, 255, 255, 0)),
                              ),
                            ),
                            SizedBox(height:40,),
                            MapAutoCompleteField(
                              googleMapApiKey: yourMapApiKey,
                              controller: addressCtrl,
                              itemBuilder: (BuildContext context, suggestion) {
                                return ListTile(
                                  title: Text(suggestion.description),
                                );
                              },
                              onSuggestionSelected: (suggestion) {
                                addressCtrl.text = suggestion.description;
                                updateAddress(suggestion.description);
                              },
                              inputDecoration: InputDecoration(
                                  isDense: true,
                                  contentPadding:  EdgeInsets.only(top: 40.0, left: 9),
                                  labelText: 'Address',
                                  labelStyle: TextStyle(
                                    color: myFocusNode.hasFocus ? Colors.blue :Color.fromARGB(255,255, 255, 0),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                      width: 1,

                                    ),
                                  ),
                                  hintText: "Address",
                                  hintStyle: TextStyle(color: Color.fromARGB(255,255, 255, 0),fontSize: 25.0,fontWeight: FontWeight.w900,)
                              ),










                            ),
                            SizedBox(height:15.0,),
                            ElevatedButton.icon(
                              onPressed: () async {
                                final Uri mapsLaunchUri = Uri(
                                  scheme: 'https',
                                  host: 'www.google.com',
                                  path: '/maps/search/',
                                  queryParameters: {
                                    'api': '1',
                                    'query': addressCtrl.text, // Replace with your desired address
                                  },
                                );

                                await launch(mapsLaunchUri.toString());
                              },
                              icon: Icon(Icons.map, color: Colors.black),
                              label: Text('Navigate to Address', style: TextStyle(color: Colors.black)),
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<Color>(
                                    Color.fromARGB(255, 255, 255, 0)),
                              ),
                            ),

                          ],
                        ),
                      ),),


                  ],
                ),


                SizedBox(height:40,),

                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [

                    Text("Total Price",style: TextStyle(fontSize: 21,fontWeight: FontWeight.w500,color: Colors.white),),
                    SizedBox(

                      height: 20,
                    ),

                  ],
                ),
                SizedBox(height: 30.0,),
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
                      child:  IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: () {
                          double currentValue = double.parse(field1.text.replaceAll('', ''));
                          setState(() {
                            print("Setting state");
                            currentValue--;
                            field1.text = (currentValue).toStringAsFixed(2); // decrementing value

                            text1=field1.text.replaceAll('', '');
                            final x = double.tryParse(field1.text.replaceAll('', ''));
                            a = x ?? 0; // handle null and String
                            if((a - b).toInt() <  0){

                              double number = double.parse("0");

                              setState(() {
                                field3.text = number.toStringAsFixed(2);
                              });


                            }else{
                              field3.text = (a - b).toStringAsFixed(2);

                            }

                            if(double.parse(field1.text.toString()).toInt() <  0){

                              double number = double.parse("0");

                              setState(() {
                                field1.text = number.toStringAsFixed(2);
                              });


                            }



                            print('$a a' +'$b b'+(a - b).toStringAsFixed(2));
                          });

                          updateBalance();
                          updateCollest();
                          updateDeposit();
                          updateTotalprice();
                        },
                        iconSize: 15,
                        tooltip: "decrease",
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: Container(
                        height: 70,
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
                          padding: const EdgeInsets.all(0),
                          child: Center(child: Focus(

                            child: AutoSizeTextField(
                              controller: field1,
                              inputFormatters: <TextInputFormatter>[
                                // for below version 2 use this
                                FilteringTextInputFormatter.allow(RegExp('[0-9.]')),
                              ],
                              keyboardType: TextInputType.numberWithOptions(decimal: true),
                              onChanged: (value){
                                print(value);

                                text1=value.replaceAll('', '');
                                final x = double.tryParse(value.replaceAll('', ''));

                                setState(() {
                                  a = x ?? 0; // handle null and String

                                  if((a - b).toInt() <  0){

                                    double number = double.parse("0");

                                    setState(() {
                                      field3.text = number.toStringAsFixed(2);
                                    });


                                  }else{
                                    field3.text = (a - b).toStringAsFixed(2);

                                  }
                                  print('$a a' +'$b b'+(a - b).toStringAsFixed(2));



                                  if(field2.text.isNotEmpty){
                                    final value = double.tryParse(field2.text.replaceAll('', '')) ?? 0;
                                    field2.text = (value.toStringAsFixed(2));
                                  }

                                  if(double.parse(value.toString()).toInt() <  0){

                                    double number = double.parse("0");

                                    setState(() {
                                      field1.text = number.toStringAsFixed(2);
                                    });


                                  }













                                  // if(field4.text.isNotEmpty){
                                  //   final value = double.tryParse(field4.text.replaceAll('', '')) ?? 0;
                                  //   field4.text = (value.toStringAsFixed(2));
                                  // }

                                });

                                debugPrint('Something changed in Description Text Field');
                                updateBalance();
                                updateCollest();
                                updateDeposit();
                                updateTotalprice();

                              },

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
                            ),
                            onFocusChange: (hasFocus) {
                              if (hasFocus) {

                                if(field2.text.isNotEmpty){
                                  final value = double.tryParse(field2.text.replaceAll('', '')) ?? 0;
                                  field2.text = (value.toStringAsFixed(2));
                                }

                                // if(field4.text.isNotEmpty){
                                //   final value = double.tryParse(field4.text.replaceAll('', '')) ?? 0;
                                //   field4.text = (value.toStringAsFixed(2));
                                // }

                              }
                            },
                          )),
                        ),
                      ),    ),
                    Container(
                      height: 30.0,
                      decoration: BoxDecoration(
                          color: Color.fromARGB(255,255, 255, 0),
                          shape: BoxShape.circle
                      ),
                      child: IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          double currentValue = field1.text.isEmpty ? 0 : double.parse(field1.text.replaceAll('', ''));

                          setState(() {
                            currentValue++;
                            field1.text = (currentValue).toStringAsFixed(2);

                            text1=field1.text.replaceAll('', '');
                            final x = double.tryParse(field1.text.replaceAll('', ''));
                            a = x ?? 0; // handle null and String
                            if((a - b).toInt() <  0){

                              double number = double.parse("0");

                              setState(() {
                                field3.text = number.toStringAsFixed(2);
                              });


                            }else{
                              field3.text = (a - b).toStringAsFixed(2);

                            }
                            print('$a a' +'$b b'+(a - b).toStringAsFixed(2));

                          });


                          updateBalance();
                          updateCollest();
                          updateDeposit();
                          updateTotalprice();
                        },
                        iconSize: 15,
                        tooltip: "increase",
                      ),
                    ),

                  ],
                ),
                SizedBox(height:25,),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [

                    Text("Deposits",style: TextStyle(fontSize: 21,fontWeight: FontWeight.w500,color: Colors.white),),
                    SizedBox(

                      height: 20,
                    ),

                  ],
                ),
                SizedBox(height: 30.0,),
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
                      child:  IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: () {
                          double currentValue = double.parse(field2.text.replaceAll('', ''));
                          setState(() {
                            print("Setting state");
                            currentValue--;
                            field2.text = (currentValue).toStringAsFixed(2); // decrementing value

                            text2=field2.text.replaceAll('', '');
                            final x = double.tryParse(field2.text.replaceAll('', ''));
                            b = x ?? 0;
                            if((a - b).toInt() <  0){

                              double number = double.parse("0");

                              setState(() {
                                field3.text = number.toStringAsFixed(2);
                              });


                            }else{
                              field3.text = (a - b).toStringAsFixed(2);

                            }

                            if(double.parse(field2.text.toString()).toInt() <  0){

                              double number = double.parse("0");

                              setState(() {
                                field2.text = number.toStringAsFixed(2);
                              });


                            }
                            print('$a' +'$b'+(a - b).toStringAsFixed(2));
                            text4 = (a - b).toStringAsFixed(2);
                          });

                          updateBalance();
                          updateCollest();
                          updateDeposit();
                          updateTotalprice();
                        },
                        iconSize: 15,
                        tooltip: "decrease",
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: Container(
                        height: 70,
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
                          padding: const EdgeInsets.all(1),
                          child: Center(child: Focus(
                            child: AutoSizeTextField(
                              controller: field2,
                              inputFormatters: <TextInputFormatter>[
                                // for below version 2 use this
                                FilteringTextInputFormatter.allow(RegExp('[0-9.]')),
                              ],
                              keyboardType: TextInputType.numberWithOptions(decimal: true),
                              onChanged: (value){
                                text2=value.replaceAll('', '');
                                final x = double.tryParse(value.replaceAll('', ''));

                                setState(() {
                                  b = x ?? 0;

                                  field3.text = (a - b).toStringAsFixed(2);;

                                  print('$a' +'$b'+(a - b).toStringAsFixed(2));
                                  text4 = (a - b).toStringAsFixed(2);


                                  if(field1.text.isNotEmpty){
                                    final value = double.tryParse(field1.text.replaceAll('', '')) ?? 0;
                                    field1.text = (value.toStringAsFixed(2));
                                  }

                                  // if(field4.text.isNotEmpty){
                                  //   final value = double.tryParse(field4.text.replaceAll('', '')) ?? 0;
                                  //   field4.text = (value.toStringAsFixed(2));
                                  // }

                                });
                                updateBalance();
                                updateCollest();
                                updateDeposit();
                                updateTotalprice();
                              },
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
                              style: TextStyle(color: Color.fromARGB(255,255, 255, 0),fontSize: 30.0,fontWeight: FontWeight.w900,),                          ),
                            onFocusChange: (hasFocus) {
                              if (hasFocus) {
                                if(field1.text.isNotEmpty){
                                  final value = double.tryParse(field1.text.replaceAll('', '')) ?? 0;
                                  field1.text = (value.toStringAsFixed(2));
                                }

                                // if(field4.text.isNotEmpty){
                                //   final value = double.tryParse(field4.text.replaceAll('', '')) ?? 0;
                                //   field4.text = (value.toStringAsFixed(2));
                                // }
                              }
                            },
                          )),
                        ),
                      ),    ),
                    Container(
                      height: 30.0,
                      decoration: BoxDecoration(
                          color: Color.fromARGB(255,255, 255, 0),
                          shape: BoxShape.circle
                      ),
                      child: IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          double currentValue = field2.text.isEmpty ? 0 : double.parse(field2.text.replaceAll('', ''));

                          setState(() {
                            currentValue++;
                            field2.text = (currentValue).toStringAsFixed(2); // incrementing value

                            text2=field2.text.replaceAll('', '');
                            final x = double.tryParse(field2.text.replaceAll('', ''));
                            b = x ?? 0;
                            if((a - b).toInt() <  0){

                              double number = double.parse("0");

                              setState(() {
                                field3.text = number.toStringAsFixed(2);
                              });


                            }else{
                              field3.text = (a - b).toStringAsFixed(2);

                            }
                            print('$a' +'$b'+(a - b).toStringAsFixed(2));
                            text4 = (a - b).toStringAsFixed(2);
                          });

                          updateBalance();
                          updateCollest();
                          updateDeposit();
                          updateTotalprice();
                        },
                        iconSize: 15,
                        tooltip: "increase",
                      ),
                    ),
                  ],
                ),




                SizedBox(height:25,),

                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [

                    Text("Balance",style: TextStyle(fontSize: 21,fontWeight: FontWeight.w500,color: Colors.white),),
                    SizedBox(

                      height: 20,
                    ),

                  ],
                ),
                SizedBox(height: 30.0,),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [

                    Container(
                      padding: const EdgeInsets.all(1.0),
                      child: Container(
                        height: 70,
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
                          padding: const EdgeInsets.all(1),
                          child: Center(child: AutoSizeTextField(
                            controller: field3,
                            readOnly: true,

                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,

                            onChanged: (value) {
                              debugPrint('Something changed in Description Text Field');
                              updateBalance();
                              updateCollest();
                              updateDeposit();
                              updateTotalprice();
                            },

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
                            style: TextStyle(color: Color.fromARGB(255,255, 255, 0),fontSize: 30.0,fontWeight: FontWeight.w900,),                            )),
                        ),
                      ),    ),


                  ],
                ),
                SizedBox(height:25,),

                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [

                    Text("Collect This week",style: TextStyle(fontSize: 21,fontWeight: FontWeight.w500,color: Colors.white),),
                    SizedBox(

                      height: 20,
                    ),

                  ],
                ),
                SizedBox(height: 30.0,),
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
                      child:  IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: () {
                          double currentValue = double.parse(field4.text.replaceAll('', ''));
                          setState(() {
                            print("Setting state");
                            currentValue--;
                            field4.text = (currentValue).toStringAsFixed(2);; // decrementing value



                            text3=field4.text.replaceAll('', '');
                            double z = double.parse(field4.text.toString().replaceAll('', ''));
                            text3=field4.text.replaceAll('', '');
                            c = z ?? 0; // handle null and String
                            // field3.text = ((a - b)-c).toStringAsFixed(2);;
                            // text4 = ((a - b)-c).toStringAsFixed(2);



                            if(double.parse(field4.text.toString()).toInt() <  0){

                              double number = double.parse("0");

                              setState(() {
                                field4.text = number.toStringAsFixed(2);
                              });


                            }
                            print(((a - b)-c).toDouble());

                            if((( double.parse( field1.text.toString())  -  double.parse( field2.text.toString()) )-c).toDouble() <  0){

                              double number = double.parse("0");

                              setState(() {
                                field3.text = number.toStringAsFixed(2);
                              });


                            }else{
                              field3.text = ((a - b)-c).toStringAsFixed(2);

                            }

                          });

                          updateBalance();
                          updateCollest();
                          updateDeposit();
                          updateTotalprice();
                        },
                        iconSize: 15,
                        tooltip: "decrease",
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: Container(
                        height: 70,
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
                          padding: const EdgeInsets.all(1),
                          child: Center(child: Focus(
                            child: AutoSizeTextField(
                              controller: field4,
                              inputFormatters: <TextInputFormatter>[
                                // for below version 2 use this
                                FilteringTextInputFormatter.allow(RegExp('[0-9.]')),
                              ],
                              keyboardType: TextInputType.numberWithOptions(decimal: true),
                              onChanged: (value){
                                // text3=value.replaceAll('', '');
                                // double z = double.tryParse(value.replaceAll('', '').toString()) as double;
                                //
                                //
                                // text3=value.replaceAll('', '');
                                // c = z ?? 0; // handle null and String
                                //
                                // field3.text = ((a - b)-c).toStringAsFixed(2);;
                                // text4 = ((a - b)-c).toStringAsFixed(2);
                                //
                                //
                                //
                                //
                                // if(field1.text.isNotEmpty){
                                //   final value = double.tryParse(field1.text.replaceAll('', '')) ?? 0;
                                //   field1.text = (value.toStringAsFixed(2));
                                // }
                                //
                                // if(field2.text.isNotEmpty){
                                //   final value = double.tryParse(field2.text.replaceAll('', '')) ?? 0;
                                //   field2.text = (value.toStringAsFixed(2));
                                // }

                                updateBalance();
                                updateCollest();
                                updateDeposit();
                                updateTotalprice();
                              },
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
                              style: TextStyle(color: Color.fromARGB(255,255, 255, 0),fontSize: 30.0,fontWeight: FontWeight.w900,),                          ),
                            onFocusChange: (hasFocus) {
                              if(hasFocus) {

                                if(field1.text.isNotEmpty){
                                  final value = double.tryParse(field1.text.replaceAll('', '')) ?? 0;
                                  field1.text = (value.toStringAsFixed(2));
                                }

                                if(field2.text.isNotEmpty){
                                  final value = double.tryParse(field2.text.replaceAll('', '')) ?? 0;
                                  field2.text = (value.toStringAsFixed(2));
                                }
                              }
                            },
                          )),
                        ),
                      ),    ),
                    Container(
                      height: 30.0,
                      decoration: BoxDecoration(
                          color: Color.fromARGB(255,255, 255, 0),
                          shape: BoxShape.circle
                      ),
                      child: IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          double currentValue = field4.text.isEmpty ? 0 : double.parse(field4.text.replaceAll('', ''));

                          setState(() {
                            currentValue++;
                            field4.text = (currentValue).toStringAsFixed(2);; // incrementing value

                            text3=field4.text.replaceAll('', '');
                            double z = double.tryParse(field4.text.toString().replaceAll('', '')) as double;
                            text3=field4.text.replaceAll('', '');
                            c = z ?? 0; // handle null and String
                            field3.text = ((a - b)-c).toStringAsFixed(2);;


                            if(((a - b)-c).toInt() <  0){

                              double number = double.parse("0");

                              setState(() {
                                field3.text = number.toStringAsFixed(2);
                              });


                            }else{
                              field3.text = ((a - b)-c).toStringAsFixed(2);

                            }




                          });

                          updateBalance();
                          updateCollest();
                          updateDeposit();
                          updateTotalprice();
                        },
                        iconSize: 15,
                        tooltip: "increase",
                      ),
                    ),


                  ],
                ),









                SizedBox(height: 20,),
                // Fourth Element
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: ElevatedButton(

                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255,255, 255, 0),
                            foregroundColor: Theme.of(context).primaryColorLight,
                          ),
                          child: Text(
                            "save",style: TextStyle(color: Colors.black),
                            textScaleFactor: 1.5,
                          ),

                          onPressed: () {

                            setState(() {
                              debugPrint("Save button clicked");
                              _save();
                              // Navigator.of(context).pushReplacement(
                              //     MaterialPageRoute(builder: (context) =>HomeScreen(text1: text1,text2: text2,text3: text3,text4:text4)));
                            });
                          },
                        ),
                      ),

                      Container(width: 5.0,),

                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255,255, 255, 0),
                            foregroundColor: Colors.black,
                          ),
                          child: Text(
                            'Delete',
                            textScaleFactor: 1.5,
                          ),
                          onPressed: () {
                            setState(() {
                              debugPrint("Delete button clicked");
                              _delete();
                            });
                          },
                        ),
                      ),

                    ],
                  ),
                ),

              ],
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

        )
    );
  }

  void moveToLastScreen() {
    // Navigator.pop(context, true);
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => Nextin()));
  }

  // Convert the String priority in the form of integer before saving it to Database
  void updatePriorityAsInt(String value) {
    switch (value) {
      case 'High':
        note.priority = 1;
        break;
      case 'Low':
        note.priority = 2;
        break;
    }
  }

  // Convert int priority to String priority and display it to user in DropDown
  String getPriorityAsString(int value) {
    late String priority;
    switch (value) {
      case 1:
        priority = _priorities[0];  // 'High'
        break;
      case 2:
        priority = _priorities[1];  // 'Low'
        break;
    }
    return priority;
  }

  // Update the title of Note object
  void updateTitle(){
    note.title = titleController.text.toString();
  }
  void updateDate(value){
    note.date = value.toString();
  }

  // Update the description of Note object
  void updateDescription() {
    note.description = descriptionController.text.toString();

  }




  void updateEmail(String value) {
    note.email =value;
  }
  void updateNumber(String value) {
    note.number =value;
  }
  void updateAddress(String value) {
    note.address =value;
  }









  void updateTotalprice(){
    if (field1.text.isNotEmpty) {
      // pass
      final value = double.tryParse(field1.text.replaceAll('', '')) ?? 0;
      note.totalprice = value.toStringAsFixed(2);
    }
  }
  void updateDeposit(){
    if (field2.text.isNotEmpty) {
      // pass
      final value = double.tryParse(field2.text.replaceAll('', '')) ?? 0;
      note.deposit = value.toStringAsFixed(2);
    }


  }
  void updateBalance(){

    if(field3.text.isNotEmpty){
      final value = double.tryParse(field3.text.replaceAll('', '')) ?? 0;
      note.balance = value.toStringAsFixed(2);
    }

  }
  void updateCollest(){
    if(field4.text.isNotEmpty){
      final value = double.tryParse(field4.text.replaceAll('', '')) ?? 0;
      note.collectthisweek = value.toStringAsFixed(2);
    }
  }

  // Save data to database
  void _save() async {

    moveToLastScreen();

    // note.date = DateFormat.yMMMd().format(DateTime.now());
    int result;
    if (note.id != null) {  // Case 1: Update operation
      result = await helper.updateNext(note);
    } else { // Case 2: Insert Operation
      result = await helper.insertNext(note);
    }

    if (result != 0) {  // Success
      _showAlertDialog('Status', 'Saved Successfully');
    } else {  // Failure
      _showAlertDialog('Status', 'Problem Saving Note');
    }

  }

  void _delete() async {

    moveToLastScreen();

    // Case 1: If user is trying to delete the NEW NOTE i.e. he has come to
    // the detail page by pressing the FAB of NoteList page.
    if (note.id == null) {
      _showAlertDialog('Status', 'No Note was deleted');
      return;
    }

    // Case 2: User is trying to delete the old note that already has a valid ID.
    int result = await helper.deleteNext(note.id!);
    if (result != 0) {
      _showAlertDialog('Status', 'Note Deleted Successfully');
    } else {
      _showAlertDialog('Status', 'Error Occured while Deleting Note');
    }
  }

  void _showAlertDialog(String title, String message) {

    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: <Widget>[

        TextButton(
          onPressed: () => Navigator.pop(context, 'OK'),
          child: const Text('OK'),
        ),
      ],
    );
    showDialog(
        context: context,
        builder: (_) => alertDialog
    );
  }

}


