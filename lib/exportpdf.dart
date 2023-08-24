import 'package:flutter/material.dart';
import 'NavBar.dart';
import 'bottem_bar.dart';
import 'pdfapi.dart';
class GeneratePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavBar(),

      appBar: AppBar(
        iconTheme: IconThemeData(color:  Color.fromARGB(255,255, 255, 0),),


        backgroundColor: Colors.black45,

        title: Text("Export Data",style: TextStyle(fontSize: 30.0,fontWeight: FontWeight.w600,color: Colors.white),),
        centerTitle: true,
      ),

      backgroundColor: Color.fromARGB(255,55, 69, 80),
      body:
      Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Text(
            //   'Generate PDF Notes',
            //     style:TextStyle(fontSize: 15,fontWeight: FontWeight.w500,color: Color.fromARGB(250, 250, 250,  0)),
            // ),

            SizedBox(height: 20),
        Expanded(
          flex: 1,
          child:Center(child:    ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromARGB(255,255, 255, 0),
              foregroundColor: Colors.black,
            ),
            onPressed:() async {
              final pdfFile = await PdfApi.generateTable();

              PdfApi.openFile(pdfFile);
            },
            child: Text('Generate PDF Notes'),
          ) ,)
        ,),
            BottomBar()
          ],
        ),
      ),
    );
  }
}
