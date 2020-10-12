import 'package:flutter/material.dart';

class TextForm extends StatelessWidget {
  final name;
  final fontsize;
  TextForm(this.name, this.fontsize);
  @override
  Widget build(BuildContext context) {
    return Text(
      name,
      style:
          TextStyle(color: Theme.of(context).primaryColor, fontSize: fontsize),
    );
  }
}
