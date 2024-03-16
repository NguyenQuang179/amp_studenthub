import 'package:amp_studenthub/configs/constant.dart';
import 'package:amp_studenthub/screens/navigation_menu.dart';
import 'package:amp_studenthub/screens/post_job_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(MyApp());
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
  MyApp({super.key});
  final GoRouter _router = GoRouter(routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const NavigationMenu(),
    ),
    GoRoute(
      path: '/postJob',
      builder: (context, state) => PostJobScreen(),
    )
  ]);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      title: 'StudentHub',
      debugShowCheckedModeBanner: false,
      theme: _buildTheme(Brightness.light),
    );
  }
}
