import 'package:amp_studenthub/configs/theme.dart';
import 'package:flutter/material.dart';
import 'package:amp_studenthub/configs/constant.dart';
import 'package:amp_studenthub/l10n/l10n.dart';
import 'package:amp_studenthub/providers/company_project_provider.dart';
import 'package:amp_studenthub/providers/signup_role_provider.dart';
import 'package:amp_studenthub/providers/student_project_provider.dart';
import 'package:amp_studenthub/providers/user_provider.dart';
import 'package:amp_studenthub/routes/app_router.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
  final appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    final brightness = View.of(context).platformDispatcher.platformBrightness;
    TextTheme textTheme = GoogleFonts.poppinsTextTheme();
    MaterialTheme theme = MaterialTheme(textTheme);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CompanyProjectProvider()),
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => RoleProvider()),
        ChangeNotifierProvider(create: (context) => StudentProjectProvider())
      ],
      child: MaterialApp.router(
        title: 'StudentHub',
        debugShowCheckedModeBanner: false,
        theme: theme.dark(),
        //  brightness == Brightness.light ? theme.light() :

        supportedLocales: l10n.all,
        locale: const Locale('en'),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate
        ],
        routeInformationProvider: appRouter.router.routeInformationProvider,
        routeInformationParser: appRouter.router.routeInformationParser,
        routerDelegate: appRouter.router.routerDelegate,
      ),
    );
  }
}
