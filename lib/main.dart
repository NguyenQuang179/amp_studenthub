import 'package:amp_studenthub/configs/constant.dart';
import 'package:amp_studenthub/screens/Message/message_detail.dart';
import 'package:amp_studenthub/screens/Student_Projects/project_detail.dart';
import 'package:amp_studenthub/screens/Student_Projects/project_list_filtered.dart';
import 'package:amp_studenthub/screens/Student_Projects/project_list_saved.dart';
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
    ),
    GoRoute(
      path: '/projectDetail',
      builder: (context, state) => const ProjectDetail(
        jobTitle: 'Front-End Developer (React JS)',
        jobCreatedDate: '16/03/2024',
        jobDuration: '1-3 months',
        jobStudentNeeded: 5,
        jobProposalNums: 10,
        jobExpectation: 'React JS, HTML, CSS, JavaScript',
      ),
    ),
    GoRoute(
      path: '/projectListSaved',
      builder: (context, state) => const ProjectListSaved(),
    ),
    GoRoute(
      path: '/projectListFiltered',
      builder: (context, state) => const ProjectListFiltered(),
    ),
    GoRoute(
      path: '/messageList',
      builder: (context, state) => const ProjectListFiltered(),
    ),
    GoRoute(
      path: '/messageDetail',
      builder: (context, state) => const MessageDetail(),
    ),
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
