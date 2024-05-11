import 'package:amp_studenthub/components/button.dart';
import 'package:amp_studenthub/components/textfield.dart';
import 'package:amp_studenthub/configs/constant.dart';
import 'package:amp_studenthub/core/socket_manager.dart';
import 'package:amp_studenthub/providers/user_provider.dart';
import 'package:amp_studenthub/routes/routes_constants.dart';
import 'package:amp_studenthub/utilities/local_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({
    super.key,
  });
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final TextEditingController _textFieldController = TextEditingController();

  Future<void> _displayTextInputDialog() async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Reset password'),
          content: TextField(
            controller: _textFieldController,
            decoration: const InputDecoration(hintText: "username"),
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
                if (_textFieldController.text.isEmpty) {
                  Fluttertoast.showToast(
                    msg: 'Please fill in all fields',
                  );
                  return;
                }

                const endpoint = '${Constant.baseURL}/api/user/forgotPassword';
                final submitData = {
                  "email": _textFieldController.text,
                };
                try {
                  final Response response = await dio.post(
                    endpoint,
                    data: submitData,
                  );

                  final responseData = response.data;
                  final String? message = responseData['result']['message'];
                  if (message != null) {
                    Fluttertoast.showToast(
                        msg: message,
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0);
                  } else {
                    Fluttertoast.showToast(
                        msg: 'An error occurred',
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0);
                  }
                } catch (error) {
                  Fluttertoast.showToast(
                      msg: 'An error occurred',
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

  // signin
  Future<void> signIn() async {
    final dio = Dio();
    String? accessToken;
    try {
      LocalStorage localStorage = await LocalStorage.init();
      String? storageAccessToken =
          localStorage.getString(key: StorageKey.accessToken);
      if (storageAccessToken != null && storageAccessToken != "") {
        accessToken = storageAccessToken;
      } else {
        if (usernameController.text.isEmpty ||
            passwordController.text.isEmpty) {
          Fluttertoast.showToast(
            msg: 'Please fill in all fields',
          );
          return;
        }
        const endpoint = '${Constant.baseURL}/api/auth/sign-in';
        final submitData = {
          "email": usernameController.text,
          "password": passwordController.text
        };

        final Response response = await dio.post(
          endpoint,
          data: submitData,
        );

        final responseData = response.data;

        // Extract the access token from the response
        accessToken = responseData['result']['token'];
      }

      if (accessToken != null) {
        localStorage.saveString(
            key: StorageKey.accessToken, value: accessToken);
        // Use Provider to set the access token
        Provider.of<UserProvider>(context, listen: false)
            .updateToken(accessToken);
        // Get and store user data to provider
        const endpoint = '${Constant.baseURL}/api/auth/me';
        final Response userResponse = await dio.get(
          endpoint,
          options: Options(headers: {
            'Authorization': 'Bearer $accessToken',
          }),
        );

        final Map<String, dynamic> userResponseData =
            userResponse.data as Map<String, dynamic>;
        final dynamic userData = userResponseData['result'];

        Provider.of<UserProvider>(context, listen: false)
            .updateUserInfo(userData);
        // connect to socket
        final socketManager = SocketManager();
        final socket =
            await socketManager.connectSocket(context, userData['id']);
        print(userData['id']);
        print(socket);

        context.goNamed(RouteConstants.companyProject);
      }
    } on DioException catch (e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      Fluttertoast.showToast(
        msg: 'Login Failed',
      );
      if (e.response != null) {
        print(e.response?.data);
        print(e.response?.headers);
        print(e.response?.requestOptions);
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        print(e.requestOptions);
        print(e.message);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: SafeArea(
          child: Center(
              child: Column(children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //logo
                  Container(
                    margin: const EdgeInsets.only(top: 16),
                    child: Text(
                      'StudentHub',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 28),
                    ),
                  ),
                  Expanded(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 24),
                        child: Text(
                          AppLocalizations.of(context)!.signInTitle,
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
                              fontWeight: FontWeight.w800,
                              fontSize: 32),
                        ),
                      ),
                      //username texfield
                      Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        child: Textfield(
                            controller: usernameController,
                            hintText: AppLocalizations.of(context)!.emailLabel,
                            obscureText: false),
                      ),
                      //password textfield
                      Textfield(
                          controller: passwordController,
                          hintText: AppLocalizations.of(context)!.passwordLabel,
                          obscureText: true),
                    ],
                  ))
                ],
              ),
            ),
            Flexible(
              flex: 1,
              child: ClipPath(
                clipper:
                    OvalTopBorderClipper(), // Custom clipper for rounded cone
                child: Container(
                  padding: const EdgeInsets.only(top: 52),
                  width: 500,
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: Center(
                      child: Column(
                    children: [
                      //sign in button
                      Button(
                          onTap: () {
                            signIn();
                          },
                          text: AppLocalizations.of(context)!.signInButton),
                      //forgot password?
                      Container(
                          margin: const EdgeInsets.only(top: 32),
                          child: GestureDetector(
                            onTap: () {
                              // Handle click on Forgot Password
                              // For example, navigate to the Forgot Password screen
                              _displayTextInputDialog();
                            },
                            child: Text(
                              AppLocalizations.of(context)!.forgotPassword,
                              style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onPrimaryContainer, // Change color as needed
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          )),
                      const SizedBox(
                        height: 32,
                      ),
                      //not a member? register
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(AppLocalizations.of(context)!.newToStudentHub,
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimaryContainer)),
                            const SizedBox(width: 16),
                            TextButton(
                              onPressed: () {
                                print(context.read<UserProvider>().userToken);
                                context.pushNamed(RouteConstants.signUp1);
                              },
                              child: Text(AppLocalizations.of(context)!.joinNow,
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimaryContainer,
                                      fontWeight: FontWeight.normal)),
                            )
                          ]),
                    ],
                  )),
                ),
              ),
            ),
          ])),
        ));
  }
}
