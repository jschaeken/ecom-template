import 'package:flutter/material.dart';

class CustomTextfield extends StatelessWidget {
  final String text;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final String? errorText;
  final bool obscureText;

  const CustomTextfield({
    super.key,
    required this.text,
    required this.controller,
    this.keyboardType,
    this.errorText,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: obscureText,
      cursorColor: Theme.of(context).primaryColor,
      controller: controller,
      decoration: InputDecoration(
        labelText: text,
        errorText: errorText,
        labelStyle: TextStyle(
          color: Theme.of(context).primaryColor,
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: Theme.of(context).unselectedWidgetColor),
        ),
        errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 2.0),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 1.0),
        ),
      ),
      keyboardType: TextInputType.text,
    );
  }
}
