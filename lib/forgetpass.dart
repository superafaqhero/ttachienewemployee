import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:line_icons/line_icons.dart';

import 'api_constants.dart';

class PasswordResetPage extends StatefulWidget {
  @override
  _PasswordResetPageState createState() => _PasswordResetPageState();
}

class _PasswordResetPageState extends State<PasswordResetPage> {
  final TextEditingController _emailController = TextEditingController();

  Future<void> sendPasswordResetEmail(String email) async {
    final url = Uri.parse('${ApiConstants.baseUrl}mailtest/emailtest.php');

    try {
      final response = await http.post(url, body: {'email': email});

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as dynamic;
        final success = data['success'] ?? false;
        final message = data['message'] ?? 'Failed to send password reset email';

        if (success) {
          // Password reset email sent successfully
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Success'),
              content: Text(message),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('OK'),
                ),
              ],
            ),
          );
        } else {
          // Failed to send password reset email
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Error'),
              content: Text(message),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('OK'),
                ),
              ],
            ),
          );
        }
      } else {
        // Failed to communicate with the server
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Error'),
            content: Text('Failed to communicate with the server'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (error) {
      // Handle any errors that occurred during the request
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('An error occurred: $error'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      iconTheme: IconThemeData(color:  Color.fromARGB(255,255, 255, 0),),

      backgroundColor: Colors.black45,

      title: Text("Password",style: TextStyle(fontSize: 30.0,fontWeight: FontWeight.w600,color: Colors.white),),
      centerTitle: true,
    ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: 20.0),
            Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/logonew.png',
                    width: 250,
                  ),
                  SizedBox(height: 20.0),
                ]),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: BorderSide(color: Colors.yellowAccent),
                  ),
                  prefixIcon: Icon(LineIcons.envelopeOpenText, color: Colors.yellow),
                  hintText: 'Email',
                  hintStyle: TextStyle(color: Color.fromARGB(255,255, 255, 0),fontSize: 25.0,fontWeight: FontWeight.w900,)

              ),
              style: TextStyle(color: Color.fromARGB(255,255, 255, 0),fontSize: 25.0,fontWeight: FontWeight.w900,),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter your email address';
                }
                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                  return 'Please enter a valid email address';
                }
                return null;
              },

            ),


            SizedBox(height: 16.0),
            // ElevatedButton(
            //   onPressed: () {
            //     final email = _emailController.text.trim();
            //     sendPasswordResetEmail(email);
            //   },
            //   child: Text('Send Password Reset Email'),
            // ),
            GestureDetector(
              onTap: () {
                final email = _emailController.text.trim();
                sendPasswordResetEmail(email);
              },
              child: Container(
                width: double.infinity,
                height: 50.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.96435),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 5.37861,
                      spreadRadius: 2.7572,
                      offset: Offset(5.0, 5.0),
                    )

                  ],
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFFFFFFFF), // white
                      Color(0xFFFFFF00), // yellow

                    ],
                    stops: [0.0, 1.0],
                    tileMode: TileMode.clamp,
                  ),
                ),
                child: Center(
                  child: Text(
                    'Send Password Reset Email',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),


















          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Password Reset Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PasswordResetPage(),
    );
  }
}
