import 'package:flutter/material.dart';

class TextFieldForm extends StatefulWidget {
  final String name;
  final TextEditingController _controller;
  final TextInputType textType;
  final Widget icon;
  final Widget _prefix;
  final Widget _suffix;
  final int _fontcolor;
  final int lines;
  final String hint;
  final String helper;
  final bool _filled;
  final UnderlineInputBorder _border;
  final OutlineInputBorder _enableborder;
  final OutlineInputBorder _focusborder;
  final bool pass;
  TextFieldForm(
      this.name,
      this._controller,
      this.textType,
      this.icon,
      this._prefix,
      this._suffix,
      this._fontcolor,
      this.lines,
      this.hint,
      this.helper,
      this._filled,
      this._border,
      this._enableborder,
      this._focusborder,
      this.pass);
  @override
  _TextFieldFormState createState() => _TextFieldFormState();
}

class _TextFieldFormState extends State<TextFieldForm> {
  @override
  Widget build(BuildContext context) {
    return new TextFormField(
      // key:_formKey,
      validator: (value) {
        //print(value);
        if (value.isEmpty) {
          return 'Please enter some text';
        }
        return null;
      },
      keyboardType: widget.textType,
      controller: widget._controller,
      maxLines: widget.lines,
      decoration: new InputDecoration(
          icon: widget.icon,
          // prefix: widget._prefix,
          // suffix: widget._suffix,
          // border: widget._border,
          // filled: widget._filled,
          // enabledBorder: widget._enableborder,
          // focusedBorder: widget._focusborder,
          labelText: widget.name,
          labelStyle: TextStyle(color: Theme.of(context).accentColor),
          hintText: widget.hint,
          helperText: widget.helper),
    );
  }
}

class PasswordForm extends StatefulWidget {
  final control;
  final pass;
  final name;
  PasswordForm(this.pass, this.control, this.name);
  @override
  _PasswordFormState createState() => _PasswordFormState();
}

class _PasswordFormState extends State<PasswordForm> {
  bool _obscureText = true;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.control,
      obscureText: _obscureText,
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter some text';
        }
        return null;
      },
      onChanged: (String value) {},
      decoration: InputDecoration(
        icon: Icon(Icons.security),
        suffixIcon: GestureDetector(
          child: Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
          onTap: () {
            setState(() {
              _obscureText = !_obscureText;
              print(_obscureText);
            });
          },
        ),
        labelText: widget.name,
        labelStyle: TextStyle(color: Theme.of(context).accentColor),
        //hintText: "Password",
        //hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0)
      ),
    );
  }
}
