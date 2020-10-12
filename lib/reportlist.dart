import 'dart:convert';
import "package:flutter/material.dart";
import 'package:myproject/detailform.dart';
import 'package:http/http.dart' as http;
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

String path;
String data;
String name;

class ReportList extends StatefulWidget {
  final name;
  ReportList(this.name);
  @override
  State<StatefulWidget> createState() {
    return _ReportList();
  }
}

Future getReport(String att, String page) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  path = prefs.getString('path');
  String json = '{"AttType":"' + att + '","PageType":"' + page + '"}';
  String url = '' + path + '/GetReportMainPage';

  Map<String, String> headers = {"Content-type": "application/json"};
  var response = await http.post(url, headers: headers, body: json);
  data = response.body;
}

class _ReportList extends State<ReportList> {
  @override
  void initState() {
    setState(() {
      name = widget.name;
      data = '';
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Report List'),
        ),
        body: list(context));
  }
}

Widget list(BuildContext context) {
  if (data == '') {
    return FutureBuilder(
      builder: (BuildContext context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          List reportDetails = jsonDecode(data);

          return ListView.builder(
            itemCount: reportDetails.length,
            itemBuilder: (BuildContext content, int index) {
              String name = reportDetails[index]['RPT_NAME'];
              String id = reportDetails[index]['TRANSID'];
              String desc = reportDetails[index]['RPT_DESC'];
              int color = int.parse(reportDetails[index]['COLOR']);

              int icon = int.parse(reportDetails[index]['ICON']);

              return SizedBox(
                  height: 80,
                  child: RaisedButton(
                    elevation: 15,
                    color: Colors.white,
                    onPressed: () {
                      Navigator.push(
                        context,
                        PageTransition(
                            duration: Duration(seconds: 1),
                            type: PageTransitionType.scale,
                            child: DetailForm(name, id)),
                      );
                    },
                    child: Card(
                      child: ListTile(
                        leading: Icon(
                          IconData(icon, fontFamily: 'MaterialIcons'),
                          color: Theme.of(context).accentColor,
                          size: 36.0,
                        ),
                        title: Text(
                          name,
                          style: TextStyle(fontSize: 18.0, color: Color(color)),
                        ),
                        subtitle: Text(desc),
                      ),
                    ),
                  ));
            },
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
      future: getReport(name, 'ReportList'),
    );
  } else {
    List reportDetails = jsonDecode(data);

    return ListView.builder(
      itemCount: reportDetails.length,
      itemBuilder: (BuildContext content, int index) {
        String name = reportDetails[index]['RPT_NAME'];
        String id = reportDetails[index]['TRANSID'];
        String desc = reportDetails[index]['RPT_DESC'];
        int color = int.parse(reportDetails[index]['COLOR']);

        int icon = int.parse(reportDetails[index]['ICON']);

        return SizedBox(
            height: 80,
            child: RaisedButton(
              elevation: 15,
              color: Colors.white,
              onPressed: () {
                Navigator.push(
                  context,
                  PageTransition(
                      duration: Duration(seconds: 1),
                      type: PageTransitionType.scale,
                      child: DetailForm(name, id)),
                );
              },
              child: Card(
                child: ListTile(
                  leading: Icon(
                    IconData(icon, fontFamily: 'MaterialIcons'),
                    color: Theme.of(context).accentColor,
                    size: 36.0,
                  ),
                  title: Text(
                    name,
                    style: TextStyle(fontSize: 18.0, color: Color(color)),
                  ),
                  subtitle: Text(desc),
                ),
              ),
            ));
      },
    );
  }
}
