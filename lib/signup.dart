
import 'package:flutter/material.dart';

import 'log_in.dart';


class SignUp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      color: Colors.blue,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: (){
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => LogIn()));
            },
          ),
        title: Text("TecHie Contractor"),
    centerTitle: true,
    ),
    body: SingleChildScrollView(
        child: Form(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 30.0,),
              Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Text(
                  "SIGN UP",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0),
                ),
              ),
              Image.asset(
                "assets/logoa.png",
                height: 200,
              ),
              Padding(
                padding: EdgeInsets.only(right: 40.0, left: 40.0),
                child: TextFormField(
                  validator: (val) => val!.isEmpty ? 'Enter a User Name' : null,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      icon: Icon(Icons.person),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide.none),
                      filled: true,
                      hintStyle: TextStyle(color: Colors.grey[800]),
                      hintText: "User Name",
                      fillColor: Colors.blue.shade100),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 40.0, left: 40.0, top: 20.0),
                child: TextFormField(
                  validator: (val) => val!.isEmpty ? 'Enter an email' : null,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      icon: Icon(Icons.mail_outline_rounded),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide.none),
                      filled: true,
                      hintStyle: TextStyle(color: Colors.grey[800]),
                      hintText: "Your Email",
                      fillColor: Colors.blue.shade100),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 40.0, left: 40.0, top: 20.0),
                child: TextFormField(
                  validator: (val) => val!.length < 6
                      ? 'Enter a password with 6+ characters'
                      : null,
                  obscureText: true,
                  decoration: InputDecoration(
                      icon: Icon(Icons.lock),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide.none),
                      filled: true,
                      hintStyle: TextStyle(color: Colors.grey[800]),
                      hintText: "Your Password",
                      fillColor: Colors.blue.shade100),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Padding(
                padding: EdgeInsets.only(right: 40.0, left: 40.0),
                child: TextFormField(
                  validator: (val) => val!.isEmpty ? 'Your Address' : null,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      icon: Icon(Icons.person),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide.none),
                      filled: true,
                      hintStyle: TextStyle(color: Colors.grey[800]),
                      hintText: "Address ",
                      fillColor: Colors.blue.shade100),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Padding(
                padding: EdgeInsets.only(right: 40.0, left: 40.0),
                child: TextFormField(
                  validator: (val) => val!.isEmpty ? 'Enter your Mobile Number' : null,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      icon: Icon(Icons.person),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide.none),
                      filled: true,
                      hintStyle: TextStyle(color: Colors.grey[800]),
                      hintText: "Mobile Number",
                      fillColor: Colors.blue.shade100),
                ),
              ),
              Divider(
                height: 40.0,
                thickness: 4.0,
                color: Colors.green.shade600,
              ),
              Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 3,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 6.0,
                    primary: Colors.blue.shade300,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                  ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 12.0, bottom: 12.0, right: 35.0, left: 35.0),
                      child: Text(
                        "Sign UP",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 25.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    onPressed: () {
                      // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> Home()));
                    }),
              ),
              SizedBox(
                height: 60,
              ),
            ],
          ),
        ),
      ),
    ),
    );
  }
}
