import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:myproject/splashscreen.dart';
import 'package:myproject/localstorage.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';

bool remember = false;
String name;
String pass;
final _name = TextEditingController();
final _pass = TextEditingController();
bool valid = false;
bool filled = false;
bool indicator = false;
String fileName;
String filepath;
final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
final _userKey = GlobalKey<FormState>();

void loginUser(username, password, path, line1, line2) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool('isLoggedIn', true);
  prefs.setString('username', username);
  prefs.setString('password', password);
  prefs.setString('path', path);
  prefs.setString('line1', line1);
  prefs.setString('line2', line2);

  prefs.setBool('remember', remember);
}

class AuthForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AuthForm();
  }
}

class _AuthForm extends State<AuthForm> {
  Future login(String userid, String password) async {
    String json = '{"userid":"' + userid + '","password":"' + password + '"}';
    print(json);
    String url = 'http://167.114.145.37:3000/dev/Login';
    Map<String, String> headers = {"Content-type": "application/json"};
    var response = await http.post(url, headers: headers, body: json);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (response.body != '') {
      //print(response.body);

      var data = jsonDecode(response.body)["data"][0];
      var token = jsonDecode(response.body)["token"];
      //print(token['token']);
      getApplicationDocumentsDirectory().then((Directory directory) {
        dir = directory;
        fileName = userid;
        jsonFile = new File(dir.path + "/" + fileName);
        //print(jsonFile);
        filepath = dir.path + "/" + fileName;
        prefs.setString('file', filepath);
        fileExists = jsonFile.existsSync();
        if (fileExists) {
          print('file exixts');
          this.setState(() {
            fileContent = jsonDecode(jsonFile.readAsStringSync());
            //print(fileContent['token']);
          });
        } else {
          LocalStorage()
              .writeToFile('token', token['token'], dir, jsonFile, fileName);
        }
      });
      if (data['line1'] == 'InCorrect') {
        final snackBar = SnackBar(
          backgroundColor: Colors.red,
          content: Text('Invalid Credentials'),
        );
        _scaffoldKey.currentState.showSnackBar(snackBar);
      } else {
        setState(() {
          valid = false;

          var path = data['Paath'];
          var line1 = data['line1'];
          var line2 = data['line2'];
          // print(filepath);
          loginUser(userid, password, path, line1, line2);

          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => SplashScreen(line1, line2)));
        });

        return 'done';
      }
    } else {
      setState(() {
        valid = true;
      });

      return '';
    }
  }

  @override
  void initState() {
    setState(() {
      SharedPreferences.getInstance().then((SharedPreferences prefs) {
        print(prefs.getBool('remember'));
        remember = prefs.getBool('remember');
        if (remember == true) {
          remember = true;
          name = prefs.getString('username');

          pass = prefs.getString('password');
        } else {
          prefs.setBool('remember', false);
          remember = false;
          name = '';
          pass = '';
        }
        _name.text = name;
        _pass.text = pass;
      });
    });
    super.initState();
    print(_name.text);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            key: _scaffoldKey,
            resizeToAvoidBottomPadding: false,
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Flexible(
                    flex: 3,
                    child: Padding(
                      padding: EdgeInsets.only(top: 10.0),
                      child: Image.asset("assets/image_01.png"),
                    )),
                Flexible(
                  flex: 6,
                  child: Column(
                    children: <Widget>[
                      Flexible(
                        flex: 5,
                        child: Padding(
                            padding: EdgeInsets.all(15), child: FormCard()),
                      ),
                      Flexible(
                        flex: 1,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  SizedBox(
                                    width: 12.0,
                                  ),
                                  Checkbox(
                                    value: remember,
                                    onChanged: (bool newValue) {
                                      setState(() {
                                        remember = newValue;
                                      });
                                    },
                                  ),
                                  SizedBox(
                                    width: 8.0,
                                  ),
                                  Text("Remember me",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontFamily: "Poppins-Medium"))
                                ],
                              ),
                            ]),
                      ),
                      Flexible(
                          flex: 1,
                          child: InkWell(
                              child: Padding(
                                  padding: EdgeInsets.only(left: 15, right: 15),
                                  child: Container(
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
                                          if (_userKey.currentState
                                              .validate()) {
                                            print(_userKey.currentContext);
                                            login(_name.text, _pass.text);
                                          }
                                        },
                                        child: Center(
                                          child: Text("SIGNIN",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontFamily: "Poppins-Bold",
                                                  fontSize: 18,
                                                  letterSpacing: 1.0)),
                                        ),
                                      ),
                                    ),
                                  ))))
                    ],
                  ),
                ),
                Flexible(flex: 1, child: Image.asset("assets/image_02.png"))
              ],
            )));
  }
}

class FormCard extends StatefulWidget {
  @override
  _FormCardState createState() => _FormCardState();
}

class _FormCardState extends State<FormCard> {
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 30,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Padding(
            padding: EdgeInsets.only(
                left: 16.0, right: 16.0, top: 16.0, bottom: 16.0),
            child: Form(
                key: _userKey,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Flexible(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text("Username",
                                  style: TextStyle(
                                      fontFamily: "Poppins-Medium",
                                      fontSize: 20)),
                              TextFormField(
                                controller: _name,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please enter some text';
                                  }
                                  return null;
                                },
                                onChanged: (String value) {
                                  setState(() {
                                    name = value;
                                  });
                                },
                                decoration: InputDecoration(
                                    icon: Icon(Icons.person),
                                    hintText: "Username",
                                    hintStyle: TextStyle(
                                        color: Colors.grey, fontSize: 12.0)),
                              ),
                            ],
                          )),
                      Flexible(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text("Password",
                                  style: TextStyle(
                                      fontFamily: "Poppins-Medium",
                                      fontSize: 20)),
                              TextFormField(
                                controller: _pass,
                                obscureText: _obscureText,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please enter some text';
                                  }
                                  return null;
                                },
                                onChanged: (String value) {
                                  setState(() {
                                    pass = value;
                                    if (value.length > 0) {
                                      filled = false;
                                    }
                                  });
                                },
                                decoration: InputDecoration(
                                    icon: Icon(Icons.security),
                                    suffixIcon: GestureDetector(
                                      child: Icon(_obscureText
                                          ? Icons.visibility
                                          : Icons.visibility_off),
                                      onTap: () {
                                        setState(() {
                                          _obscureText = !_obscureText;
                                        });
                                      },
                                    ),
                                    hintText: "Password",
                                    hintStyle: TextStyle(
                                        color: Colors.grey, fontSize: 12.0)),
                              ),
                            ],
                          )),
                      Flexible(
                          flex: 1,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              GestureDetector(
                                onTap: () {
                                  final snackBar = SnackBar(
                                    content: Text(
                                        'Please contact System Administrator'),
                                  );
                                  _scaffoldKey.currentState
                                      .showSnackBar(snackBar);
                                },
                                child: Text(
                                  "Forgot Password?",
                                  style: TextStyle(
                                      color: Colors.blue,
                                      fontFamily: "Poppins-Medium",
                                      fontSize: 20),
                                ),
                              )
                            ],
                          )),
                    ]))));
  }
}
