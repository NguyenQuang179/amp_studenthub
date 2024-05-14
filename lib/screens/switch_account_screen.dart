import 'package:amp_studenthub/configs/constant.dart';
import 'package:amp_studenthub/core/socket_manager.dart';
import 'package:amp_studenthub/models/account.dart';
import 'package:amp_studenthub/models/user.dart';
import 'package:amp_studenthub/providers/user_provider.dart';
import 'package:amp_studenthub/routes/routes_constants.dart';
import 'package:amp_studenthub/utilities/local_storage.dart';
import 'package:amp_studenthub/widgets/account_list_view.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SwitchAccountScreen extends StatefulWidget {
  const SwitchAccountScreen({super.key});

  @override
  State<SwitchAccountScreen> createState() => _SwitchAccountScreenState();
}

class _SwitchAccountScreenState extends State<SwitchAccountScreen> {
  late User user;
  String? _passwordErrorText;
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
          backgroundColor: Theme.of(context).colorScheme.background,
          surfaceTintColor: Theme.of(context).colorScheme.background,
          insetPadding: const EdgeInsets.symmetric(horizontal: 8),
          title: Text(AppLocalizations.of(context)!.changePassword),
          content: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: oldPasswordController,
                  decoration: const InputDecoration(hintText: "Old Password"),
                ),
                TextField(
                  controller: newPasswordController,
                  onChanged: (value) {
                    setState(() {
                      // Update the error text dynamically when the text changes
                      // by calling setState to trigger a rebuild
                      // validatePassword returns null if the password is valid
                      // or a validation error message if the password is invalid
                      // Update the error text accordingly
                      _passwordErrorText =
                          validatePassword(newPasswordController.text);
                    });
                  },

                  decoration: InputDecoration(
                      errorMaxLines: 5,
                      hintText: "New Password",
                      errorText: _passwordErrorText), // Display the error text
                )
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('CANCEL'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: const Text('OK'),
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
                if (validatePassword(newPasswordController.text) != null) {
                  Fluttertoast.showToast(
                    msg:
                        'Password must be at least 8 characters long and contain at least one uppercase letter, one lowercase letter, and one digit',
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
                      msg: "Change Password Successfully",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0);
                } catch (error) {
                  print(error);
                  Fluttertoast.showToast(
                      msg: 'Incorrect Old Password',
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
        backgroundColor: Theme.of(context).colorScheme.background,
        toolbarHeight: 56,
        title: Text(
          'StudentHub',
          style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold),
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
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              height: 52,
              width: double.infinity,
              child: TextButton(
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
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.zero,
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 16),
                    Icon(
                      Icons.person,
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                    const SizedBox(width: 16),
                    Text(
                      AppLocalizations.of(context)!.profile,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onBackground,
                          fontSize: 16,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Divider(),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              height: 52,
              width: double.infinity,
              child: TextButton(
                onPressed: () {
                  context.pushNamed(RouteConstants.settings);
                },
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.zero,
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 16),
                    Icon(
                      Icons.settings,
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                    const SizedBox(width: 16),
                    Text(
                      AppLocalizations.of(context)!.settings,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onBackground,
                          fontSize: 16,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Divider(),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              height: 52,
              width: double.infinity,
              child: TextButton(
                onPressed: () {
                  _displayTextInputDialog();
                },
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.zero,
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 16),
                    Icon(
                      Icons.lock,
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                    const SizedBox(width: 16),
                    Text(
                      AppLocalizations.of(context)!.changePassword,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onBackground,
                          fontSize: 16,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Divider(),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
            child: SizedBox(
              height: 52,
              width: double.infinity,
              child: TextButton(
                onPressed: () {
                  LocalStorage pref = LocalStorage.instance;
                  pref.clearStorage();
                  //disconnect socket
                  SocketManager().disconnectSocket();
                  context.goNamed(RouteConstants.home);
                },
                style: TextButton.styleFrom(
                    backgroundColor:
                        Theme.of(context).colorScheme.primaryContainer,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    side: BorderSide(
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                        width: 1),
                    foregroundColor:
                        Theme.of(context).colorScheme.onPrimaryContainer),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.logout,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                    const SizedBox(width: 16),
                    Text(
                      AppLocalizations.of(context)!.signOut,
                      style: TextStyle(
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer,
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
