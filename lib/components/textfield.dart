import 'package:amp_studenthub/configs/constant.dart';
import 'package:flutter/material.dart';

class Textfield extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final String? errorText; // Added errorText parameter

  const Textfield({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    this.errorText, // Make errorText optional
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
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
                errorText: errorText, // Set errorText here
              ),
            ),
          ),
          if (errorText != null) // Display error text if provided
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                errorText!,
                style: TextStyle(color: Colors.red),
              ),
            ),
        ],
      ),
    );
  }
}
