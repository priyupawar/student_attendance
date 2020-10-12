import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class GroupSms extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _GroupSms();
  }
}

String path;

class _GroupSms extends State<GroupSms> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List comboData1 = [];
  bool checked = true;
  String name;
  String message = '';
  List keys;
  String authKey;
  String senderId;
  List mobiles = [];
  int char = 0;
  int msg = 1;
  bool disabled = true;

  Future getConfig() async {
    var response = await http.get('http://167.114.145.37:3000/GetConfig');

    var data = jsonDecode(response.body);
    authKey = data[0]['AuthKey'];
    senderId = data[0]['SenderID'];
    return response.body;
  }

  Future getMobile(String className) async {
    Map<String, String> headers = {"Content-type": "application/json"};
    var response = await http.post('http://167.114.145.37:3000/GetClassMobile',
        headers: headers, body: '{"ClassName":"' + className + '"}');
    List res = jsonDecode(response.body);

    var i;
    mobiles = [];
    for (i = 0; i < res.length; i++) {
      mobiles.add(res[i]['Mobile']);
    }
    //print(mobiles);
    return response.body;
  }

  Future sendMsg(msg, mobile) async {
    // var response = await http.get(
    //     'http://mysms.msgclub.net/rest/services/sendSMS/sendGroupSms?AUTH_KEY=' +
    //         authKey +
    //         '&message=' +
    //         msg +
    //         '&senderId=' +
    //         senderId +
    //         '&routeId=1&mobileNos=' +
    //         mobile.toString() +
    //         '&smsContentType=english');
    // var res = jsonDecode(response.body);
    // if (res['responseCode'] == "3001") {
    //   final snackBar = SnackBar(
    //     content: Text('Message Sent'),
    //   );
    //   _scaffoldKey.currentState.showSnackBar(snackBar);
    // } else {
    //   final snackBar = SnackBar(
    //     content: Text('Message Not Sent'),
    //   );
    //   _scaffoldKey.currentState.showSnackBar(snackBar);
    // }
    final snackBar = SnackBar(
      content: Text('Message Sent(Testing)'),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
    return 'sent';
  }

  Future getComboData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    path = prefs.getString('path');
    String json = '{"condition":"Class"}';
    String url = '' + path + '/GetComboData';
    Map<String, String> headers = {"Content-type": "application/json"};
    var response = await http.post(url, headers: headers, body: json);

    if (response.body != '') {
      setState(() {
        comboData1 = jsonDecode(response.body);

        keys = comboData1[0].keys.toList();
        name = comboData1[0][keys[0]].toString();

        getMobile(name);
      });
    }
  }

  @override
  void initState() {
    getComboData();
    getConfig();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        body: Wrap(children: <Widget>[
          Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  'Class Name',
                  style: TextStyle(
                      color: Theme.of(context).accentColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0),
                ),
              ),
              DropdownButton<String>(
                hint: Text('Class Name'), // Not necessary for Option 1

                elevation: 16,
                style: TextStyle(color: Colors.deepPurple),
                items: comboData1.map((value) {
                  return DropdownMenuItem<String>(
                    value: value[keys[0]].toString(),
                    child: SizedBox(width: 150, child: Text(value[keys[1]])),
                  );
                }).toList(),

                onChanged: (String newValue1) {
                  setState(() {
                    name = newValue1;
                    getMobile(name);
                  });
                },
                value: name,
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: TextFormField(
              maxLines: 5,
              onChanged: (String value) {
                setState(() {
                  message = value;
                  char = message.length;
                  if (char > 0) {
                    disabled = false;
                  } else {
                    disabled = true;
                  }
                  if (char % 160 == 0) {
                    msg += 1;
                  }
                });
              },
              decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).accentColor, width: 0.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).accentColor, width: 0.0),
                  ),
                  labelText: 'Enter your message',
                  labelStyle: TextStyle(color: Theme.of(context).accentColor)),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 10, bottom: 10),
            child: Container(
                alignment: Alignment.centerRight,
                child: Text('' + char.toString() + '/' + msg.toString() + '',
                    style: TextStyle(color: Colors.grey))),
          ),
          SizedBox(
              height: 100,
              width: double.infinity,
              child: RaisedButton(
                color: Colors.white,
                onPressed: () {
                  if (!disabled) {
                    //sendMsg(message, mobiles);
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                              title: Text('Group SMS'),
                              content: Text('Do you want to send sms to ' +
                                  mobiles.length.toString() +
                                  ' people'),
                              actions: <Widget>[
                                FlatButton(
                                  child: Text('Yes'),
                                  onPressed: () {
                                    Navigator.pop(context);
                                    sendMsg(message, [9004278382]);
                                  },
                                ),
                                FlatButton(
                                  child: Text('No'),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                )
                              ],
                            ));
                  } else {
                    final snackBar = SnackBar(
                      content: Text('Please enter some message'),
                    );
                    _scaffoldKey.currentState.showSnackBar(snackBar);
                  }
                },
                child: Text(
                  'Send',
                  style: TextStyle(
                      fontSize: 18.0, color: Theme.of(context).accentColor),
                ),
              )),
        ]));
  }
}
