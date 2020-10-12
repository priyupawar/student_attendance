import 'package:flutter/material.dart';

bool state = false;

class CheckboxForm extends StatefulWidget {
  final name;
  final check;

  final textedit;
  CheckboxForm(this.name, this.check, this.textedit);
  @override
  _CheckboxFormState createState() => _CheckboxFormState();
}

void changeState(state, textedit, name) {
  textedit.update(name, (v) {
    return state.toString();
  });
  // print(textedit);
}

class _CheckboxFormState extends State<CheckboxForm> {
  @override
  Widget build(BuildContext context) {
    // return RaisedButton(
    //     color: Colors.white,
    //     onPressed: () {},
    //     child:
    return Container(
        alignment: Alignment.center,
        height: 80.0,
        child: Row(
          children: <Widget>[
            Checkbox(
              value: state,
              onChanged: (bool value) {
                setState(() {
                  state = value;

                  changeState(state, widget.textedit, widget.name);
                });

                // check = value;
              },
            ),
            //text(widget.name, 20.0)
            Text(widget.name)
          ],
        ));
    //);
  }
}
