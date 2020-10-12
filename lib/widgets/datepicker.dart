import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

DateTime selecteddate = new DateTime.now();
String _date1;

class DatePickerForm extends StatefulWidget {
  final name;
  final textedit;
  DatePickerForm(this.name, this.textedit);
  @override
  _DatePickerFormState createState() => _DatePickerFormState();
}

void updateDate(name, value, textedit) {
  textedit.update(name, (v) {
    return DateFormat("dd-MMM-yy").format(DateTime.parse(value.toString()));
  });
}

class _DatePickerFormState extends State<DatePickerForm> {
  Future selectDate1(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selecteddate,
      firstDate: new DateTime(2000, 1, 1),
      lastDate: new DateTime(DateTime.now().year, 12, 31),
    );
    if (picked != null) {
      setState(() {
        // textedit.update(widget.name, (v) {
        //   return DateFormat("dd-MMM-yy")
        //       .format(DateTime.parse(picked.toString()));
        // });
        updateDate(widget.name, picked, widget.textedit);
        selecteddate = picked;
        _date1 =
            DateFormat("dd-MMM-yy").format(DateTime.parse(picked.toString()));
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _date1 = DateFormat("dd-MMM-yy")
        .format(DateTime.parse(DateTime.now().toString()));
  }

  @override
  Widget build(BuildContext context) {
    return datePicker();
  }

  Widget datePicker() {
    return Padding(
      padding: EdgeInsets.only(top: 10),
      // child: RaisedButton(
      //   shape:
      //       RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      //   elevation: 6.0,
      //   onPressed: () {
      //     selectDate1(context);
      //   },
      child: Container(
        alignment: Alignment.center,
        height: 80.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  child: Row(
                    children: <Widget>[
                      Text(
                        widget.name + ":",
                        style: TextStyle(
                            color: Theme.of(context).accentColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0),
                      ),
                      Text(
                        " $_date1",
                        style: TextStyle(
                            color: Theme.of(context).accentColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0),
                      ),
                    ],
                  ),
                )
              ],
            ),
            GestureDetector(
                onTap: () {
                  selectDate1(context);
                },
                child: Text(
                  "  Change",
                  style: TextStyle(
                      color: Theme.of(context).accentColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0),
                )),
          ],
        ),
      ),
      //   color: Colors.white,
      // )
    );
  }
}
