import 'package:amp_studenthub/routes/routes_constants.dart';
import 'package:amp_studenthub/screens/Message/message_detail.dart';
import 'package:amp_studenthub/screens/Student_Projects/project_detail.dart';
import 'package:amp_studenthub/screens/Student_Projects/project_list_filtered.dart';
import 'package:amp_studenthub/screens/Student_Projects/project_list_saved.dart';
import 'package:amp_studenthub/screens/home_screen.dart';
import 'package:amp_studenthub/screens/job_details_screen.dart';
import 'package:amp_studenthub/screens/login_page.dart';
import 'package:amp_studenthub/screens/post_job_screen.dart';
import 'package:amp_studenthub/screens/signup_step1.dart';
import 'package:amp_studenthub/screens/signup_step2.dart';
import 'package:amp_studenthub/screens/switch_account_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  GoRouter router = GoRouter(
    routes: [
      GoRoute(
          name: RouteConstants.home,
          path: '/',
          pageBuilder: (context, state) {
            return const MaterialPage(child: HomeScreen());
          }),
      GoRoute(
        name: RouteConstants.login,
        path: '/login',
        pageBuilder: (context, state) {
          return MaterialPage(child: LoginPage());
        },
      ),
      GoRoute(
        name: RouteConstants.signUp1,
        path: '/signup1',
        pageBuilder: (context, state) {
          return MaterialPage(child: SignUpStepOne());
        },
      ),
      GoRoute(
        name: RouteConstants.signUp2,
        path: '/signup2',
        pageBuilder: (context, state) {
          return MaterialPage(child: SignupStepTwo());
        },
      ),
      GoRoute(
        name: RouteConstants.switchAccount,
        path: '/switchAccount',
        pageBuilder: (context, state) {
          return const MaterialPage(child: SwitchAccountScreen());
        },
      ),
      GoRoute(
          name: RouteConstants.companyPostProject,
          path: '/postJob',
          pageBuilder: (context, state) {
            return const MaterialPage(child: PostJobScreen());
          }),
      GoRoute(
          name: RouteConstants.companyProjectDetails,
          path: '/jobDetails',
          pageBuilder: (context, state) {
            return const MaterialPage(child: JobDetailsScreen());
          }),
      GoRoute(
          name: RouteConstants.projectDetails,
          path: '/projectDetail',
          pageBuilder: (context, state) {
            return const MaterialPage(
                child: ProjectDetail(
              jobTitle: 'Front-End Developer (React JS)',
              jobCreatedDate: '16/03/2024',
              jobDuration: '1-3 months',
              jobStudentNeeded: 5,
              jobProposalNums: 10,
              jobExpectation: 'React JS, HTML, CSS, JavaScript',
            ));
          }),
      GoRoute(
          name: RouteConstants.projectListSaved,
          path: '/projectListSaved',
          pageBuilder: (context, state) {
            return const MaterialPage(child: ProjectListSaved());
          }),
      GoRoute(
          name: RouteConstants.projectListFiltered,
          path: '/projectListFiltered',
          pageBuilder: (context, state) {
            return const MaterialPage(child: ProjectListFiltered());
          }),
      GoRoute(
          name: RouteConstants.messageList,
          path: '/messageList',
          pageBuilder: (context, state) {
            return const MaterialPage(child: ProjectListFiltered());
          }),
      GoRoute(
          name: RouteConstants.messageDetail,
          path: '/messageDetail',
          pageBuilder: (context, state) {
            return const MaterialPage(child: MessageDetail());
          }),
    ],
    // errorPageBuilder: (context, state) {
    //   return MaterialPage(child: null);
    // },
    redirect: (context, state) {
      bool isAuth = false;
      // ignore: dead_code
      if (!isAuth && state.matchedLocation == '/') {
        return state.namedLocation(RouteConstants.login);
      }
      return null;
    },
  );
}
