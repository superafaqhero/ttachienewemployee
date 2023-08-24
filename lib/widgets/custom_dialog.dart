
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

import '../log_in.dart';

class CustomDialog extends StatelessWidget {
  final String title,
      desc,
      primaryButtonText,
      primaryButtonRoute,
      seconderyButtonText,
      seconderyButtonRoute;

  CustomDialog(
      {required this.title,
        required this.desc,
        required this.primaryButtonText,
        required this.primaryButtonRoute,
        required this.seconderyButtonText,
        required this.seconderyButtonRoute, required MaterialColor backgroundColor});

  static const double padding = 20;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.all(padding),
            decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.rectangle,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black,
                      blurRadius: 10,
                      offset: const Offset(0.0, 10.0))
                ]),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 24.0,
                ),
                AutoSizeText(
                  title,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black, fontSize: 26.0),
                ),
                SizedBox(
                  height: 24.0,
                ),
                AutoSizeText(
                  desc,
                  maxLines: 4,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.blueGrey, fontSize: 18.0),
                ),
                SizedBox(
                  height: 24.0,
                ),
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
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Color.fromARGB(255,255, 255, 0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0)),
                    ),
                      child: AutoSizeText(
                        primaryButtonText,
                        maxLines: 1,
                        style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w400,
                            color:Colors.black),
                      ),
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context)=>LogIn())
                        );
                      }
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                showSeconderyButton(context),

              ],
            ),
          )
        ],
      ),
    );
  }

  showSeconderyButton(BuildContext context) {
    if(seconderyButtonText!=null && seconderyButtonRoute!=null){
      return Container(
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
        child: ElevatedButton(
    style: ElevatedButton.styleFrom(
          primary: Color.fromARGB(255,255, 255, 0),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0)),
    ),
          child: AutoSizeText(
            seconderyButtonText,
            maxLines: 1,
            style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w400,
                color: Colors.black),
          ),
          onPressed: () {
            // Navigator.of(context).pushReplacement(MaterialPageRoute(
            //     builder: (context) =>  FirstScreen()));
          },
        ),
      );
    }
    else{
      return SizedBox(
        height: 10.0,
      );
    }

  }
}
