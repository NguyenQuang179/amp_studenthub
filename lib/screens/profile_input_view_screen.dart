import 'package:amp_studenthub/configs/constant.dart';
import 'package:amp_studenthub/models/company_profile.dart';
import 'package:amp_studenthub/models/user.dart';
import 'package:amp_studenthub/providers/user_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileInputView extends StatefulWidget {
  const ProfileInputView({super.key});

  @override
  State<ProfileInputView> createState() => _ProfileInputViewState();
}

class _ProfileInputViewState extends State<ProfileInputView> {
  Map<int, String> optionList = {
    0: 'It\'s just me',
    1: '2-9 employees',
    2: '10-100 employees',
    3: '100-1000 employees',
    4: 'More than 1000 employees'
  };

  @override
  void initState() {
    super.initState();
    option = optionList[0]!;
  }

  @override
  didChangeDependencies() {
    getCompanyProfle(context);
    super.didChangeDependencies();
  }

  late CompanyProfile _companyProfile;
  late String option;

  Future<void> getCompanyProfle(BuildContext context) async {
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
        var user = User.fromJson(result);
        _companyProfile = user.company != null
            ? user.company!
            : CompanyProfile(0, '', 0, '', '');
        option = optionList[_companyProfile.size] ?? optionList[0]!;
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
        title: const Text(
          "Profile",
          style: TextStyle(color: Constant.onPrimaryColor),
        ),
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.arrow_back),
          color: Constant.onPrimaryColor,
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.person),
            color: Constant.onPrimaryColor,
          )
        ],
        backgroundColor: const Color(0xFF3F72AF),
        centerTitle: true,
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
              padding: EdgeInsets.only(left: 15.0),
              child: Text(
                'How many people are there in your company?',
                style: TextStyle(
                    fontFamily: 'sans serif',
                    fontWeight: FontWeight.normal,
                    fontSize: 18,
                    decoration: TextDecoration.underline),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 5, left: 15, bottom: 10),
              child: Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(right: 20),
                    height: 20,
                    width: 20,
                    child: const Radio(
                      value: 1,
                      groupValue: 1,
                      onChanged: null,
                    ),
                  ),
                  Text(
                    option,
                    style: const TextStyle(fontSize: 15),
                  )
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 15.0),
              child: Text(
                'Company Name',
                style: TextStyle(
                    fontFamily: 'sans serif',
                    fontWeight: FontWeight.normal,
                    fontSize: 18,
                    decoration: TextDecoration.underline),
              ),
            ),
            Container(
              width: double.infinity,
              height: 50,
              margin: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
              decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFF3F72AF), width: 2)),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  _companyProfile.companyName,
                  textAlign: TextAlign.left,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Padding(
              padding: EdgeInsets.only(left: 15.0),
              child: Text(
                'Website',
                style: TextStyle(
                    fontFamily: 'sans serif',
                    fontWeight: FontWeight.normal,
                    fontSize: 18,
                    decoration: TextDecoration.underline),
              ),
            ),
            Container(
              width: double.infinity,
              height: 50,
              margin: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
              decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFF3F72AF), width: 2)),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  _companyProfile.website,
                  textAlign: TextAlign.left,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 15.0),
              child: Text(
                'Description',
                style: TextStyle(
                    fontFamily: 'sans serif',
                    fontWeight: FontWeight.normal,
                    fontSize: 18,
                    decoration: TextDecoration.underline),
              ),
            ),
            Container(
              width: double.infinity,
              height: 50,
              margin: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
              decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFF3F72AF), width: 2)),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  _companyProfile.description,
                  textAlign: TextAlign.left,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 0.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              width: 130,
              margin: const EdgeInsets.only(right: 10),
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.edit),
                label: const Text('Edit'),
              ),
            ),
            SizedBox(
              width: 130,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.cancel),
                label: const Text('Cancel'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
