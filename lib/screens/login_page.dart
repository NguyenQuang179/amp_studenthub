import 'dart:convert';
import 'package:amp_studenthub/components/button.dart';
import 'package:amp_studenthub/components/textfield.dart';
import 'package:amp_studenthub/configs/constant.dart';
import 'package:amp_studenthub/providers/user_provider.dart';
import 'package:amp_studenthub/routes/routes_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:go_router/go_router.dart';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // signin
  Future<void> signIn() async {
    final dio = Dio();
    try {
      const endpoint = '${Constant.baseURL}/api/auth/sign-in';
      final submitData = {
        "email": usernameController.text,
        "password": passwordController.text
      };

      final Response response = await dio.post(
        endpoint,
        data: submitData,
      );
      final List<dynamic> resData = jsonDecode(response.data[0]);
      for (var res in resData) {
        print(res['result']);
      }
    } on DioException catch (e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
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
        backgroundColor: Constant.backgroundColor,
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
                    child: const Text(
                      'StudentHub',
                      style: TextStyle(
                          color: Constant.primaryColor,
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
                        child: const Text(
                          'SIGN IN',
                          style: TextStyle(
                              color: Constant.secondaryColor,
                              fontWeight: FontWeight.w800,
                              fontSize: 32),
                        ),
                      ),
                      //username texfield
                      Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        child: Textfield(
                            controller: usernameController,
                            hintText: 'Username',
                            obscureText: false),
                      ),
                      //password textfield
                      Textfield(
                          controller: passwordController,
                          hintText: 'Password',
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
                  color: Constant.primaryColor,
                  child: Center(
                      child: Column(
                    children: [
                      //sign in button
                      Button(onTap: signIn, text: 'Sign In'),
                      //forgot password?
                      Container(
                        margin: const EdgeInsets.only(top: 32),
                        child: const Text(
                          'Forgot Password?',
                          style: TextStyle(
                            color: Constant.onPrimaryColor,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 32,
                      ),
                      //not a member? register
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('New to StudentsHub?',
                                style:
                                    TextStyle(color: Constant.onPrimaryColor)),
                            const SizedBox(width: 16),
                            TextButton(
                              onPressed: () {
                                print(context.read<UserProvider>().userToken);
                                context.pushNamed(RouteConstants.signUp1);
                              },
                              child: const Text('Join Now',
                                  style: TextStyle(
                                      color: Constant.onPrimaryColor,
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
