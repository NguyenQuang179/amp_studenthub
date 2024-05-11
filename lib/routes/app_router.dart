import 'dart:developer';

import 'package:amp_studenthub/providers/signup_role_provider.dart';
import 'package:amp_studenthub/providers/user_provider.dart';
import 'package:amp_studenthub/routes/routes_constants.dart';
import 'package:amp_studenthub/screens/Message/active_interview_list.dart';
import 'package:amp_studenthub/screens/Message/message_detail.dart';
import 'package:amp_studenthub/screens/Message/message_list.dart';
import 'package:amp_studenthub/screens/Student_Profile/profile_input_1.dart';
import 'package:amp_studenthub/screens/Student_Profile/profile_input_2.dart';
import 'package:amp_studenthub/screens/Student_Profile/profile_input_3.dart';
import 'package:amp_studenthub/screens/Student_Profile/view_student_profile.dart';
import 'package:amp_studenthub/screens/Student_Projects/project_detail.dart';
import 'package:amp_studenthub/screens/Student_Projects/project_list.dart';
import 'package:amp_studenthub/screens/Student_Projects/project_list_filtered.dart';
import 'package:amp_studenthub/screens/Student_Projects/project_list_saved.dart';
import 'package:amp_studenthub/screens/account_settings.dart';
import 'package:amp_studenthub/screens/bottom_navbar_scaffold/company_bottom_navbar.dart';
import 'package:amp_studenthub/screens/company_dashboard_screen.dart';
import 'package:amp_studenthub/screens/edit_company_profile.dart';
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
import 'package:amp_studenthub/screens/student_proposal_details.dart';
import 'package:amp_studenthub/screens/student_submit_proposal.dart';
import 'package:amp_studenthub/screens/switch_account_screen.dart';
import 'package:amp_studenthub/screens/video_call_screen.dart';
import 'package:amp_studenthub/screens/welcome_screen.dart';
import 'package:amp_studenthub/utilities/local_storage.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

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
            return const MaterialPage(child: HomeScreen());
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
              // routes: [
              //   GoRoute(
              //       name: RouteConstants.projectDetails,
              //       path: 'details',
              //       pageBuilder: (context, state) {
              //         // Extract id from the URI query parameters
              //         final id = state.uri.queryParameters['id'] ?? '0';

              //         // Create the ProjectDetail widget with the extracted id
              //         return MaterialPage(
              //           child: ProjectDetail(id: id),
              //         );
              //       }),
              // ]
            ),
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
                final userProvider =
                    Provider.of<UserProvider>(context, listen: false);
                final userRole = userProvider.userRole;
                return userRole == "Student"
                    ? const MaterialPage(child: StudentDashboard())
                    : const MaterialPage(child: CompanyDashboardScreen());
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
          return const MaterialPage(child: LoginPage());
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
          final roleProvider =
              Provider.of<RoleProvider>(context, listen: false);
          return MaterialPage(
            child: SignupStepTwo(
              role: roleProvider.role,
            ),
          );
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
          name: RouteConstants.projectDetails,
          path: '/project/details',
          pageBuilder: (context, state) {
            // Extract id from the URI query parameters
            final id = state.uri.queryParameters['id'] ?? '0';

            // Create the ProjectDetail widget with the extracted id
            return MaterialPage(
              child: ProjectDetail(id: id),
            );
          }),
      GoRoute(
          name: RouteConstants.companyProjectDetails,
          path: '/jobDetails/:projectId',
          pageBuilder: (context, state) {
            // Extract id from the URI query parameters
            final id = state.pathParameters['projectId'] ?? '0';
            log('ProjectID: $id');
            // Create the ProjectDetail widget with the extracted id
            return MaterialPage(child: JobDetailsScreen(projectId: id));
          }),
      GoRoute(
          name: RouteConstants.studentProposalDetails,
          path: '/proposalDetails/:proposalId',
          pageBuilder: (context, state) {
            // Extract id from the URI query parameters
            final id = state.pathParameters['proposalId'] ?? '0';
            log('ProposalID: $id');
            // Create the ProjectDetail widget with the extracted id
            return MaterialPage(child: StudentProposalDetails(proposalId: id));
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
            final userId =
                int.parse(state.uri.queryParameters['userId'] ?? '0');
            final receiverId =
                int.parse(state.uri.queryParameters['receiverId'] ?? '0');
            final projectId =
                int.parse(state.uri.queryParameters['projectId'] ?? '0');
            final receiverName =
                state.uri.queryParameters['receiverName'] ?? '';
            print({
              'userId': userId,
              'receiverId': receiverId,
              'projectId': projectId,
              'receiverName': receiverName
            });
            return MaterialPage(
                child: MessageDetail(
              userId: userId,
              receiverId: receiverId,
              projectId: projectId,
              receiverName: receiverName,
            ));
          }),
      GoRoute(
          name: RouteConstants.videoCall,
          path: '/videoCall',
          pageBuilder: (context, state) {
            final meetingRoomCode =
                state.uri.queryParameters['meetingRoomCode'] ?? '0';
            return MaterialPage(
                child: VideoCallScreen(conferenceId: meetingRoomCode));
          }),
      GoRoute(
          name: RouteConstants.activeInterviewList,
          path: '/ativeInterviewList',
          pageBuilder: (context, state) {
            return const MaterialPage(child: ActiveInterview());
          }),
      GoRoute(
          name: RouteConstants.createCompanyProfile,
          path: '/createCompanyProfile',
          pageBuilder: (context, state) {
            return const MaterialPage(child: ProfileInputNew());
          }),
      GoRoute(
          name: RouteConstants.viewCompanyProfile,
          path: '/viewCompanyProfile',
          pageBuilder: (context, state) {
            return const MaterialPage(child: ProfileInputView());
          }),
      GoRoute(
          name: RouteConstants.editCompanyProfile,
          path: '/editCompanyProfile',
          pageBuilder: (context, state) {
            return const MaterialPage(child: EditCompanyProfile());
          }),
      GoRoute(
          name: RouteConstants.studentProfile,
          path: '/studentProfile',
          pageBuilder: (context, state) {
            return const MaterialPage(child: ViewStudentProfile());
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
            final projectId = state.uri.queryParameters['id'] ?? '0';
            return MaterialPage(
                child: StudentSubmitProposal(projectId: projectId));
          }),
      GoRoute(
          name: RouteConstants.settings,
          path: '/settings',
          pageBuilder: (context, state) {
            return const MaterialPage(child: AccountSettings());
          }),
    ],
    // errorPageBuilder: (context, state) {
    //   return MaterialPage(child: null);
    // },
    redirect: (context, state) async {
      // final dio = Dio();
      // LocalStorage localStorage = await LocalStorage.init();
      // String? token = localStorage.getString(key: StorageKey.accessToken);
      // log(token ?? "No Token");
      // bool isAuth = token != null ? true : false;
      // // ignore: dead_code
      // if (!isAuth && state.matchedLocation != '/') {
      //   return state.namedLocation(RouteConstants.home);
      //   // ignore: dead_code
      // } else if (isAuth && state.matchedLocation == '/') {
      //   // Provider.of<UserProvider>(context, listen: false).updateToken(token);
      //   // // Get and store user data to provider
      //   // const endpoint = '${Constant.baseURL}/api/auth/me';
      //   // final Response userResponse = await dio.get(
      //   //   endpoint,
      //   //   options: Options(headers: {
      //   //     'Authorization': 'Bearer $token',
      //   //   }),
      //   // );

      //   // final Map<String, dynamic> userResponseData =
      //   //     userResponse.data as Map<String, dynamic>;
      //   // final dynamic userData = userResponseData['result'];

      //   // Provider.of<UserProvider>(context, listen: false)
      //   //     .updateUserInfo(userData);
      //   // // connect to socket
      //   // final socketManager = SocketManager();
      //   // final socket =
      //   //     await socketManager.connectSocket(context, userData['id']);
      //   // return state.namedLocation(RouteConstants.companyProject);
      // }
      // // ignore: dead_code
      bool isAuth = false;
      // ignore: dead_code
      if (!isAuth && state.matchedLocation == '/') {
        return state.namedLocation(RouteConstants.home);
        // ignore: dead_code
      } else if (state.matchedLocation == '/') {
        return state.namedLocation(RouteConstants.company);
      }
      return null;
    },
  );
}
