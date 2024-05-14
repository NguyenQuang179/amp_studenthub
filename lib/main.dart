import 'package:amp_studenthub/configs/theme.dart';
import 'package:amp_studenthub/l10n/l10n.dart';
import 'package:amp_studenthub/providers/company_project_provider.dart';
import 'package:amp_studenthub/providers/language_provider.dart';
import 'package:amp_studenthub/providers/signup_role_provider.dart';
import 'package:amp_studenthub/providers/student_project_provider.dart';
import 'package:amp_studenthub/providers/theme_provider.dart';
import 'package:amp_studenthub/providers/user_provider.dart';
import 'package:amp_studenthub/routes/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = GoogleFonts.poppinsTextTheme();
    MaterialTheme theme = MaterialTheme(textTheme);
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => CompanyProjectProvider()),
          ChangeNotifierProvider(create: (context) => UserProvider()),
          ChangeNotifierProvider(create: (context) => RoleProvider()),
          ChangeNotifierProvider(create: (context) => StudentProjectProvider()),
          ChangeNotifierProvider(create: (context) => ThemeProvider()),
          ChangeNotifierProvider(create: (context) => LanguageProvider()),
        ],
        child: Consumer2<ThemeProvider, LanguageProvider>(
          builder: (context, themeObject, languageProvider, _) =>
              MaterialApp.router(
            title: 'StudentHub',
            debugShowCheckedModeBanner: false,
            themeMode: themeObject.mode,
            theme: theme.light(),
            darkTheme: theme.dark(),
            //  brightness == Brightness.light ? theme.light() :

            supportedLocales: l10n.all,
            locale: languageProvider.appLocal,
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
        ));
  }
}
