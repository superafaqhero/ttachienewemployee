import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:auto_size_text_field/auto_size_text_field.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:map_autocomplete_field/map_autocomplete_field.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ttachienew/tabstestfile.dart';
import 'package:ttachienew/utils/database_helper.dart';
import 'package:ttachienew/utils/mysql.dart';
import 'package:url_launcher/url_launcher.dart';
import 'NavBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart' as PP;
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:dio/dio.dart' as dio;
import 'imageviewer.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';
import 'api_constants.dart';
import 'package:video_player/video_player.dart';
import 'package:path/path.dart' as path;









class NoteDetailapi extends StatefulWidget {

  final String appBarTitle;
  final String isEdit;
  final String type;
  final dynamic note;

  NoteDetailapi(this.note, this.appBarTitle, this.isEdit, this.type);

  @override
  State<StatefulWidget> createState() {

    return NoteDetailState(this.note, this.appBarTitle, this.isEdit,this.type);

  }
}

class NoteDetailState extends State<NoteDetailapi> {
  NoteDetailState(this.note, this.appBarTitle, this.isEdit, this.type);
  dynamic note;
  String type;
  SharedPreferences? prefs;
  bool _isLoading = false;
  bool isLoggedIn = false;
  String userId = '';
  String username = '';
  String email = '';
  String role = '';

  Future<void> initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    isLoggedIn = prefs?.getBool('loggedIn') ?? false;
    userId = prefs?.getString('userId') ?? '';
    username = prefs?.getString('username') ?? '';
    email = prefs?.getString('email') ?? '';
    role = prefs?.getString('role') ?? '';
    _fetchImages();

  }
  void _printMessage () {
    print(userId);
  }


  List<Map<String, dynamic>> _imageDetails = [];
  var permissionGranted = false;

  List<Widget> _selectedImagesn = [];
  List<File> _selectedImages = [];
  final String uploadUrl = '${ApiConstants.baseUrl}upload_images.php';
  final String fetchImagesUrl = '${ApiConstants.baseUrl}fetch_images.php';

  Future<void> _getStoragePermission() async {
    DeviceInfoPlugin plugin = DeviceInfoPlugin();
    AndroidDeviceInfo android = await plugin.androidInfo;
    if (android.version.sdkInt < 33) {
      if (await Permission.storage.request().isGranted) {
        setState(() {
          permissionGranted = true;
        });
      } else if (await Permission.storage.request().isPermanentlyDenied) {
        await openAppSettings();
      } else if (await Permission.audio.request().isDenied) {
        setState(() {
          permissionGranted = false;
        });
      }
    } else {
      if (await Permission.photos.request().isGranted) {
        setState(() {
          permissionGranted = true;
        });
      } else if (await Permission.photos.request().isPermanentlyDenied) {
        await openAppSettings();
      } else if (await Permission.photos.request().isDenied) {
        setState(() {
          permissionGranted = false;
        });
      }
    }
  }

  Future<void> _pickImages() async {
    // final hasPermission = await Permission.storage.request();
    _getStoragePermission();
    if (permissionGranted = true) {
      final ImagePicker picker = ImagePicker();
      final   List<XFile> images = await picker.pickMultipleMedia();
      if (images != null) {
        setState(() {
          _selectedImages = images.map((image) => File(image.path)).toList();
        });
        if(_selectedImages.length == 1 ) {
          print([_selectedImages.first.path, "yersyyesy"]);
          File imageFile = File(_selectedImages.first.path);
          String apiUrl = '${ApiConstants.baseUrl}upload_image.php?ii=565'; // Replace with your API endpoint URL
          uploadImage(imageFile, apiUrl);
        }else{
          uploadImages();
        }
      }
    } else if (permissionGranted = false) {
      _showPermissionDeniedDialog(context);
    }
  }
  Future<void> uploadImage(File imageFile, String apiUrl) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16.0),
              Text('Uploading Media...'),
            ],
          ),
        );
      },
    );

    //   final  request = http.MultipartRequest(
    //   'POST',
    //   Uri.parse("${ApiConstants.baseUrl}upload_image.php"),
    // );
    // request.headers["Accept"] = "multipart/form-data";
    // var file = File(imageFile.path);
    // var stream = http.ByteStream(file.openRead());
    // var length = await file.length();
    //
    // var multipartFile = http.MultipartFile(
    //   'file',
    //   stream,
    //   length,
    //   filename: file.path.split('/').last,
    // );
    // request.fields['user_id'] = userId; // Replace with the actual user ID
    // request.fields['colID'] = note['colId'].toString();
    // request.files.add(multipartFile);
    //
    // final StreamedResponse response = await request.send();
//     var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
//     request.headers['Access-Control-Allow-Origin'] = '*';
//     request.headers['Accept'] = '*/*';
//     request.files.add(await http.MultipartFile.fromPath(
//       'image[]',
//       imageFile.path,
//     ));
//     request.fields['user_id'] = userId; // Replace with the actual user ID
//     request.fields['colID'] = note['colId'].toString();
//
//     var response = await request.send();
//     final respStr = await response.stream.bytesToString();
//     print('responseBody: ' + respStr);
// print([response.statusCode,"ststus is",apiUrl ]) ;
//
//     if (response.statusCode == 200) {
//       Navigator.pop(context);
//       // Images uploaded successfully
//       // Handle the response as per your API's requirements
//       _showSuccessDialog();
//       _fetchImages();
//       print('Image uploaded successfully');
//     } else {
//       print(response.statusCode);
//       _showErrorDialog();
//       Navigator.pop(context);
//       print('Image upload failed with status: ${response.statusCode}');
//     }
    String fileExtension = path.extension(imageFile.path);
    List<int> imageBytes = await File(imageFile.path).readAsBytes();
    String image = base64Encode(imageBytes);
print(fileExtension);
    Map<String, dynamic> body = {
      "image": image,
      "ext": fileExtension,
      "user_id": userId,
      "colID": note['colId'].toString(),
    };

    try {
      var response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Access-Control-Allow-Origin': '*',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        print('Response: ${responseData['status']}, ${responseData['message']}');
        Navigator.pop(context);
        // Images uploaded successfully
        // Handle the response as per your API's requirements
        _showSuccessDialog();
        _fetchImages();
      } else {
        print('HTTP Error ${response.statusCode}');
        print(response.statusCode);
        _showErrorDialog();
        Navigator.pop(context);
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _fetchImages() async {




    setState(() {
      _isLoading = true; // Set the loading state to true before fetching images
    });

    print(["idusawere" , userId,note['colId']]);
    final userIdto = userId; // Replace with the actual user ID
    final note_id = note['colId']; // Replace with the actual user ID
    try {
      final response = await http.get(Uri.parse('$fetchImagesUrl?user_id=$userIdto&note_id=$note_id'));
      print(Uri.parse('$fetchImagesUrl?user_id=$userIdto&note_id=$note_id'));
      if (response.statusCode == 200) {
        final List<dynamic> imageUrls = jsonDecode(response.body);

        setState(() {

        _selectedImagesn = imageUrls.map((url) {
              bool isVideo = _isVideoUrl(url);
              return isVideo
                  ?  _buildVideoPlayer(url)
                  :FadeInImage.assetNetwork(
                placeholder: 'assets/spinner2.gif',
                image: "${ApiConstants.baseUrl}" + url,
              );
            }).toList();











        });
        print(_selectedImagesn);

      } else {
        _showErrorDialog();

      }
    } catch (e) {
      print('Error fetching images: $e');
      _showErrorDialog();
    } finally {
      setState(() {
        _isLoading = false; // Set the loading state to false after fetching images
      });
    }
  }

  bool _isVideoUrl(String url) {
    // You need to implement the logic to check if the URL is a video URL
    // This can be done by checking the file extension or checking the URL pattern.
    // For simplicity, let's assume all URLs ending with ".mp4" are considered video URLs.
    return url.toLowerCase().endsWith('.mp4');
  }
  Widget _buildVideoPlayer(String videoUrl) {
    VideoPlayerController controller = VideoPlayerController.network(videoUrl);
    controller.initialize().then((_) {
      controller.play();
    });

    return AspectRatio(
      aspectRatio: controller.value.aspectRatio,
      child: VideoPlayer(controller),
    );
  }

  Future<void> uploadImages() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16.0),
              Text('Uploading Media...'),
            ],
          ),
        );
      },
    );

    var request = http.MultipartRequest('POST', Uri.parse(uploadUrl));
    request.fields['user_id'] = userId; // Replace with the actual user ID
    request.fields['colID'] = note['colId'].toString(); // Replace with the actual user ID

    for (var i = 0; i < _selectedImages.length; i++) {
      var imageFile = _selectedImages[i];
      var stream = http.ByteStream(imageFile.openRead());
      var length = await imageFile.length();

      var multipartFile = http.MultipartFile(
        'images[]',
        stream,
        length,
        filename: imageFile.path,
      );

      request.files.add(multipartFile);
    }

    var response = await request.send();
    if (response.statusCode == 200) {
      Navigator.pop(context);
      // Images uploaded successfully
      // Handle the response as per your API's requirements
      _showSuccessDialog();
      _fetchImages();

    } else {
      // Failed to upload images
      // Handle the error
      print(response.statusCode);
      _showErrorDialog();
      Navigator.pop(context);

    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Success'),
          content: Text('Media uploaded successfully'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text('Failed to upload Media'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showPermissionDeniedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text('Storage Permission'),
        content: Text('Please grant storage permission to use this feature.'),
        actions: <Widget>[
          TextButton(
            child: Text('Cancel'),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: Text('Open Settings'),
            onPressed: () {
              Navigator.pop(context);
              openAppSettings();
            },
          ),
        ],
      ),
    );
  }













  Future<bool> onbackpress() async{
    Navigator.pop(context, true);
    return true;
  }
  static var _priorities = ['High', 'Low'];

  DatabaseHelper helper = DatabaseHelper();

  String isEdit;
  String appBarTitle;



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

  @override
  void initState() {
    super.initState();

    initPrefs();

    // print(note['colId']);
    titleController.text = note['colTitle'].toString();
    descriptionController.text = note['colDescription'].toString()  == "null" ? "":note['colDescription'].toString();

    _emailController.text = note['colemail'].toString()== "null" ?  "" : (note['colemail'].toString());
    _numberController.text = note['colnumber'].toString()== "null" ? "" : (note['colnumber'].toString());
    addressCtrl.text = note['coladdress'].toString()== "null" ?  "" : (note['coladdress'].toString());





    field1.text = note['colTotalprice'].toString().isEmpty ?  note['colTotalprice'].toString() : (note['colTotalprice'].toString());
    field2.text = note['colDeposit'].toString().isEmpty ?  note['colDeposit'].toString() : note['colDeposit'].toString();
    field3.text = note['colBalance'].toString().isEmpty ?  note['colBalance'].toString() : note['colBalance'].toString();
    field4.text = note['colCollectthisweek'].toString().isEmpty ?  note['colCollectthisweek'].toString() : note['colCollectthisweek'].toString();

    print(note['colTotalprice'].toString().isEmpty);
    a =  (note['colTotalprice'].toString().isEmpty ? 0 : double.tryParse(note['colTotalprice'].toString()))!;

    b = (note['colDeposit'].toString().isEmpty ? 0 : double.tryParse(note['colDeposit'].toString()))!;
    if (note['colDate'].toString().isEmpty) {
      note['colDate'] = DateTime.now().toString();
    }
  }
  bool _isVisible = false;

  @override
  Widget build(BuildContext context) {
    final textScale=MediaQuery.of(context).size.height * 0.01;
    final screenHeight=MediaQuery.of(context).size.height;

    double getHeight(double sysVar,double size){
      double calc=size/1000;
      return sysVar *calc;
    }

    double getTextSize(double sysVar,double size){
      double calc=size/12;
      return sysVar *calc;
    }
    TextStyle? textStyle = Theme.of(context).textTheme.headline6;

    return WillPopScope(

        onWillPop: onbackpress,

        child: Scaffold(
          drawer: NavBar(),
          appBar: AppBar(
            iconTheme: IconThemeData(color:  Color.fromARGB(255,255, 255, 0),),

            backgroundColor: Color.fromARGB(255,55, 69, 80),
            title: Text(appBarTitle),

          ),

          body:
          Padding(
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
maxLines: 3,
                    onChanged: (value) {
                      debugPrint('Something changed in Description Text Field');
                      updateDescription();
                    },
                    decoration: InputDecoration(
                        isDense: true,
                        contentPadding:  EdgeInsets.only(top: 40.0, left: 9),
                        labelText: 'Note',
                        labelStyle: TextStyle(
                          color: myFocusNode.hasFocus ? Colors.blue :Color.fromARGB(255,255, 255, 0),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            width: 1,

                          ),
                        ),
                        hintText: "Note",
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
                              child:

                              // IntlPhoneField(
                              //   controller: _numberController,
                              //   decoration: InputDecoration(
                              //       isDense: true,
                              //       contentPadding:  EdgeInsets.only(top: 40.0, left: 9),
                              //       labelText: 'Number',
                              //       labelStyle: TextStyle(
                              //         color: myFocusNode.hasFocus ? Colors.blue :Color.fromARGB(255,255, 255, 0),
                              //       ),
                              //       border: OutlineInputBorder(
                              //         borderRadius: BorderRadius.circular(10),
                              //         borderSide: const BorderSide(
                              //           width: 1,
                              //
                              //         ),
                              //       ),
                              //       hintText: "Number",
                              //       hintStyle: TextStyle(color: Color.fromARGB(255,255, 255, 0),fontSize: 25.0,fontWeight: FontWeight.w900,)
                              //   ),
                              //   initialCountryCode: 'US', // Set initial country code if needed
                              //   onChanged: (phone) {
                              //     // updateNumber(phone);
                              //     setState(() {
                              //
                              //     });
                              //   },
                              //   onSaved: (phone) {
                              //
                              //   },
                              //   validator: (phone) {
                              //
                              //     // You can add more specific validation rules here
                              //     return null;
                              //   },
                              // ),



                              AutoSizeTextField(
                                controller: _numberController,
                                inputFormatters: <TextInputFormatter>[
                                  // for below version 2 use this
                                  FilteringTextInputFormatter.allow(RegExp('[0-9.]')),
                                ],
                                keyboardType: TextInputType.numberWithOptions(decimal: true),
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

                            AutoSizeTextField(
                              controller: addressCtrl,

                              onChanged: (value) {
                                debugPrint('Something changed in Title Text Field');
                                // updateEmail(value);
                                updateAddress(value);
                              },
                              decoration: InputDecoration(
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
                              style: TextStyle(color: Color.fromARGB(255,255, 255, 0),fontSize: 30.0,fontWeight: FontWeight.w900,),
                            ),


                            // MapAutoCompleteField(
                            //   googleMapApiKey: yourMapApiKey,
                            //   controller: addressCtrl,
                            //   itemBuilder: (BuildContext context, suggestion) {
                            //     return ListTile(
                            //       title: Text(suggestion.description),
                            //     );
                            //   },
                            //   onSuggestionSelected: (suggestion) {
                            //     addressCtrl.text = suggestion.description;
                            //     updateAddress(suggestion.description);
                            //   },
                            //   inputDecoration: InputDecoration(
                            //       isDense: true,
                            //       contentPadding:  EdgeInsets.only(top: 40.0, left: 9),
                            //       labelText: 'Address',
                            //       labelStyle: TextStyle(
                            //         color: myFocusNode.hasFocus ? Colors.blue :Color.fromARGB(255,255, 255, 0),
                            //       ),
                            //       border: OutlineInputBorder(
                            //         borderRadius: BorderRadius.circular(10),
                            //         borderSide: const BorderSide(
                            //           width: 1,
                            //
                            //         ),
                            //       ),
                            //       hintText: "Address",
                            //       hintStyle: TextStyle(color: Color.fromARGB(255,255, 255, 0),fontSize: 25.0,fontWeight: FontWeight.w900,)
                            //   ),
                            //
                            //
                            //
                            //
                            //
                            //
                            //
                            //
                            //
                            //
                            // ),
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

                Visibility(
                  visible: isEdit != "", // Show the widget only if isEdit is not empty
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            ElevatedButton(
                              onPressed: _pickImages,
                              child: Text('Select Media'),
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 255, 255, 0)),
                                foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
                              ),
                            ),
                            SizedBox(height: 16),
                            _isLoading ?CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.yellow),
                            ):
                            Container(
                              height: MediaQuery.of(context).size.height * 0.6,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.yellow.shade200,
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child:GridView.builder(
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 8.0,
                                  crossAxisSpacing: 8.0,
                                  childAspectRatio: 1.0,
                                ),
                                scrollDirection: Axis.horizontal,
                                itemCount: _selectedImagesn.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return GestureDetector(
                                    onTap: () {
                                      // Handle the touch event and navigate to a new page
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ImageViewerScreen(
                                            userId: userId,
                                            noteId: note['colId'],
                                          ),
                                        ),
                                      );
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child:_selectedImagesn[index],



                                    ),
                                  );
                                },
                              ),
                            ),

                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // ElevatedButton(
                //   onPressed: _printMessage,
                //   child: Text('Test Button'),
                // ),
                if (role == "owner")
                SizedBox(height:15,),
                if (role == "owner")
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
                if (role == "owner")
                SizedBox(height: 30.0,),
                if (role == "owner")
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
                if (role == "owner")
                SizedBox(height:25,),
                if (role == "owner")
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
                if (role == "owner")
                SizedBox(height: 30.0,),
                if (role == "owner")
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


                if (role == "owner")

                SizedBox(height:25,),
                if (role == "owner")
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
                if (role == "owner")
                SizedBox(height: 30.0,),
                if (role == "owner")
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
                if (role == "owner")
                SizedBox(height:25,),
                if (role == "owner")
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
                if (role == "owner")
                SizedBox(height: 30.0,),
                if (role == "owner")
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








                if (role == "owner")
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
                              delete_job(context,note['colId']);
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
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => MyHomePage()));
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
    note["colTitle"] = titleController.text.toString();
  }
  void updateDate(value){
    note['colDate'] = value.toString();
  }
  // Update the description of Note object
  void updateDescription() {
    note['colDescription'] = descriptionController.text.toString();

  }

  void updateEmail(String value) {
    note['colemail'] =value;
  }
  void updateNumber(String value) {
    note['colnumber'] =value;
  }
  void updateAddress(String value) {
    note['coladdress'] =value;
  }










  void updateTotalprice(){
    if (field1.text.isNotEmpty) {
      // pass
      final value = double.tryParse(field1.text.replaceAll('', '')) ?? 0;
      note['colTotalprice'] = value.toStringAsFixed(2);
    }
  }
  void updateDeposit(){
    if (field2.text.isNotEmpty) {
      // pass
      final value = double.tryParse(field2.text.replaceAll('', '')) ?? 0;
      note['colDeposit'] = value.toStringAsFixed(2);
    }


  }
  void updateBalance(){

    if(field3.text.isNotEmpty){
      final value = double.tryParse(field3.text.replaceAll('', '')) ?? 0;
      note['colBalance'] = value.toStringAsFixed(2);
    }

  }
  void updateCollest(){
    if(field4.text.isNotEmpty){
      final value = double.tryParse(field4.text.replaceAll('', '')) ?? 0;
      note['colCollectthisweek'] = value.toStringAsFixed(2);
    }
  }

  // Save data to database
  void _save() async {

note['notetype'] = type.toString();

    int result;
    if (isEdit != "") {
      // Case 1: Update operation
      // print(note);
       result = await MySqlDatabase().updateNote(note);
    } else { // Case 2: Insert Operation
// print(note);

      result = await MySqlDatabase().insertNote(note);
    }

    if (result != 0) {  // Success
      _showAlertDialog('Status', 'Saved Successfully');
    } else {  // Failure
      _showAlertDialog('Status', 'Problem Saving Note');
    }
    moveToLastScreen();
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
      // _fetchData();
      moveToLastScreen();
    } else {
      // Handle error
      print('Failed to delete data.');
    }
  }
  // void _delete() async {
  //
  //   moveToLastScreen();
  //
  //   // Case 1: If user is trying to delete the NEW NOTE i.e. he has come to
  //   // the detail page by pressing the FAB of NoteList page.
  //   if (note.id == null) {
  //     _showAlertDialog('Status', 'No Note was deleted');
  //     return;
  //   }
  //
  //   // Case 2: User is trying to delete the old note that already has a valid ID.
  //   int result = await helper.deleteNote(note.id!);
  //   if (result != 0) {
  //     _showAlertDialog('Status', 'Note Deleted Successfully');
  //   } else {
  //     _showAlertDialog('Status', 'Error Occured while Deleting Note');
  //   }
  // }

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


