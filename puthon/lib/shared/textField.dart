import 'package:flutter/material.dart';

var textField = InputDecoration(
  border: InputBorder.none,
  focusedBorder: InputBorder.none,
  enabledBorder: InputBorder.none,
  errorBorder: InputBorder.none,
  disabledBorder: InputBorder.none,
  labelStyle: TextStyle(
    color: Colors.black.withOpacity(.35),
  ),
);

class CField extends StatelessWidget {
  final TextInputAction inputAction;
  final String label;
  final String? initial;
  final TextInputType inputType;
  final IconData? preIcon;
  final TextEditingController controller;
  final Color? bgColor;
  final bool hidden;

  CField({
    Key? key,
    this.inputAction = TextInputAction.next,
    this.label = '',
    this.inputType = TextInputType.text,
    this.preIcon,
    required this.controller,
    this.initial,
    this.bgColor,
    this.hidden = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      child: TextFormField(
        initialValue: initial,
        controller: controller,
        textInputAction: inputAction,
        keyboardType: inputType,
        obscureText: hidden,
        decoration: textField.copyWith(
          labelText: label,
          labelStyle: TextStyle(
            color: Colors.black.withOpacity(.35),
            fontSize: 14,
          ),
          prefixIcon: preIcon == null
              ? null
              : Icon(
                  preIcon,
                  color: Colors.black87,
                ),
        ),
      ),
    );
  }
}
