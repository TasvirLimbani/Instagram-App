import 'package:flutter/material.dart';

class EditTextFiled extends StatefulWidget {
  String hintText;
  FormFieldValidator<String>? validator;
  FormFieldSetter<String>? onSaved;
  TextStyle? style;
  TextEditingController controller;
  bool obscureText;
  InputBorder border;
  Widget? suffix;
  TextStyle? textStyle;
  ValueChanged<String>? onChanged;
  EdgeInsetsGeometry padding;
  EditTextFiled(
      {required this.hintText,
      required this.controller,
      this.validator,
      this.onSaved,
      this.textStyle,
      this.suffix,
      this.onChanged,
      this.obscureText = false,
      this.style,
      this.padding = const EdgeInsets.fromLTRB(12, 24, 12, 16),
      this.border = const UnderlineInputBorder()});
  @override
  _EditTextFiledState createState() => _EditTextFiledState();
}

class _EditTextFiledState extends State<EditTextFiled> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: widget.validator,
      onChanged: widget.onChanged,
      onSaved: widget.onSaved,
      controller: widget.controller,
      obscureText: widget.obscureText,
      style: widget.textStyle,
      decoration: InputDecoration(
          suffixIcon: widget.suffix,
          hintStyle: widget.style,
          hintText: widget.hintText,
          border: widget.border,
          contentPadding: widget.padding,
          enabledBorder: widget.border,
          focusedBorder: widget.border),
    );
  }
}
