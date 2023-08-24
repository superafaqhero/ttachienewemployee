import 'package:flutter/material.dart';

import 'NavBar.dart';

class EditExpensePage extends StatefulWidget {
  final String expenseName;
  final String expenseDate;
  final double expensePrice;

  EditExpensePage({
    required this.expenseName,
    required this.expenseDate,
    required this.expensePrice,
  });

  @override
  _EditExpensePageState createState() => _EditExpensePageState();
}

class _EditExpensePageState extends State<EditExpensePage> {
  late TextEditingController _nameController;
  late TextEditingController _dateController;
  late TextEditingController _priceController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.expenseName);
    _dateController = TextEditingController(text: widget.expenseDate.toString());
    _priceController = TextEditingController(text: widget.expensePrice.toString());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dateController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavBar(),

      appBar: AppBar(
        iconTheme: IconThemeData(color:  Color.fromARGB(255,255, 255, 0),),

        backgroundColor: Colors.black45,

        title: Text("Edit Expense",style: TextStyle(fontSize: 30.0,fontWeight: FontWeight.w600,color: Colors.white),),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: 12,),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                  isDense: true,
                  contentPadding:  EdgeInsets.only(top: 40.0, left: 9),
                  labelText: 'Name',
                  labelStyle: TextStyle(
                    color: Color.fromARGB(255,255, 255, 0),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      width: 1,

                    ),
                  ),
                  hintText: "Name",
                  hintStyle: TextStyle(color: Color.fromARGB(255,255, 255, 0),fontSize: 25.0,fontWeight: FontWeight.w900,)
              ),
              style: TextStyle(color: Color.fromARGB(255,255, 255, 0),fontSize: 30.0,fontWeight: FontWeight.w900,),

            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _dateController,
              decoration: InputDecoration(
                  isDense: true,
                  contentPadding:  EdgeInsets.only(top: 40.0, left: 9),
                  labelText: 'Date',
                  labelStyle: TextStyle(
                    color:Color.fromARGB(255,255, 255, 0),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      width: 1,

                    ),
                  ),
                  hintText: "Date",
                  hintStyle: TextStyle(color: Color.fromARGB(255,255, 255, 0),fontSize: 25.0,fontWeight: FontWeight.w900,)
              ),
              style: TextStyle(color: Color.fromARGB(255,255, 255, 0),fontSize: 30.0,fontWeight: FontWeight.w900,),

            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _priceController,
              decoration: InputDecoration(
                  isDense: true,
                  contentPadding:  EdgeInsets.only(top: 40.0, left: 9),
                  labelText: 'Price',
                  labelStyle: TextStyle(
                    color: Color.fromARGB(255,255, 255, 0),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      width: 1,

                    ),
                  ),
                  hintText: "Price",
                  hintStyle: TextStyle(color: Color.fromARGB(255,255, 255, 0),fontSize: 25.0,fontWeight: FontWeight.w900,)
              ),
              style: TextStyle(color: Color.fromARGB(255,255, 255, 0),fontSize: 30.0,fontWeight: FontWeight.w900,),

            ),
            SizedBox(height: 16.0),
            Container(
              color: Color.fromARGB(255, 255, 255, 0),
              child:
              ElevatedButton(

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
                    String newName = _nameController.text;
                    DateTime newDate = DateTime.parse(_dateController.text);
                    double newPrice = double.parse(_priceController.text);
                    Navigator.pop(context);
                    // Navigator.of(context).pushReplacement(
                    //     MaterialPageRoute(builder: (context) =>HomeScreen(text1: text1,text2: text2,text3: text3,text4:text4)));
                  });
                },
              ),





            ),

          ],
        ),
      ),
    );
  }
}
