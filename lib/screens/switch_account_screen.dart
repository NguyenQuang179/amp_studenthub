import 'package:amp_studenthub/configs/constant.dart';
import 'package:amp_studenthub/models/account.dart';
import 'package:amp_studenthub/models/user.dart';
import 'package:amp_studenthub/providers/user_provider.dart';
import 'package:amp_studenthub/routes/routes_constants.dart';
import 'package:amp_studenthub/widgets/account_list_view.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  String? validatePassword(String password) {
    // Define a regular expression pattern
    final RegExp passwordPattern = RegExp(
      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$',
    );

    // Check if the password matches the pattern
    if (!passwordPattern.hasMatch(password)) {
      return 'Password must be at least 8 characters long and contain at least one uppercase letter, one lowercase letter, and one digit';
    }
    // Return null if password is valid
    return null;
  }

  Future<void> _displayTextInputDialog() async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Change password'),
          content: Column(
            children: [
              TextField(
                controller: oldPasswordController,
                decoration: InputDecoration(hintText: "old password"),
              ),
              TextField(
                  controller: newPasswordController,
                  decoration: InputDecoration(
                      hintText: "new password",
                      errorText: validatePassword(newPasswordController.text))),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('CANCEL'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text('OK'),
              onPressed: () async {
                //api request
                final dio = Dio();
                if (oldPasswordController.text.isEmpty ||
                    newPasswordController.text.isEmpty) {
                  Fluttertoast.showToast(
                    msg: 'Please fill in all fields',
                  );
                  return;
                }
                final userProvider =
                    Provider.of<UserProvider>(context, listen: false);
                final accessToken = userProvider.userToken;

                const endpoint = '${Constant.baseURL}/api/user/changePassword';
                final submitData = {
                  "oldPassword": oldPasswordController.text,
                  "newPassword": newPasswordController.text,
                };
                try {
                  print(submitData);
                  final Response response = await dio.put(endpoint,
                      data: submitData,
                      options: Options(headers: {
                        'Authorization': 'Bearer $accessToken',
                      }));

                  Fluttertoast.showToast(
                      msg: "Pass change successfully",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0);
                } catch (error) {
                  print(error);
                  Fluttertoast.showToast(
                      msg: 'Incorrect Old Pass',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0);
                }
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  didChangeDependencies() {
    getUser(context).then((_) {
      setupAccount(context);
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
        userProvider.updateIsStudentProfile(user.student != null);
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
    if (userProvider.userRole == "") {
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
    } else {
      int accType = userProvider.userRole == "Student" ? 0 : 1;
      currentAccount = Account(fullName: user.fullname, type: accType);
      accountList = [
        Account(fullName: user.fullname, type: accType == 0 ? 1 : 0)
      ];
    }

    if (userProvider.userRole == "") {
      var role = user.roles[0] == 0 ? 'Student' : 'Company';
      userProvider.updateRole(role);
    }

    userProvider.updateCurrentAccount(currentAccount);
    userProvider.updateAccountList(accountList);
  }

  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context, listen: false);

    var role = userProvider.userRole;
    print(role);
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
                  bool isStudent = role == 'Student';
                  print("profile new:$isNewProfile");
                  print("isStudent: $isStudent");
                  if (isStudent) {
                    if (!isNewProfile) {
                      context.pushNamed(RouteConstants.createStudentProfile1);
                    } else {
                      context.pushNamed(RouteConstants.studentProfile);
                    }
                  } else {
                    if (!isNewProfile) {
                      context.pushNamed(RouteConstants.createCompanyProfile);
                    } else {
                      context.pushNamed(RouteConstants.viewCompanyProfile);
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
                onPressed: () {
                  context.pushNamed(RouteConstants.settings);
                },
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
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
            child: SizedBox(
              height: 50,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  _displayTextInputDialog();
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero,
                ),
                child: const Row(
                  children: [
                    SizedBox(width: 16),
                    Icon(Icons.lock),
                    SizedBox(width: 8),
                    Text('Change Password'),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
            child: SizedBox(
              height: 52,
              width: double.infinity,
              child: TextButton(
                onPressed: () {
                  context.goNamed(RouteConstants.home);
                },
                style: TextButton.styleFrom(
                    backgroundColor: Constant.onPrimaryColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100)),
                    side: const BorderSide(
                        color: Constant.primaryColor, width: 1),
                    foregroundColor: Constant.primaryColor),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.logout,
                      color: Constant.primaryColor,
                    ),
                    SizedBox(width: 16),
                    Text(
                      'Sign Out',
                      style: TextStyle(
                          color: Constant.primaryColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w500),
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
