import 'package:amp_studenthub/configs/constant.dart';
import 'package:amp_studenthub/models/account.dart';
import 'package:amp_studenthub/providers/user_provider.dart';
import 'package:amp_studenthub/routes/routes_constants.dart';
import 'package:amp_studenthub/widgets/account_list_view.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class SwitchAccountScreen extends StatefulWidget {
  const SwitchAccountScreen({super.key});

  @override
  State<SwitchAccountScreen> createState() => _SwitchAccountScreenState();
}

class _SwitchAccountScreenState extends State<SwitchAccountScreen> {
  logOut(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    //get access token from provider
    final accessToken = userProvider.userToken;
    final dio = Dio();

    try {
      const endpoint = '${Constant.baseURL}/api/auth/logout';

      final Response response = await dio.post(
        endpoint,
      );

      userProvider.update("");
      context.pushNamed(RouteConstants.createStudentProfile1);
    } on DioException catch (e) {
      // Handle Dio errors
      if (e.response != null) {
        // The request was made and the server responded with an error status code
        final responseData = e.response?.data;
        Fluttertoast.showToast(msg: responseData.toString());
      } else {
        // Something else happened, such as network error
        Fluttertoast.showToast(msg: e.message as String);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Account currentAccount =
        Account(fullName: 'Nguyễn Duy Niên', type: 'Student');
    List<Account> accountList = [
      Account(fullName: 'Niên', type: 'Company'),
      Account(fullName: 'Niên 2', type: 'Student')
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Constant.backgroundColor,
        toolbarHeight: 56,
        title: const Text(
          'StudentHub',
          style: TextStyle(
              color: Constant.primaryColor, fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              child: IconButton.outlined(
                  onPressed: () {},
                  icon: const FaIcon(
                    FontAwesomeIcons.magnifyingGlass,
                    size: 16,
                  ))),
        ],
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          AccountListView(
            currentAccount: currentAccount,
            accountList: accountList,
          ),
          const SizedBox(
            height: 5,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
            child: SizedBox(
              height: 50,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  bool isNewProfile = true;
                  bool isStudent = true;
                  if (isStudent) {
                    context.pushNamed(RouteConstants.createStudentProfile1);
                    // ignore: dead_code
                  } else {
                    if (isNewProfile) {
                      context.pushNamed(RouteConstants.createCompanyProfile);
                      // ignore: dead_code
                    } else {
                      context.pushNamed(RouteConstants.editCompanyProfile);
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero,
                ),
                child: const Row(
                  children: [
                    SizedBox(width: 16),
                    Icon(Icons.person),
                    SizedBox(width: 8),
                    Text('Profile'),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
            child: SizedBox(
              height: 50,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero,
                ),
                child: const Row(
                  children: [
                    SizedBox(width: 16),
                    Icon(Icons.settings),
                    SizedBox(width: 8),
                    Text('Settings'),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            child: SizedBox(
              height: 60,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  context.goNamed(RouteConstants.login);
                },
                style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    backgroundColor: const Color(0xFF3F72AF)),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.logout,
                      color: Colors.white,
                    ),
                    SizedBox(width: 16),
                    Text(
                      'Sign Out',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
