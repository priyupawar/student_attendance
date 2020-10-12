import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ResetPassword extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ResetPassword();
  }
}

String line2;

class _ResetPassword extends State<ResetPassword> {
  SharedPreferences prefs;
  @override
  void initState() {
    SharedPreferences.getInstance().then((SharedPreferences sp) {
      setState(() {
        line2 = sp.getString('line2');
        //path = prefs.getString('path');
      });
    });
    super.initState();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String name;
  String password;
  String retype;
  bool match = false;
  Future resetpass(String userid, String password) async {
    String json = '{"userid":"' + userid + '","password":"' + password + '"}';
    String url = 'http://167.114.145.37:3000/ResetPassword';
    Map<String, String> headers = {
      // "Content-Type": "application/x-www-form-urlencoded"
      "Content-type": "application/json"
    };
    var response = await http.post(url, headers: headers, body: json);
    print(response.body);
    if (response.body != '') {
      return 'Sucess';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //backgroundColor: Theme.of(context).accentColor,
        appBar: AppBar(
          title: Text(line2),
        ),
        key: _scaffoldKey,
        body: Center(
            child: Padding(
          padding: EdgeInsets.all(10),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: <
                  Widget>[
            Flexible(
                flex: 6,
                child: Card(
                    elevation: 20,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.perm_identity,
                            size: 100, color: Theme.of(context).accentColor),
                        Padding(
                            padding: EdgeInsets.only(bottom: 10, top: 0),
                            child: Text(
                              'Reset Password',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Theme.of(context).accentColor),
                            )),
                        Padding(
                            padding: EdgeInsets.all(10),
                            child: TextFormField(
                              onChanged: (String value) {
                                setState(() {
                                  name = value;
                                });
                              },
                              decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).accentColor,
                                        width: 0.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).accentColor,
                                        width: 0.0),
                                  ),
                                  labelText: 'Username',
                                  labelStyle: TextStyle(
                                      color: Theme.of(context).accentColor)),
                            )),
                        Padding(
                            padding: EdgeInsets.all(10),
                            child: TextFormField(
                              obscureText: true,
                              onChanged: (String value) {
                                setState(() {
                                  password = value;
                                });
                              },
                              decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).accentColor,
                                        width: 0.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).accentColor,
                                        width: 0.0),
                                  ),
                                  labelText: 'Password',
                                  labelStyle: TextStyle(
                                      color: Theme.of(context).accentColor)),
                            )),
                        Padding(
                            padding: EdgeInsets.all(10),
                            child: TextFormField(
                              obscureText: true,
                              onChanged: (String value) {
                                setState(() {
                                  retype = value;

                                  if (retype == password) {
                                    match = false;
                                  } else {
                                    match = true;
                                  }
                                });
                              },
                              decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).accentColor,
                                        width: 0.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).accentColor,
                                        width: 0.0),
                                  ),
                                  labelText: 'Retype Password',
                                  labelStyle: TextStyle(
                                      color: Theme.of(context).accentColor)),
                            )),
                        match
                            ? Text('Password not matched',
                                style: TextStyle(color: Colors.red))
                            : Text(''),

                        // SizedBox(
                        //     width: double.infinity,
                        //     height: 80,
                        //     child: Padding(
                        //         padding: EdgeInsets.all(10),
                        //         child: RaisedButton(
                        //           elevation: 20,
                        //           color: Colors.white,
                        //           child: Text('Submit',
                        //               style: TextStyle(
                        //                 fontSize: 18,
                        //                 color: Theme.of(context).accentColor,
                        //               )),
                        //           onPressed: () {
                        //             var msg = resetpass(name, password);
                        //             if (msg.toString() != '') {
                        //               final snackBar = SnackBar(
                        //                 content: Text(
                        //                     'Password Reset Sucessfully'),
                        //               );
                        //               _scaffoldKey.currentState
                        //                   .showSnackBar(snackBar);
                        //             }
                        //             // Navigator.pushReplacement(
                        //             //   context,
                        //             //   MaterialPageRoute(builder: (context) => MainPage()),
                        //             // );
                        //           },
                        //         )))
                        Flexible(
                          flex: 1,
                          child: InkWell(
                              child: Padding(
                                  padding: EdgeInsets.all(0),
                                  child: Container(
                                    // width: 330,
                                    // height: 50,
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(colors: [
                                          Color(0xFF17ead9),
                                          Color(0xFF6078ea)
                                        ]),
                                        borderRadius:
                                            BorderRadius.circular(6.0),
                                        boxShadow: [
                                          BoxShadow(
                                              color: Color(0xFF6078ea)
                                                  .withOpacity(.3),
                                              offset: Offset(0.0, 8.0),
                                              blurRadius: 8.0)
                                        ]),
                                    child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        onTap: () {
                                          var msg = resetpass(name, password);
                                          if (msg.toString() != '') {
                                            final snackBar = SnackBar(
                                              content: Text(
                                                  'Password Reset Sucessfully'),
                                            );
                                            _scaffoldKey.currentState
                                                .showSnackBar(snackBar);
                                          }
                                        },
                                        child: Center(
                                          child: Text("RESET",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontFamily: "Poppins-Bold",
                                                  fontSize: 18,
                                                  letterSpacing: 1.0)),
                                        ),
                                      ),
                                    ),
                                  ))),
                        )
                      ],
                    ))),
          ]),
        )));
  }
}
