import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:myproject/getlist.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

String path;

class DetailForm extends StatefulWidget {
  final String name;
  final String id;
  DetailForm(this.name, this.id);
  @override
  State<StatefulWidget> createState() {
    return _DetailForm();
  }
}

class _DetailForm extends State<DetailForm> {
  bool checked1 = false;
  bool checked2 = false;
  bool indicator = false;
  bool mainindicator = true;
  String name1 = '';
  String name2 = '';
  bool fromPresent = false;
  bool toPresent = false;
  bool combo1Present = false;
  bool combo2Present = false;
  bool check1Present = false;
  bool check2Present = false;
  bool text1Present = false;
  bool text2Present = false;
  DateTime selecteddate = new DateTime.now();
  DateTime selecteddate2 = new DateTime.now();
  DateTime date = new DateTime.now();
  List<Map> data1;
  List comboData1;
  List comboData2;
  List keys1;
  List keys2;
  List reportDetails;
  String _date1;
  String _date2;
  String sp;

  Future selectDate1(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selecteddate,
      firstDate: new DateTime(2000, 1, 1),
      lastDate: new DateTime(DateTime.now().year, 12, 31),
    );
    if (picked != null) {
      setState(() {
        selecteddate = picked;
        _date1 =
            DateFormat("dd-MMM-yy").format(DateTime.parse(picked.toString()));
      });
    }
  }

  Future selectDate2(BuildContext context) async {
    final DateTime picked2 = await showDatePicker(
      context: context,
      initialDate: selecteddate2,
      firstDate: new DateTime(2000, 1, 1),
      lastDate: new DateTime(DateTime.now().year, 12, 31),
    );
    if (picked2 != null) {
      setState(() {
        selecteddate2 = picked2;
        _date2 =
            DateFormat("dd-MMM-yy").format(DateTime.parse(picked2.toString()));
      });
    }
  }

  Future getReportDetails(String transID) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    path = prefs.getString('path');

    String json = '{"TransID":"' + transID + '"}';

    String url = '' + path + '/GetReportDetails';
    Map<String, String> headers = {"Content-type": "application/json"};
    var response = await http.post(url, headers: headers, body: json);

    setState(() {
      reportDetails = jsonDecode(response.body);
      print(reportDetails);
      mainindicator = false;
      sp = reportDetails[0]['SP_NAME'];
      if (reportDetails[0]['CBO_1'] != null) {
        setState(() {
          getComboData1(reportDetails[0]['CBO_1_QRY']);
        });
      }

      if (reportDetails[0]['CHK_BOX'] != null) {
        check1Present = true;
      }
      if (reportDetails[0]['CHK_BOX2'] != null) {
        check2Present = true;
      }
      // if (reportDetails[0]['TXT_BOX'] != null) {
      //   text1Present = true;
      // }
      // if (reportDetails[0]['TXT_BOX2'] != null) {
      //   text2Present = true;
      // }
      if (reportDetails[0]['DTP_1'] != null) {
        fromPresent = true;
      }
      if (reportDetails[0]['DTP_2'] != null) {
        toPresent = true;
      }
      if (reportDetails[0]['CHK_BOX'] != null) {
        checked1 = true;
      }
      if (reportDetails[0]['CHK_BOX2'] != null) {
        checked2 = true;
      }
    });
  }

  Future getComboData1(String transID) async {
    String json = '{"condition":"' + transID + '","condition2":"0"}';
    String url = '' + path + '/GetComboData';
    Map<String, String> headers = {"Content-type": "application/json"};
    var response = await http.post(url, headers: headers, body: json);
    setState(() {
      comboData1 = jsonDecode(response.body);

      keys1 = comboData1[0].keys.toList();
      name1 = comboData1[0][keys1[0]].toString();
      combo1Present = true;
    });
  }

  Future getComboData2(String transID, String name) async {
    String json = '{"condition":"' + transID + '","condition2":"' + name + '"}';
    String url = '' + path + '/GetComboData';
    Map<String, String> headers = {"Content-type": "application/json"};
    var response = await http.post(url, headers: headers, body: json);

    setState(() {
      if (response.body != '') {
        comboData2 = jsonDecode(response.body);
        keys2 = comboData2[0].keys.toList();
        name2 = comboData2[0][keys2[0]].toString();
        combo2Present = true;
      }
    });
  }

  Future getEmpData(String name1, String name2, bool checked1, bool checked2,
      String date1, String date2, String sp) async {
    String json = '{"combo1":"' +
        name1 +
        '","combo1All":"' +
        checked1.toString() +
        '","combo2":"' +
        name2 +
        '","combo2All":"' +
        checked2.toString() +
        '","FromDate":"' +
        date1 +
        '","ToDate":"' +
        date2 +
        '","SP_NAME":"' +
        sp +
        '"}';

    String url = '' + path + '/GetReportData';

    Map<String, String> headers = {"Content-type": "application/json"};

    var response = await http.post(url, headers: headers, body: json);

    if (response.body != '') {
      //print(response.body);
      indicator = false;
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => GetList(response.body, widget.name)),
      );
    }
  }

  @override
  void initState() {
    super.initState();

    getReportDetails(widget.id);
    _date1 = DateFormat("dd-MMM-yy").format(DateTime.parse(date.toString()));
    _date2 =
        DateFormat("dd-MMM-yy").format(DateTime.parse(selecteddate.toString()));
  }

  @override
  Widget build(BuildContext context) {
    print(mainindicator);
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.name),
        ),
        body: !mainindicator
            ? Center(
                child: SingleChildScrollView(
                    child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Card(
                            elevation: 20,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: Padding(
                                padding: EdgeInsets.all(20),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    Column(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        // Text(
                                        //   reportDetails[0]['CBO_1']
                                        //       .toString()
                                        //       .toUpperCase(),
                                        //   style: TextStyle(
                                        //       color:
                                        //           Theme.of(context).accentColor,
                                        //       fontWeight: FontWeight.bold,
                                        //       fontSize: 18.0),
                                        // ),
                                        Row(
                                          children: <Widget>[
                                            Expanded(
                                                child: TextField(
                                              decoration: InputDecoration(
                                                  labelText: reportDetails[0]
                                                          ['CBO_1_QRY']
                                                      .toString()),
                                            )),
                                          ],
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Column(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        // Text(
                                        //   reportDetails[0]['CBO_1']
                                        //       .toString()
                                        //       .toUpperCase(),
                                        //   style: TextStyle(
                                        //       color:
                                        //           Theme.of(context).accentColor,
                                        //       fontWeight: FontWeight.bold,
                                        //       fontSize: 18.0),
                                        // ),
                                        Row(
                                          children: <Widget>[
                                            Expanded(
                                                child: TextField(
                                              decoration: InputDecoration(
                                                  labelText: reportDetails[0]
                                                          ['CBO_1_QRY']
                                                      .toString()),
                                            )),
                                          ],
                                        ),
                                      ],
                                    ),
                                    combo1Present
                                        ? Column(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Container(
                                                margin: EdgeInsets.all(10.0),
                                                alignment: Alignment.topLeft,
                                                child: Padding(
                                                  padding:
                                                      EdgeInsets.only(right: 5),
                                                  child: Text(
                                                    reportDetails[0]['CBO_1']
                                                        .toString()
                                                        .toUpperCase(),
                                                    style: TextStyle(
                                                        color: Theme.of(context)
                                                            .accentColor,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 18.0),
                                                  ),
                                                ),
                                              ),
                                              Row(
                                                children: <Widget>[
                                                  check1Present
                                                      ? Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: <Widget>[
                                                              Checkbox(
                                                                value: checked1,
                                                                onChanged: (bool
                                                                    newValue) {
                                                                  setState(() {
                                                                    checked1 =
                                                                        newValue;

                                                                    if (!newValue) {
                                                                      getComboData2(
                                                                          reportDetails[0]['CBO_2_QRY']
                                                                              .toString(),
                                                                          name1);
                                                                    }
                                                                  });
                                                                },
                                                              ),
                                                            ])
                                                      : Text(''),
                                                  combo1()
                                                ],
                                              ),
                                            ],
                                          )
                                        : Text(''),
                                    !checked1
                                        ? Column(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              combo2Present
                                                  ? Container(
                                                      margin:
                                                          EdgeInsets.all(10.0),
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Text(
                                                        reportDetails[0]
                                                                ['CBO_2']
                                                            .toString(),
                                                        style: TextStyle(
                                                            color: Theme.of(
                                                                    context)
                                                                .accentColor,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 18.0),
                                                      ),
                                                    )
                                                  : Text(''),
                                              combo2Present
                                                  ? Row(
                                                      children: <Widget>[
                                                        check2Present
                                                            ? Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: <
                                                                    Widget>[
                                                                    Checkbox(
                                                                      value:
                                                                          checked2,
                                                                      onChanged:
                                                                          (bool
                                                                              newValue) {
                                                                        setState(
                                                                            () {
                                                                          checked2 =
                                                                              newValue;
                                                                          print(
                                                                              checked2);
                                                                        });
                                                                      },
                                                                    ),
                                                                  ])
                                                            : Text(''),
                                                        combo2(),
                                                      ],
                                                    )
                                                  : Text('')
                                            ],
                                          )
                                        : Text(''),
                                    Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        fromPresent
                                            ? Padding(
                                                padding:
                                                    EdgeInsets.only(top: 10),
                                                child: RaisedButton(
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5.0)),
                                                  elevation: 6.0,
                                                  onPressed: () {
                                                    selectDate1(context);
                                                  },
                                                  child: Container(
                                                    alignment: Alignment.center,
                                                    height: 80.0,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: <Widget>[
                                                        Row(
                                                          children: <Widget>[
                                                            Container(
                                                              child: Row(
                                                                children: <
                                                                    Widget>[
                                                                  Text(
                                                                    reportDetails[0]
                                                                            [
                                                                            'DTP_1']
                                                                        .toString(),
                                                                    style: TextStyle(
                                                                        color: Theme.of(context)
                                                                            .accentColor,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        fontSize:
                                                                            18.0),
                                                                  ),
                                                                  Text(
                                                                    " $_date1",
                                                                    style: TextStyle(
                                                                        color: Theme.of(context)
                                                                            .accentColor,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        fontSize:
                                                                            18.0),
                                                                  ),
                                                                ],
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                        Text(
                                                          "  Change",
                                                          style: TextStyle(
                                                              color: Theme.of(
                                                                      context)
                                                                  .accentColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 18.0),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  color: Colors.white,
                                                ))
                                            : Text(''),
                                        toPresent
                                            ? Padding(
                                                padding:
                                                    EdgeInsets.only(top: 10),
                                                child: RaisedButton(
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5.0)),
                                                  elevation: 6.0,
                                                  onPressed: () {
                                                    selectDate2(context);
                                                  },
                                                  child: Container(
                                                    alignment: Alignment.center,
                                                    height: 80.0,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: <Widget>[
                                                        Row(
                                                          children: <Widget>[
                                                            Container(
                                                              child: Row(
                                                                children: <
                                                                    Widget>[
                                                                  Text(
                                                                    reportDetails[0]
                                                                            [
                                                                            'DTP_2']
                                                                        .toString(),
                                                                    style: TextStyle(
                                                                        color: Theme.of(context)
                                                                            .accentColor,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        fontSize:
                                                                            18.0),
                                                                  ),
                                                                  Text(
                                                                    " $_date2",
                                                                    style: TextStyle(
                                                                        color: Theme.of(context)
                                                                            .accentColor,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        fontSize:
                                                                            18.0),
                                                                  ),
                                                                ],
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                        Text(
                                                          "  Change",
                                                          style: TextStyle(
                                                              color: Theme.of(
                                                                      context)
                                                                  .accentColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 18.0),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  color: Colors.white,
                                                ))
                                            : Text(''),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 20.0,
                                    ),
                                    Center(
                                        child: Padding(
                                      padding: EdgeInsets.only(top: 10.0),
                                      child: InkWell(
                                          child: Container(
                                        width: 330,
                                        height: 50,
                                        decoration: BoxDecoration(
                                            gradient: LinearGradient(colors: [
                                              Theme.of(context).backgroundColor,
                                              Theme.of(context).accentColor
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
                                              setState(() {
                                                indicator = true;
                                                getEmpData(
                                                    name1,
                                                    name2,
                                                    checked1,
                                                    checked2,
                                                    _date1,
                                                    _date2,
                                                    sp);
                                              });
                                            },
                                            child: Center(
                                              child: Text("SUBMIT",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontFamily:
                                                          "Poppins-Bold",
                                                      fontSize: 18,
                                                      letterSpacing: 1.0)),
                                            ),
                                          ),
                                        ),
                                      )),
                                    )),
                                    indicator
                                        ? Center(
                                            child: Padding(
                                                padding: EdgeInsets.all(20),
                                                child:
                                                    CircularProgressIndicator()))
                                        : Text(''),
                                  ],
                                ))))))
            : Center(child: CircularProgressIndicator()));
  }

  Widget combo1() {
    if (comboData1 != null) {
      return DropdownButton<String>(
        hint: Text(comboData1[0][keys1[1]].toString(),
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0)), // Not necessary for Option 1

        elevation: 16,
        style: TextStyle(color: Colors.deepPurple),
        items: !checked1
            ? comboData1.map((value) {
                return DropdownMenuItem<String>(
                  value: value[keys1[0]].toString(),
                  child: Text(value[keys1[1]],
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18.0)),
                );
              }).toList()
            : null,
        onChanged: (String newValue1) {
          setState(() {
            name1 = newValue1;

            getComboData2(reportDetails[0]['CBO_2_QRY'].toString(), name1);
          });
        },
        value: name1,
      );
    } else {
      return DropdownButton<String>(
        onChanged: (value) {},
        hint: Text(''), // Not necessary for Option 1

        elevation: 16,
        style: TextStyle(color: Colors.deepPurple), items: null,
      );
    }
  }

  Widget combo2() {
    if (comboData2 != null) {
      return DropdownButton<String>(
        hint: Text(
            comboData2[0][keys2[1]].toString()), // Not necessary for Option 1

        elevation: 16,
        style: TextStyle(color: Colors.deepPurple),
        items: !checked2
            ? comboData2.map((value) {
                return DropdownMenuItem<String>(
                  value: value[keys2[0]].toString(),
                  child: Text(value[keys2[1]],
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18.0)),
                );
              }).toList()
            : null,
        onChanged: (String newValue) {
          setState(() {
            name2 = newValue;
          });
        },
        value: name2,
      );
    } else {
      return DropdownButton<String>(
          items: null,
          onChanged: (value) {},
          hint: Text(''), // Not necessary for Option 1

          elevation: 16,
          style: TextStyle(color: Colors.deepPurple));
    }
  }
}
