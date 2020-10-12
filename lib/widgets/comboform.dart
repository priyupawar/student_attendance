import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'textform.dart';

String path;
Map<String, List> comboData1 = {};

class Combo1 extends StatefulWidget {
  final name;
  final data;
  final fontSize;
  final Map textedit;
  Combo1(this.data, this.name, this.fontSize, this.textedit);
  @override
  _Combo1State createState() => _Combo1State();
}

void updateCombo(textedit, name, value) {
  //print(name);
  textedit.update(name, (v) {
    return value.toString();
  });
  // print(textedit);
}

int nth = 0;
Future getComboData1(String transID, String label) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  path = prefs.getString('path');
  String json = '{"condition":"' + transID + '","condition2":"0"}';
  String url = '' + path + '/GetComboData';
  Map<String, String> headers = {
    // "Content-Type": "application/x-www-form-urlencoded"
    "Content-type": "application/json"
  };
  var response = await http.post(url, headers: headers, body: json);
  //print(response.body);

  comboData1.putIfAbsent(label, () => jsonDecode(response.body));
}

class _Combo1State extends State<Combo1> {
  List comboData = [];
  List keys1 = [];
  String name;
  String comboName;
  String hinttext = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (comboData1[widget.name] == null) {
      return FutureBuilder(
          future: getComboData1(widget.data, widget.name),
          builder: (BuildContext context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              comboData = comboData1[widget.name];
              keys1 = comboData[0].keys.toList();
              comboName = comboData[0][keys1[0]].toString();
              hinttext = comboData[0][keys1[1]].toString();
              // textedit.update(widget.name, (v) {
              //   return comboName;
              // });
              updateCombo(widget.textedit, widget.name, comboName);
              return Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                    elevation: 6.0,
                    onPressed: () {
                      // selectDate1(context);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 80.0,
                      child: Column(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: Row(
                              children: <Widget>[
                                //TextForm(widget.name, widget.fontSize)
                                Text(
                                  widget.name,
                                  style: TextStyle(
                                      color: Theme.of(context).accentColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: widget.fontSize),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                              flex: 3,
                              child: DropdownButton<String>(
                                isExpanded: true,
                                //icon: Icon(Icons.ac_unit),
                                //style: Theme.of(context).textTheme.title,
                                hint: TextForm(
                                    hinttext,
                                    widget
                                        .fontSize), // Not necessary for Option 1
                                // value: dropText,
                                elevation: 16,
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 20),
                                items: comboData.map((value) {
                                  return DropdownMenuItem<String>(
                                    value: value[keys1[0]].toString(),
                                    child: TextForm(
                                        value[keys1[1]], widget.fontSize),
                                  );
                                }).toList(),
                                onChanged: (String newValue1) {
                                  setState(() {
                                    comboName = newValue1;
                                    // textedit.update(widget.name, (v) {
                                    //   return comboName;
                                    // });
                                    updateCombo(widget.textedit, widget.name,
                                        comboName);
                                    // print(textedit);
                                    //getComboData2(reportDetails[0]['CBO_2_QRY'].toString(), name1);
                                  });
                                },
                                value: comboName,
                              ))
                        ],
                      ),
                    ),
                    color: Colors.white,
                  ));
            } else {
              return CircularProgressIndicator();
            }
          });
    } else {
      comboData = comboData1[widget.name];
      keys1 = comboData[0].keys.toList();
      comboName = widget.textedit[widget.name];
      hinttext = comboData[0][keys1[1]].toString();

      if (widget.textedit[widget.name] == 'null') {
        updateCombo(
            widget.textedit, widget.name, comboData[0][keys1[0]].toString());
        // textedit.update(widget.name, (v) {
        //   return comboData[0][keys1[0]].toString();
        // });
      }
      return Padding(
        padding: EdgeInsets.only(top: 10),
        // child: RaisedButton(
        //   shape: RoundedRectangleBorder(
        //       borderRadius: BorderRadius.circular(5.0)),
        //   elevation: 6.0,
        //   onPressed: () {
        //     // selectDate1(context);
        //   },
        child: Container(
          alignment: Alignment.center,
          height: 80.0,
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Row(
                  children: <Widget>[
                    //TextForm(widget.name, widget.fontSize)
                    Text(
                      widget.name,
                      style: TextStyle(
                          color: Theme.of(context).accentColor,
                          fontWeight: FontWeight.bold,
                          fontSize: widget.fontSize),
                    ),
                  ],
                ),
              ),
              Expanded(
                  flex: 2,
                  child: DropdownButton<String>(
                    isExpanded: true,
                    // icon: Icon(Icons.ac_unit),
                    //style: Theme.of(context).textTheme.title,
                    hint: TextForm(hinttext,
                        widget.fontSize), // Not necessary for Option 1
                    // value: dropText,
                    elevation: 16,
                    style: TextStyle(color: Theme.of(context).accentColor),
                    items: comboData.map((value) {
                      return DropdownMenuItem<String>(
                        value: value[keys1[0]].toString(),
                        child: TextForm(value[keys1[1]], widget.fontSize),
                      );
                    }).toList(),
                    onChanged: (String newValue1) {
                      setState(() {
                        comboName = newValue1;
                        updateCombo(widget.textedit, widget.name, comboName);
                        // textedit.update(widget.name, (v) {
                        //   return comboName;
                        // });
                        // print(textedit);
                        //getComboData2(reportDetails[0]['CBO_2_QRY'].toString(), name1);
                      });
                    },
                    value: widget.textedit[widget.name],
                  ))
            ],
          ),
        ),
        //   color: Colors.white,
        // )
      );
    }
  }
}
