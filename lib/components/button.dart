import 'package:amp_studenthub/configs/constant.dart';
import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  const Button({super.key, required this.onTap, required this.text});

  final String text;
  final Function()? onTap;
  // final String labelText;
  // ignore: prefer_typing_uninitialized_variables
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: Constant.onPrimaryColor,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Constant.primaryColor, width: 2),
            boxShadow: const [
              BoxShadow(
                color: Constant.textColor,
                blurRadius: 8,
                offset: Offset(0, 5),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
          margin: const EdgeInsets.symmetric(horizontal: 75),
          child: Center(
            child: Text(
              text,
              style: const TextStyle(
                color: Constant.primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ));
  }
}
