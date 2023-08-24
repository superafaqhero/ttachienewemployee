
import 'package:flutter/material.dart';
import 'package:ttachienew/widgets/already_have_an_account_acheak.dart';

import 'First_screen.dart';
import 'home_screen.dart';



TextEditingController namefield = TextEditingController();
TextEditingController passwordfield = TextEditingController();

class LogIn extends StatelessWidget {

  @override
  Widget build(BuildContext context) {


    void navigate(){

      if(passwordfield.text == "tachie123"){

      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> HomeScreen(text1: '', text2: '', text3: '', text4: '',)));

    }

    }



    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255,55, 69, 80),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: (){
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => FirstScreen()));
          },
        ),
        title: Text("Techie Contractor"),
        centerTitle: true,
      ),
      body:SingleChildScrollView(

        child: Form(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 20.0,
              ),
              Container(
                /*decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                     *//* color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 3,
                      blurRadius: 7,
                      offset: Offset(0, 3)*//*
                        // changes position of shadow
                    ),
                  ],
                ),*/
                child: Text(
                  "LOGIN",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0,color: Color.fromARGB(255,255, 255, 0)),
                ),
              ),
              Padding(padding: EdgeInsets.all(23),child:    Image.asset(
                "assets/logonew.png",

              ), ),

              SizedBox(height: 20.0,),
              Container(
                height: 70.0,
                child: Padding(
                  padding: EdgeInsets.only(right: 40.0, left: 40.0,top: 22),
                  child: TextFormField(
                    textAlignVertical: TextAlignVertical.center,
                    controller: namefield,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(left: 10.0),
                        icon: Icon(Icons.person,color: Color.fromARGB(255,255, 255, 0),),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: BorderSide.none),
                        filled: true,
                        hintStyle: TextStyle(color: Colors.grey[800],fontSize: 18.0),
                        hintText: "User Name",
                        fillColor: Color.fromARGB(255,255, 255, 0)),
                  ),
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Container(
                height: 70.0,
                child: Padding(
                  padding: EdgeInsets.only(right: 40.0, left: 40.0, top: 20.0),
                  child: TextFormField(
                    textAlignVertical: TextAlignVertical.center,
                    controller: passwordfield,
                    obscureText: true,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(left: 10.0),
                        icon: Icon(Icons.lock,color: Color.fromARGB(255,255, 255, 0),),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: BorderSide.none),
                        filled: true,
                        hintStyle: TextStyle(color: Colors.grey[800],fontSize: 18.0),
                        hintText: "Password",
                        fillColor: Color.fromARGB(255,255, 255, 0)),
                  ),
                ),
              ),
              SizedBox(
                height: 30.0,
              ),
              Center(
                child: Padding(
                  padding: EdgeInsets.only(right: 40.0, left: 80.0, top: 0.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(25.0),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color:  Color.fromARGB(255,255, 255, 0),
                          spreadRadius: 2,
                          blurRadius: 10,
                          offset: Offset(0, 3),
                          // changes position of shadow
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 6.0,
                        backgroundColor: Color.fromARGB(255,255, 255, 0),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                      ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 12.0, bottom: 12.0, right: 40.0, left: 40.0),
                          child: Text(
                            "Proceed",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 25.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        onPressed: () {
                          navigate();
                        }),
                  ),
                ),
              ),
            ],
          ),
        ),
      )
    );

  }


}
