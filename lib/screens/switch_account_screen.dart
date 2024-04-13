import 'package:amp_studenthub/configs/constant.dart';
import 'package:amp_studenthub/models/account.dart';
import 'package:amp_studenthub/models/user.dart';
import 'package:amp_studenthub/providers/user_provider.dart';
import 'package:amp_studenthub/routes/routes_constants.dart';
import 'package:amp_studenthub/widgets/account_list_view.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class SwitchAccountScreen extends StatefulWidget {
  const SwitchAccountScreen({super.key});

  @override
  State<SwitchAccountScreen> createState() => _SwitchAccountScreenState();
}

class _SwitchAccountScreenState extends State<SwitchAccountScreen> {
  late User user;
  late Account currentAccount;
  late List<Account> accountList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  didChangeDependencies() {
    getUser(context as BuildContext).then((_) {
      setupAccount(context as BuildContext);
      setState(() {
        _isLoading = false;
      });
    });
    super.didChangeDependencies();
  }

  Future<void> getUser(BuildContext context) async {
    final dio = Dio();
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      // Get access token from provider
      final accessToken = userProvider.userToken;
      const endpoint = '${Constant.baseURL}/api/auth/me';
      final Response response = await dio.get(
        endpoint,
        options: Options(headers: {
          'Authorization': 'Bearer $accessToken',
        }),
      );

      final Map<String, dynamic> responseData =
          response.data as Map<String, dynamic>;
      final dynamic result = responseData['result'];
      if (result != null) {
        user = User.fromJson(result);
        userProvider.updateIsCompanyProfile(user.company != null);
      } else {
        print('User data not found in the response');
      }
    } on DioError catch (e) {
      // Handle Dio errors
      if (e.response != null) {
        final responseData = e.response?.data;
        print(responseData);
      } else {
        print(e.message);
      }
    }
  }

  void setupAccount(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    if (user.roles.length == 1) {
      currentAccount = Account(fullName: user.fullname, type: user.roles[0]);
      accountList = [
        Account(fullName: user.fullname, type: user.roles[0] == 0 ? 1 : 0)
      ];
    } else {
      currentAccount = Account(fullName: user.fullname, type: user.roles[0]);
      accountList = [
        Account(fullName: user.fullname, type: user.roles[0] == 0 ? 1 : 0)
      ];
    }

    var role = user.roles[0] == 0 ? 'Company' : 'Student';
    userProvider.updateRole(role);
    userProvider.updateCurrentAccount(currentAccount);
    userProvider.updateAccountList(accountList);
  }

  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context, listen: false);

    var role = userProvider.userRole;
    var isNewProfile = role == 'Student'
        ? userProvider.isStudentProfile
        : userProvider.isCompanyProfile;

    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
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
              ),
            ),
          ),
        ],
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          AccountListView(
            currentAccount: currentAccount,
            accountList: accountList,
            onAccountChange: (account) {
              setState(() {
                accountList.add(currentAccount);
                currentAccount = account;
                accountList.remove(currentAccount);
                userProvider.updateAccountList(accountList);
                userProvider.updateCurrentAccount(currentAccount);
                var role = account.type == 0 ? 'Student' : 'Company';
                userProvider.updateRole(role);
              });
            },
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
                  bool _isNewProfile = isNewProfile;
                  bool isStudent = role == 'Student';
                  print("profile new:" + _isNewProfile.toString());
                  print("isStudent: " + isStudent.toString());
                  if (isStudent) {
                    context.pushNamed(RouteConstants.createStudentProfile1);

                    // ignore: dead_code
                  } else {
                    if (!_isNewProfile) {
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
