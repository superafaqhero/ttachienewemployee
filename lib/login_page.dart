import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:line_icons/line_icons.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ttachienew/tabstestfile.dart';

import 'forgetpass.dart';
import 'home_screen.dart';
import 'api_constants.dart';















//after libraries
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  String? _selectedRole ='employee';
String? _email;
String? _username;
String? _password;

  void _submitForm() { 
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // do something with _email, _username and _password
      _login();
    }
  }





  bool _isLoading = false;
  Future<void> _login() async {
    setState(() {
      _isLoading = true;
    });

    var url = '${ApiConstants.baseUrl}login.php';
    var response = await http.post(Uri.parse(url), body: {
      'email': _emailController.text,
      'password': _passwordController.text,
    });
    var jsonResponse;
    try {
      jsonResponse = json.decode(response.body);
      // Use the jsonResponse data here
    } catch (e) {
      // Handle the error here
      print('Error decoding JSON response: $e');
    }


    setState(() {
      _isLoading = false;
    });

    if (!jsonResponse['error'] && jsonResponse['user']['type'] == 'owner') {
      // Login successful, navigate to home page or other page

      final prefs = await SharedPreferences.getInstance();
      prefs.setBool('loggedIn', true); // set a flag to indicate that the user is logged in
      prefs.setString('userId', jsonResponse['user']['id']);
      prefs.setString('username', jsonResponse['user']['username']);
      prefs.setString('email', jsonResponse['user']['email']);
      prefs.setString('role', _selectedRole!);

print(_selectedRole);


if(_selectedRole == "employee"){
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => MyHomePage()),
        (route) => false,
  );

}else{
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => HomeScreen()),
        (route) => false,
  );


}
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => HomeScreen(),
      //   ),
      // );




    } else {
      // Login failed, show error message
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text(jsonResponse['message']),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('OK')),
              ],
            );
          });
    }
  }








  //here to add public variables
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:     SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 60.0),
          child:
          Column(
            children: [
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
                Container(
                  width: double.infinity, // width matches parent widget
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start, // aligns children to the start
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Sign in',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Text(
                        'Welcome back to Techie',
                        style: TextStyle(color: Colors.white,fontSize: 18.0),
                      ),
                    ],
                  ),
                )
                ,



          Form(
            key: _formKey,
            child:
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 40.0),
                  // Container(
                  //   width: MediaQuery.of(context).size.width * 0.8, // 80% of the total screen width
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //     crossAxisAlignment: CrossAxisAlignment.center,
                  //     children: <Widget>[
                  //       SizedBox(
                  //         width: 32, // Set your desired fixed width for the Radio widget
                  //         child: Theme(
                  //           data: ThemeData(
                  //             unselectedWidgetColor: Colors.grey, // Text color when not selected
                  //           ),
                  //           child: Radio(
                  //             value: 'employee',
                  //             groupValue: _selectedRole,
                  //             onChanged: (value) {
                  //               setState(() {
                  //                 _selectedRole = value;
                  //               });
                  //             },
                  //           ),
                  //         ),
                  //       ),
                  //       Text(
                  //         'Employee',
                  //         style: TextStyle(
                  //           fontSize: 18,
                  //           color: Color.fromARGB(255,255, 255, 0), // Text color when selected
                  //         ),
                  //       ),
                  //       SizedBox(width: 20),
                  //       SizedBox(
                  //         width: 32, // Set your desired fixed width for the Radio widget
                  //         child: Theme(
                  //           data: ThemeData(
                  //             unselectedWidgetColor: Colors.grey, // Text color when not selected
                  //           ),
                  //           child: Radio(
                  //             value: 'owner',
                  //             groupValue: _selectedRole,
                  //             onChanged: (value) {
                  //               setState(() {
                  //                 _selectedRole = value;
                  //               });
                  //             },
                  //           ),
                  //         ),
                  //       ),
                  //       Text(
                  //         'Owner',
                  //         style: TextStyle(
                  //           fontSize: 18,
                  //           color:  Color.fromARGB(255,255, 255, 0), // Text color when selected
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),

                  SizedBox(height: 20.0),
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
                    onSaved: (value) {
                      _email = value!;
                    },
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide(color: Color.fromARGB(255,255, 255, 0)),
                      ),
                      prefixIcon: Icon(LineIcons.lock, color: Color.fromARGB(255,255, 255, 0)),
                      hintText: 'Password',
                        hintStyle: TextStyle(color: Color.fromARGB(255,255, 255, 0),fontSize: 25.0,fontWeight: FontWeight.w900,)

                    ),
                    style: TextStyle(color: Color.fromARGB(255,255, 255, 0),fontSize: 25.0,fontWeight: FontWeight.w900,),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a password';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _password = value!;
                    },
                  ),
                  SizedBox(height: 25.0),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> PasswordResetPage()));
                    },

                    child: Text(
                      'Forgot password?',
                      style: TextStyle(
                        color: Colors.white,

                      ),
                    ),
                  ),
                  SizedBox(height: 40.0),
                  GestureDetector(
                    onTap: () {

                      if(_selectedRole !=null){
                        _isLoading ? null : _submitForm();
                      }else{

                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Please Select a Role'),
                              content: Text('You must select a role before submitting the form.'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(); // Close the dialog
                                  },
                                  child: Text('OK'),
                                ),
                              ],
                            );
                          },
                        );

                      }




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
                          'Sign In',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Your other widgets here
                        Visibility(
                          visible: _isLoading,
                          child: CircularProgressIndicator(),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 40.0),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     Container(
                  //       decoration: BoxDecoration(
                  //         border: Border.all(color: Color(0xFF93278F), width: 2.0),
                  //         borderRadius: BorderRadius.circular(8.0),
                  //         color: Colors.transparent,
                  //       ),
                  //       child: IconButton(
                  //         icon: Icon(Icons.facebook, color: Color(0xFF93278F)),
                  //         onPressed: () {},
                  //       ),
                  //     ),
                  //     SizedBox(width: 20.0),
                  //     Container(
                  //       decoration: BoxDecoration(
                  //         border: Border.all(color: Color(0xFF93278F), width: 2.0),
                  //         borderRadius: BorderRadius.circular(8.0),
                  //         color: Colors.transparent,
                  //       ),
                  //       child: IconButton(
                  //         icon: Icon(FontAwesomeIcons.google, color: Color(0xFF93278F)),
                  //         onPressed: () {},
                  //       ),
                  //     ),
                  //
                  //   ],
                  // ),
                  SizedBox(height: 40.0),
                  Text.rich(
                    TextSpan(
                      text: 'Don\'t have an account? ',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.normal,
                        color: Color(0xFFFFFFFF), // white
                       // yellow

                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Sign up',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: // white
                            Color(0xFFFFFF00), // yellow

                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              // TODO: Implement sign up functionality
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RegisterPage(),
                                ),
                              );
                            },
                        ),
                      ],
                    ),
                  )

                ],
              ),
          ), ],
          ),


        ),
      ),
    );
  }

}

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();


  final _formKey = GlobalKey<FormState>();

String? _username;
String? _name;
String? _email;
String? _phone;
String? _password;
String? _confirmPassword;

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Do something with _username, _name, _email, _phone, and _password
      _register();
    }
  }












  Future<void> _register() async {
    final response = await http.post(Uri.parse('${ApiConstants.baseUrl}register.php'),
      body: {
        'username': _usernameController.text,
        'name': _nameController.text,
        'email': _emailController.text,
        'phone': _phoneController.text,
        'password': _passwordController.text,
        'type': 'owner',
      },
    );

    final data = jsonDecode(response.body);

    if (data['success']) {
      // registration successful
      // do something here, e.g. navigate to home page

      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Success'),
              content: Text(data['message']),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('OK')),
              ],
            );
          });
    } else {
      // registration failed
      // show an error message
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text(data['message']),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('OK')),
              ],
            );
          });
    }
  }










  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 60.0),
          child:
          Column(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/logonew.png',
                    width: 150,
                  ),
                  SizedBox(height:15.0),
    ]),
              Container(
                width: double.infinity, // width matches parent widget
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start, // aligns children to the start
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sign Up',
                      style: TextStyle(
                        fontSize: 28.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      'Create your Techie account now',
                      style: TextStyle(fontSize: 18.0
                      ,
                          color: Colors.white

                      ),
                    ),
                  ],
                ),
              )
,

          Form(
            key: _formKey,
            child:
            Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [


                  SizedBox(height: 25.0),
                  TextFormField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide(color: Color.fromARGB(255,255, 255, 0)),
                      ),
                        prefixIcon: Icon(LineIcons.user, color: Color.fromARGB(255,255, 255, 0)),
                        hintText: 'User Name',
                        contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),

                        hintStyle: TextStyle(color: Color.fromARGB(255,255, 255, 0),fontSize: 25.0,fontWeight: FontWeight.w900,)

                    ),
                    style: TextStyle(color: Color.fromARGB(255,255, 255, 0),fontSize: 25.0,fontWeight: FontWeight.w900,),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a username';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _username = value!;
                    },




                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide(color: Color.fromARGB(255,255, 255, 0)),
                      ),
                        prefixIcon: Icon(LineIcons.userCircleAlt, color: Color.fromARGB(255,255, 255, 0)),
                        hintText: 'Name',
                        contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),

                        hintStyle: TextStyle(color: Color.fromARGB(255,255, 255, 0),fontSize: 25.0,fontWeight: FontWeight.w900,)

                    ),
                    style: TextStyle(color: Color.fromARGB(255,255, 255, 0),fontSize: 25.0,fontWeight: FontWeight.w900,),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _name = value!;
                    },
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide(color: Color.fromARGB(255,255, 255, 0)),
                      ),
                        prefixIcon: Icon(LineIcons.envelopeOpenText, color: Color.fromARGB(255,255, 255, 0)),
                        hintText: 'Email',
                        contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),

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
                    onSaved: (value) {
                      _email = value!;
                    },
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                    controller: _phoneController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide(color: Color.fromARGB(255,255, 255, 0)),
                      ),
                        prefixIcon: Icon(LineIcons.phone, color: Color.fromARGB(255,255, 255, 0)),
                        hintText: 'Phone Number',
                        contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),

                        hintStyle: TextStyle(color: Color.fromARGB(255,255, 255, 0),fontSize: 25.0,fontWeight: FontWeight.w900,)

                    ),
                    style: TextStyle(color: Color.fromARGB(255,255, 255, 0),fontSize: 25.0,fontWeight: FontWeight.w900,),
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your phone number';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _phone = value!;
                    },
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                    obscureText: true,
                    controller: _passwordController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide(color: Color.fromARGB(255,255, 255, 0)),
                      ),
                        prefixIcon: Icon(LineIcons.lock, color: Color.fromARGB(255,255, 255, 0)),
                        hintText: 'Password',
                        contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),

                        hintStyle: TextStyle(color: Color.fromARGB(255,255, 255, 0),fontSize: 25.0,fontWeight: FontWeight.w900,)

                    ),
                    style: TextStyle(color: Color.fromARGB(255,255, 255, 0),fontSize: 25.0,fontWeight: FontWeight.w900,),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a password';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _password = value!;
                    },
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                    obscureText: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide(color: Color.fromARGB(255,255, 255, 0)),
                      ),
                        prefixIcon: Icon(LineIcons.lock, color: Color.fromARGB(255,255, 255, 0)),
                        hintText: 'Confirm Password',
                        contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),

                        hintStyle: TextStyle(color: Color.fromARGB(255,255, 255, 0),fontSize: 25.0,fontWeight: FontWeight.w900,)

                    ),
                    style: TextStyle(color: Color.fromARGB(255,255, 255, 0),fontSize: 25.0,fontWeight: FontWeight.w900,),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please confirm your password';
                      }
                      if (value != _passwordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _confirmPassword = value!;
                    },
                  ),

                  SizedBox(height: 25.0),
                  GestureDetector(
                    onTap: () {
                      // TODO: Implement sign in functionality
                      // _register();
                      _submitForm();
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
                            Color(0xFFFFFF00), //
                          ],
                          stops: [0.0, 1.0],
                          tileMode: TileMode.clamp,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'Sign Up',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),


                  SizedBox(height: 20.0),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     Container(
                  //       decoration: BoxDecoration(
                  //         border: Border.all(color: Color(0xFF93278F), width: 2.0),
                  //         borderRadius: BorderRadius.circular(8.0),
                  //         color: Colors.transparent,
                  //       ),
                  //       child: IconButton(
                  //         icon: Icon(Icons.facebook, color: Color(0xFF93278F)),
                  //         onPressed: () {},
                  //       ),
                  //     ),
                  //     SizedBox(width: 20.0),
                  //     Container(
                  //       decoration: BoxDecoration(
                  //         border: Border.all(color: Color(0xFF93278F), width: 2.0),
                  //         borderRadius: BorderRadius.circular(8.0),
                  //         color: Colors.transparent,
                  //       ),
                  //       child: IconButton(
                  //         icon: Icon(FontAwesomeIcons.google, color: Color(0xFF93278F)),
                  //         onPressed: () {},
                  //       ),
                  //     ),
                  //
                  //   ],
                  // ),
                  SizedBox(height: 20.0),
                  Text.rich(
                    TextSpan(
                      text: 'Already have an account? ',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.normal,
                        color: Colors.white,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Sign in',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255,255, 255, 0)
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              // TODO: Implement sign up functionality
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LoginPage(),
                                ),
                              );
                            },
                        ),
                      ],
                    ),
                  )

                ],
              ),
          ), ],
          ),


        ),
      ),
    );
  }
}
