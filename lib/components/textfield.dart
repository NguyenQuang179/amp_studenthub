import 'package:amp_studenthub/configs/constant.dart';
import 'package:flutter/material.dart';

class Textfield extends StatelessWidget {
  // final String labelText;
  // ignore: prefer_typing_uninitialized_variables
  final controller;
  final String hintText;
  final bool obscureText;

  const Textfield(
      {super.key,
      // required this.labelText,
      required this.controller,
      required this.hintText,
      required this.obscureText});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50.0),
      child: SizedBox(
        height: 50,
        child: TextField(
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Constant.primaryColor),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Constant.secondaryColor),
            ),
            labelText: hintText,
            fillColor: Constant.backgroundWithOpacity,
            filled: true,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          ),
        ),
      ),
    );
  }
}
