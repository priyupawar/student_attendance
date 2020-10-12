import 'widgets/textfieldform.dart';
import 'widgets/checkboxform.dart';
import 'widgets/comboform.dart';
import 'widgets/textform.dart';
import 'widgets/datepicker.dart';
import 'widgets/timepicker.dart';
import 'widgets/buttonform.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

var textEditingControllers = <TextEditingController>[];
Map<String, String> textedit;
String jsondata;
List reportDetails;
List<Widget> data = [];
Map<String, String> checkvalue;
String formType;
int textfieldcount;
Map<String, List> comboData1 = {};
List keys1;
String path;
String name1;
List<Widget> checkcombo = [];
bool formFilled = false;
bool comboFilled = false;
String _date1;
String _time;
DateTime selecteddate = new DateTime.now();
TimeOfDay selectedtime = new TimeOfDay(
  hour: DateTime.now().hour,
  minute: DateTime.now().minute,
);
Future getMasterReport() async {
  // print('inside master form');
  SharedPreferences prefs = await SharedPreferences.getInstance();

  path = prefs.getString('path');
  String query =
      "select * from UTIL_SCREEN_BUILDER_T where code = 'M002' order by 2";
  String json = '{"key":"8080883330","query":"' + query + '"}';
  String url = '' + path + '/sqldirect';
  //print(json);
  Map<String, String> headers = {
    // "Content-Type": "application/x-www-form-urlencoded"
    "Content-type": "application/json"
  };
  var response = await http.post(url, headers: headers, body: json);
  print(response.body);
  jsondata = response.body;

}

class MasterForm extends StatefulWidget {
  final name;
  MasterForm(this.name);

  @override
  State<StatefulWidget> createState() {
    return _MasterForm();
  }
}

class _MasterForm extends State<MasterForm> {
  @override
  void initState() {
    //checkvalue = {};
    jsondata = '';
    super.initState();
    _date1 = DateFormat("dd-MMM-yy")
        .format(DateTime.parse(DateTime.now().toString()));
    if (DateTime.now().minute < 10) {
      _time = DateTime.now().hour.toString() +
          ":0" +
          DateTime.now().minute.toString();
    } else {
      _time = DateTime.now().hour.toString() +
          ":" +
          DateTime.now().minute.toString();
    }
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   title: Text(widget.name),
        // ),
        body: Form(key: _formKey, child: list()));
  }

  Widget list() {
    if (jsondata == '') {
      return FutureBuilder(
        builder: (BuildContext context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            reportDetails = jsonDecode(jsondata);

            //keys = reportDetails[0].keys.toList();
            //formType = reportDetails[0][keys[0]];
            formType = 'Dynamic';
            if (formType == 'Dynamic') {
              int i;
              textEditingControllers = [];
              data = [];
              textedit = {};
              checkvalue = {};
              checkcombo = [];
              for (i = 0; i < reportDetails.length; i++) {
                //print(reportDetails[i]['CONTROL_TYPE']);
                if (reportDetails[i]['CONTROL_TYPE'] == 'Password') {
                  textedit.putIfAbsent(
                      reportDetails[i]['FIELD_NAME'], () => 'null');
                  var textEditingController =
                      new TextEditingController(text: '');
                  textEditingControllers.add(textEditingController);

                  data.add(PasswordForm(true, textEditingController,
                      reportDetails[i]['FIELD_NAME']));
                }
                if (reportDetails[i]['CONTROL_TYPE'] == 'TextBox') {
                  TextInputType type;
                  if (reportDetails[i]['FIELD_TYPE'] == 'Decimal') {
                    type = TextInputType.number;
                  }

                  textedit.putIfAbsent(
                      reportDetails[i]['FIELD_NAME'], () => 'null');
                  var textEditingController =
                      new TextEditingController(text: '');
                  textEditingControllers.add(textEditingController);
                  int bordercolor = 0xFFE53935;
                  int fontcolor = 0xFFE53935;
                  Icon icon;
                  Widget prefix;
                  Widget suffix;
                  int maxline = 1;
                  String hint;
                  String helper;
                  bool filled = false;

                  UnderlineInputBorder border;
                  OutlineInputBorder enabledborder;
                  OutlineInputBorder focusedborder;
                  if (reportDetails[i]['ICON'] != null) {
                    icon = Icon(IconData(int.parse(reportDetails[i]['ICON']),
                        fontFamily: 'MaterialIcons'));
                  }
                  if (reportDetails[i]['PREFFIX'] != null) {
                    prefix = Text(reportDetails[i]['PREFFIX']);
                  }

                  if (reportDetails[i]['SUFFIX'] != null) {
                    suffix = TextForm(reportDetails[i]['SUFFIX'], 20.0);
                  }
                  if (reportDetails[i]['FONTCOLOR'] != null) {
                    fontcolor = int.parse(reportDetails[i]['FONTCOLOR']);
                  }

                  if (reportDetails[i]['BORDERCOLOR'] != null) {
                    bordercolor = int.parse(reportDetails[i]['BORDERCOLOR']);
                  }

                  if (reportDetails[i]['MAXLINE'] != null) {
                    maxline = reportDetails[i]['MAXLINE'];
                  }
                  if (reportDetails[i]['HINTTEXT'] != null) {
                    hint = reportDetails[i]['HINTTEXT'];
                  }
                  if (reportDetails[i]['HELPERTEXT'] != null) {
                    helper = reportDetails[i]['HELPERTEXT'];
                  }
                  if (reportDetails[i]['FILLED'] != null) {
                    filled = true;
                  }
                  if (reportDetails[i]['BORDER'] != null) {
                    border = UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Color(bordercolor),
                            width: double.parse(reportDetails[i]['BORDER'])));
                  }
                  if (reportDetails[i]['ENABLEBORDER'] != null) {
                    enabledborder = OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color(bordercolor),
                            width: double.parse(
                                reportDetails[i]['ENABLEBORDER'])));
                  }
                  if (reportDetails[i]['FOCUSBORDER'] != null) {
                    focusedborder = OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color(bordercolor),
                            width:
                                double.parse(reportDetails[i]['FOCUSBORDER'])));
                  }

                  data.add(TextFieldForm(
                      reportDetails[i]['FIELD_NAME'],
                      textEditingController,
                      type,
                      icon,
                      prefix,
                      suffix,
                      fontcolor,
                      maxline,
                      hint,
                      helper,
                      filled,
                      border,
                      enabledborder,
                      focusedborder,
                      false));
                }
                if (reportDetails[i]['CONTROL_TYPE'] == 'CheckBox') {
                  bool check = false;

                  textedit.putIfAbsent(
                      reportDetails[i]['FIELD_NAME'], () => 'false');
                  data.add(CheckboxForm(
                      reportDetails[i]['FIELD_NAME'], check, textedit));
                }
                if (reportDetails[i]['CONTROL_TYPE'] == 'ComboBox') {
                  textedit.putIfAbsent(
                      reportDetails[i]['FIELD_NAME'], () => 'null');
                  data.add(Combo1(
                      reportDetails[i]['LIST_SQL'],
                      reportDetails[i]['FIELD_NAME'],
                      double.parse(reportDetails[i]['FONTSIZE']),
                      textedit));
                }
                if (reportDetails[i]['CONTROL_TYPE'] == 'Date') {
                  textedit.putIfAbsent(
                      reportDetails[i]['FIELD_NAME'], () => _date1);
                  data.add(
                      DatePickerForm(reportDetails[i]['FIELD_NAME'], textedit));
                }
                if (reportDetails[i]['CONTROL_TYPE'] == 'Time') {
                  textedit.putIfAbsent(
                      reportDetails[i]['FIELD_NAME'], () => _time);
                  data.add(
                      TimePickerForm(reportDetails[i]['FIELD_NAME'], textedit));
                }
              }

              data.add(ButtonForm(textedit, textEditingControllers));
              formFilled = true;

              return Card(
                  elevation: 15,
                  child: ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (BuildContext context, int i) {
                      return Padding(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[data[i]],
                          ));
                    },
                  ));
            } else {
              return Text('Static form');
            }
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
        future: getMasterReport(),
      );
    } else {
      reportDetails = jsonDecode(jsondata);

      formType = 'Dynamic';
      if (formType == 'Dynamic') {
        int i;
        textEditingControllers = [];
        data = [];
        textedit = {};
        checkvalue = {};
        checkcombo = [];
        for (i = 0; i < reportDetails.length; i++) {
          if (reportDetails[i]['CONTROL_TYPE'] == 'Password') {
            textedit.putIfAbsent(reportDetails[i]['FIELD_NAME'], () => 'null');
            var textEditingController = new TextEditingController(text: '');
            textEditingControllers.add(textEditingController);

            data.add(PasswordForm(
                true, textEditingController, reportDetails[i]['FIELD_NAME']));
          }
          if (reportDetails[i]['CONTROL_TYPE'] == 'TextBox') {
            TextInputType type;
            if (reportDetails[i]['FIELD_TYPE'] == 'Decimal') {
              type = TextInputType.number;
            }

            textedit.putIfAbsent(reportDetails[i]['FIELD_NAME'], () => 'null');
            var textEditingController = new TextEditingController(text: '');
            textEditingControllers.add(textEditingController);
            int bordercolor = 0xFFE53935;
            int fontcolor = 0xFFE53935;
            Icon icon;
            Widget prefix;
            Widget suffix;
            int maxline = 1;
            String hint;
            String helper;
            bool filled = false;

            UnderlineInputBorder border;
            OutlineInputBorder enabledborder;
            OutlineInputBorder focusedborder;
            if (reportDetails[i]['ICON'] != null) {
              icon = Icon(IconData(int.parse(reportDetails[i]['ICON']),
                  fontFamily: 'MaterialIcons'));
            }
            if (reportDetails[i]['PREFFIX'] != null) {
              prefix = Text(reportDetails[i]['PREFFIX']);
            }

            if (reportDetails[i]['SUFFIX'] != null) {
              suffix = TextForm(reportDetails[i]['SUFFIX'], 20.0);
            }
            if (reportDetails[i]['FONTCOLOR'] != null) {
              fontcolor = int.parse(reportDetails[i]['FONTCOLOR']);
            }

            if (reportDetails[i]['BORDERCOLOR'] != null) {
              bordercolor = int.parse(reportDetails[i]['BORDERCOLOR']);
            }

            if (reportDetails[i]['MAXLINE'] != null) {
              maxline = reportDetails[i]['MAXLINE'];
            }
            if (reportDetails[i]['HINTTEXT'] != null) {
              hint = reportDetails[i]['HINTTEXT'];
            }
            if (reportDetails[i]['HELPERTEXT'] != null) {
              helper = reportDetails[i]['HELPERTEXT'];
            }
            if (reportDetails[i]['FILLED'] != null) {
              filled = true;
            }
            if (reportDetails[i]['BORDER'] != null) {
              border = UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: Color(bordercolor),
                      width: double.parse(reportDetails[i]['BORDER'])));
            }
            if (reportDetails[i]['ENABLEBORDER'] != null) {
              enabledborder = OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Color(bordercolor),
                      width: double.parse(reportDetails[i]['ENABLEBORDER'])));
            }
            if (reportDetails[i]['FOCUSBORDER'] != null) {
              focusedborder = OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Color(bordercolor),
                      width: double.parse(reportDetails[i]['FOCUSBORDER'])));
            }

            data.add(TextFieldForm(
                reportDetails[i]['FIELD_NAME'],
                textEditingController,
                type,
                icon,
                prefix,
                suffix,
                fontcolor,
                maxline,
                hint,
                helper,
                filled,
                border,
                enabledborder,
                focusedborder,
                false));
          }
          if (reportDetails[i]['CONTROL_TYPE'] == 'CheckBox') {
            bool check = false;
            textedit.putIfAbsent(reportDetails[i]['FIELD_NAME'], () => 'false');
            data.add(
                CheckboxForm(reportDetails[i]['FIELD_NAME'], check, textedit));
          }
          if (reportDetails[i]['CONTROL_TYPE'] == 'ComboBox') {
            textedit.putIfAbsent(reportDetails[i]['FIELD_NAME'], () => 'null');
            data.add(Combo1(
                reportDetails[i]['LIST_SQL'],
                reportDetails[i]['FIELD_NAME'],
                double.parse(reportDetails[i]['FONTSIZE']),
                textedit));
          }
          if (reportDetails[i]['CONTROL_TYPE'] == 'Date') {
            textedit.putIfAbsent(reportDetails[i]['FIELD_NAME'], () => _date1);
            data.add(DatePickerForm(reportDetails[i]['FIELD_NAME'], textedit));
          }
          if (reportDetails[i]['CONTROL_TYPE'] == 'Time') {
            textedit.putIfAbsent(reportDetails[i]['FIELD_NAME'], () => _time);
            data.add(TimePickerForm(reportDetails[i]['FIELD_NAME'], textedit));
          }
        }

        data.add(ButtonForm(textedit, textEditingControllers));
        formFilled = true;

        return Card(
            elevation: 15,
            child: ListView.builder(
              itemCount: data.length,
              itemBuilder: (BuildContext context, int i) {
                return Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[data[i]],
                    ));
              },
            ));
      } else {
        return Text('Static form');
      }
    }
  }
}
