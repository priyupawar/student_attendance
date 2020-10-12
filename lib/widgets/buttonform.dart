import 'package:flutter/material.dart';

class ButtonForm extends StatefulWidget {
  final textEditingControllers;
  final textedit;
  ButtonForm(this.textedit, this.textEditingControllers);
  @override
  _ButtonFormState createState() => _ButtonFormState();
}

submitData(textedit, textEditingControllers) {
  List keys = [];
  textedit.forEach((k, v) => {keys.add(k)});

  for (int i = 0; i < textEditingControllers.length; i++) {
    for (int j = 0; j < keys.length; j++) {
      textedit[keys[i]] = textEditingControllers[i].text;
    }
  }
  print(textedit);
}

class _ButtonFormState extends State<ButtonForm> {
  @override
  Widget build(BuildContext context) {
    return buttonForm();
  }

  Widget buttonForm() {
    return Center(
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
            borderRadius: BorderRadius.circular(6.0),
            boxShadow: [
              BoxShadow(
                  color: Color(0xFF6078ea).withOpacity(.3),
                  offset: Offset(0.0, 8.0),
                  blurRadius: 8.0)
            ]),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              submitData(widget.textedit, widget.textEditingControllers);
            },
            child: Center(
              child: Text("SUBMIT",
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: "Poppins-Bold",
                      fontSize: 18,
                      letterSpacing: 1.0)),
            ),
          ),
        ),
      )),
    ));
  }
}
