import 'package:amp_studenthub/configs/constant.dart';
import 'package:amp_studenthub/routes/app_router.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

ThemeData _buildTheme(brightness) {
  var baseTheme = ThemeData(brightness: brightness);

  return baseTheme.copyWith(
    textTheme: GoogleFonts.poppinsTextTheme(baseTheme.textTheme),
    scaffoldBackgroundColor: Constant.backgroundColor,
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.grey[900],
      elevation: 10,
      selectedItemColor: Constant.primaryColor,
      unselectedItemColor: Colors.grey[600],
      showUnselectedLabels: true,
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'StudentHub',
      debugShowCheckedModeBanner: false,
      theme: _buildTheme(Brightness.light),
      routeInformationProvider: AppRouter().router.routeInformationProvider,
      routeInformationParser: AppRouter().router.routeInformationParser,
      routerDelegate: AppRouter().router.routerDelegate,
    );
  }
}
