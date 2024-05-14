import 'dart:convert';
import 'dart:developer';

import 'package:amp_studenthub/configs/constant.dart';
import 'package:amp_studenthub/providers/user_provider.dart';
import 'package:amp_studenthub/routes/routes_constants.dart';
import 'package:amp_studenthub/screens/input_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class EditCompanyProfile extends StatefulWidget {
  const EditCompanyProfile({super.key});

  @override
  State<EditCompanyProfile> createState() => _EditCompanyProfileState();
}

class _EditCompanyProfileState extends State<EditCompanyProfile> {
  Map<String, int> option = {
    'It\'s just me': 0,
    '2-9 employees': 1,
    '10-100 employees': 2,
    '100-1000 employees': 3,
    'More than 1000 employees': 4
  };

  @override
  didChangeDependencies() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    var companyProfile = userProvider.userInfo['company'];
    setState(() {
      _selectedOption = companyProfile['size'];
      log(companyProfile['size'].toString());
      companyNameController.text = companyProfile['companyName'];
      websiteController.text = companyProfile['website'];
      descriptionController.text = companyProfile['description'];
    });
    super.didChangeDependencies();
  }

  int _selectedOption = 0;
  final companyNameController = TextEditingController();
  final websiteController = TextEditingController();
  final descriptionController = TextEditingController();

  Future<void> updateCompanyProfile(BuildContext context) async {
    final dio = Dio();
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      var companyId = userProvider.userInfo['company']['id'];
      final accessToken = userProvider.userToken;
      var endpoint = '${Constant.baseURL}/api/profile/company/$companyId';

      var data = {
        "companyName": companyNameController.text,
        "size": _selectedOption,
        "website": websiteController.text,
        "description": descriptionController.text
      };

      final Response response = await dio.put(endpoint,
          options: Options(headers: {
            'Authorization': 'Bearer $accessToken',
          }),
          data: jsonEncode(data));

      final Map<String, dynamic> responseData =
          response.data as Map<String, dynamic>;
      final dynamic result = responseData['result'];
      if (result != null) {
        const infoEndpoint = '${Constant.baseURL}/api/auth/me';
        final Response userResponse = await dio.get(
          infoEndpoint,
          options: Options(headers: {
            'Authorization': 'Bearer $accessToken',
          }),
        );

        final Map<String, dynamic> userResponseData =
            userResponse.data as Map<String, dynamic>;
        final dynamic userData = userResponseData['result'];
        userProvider.updateUserInfo(userData);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        toolbarHeight: 56,
        title: Text(
          'Edit Profile',
          style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: CircleAvatar(
              radius: 24,
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: IconButton(
                icon: FaIcon(
                  FontAwesomeIcons.user,
                  size: 20,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
                onPressed: () {
                  GoRouter.of(context).pushNamed(RouteConstants.switchAccount);
                },
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),
            const Center(
              child: Text(
                'Welcome to Student Hub',
                style: TextStyle(
                    fontFamily: 'sans serif',
                    fontWeight: FontWeight.bold,
                    fontSize: 25),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 20),
              child: Text(
                'Tell us about your company and you will be your way connect with high-skilled students',
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontFamily: 'sans serif',
                    fontWeight: FontWeight.normal,
                    fontSize: 18),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 20.0),
              child: Text(
                'How many people are there in your company?',
                style: TextStyle(
                    fontFamily: 'sans serif',
                    fontWeight: FontWeight.normal,
                    fontSize: 18,
                    decoration: TextDecoration.underline),
              ),
            ),
            Column(
              children: option.entries
                  .map(
                    (entry) => GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedOption = entry.value;
                        });
                      },
                      child: Container(
                        padding:
                            const EdgeInsets.only(top: 5, left: 24, bottom: 10),
                        child: Row(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(right: 20),
                              height: 20,
                              width: 20,
                              child: Radio(
                                value: entry.value,
                                groupValue: _selectedOption,
                                onChanged: (int? value) {
                                  setState(() {
                                    _selectedOption = value!;
                                  });
                                },
                              ),
                            ),
                            Text(
                              entry.key,
                              style: const TextStyle(fontSize: 15),
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 20.0),
              child: Text(
                'Company Name',
                style: TextStyle(
                    fontFamily: 'sans serif',
                    fontWeight: FontWeight.normal,
                    fontSize: 18,
                    decoration: TextDecoration.underline),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
              child: TextField(
                controller: companyNameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Company Name',
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Padding(
              padding: EdgeInsets.only(left: 20.0),
              child: Text(
                'Website',
                style: TextStyle(
                    fontFamily: 'sans serif',
                    fontWeight: FontWeight.normal,
                    fontSize: 18,
                    decoration: TextDecoration.underline),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
              child: TextField(
                controller: websiteController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Website',
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 20.0),
              child: Text(
                'Description',
                style: TextStyle(
                    fontFamily: 'sans serif',
                    fontWeight: FontWeight.normal,
                    fontSize: 18,
                    decoration: TextDecoration.underline),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
              child: TextField(
                controller: descriptionController,
                onTap: () async {
                  final String? newText = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          InputScreen(initialText: descriptionController.text),
                    ),
                  );
                  if (newText != null) {
                    setState(() {
                      descriptionController.text = newText;
                    });
                  }
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Description',
                ),
              ),
            ),
            Center(
              child: Container(
                width: double.infinity,
                height: 60,
                margin: const EdgeInsets.only(top: 50),
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: ElevatedButton.icon(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Theme.of(context).colorScheme.primary)),
                  onPressed: () {
                    updateCompanyProfile(context);
                    context.pop(true);
                    context.pushNamed(RouteConstants.viewCompanyProfile);
                  },
                  icon: const Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                  ),
                  label: const Text(
                    'Save',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
