import 'package:amp_studenthub/configs/constant.dart';
import 'package:amp_studenthub/screens/home_screen.dart';
import 'package:amp_studenthub/screens/login_page.dart';
import 'package:amp_studenthub/screens/signup_step1.dart';
import 'package:amp_studenthub/screens/signup_step2.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

ThemeData _buildTheme(brightness) {
  var baseTheme = ThemeData(brightness: brightness);

  return baseTheme.copyWith(
      textTheme: GoogleFonts.poppinsTextTheme(baseTheme.textTheme),
      scaffoldBackgroundColor: Constant.backgroundColor);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StudentHub',
      debugShowCheckedModeBanner: false,
      theme: _buildTheme(Brightness.light),
      home: SignupStepTwo(),
    );
  }
}
