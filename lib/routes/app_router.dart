import 'package:amp_studenthub/routes/routes_constants.dart';
import 'package:amp_studenthub/screens/Message/message_detail.dart';
import 'package:amp_studenthub/screens/Message/message_list.dart';
import 'package:amp_studenthub/screens/Student_Profile/profile_input_1.dart';
import 'package:amp_studenthub/screens/Student_Profile/profile_input_2.dart';
import 'package:amp_studenthub/screens/Student_Profile/profile_input_3.dart';
import 'package:amp_studenthub/screens/Student_Projects/project_detail.dart';
import 'package:amp_studenthub/screens/Student_Projects/project_list.dart';
import 'package:amp_studenthub/screens/Student_Projects/project_list_filtered.dart';
import 'package:amp_studenthub/screens/Student_Projects/project_list_saved.dart';
import 'package:amp_studenthub/screens/bottom_navbar_scaffold/company_bottom_navbar.dart';
import 'package:amp_studenthub/screens/company_dashboard_screen.dart';
import 'package:amp_studenthub/screens/home_screen.dart';
import 'package:amp_studenthub/screens/job_details_screen.dart';
import 'package:amp_studenthub/screens/login_page.dart';
import 'package:amp_studenthub/screens/notification_list.dart';
import 'package:amp_studenthub/screens/post_job_screen.dart';
import 'package:amp_studenthub/screens/profile_input_new_screen.dart';
import 'package:amp_studenthub/screens/profile_input_view_screen.dart';
import 'package:amp_studenthub/screens/signup_step1.dart';
import 'package:amp_studenthub/screens/signup_step2.dart';
import 'package:amp_studenthub/screens/student_dashboard.dart';
import 'package:amp_studenthub/screens/student_submit_proposal.dart';
import 'package:amp_studenthub/screens/switch_account_screen.dart';
import 'package:amp_studenthub/screens/video_call_screen.dart';
import 'package:amp_studenthub/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _bottomNavbarNavigatorKey = GlobalKey<NavigatorState>();
  GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    routes: [
      GoRoute(
          parentNavigatorKey: _rootNavigatorKey,
          name: RouteConstants.home,
          path: '/',
          pageBuilder: (context, state) {
            return const MaterialPage(child: StudentDashboard());
          }),
      GoRoute(
          parentNavigatorKey: _rootNavigatorKey,
          name: RouteConstants.welcome,
          path: '/welcome',
          pageBuilder: (context, state) {
            return const MaterialPage(child: WelcomeScreen());
          }),
      GoRoute(
        name: RouteConstants.company,
        parentNavigatorKey: _rootNavigatorKey,
        path: '/company',
        pageBuilder: (context, state) => const MaterialPage(
            child: CompanyNavbarScaffold(
          location: '/project',
          child: ProjectList(),
        )),
      ),
      ShellRoute(
          navigatorKey: _bottomNavbarNavigatorKey,
          pageBuilder: (context, state, child) {
            return MaterialPage(
                child: CompanyNavbarScaffold(
              location: state.uri.toString(),
              child: child,
            ));
          },
          routes: [
            GoRoute(
                name: RouteConstants.companyProject,
                parentNavigatorKey: _bottomNavbarNavigatorKey,
                path: '/project',
                pageBuilder: (context, state) {
                  return const MaterialPage(child: ProjectList());
                },
                routes: [
                  GoRoute(
                      name: RouteConstants.projectDetails,
                      path: 'details',
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
                ]),
            GoRoute(
              name: RouteConstants.studentDashboard,
              parentNavigatorKey: _bottomNavbarNavigatorKey,
              path: '/studentDashboard',
              pageBuilder: (context, state) {
                return const MaterialPage(child: StudentDashboard());
              },
            ),
            GoRoute(
              name: RouteConstants.companyDashboard,
              parentNavigatorKey: _bottomNavbarNavigatorKey,
              path: '/dashboard',
              pageBuilder: (context, state) {
                return const MaterialPage(child: StudentDashboard());
              },
            ),
            GoRoute(
              name: RouteConstants.companyMessage,
              parentNavigatorKey: _bottomNavbarNavigatorKey,
              path: '/message',
              pageBuilder: (context, state) {
                return const MaterialPage(child: MessageList());
              },
            ),
            GoRoute(
              name: RouteConstants.companyNotification,
              parentNavigatorKey: _bottomNavbarNavigatorKey,
              path: '/notification',
              pageBuilder: (context, state) {
                return const MaterialPage(child: NotificationListScreen());
              },
            )
          ]),
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
      GoRoute(
          name: RouteConstants.videoCall,
          path: '/videoCall',
          pageBuilder: (context, state) {
            return const MaterialPage(child: VideoCallScreen());
          }),
      GoRoute(
          name: RouteConstants.createCompanyProfile,
          path: '/createCompanyProfile',
          pageBuilder: (context, state) {
            return const MaterialPage(child: ProfileInputNew());
          }),
      GoRoute(
          name: RouteConstants.editCompanyProfile,
          path: '/editCompanyProfile',
          pageBuilder: (context, state) {
            return const MaterialPage(child: ProfileInputView());
          }),
      GoRoute(
          name: RouteConstants.createStudentProfile1,
          path: '/createStudentProfile1',
          pageBuilder: (context, state) {
            return const MaterialPage(child: StudentProfileInput1());
          }),
      GoRoute(
          name: RouteConstants.createStudentProfile2,
          path: '/createStudentProfile2',
          pageBuilder: (context, state) {
            return const MaterialPage(child: StudentProfileInput2());
          }),
      GoRoute(
          name: RouteConstants.createStudentProfile3,
          path: '/createStudentProfile3',
          pageBuilder: (context, state) {
            return const MaterialPage(child: StudentProfileInput3());
          }),
      GoRoute(
          name: RouteConstants.submitProposal,
          path: '/submitProposal',
          pageBuilder: (context, state) {
            return const MaterialPage(child: StudentSubmitProposal());
          }),
    ],
    // errorPageBuilder: (context, state) {
    //   return MaterialPage(child: null);
    // },
    // redirect: (context, state) {
    //   bool isAuth = true;
    //   // ignore: dead_code
    //   if (!isAuth && state.matchedLocation == '/') {
    //     return state.namedLocation(RouteConstants.home);
    //     // ignore: dead_code
    //   } else if (state.matchedLocation == '/') {
    //     return state.namedLocation(RouteConstants.company);
    //   }
    //   // ignore: dead_code
    //   return null;
    // },
  );
}
