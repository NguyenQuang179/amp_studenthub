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
            color: Theme.of(context).colorScheme.onPrimary,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
                color: Theme.of(context).colorScheme.primary, width: 2),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).colorScheme.onBackground,
                blurRadius: 8,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
          margin: const EdgeInsets.symmetric(horizontal: 75),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ));
  }
}
