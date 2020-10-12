import 'dart:async';

import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
//import 'package:myproject/authform.dart';
import 'package:myproject/homepage.dart';
//import 'package:page_transition/page_transition.dart';

class SplashScreen extends StatefulWidget {
  final line1;
  final line2;
  SplashScreen(this.line1, this.line2);
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
        Duration(seconds: 3),
        () =>
            //Navigator.of(context).pushReplacement(

            //     PageTransition(
            //         type: PageTransitionType.fade,
            //         child: MainPage()))
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => MainPage(widget.line2)),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    stops: [
                      0.1,
                      0.4,
                      0.6,
                      0.9
                    ],
                    colors: [
                      Colors.yellow,
                      Colors.red,
                      Colors.indigo,
                      Colors.teal
                    ]),
                borderRadius: BorderRadius.circular(6.0),
                boxShadow: [
                  BoxShadow(
                      color: Color(0xFF6078ea).withOpacity(.3),
                      offset: Offset(0.0, 8.0),
                      blurRadius: 8.0)
                ]),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Flexible(
                flex: 3,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 50,
                          child: Icon(
                            Icons.school,
                            color: Colors.red,
                            size: 50,
                          )),
                      Padding(
                        padding: EdgeInsets.only(top: 10),
                      ),
                      Text(
                        widget.line1,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        widget.line2,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
              ),
              Flexible(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: 200,
                        height: 200,
                        child: FlareActor(
                          'assets/Loading.flr',
                          animation: "Alarm",
                          fit: BoxFit.contain,
                          alignment: Alignment.center,
                        ),
                      ),
                      // Padding(
                      //   padding: EdgeInsets.only(top: 20),
                      // ),
                      Center(
                          child: Text(
                        'Loading...',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ))
                    ],
                  ))
            ],
          )
        ],
      ),
    );
  }
}
