import 'package:flutter/material.dart';

String _time;
TimeOfDay selectedtime = new TimeOfDay(
  hour: DateTime.now().hour,
  minute: DateTime.now().minute,
);

class TimePickerForm extends StatefulWidget {
  final name;
  final textedit;
  TimePickerForm(this.name, this.textedit);
  @override
  _TimePickerState createState() => _TimePickerState();
}

void updateTime(name, value, textedit) {
  textedit.update(name, (v) {
    return value.hour.toString() + ":" + value.minute.toString();
  });
}

class _TimePickerState extends State<TimePickerForm> {
  Future selectTime1(BuildContext context) async {
    final TimeOfDay picked = (await showTimePicker(
      context: context,
      initialTime: selectedtime,
      // firstDate: new DateTime(2000, 1, 1),
      // lastDate: new DateTime(DateTime.now().year, 12, 31),
    ));
    //print(selectedtime);
    if (picked != null) {
      setState(() {
        // textedit.update(widget.name, (v) {
        //   return picked.hour.toString() + ":" + picked.minute.toString();
        // });
        updateTime(widget.name, picked, widget.textedit);
        selectedtime = picked;

        _time =
            selectedtime.hour.toString() + ":" + selectedtime.minute.toString();
        // _date1 =
        //     DateFormat("dd-MMM-yy").format(DateTime.parse(picked.toString()));
      });
    }
  }

  @override
  void initState() {
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    return timePicker();
  }

  Widget timePicker() {
    return Padding(
      padding: EdgeInsets.only(top: 10),
      // child: RaisedButton(
      //   shape:
      //       RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      //   elevation: 6.0,
      //   onPressed: () {
      //     selectTime1(context);
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
                        _time,
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
                  selectTime1(context);
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
