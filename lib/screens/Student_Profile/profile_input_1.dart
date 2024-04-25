import 'dart:convert';
import 'dart:developer';

import 'package:amp_studenthub/configs/constant.dart';
import 'package:amp_studenthub/network/dio.dart';
import 'package:dio/dio.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';

class StudentProfileInput1 extends StatefulWidget {
  const StudentProfileInput1({super.key});

  @override
  State<StudentProfileInput1> createState() => _StudentProfileInput1State();
}

class _StudentProfileInput1State extends State<StudentProfileInput1> {
  List techStacks = [];
  String selectedTechStackId = '';
  List<ValueItem<dynamic>> skillsetList = [];
  final MultiSelectController<dynamic> _controller = MultiSelectController();

  Future<void> getInitData() async {
    final dio = Dio();

    Map<String, String> headers = {
      CONTENT_TYPE: APPLICATION_JSON,
      ACCEPT: APPLICATION_JSON,
      AUTHORIZATION: Constant.token,
      DEFAULT_LANGUAGE: "en"
    };

    dio.options = BaseOptions(
      baseUrl: Constant.baseURL,
      headers: headers,
    );
    try {
      // Get techstack
      const endpoint = '${Constant.baseURL}/api/techstack/getAllTechStack';
      final Response response = await dio.get(endpoint);
      final dynamic resData = response.data;
      final jsonList = resData['result'] as List;
      setState(() {
        techStacks = jsonList;
      });
      print(jsonList[0]['id']);
      log(jsonList.toString());
      // Get skill sets
      const skillsetEndpoint =
          '${Constant.baseURL}/api/skillset/getAllSkillSet';
      final Response skillsetResponse = await dio.get(skillsetEndpoint);
      final dynamic skillsetResData = skillsetResponse.data;
      final skillsetJsonList = skillsetResData['result'] as List;
      setState(() {
        skillsetList = skillsetJsonList
            .map((skill) => ValueItem(label: skill['name'], value: skill['id']))
            .toList();
        _controller.setOptions(skillsetList);
      });
      print(skillsetJsonList[0]['name']);
      log(skillsetList.toString());
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

  Future<void> uploadProfileData() async {
    final dio = Dio();

    Map<String, String> headers = {
      CONTENT_TYPE: APPLICATION_JSON,
      ACCEPT: APPLICATION_JSON,
      AUTHORIZATION: Constant.token,
      DEFAULT_LANGUAGE: "en"
    };

    dio.options = BaseOptions(
      baseUrl: Constant.baseURL,
      headers: headers,
    );
    try {
      const endpoint = '${Constant.baseURL}/api/profile/student';
      List<String> selectedSkillSetIds = _controller.selectedOptions
          .map((opt) => opt.value.toString())
          .toList();
      var data = {
        "techStackId": selectedTechStackId,
        "skillSets": selectedSkillSetIds
      };
      final Response response =
          await dio.post(endpoint, data: jsonEncode(data));
      Fluttertoast.showToast(
          msg: "Create Student Profile Successfully",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 3,
          fontSize: 20.0);
      log(response.toString());
    } on DioException catch (e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        if (e.response?.statusCode == 422) {
          Fluttertoast.showToast(
              msg: "Student Profile Existed",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.TOP,
              timeInSecForIosWeb: 3,
              fontSize: 20.0);
        }
        print(e.response?.statusCode);
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

  final List<Map<String, dynamic>> educationList = [
    {'name': 'HCMUS', 'time': '2020-2024'}
  ];

  final List<String> languageList = ['English'];

  @override
  void initState() {
    super.initState();
    getInitData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Constant.backgroundColor,
        toolbarHeight: 64,
        title: const Text(
          'StudentHub',
          style: TextStyle(
              color: Constant.primaryColor, fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: CircleAvatar(
              radius: 24,
              backgroundColor: Constant.primaryColor,
              child: IconButton(
                icon: const FaIcon(
                  FontAwesomeIcons.user,
                  size: 20,
                  color: Constant.onPrimaryColor,
                ),
                onPressed: () {},
              ),
            ),
          ),
        ],
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              const Center(
                child: Text(
                  'Welcome to Student Hub',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 10),
                child: Text(
                    'Tell us about your self and you will be on your way connect with real-world project'),
              ),
              const Text(
                'Techstack',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              DropdownButtonFormField2<String>(
                isExpanded: true,
                decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.only(top: 8, left: 8, right: 8),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                          color: Constant.primaryColor, width: 1)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                          color: Constant.primaryColor, width: 2)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                          color: Constant.secondaryColor, width: 1)),
                  labelStyle: TextStyle(color: Colors.grey[600]),
                ),
                hint: const Text(
                  'Select Your Techstack',
                  style: TextStyle(fontSize: 14),
                ),
                items: techStacks
                    .map((techStack) => DropdownMenuItem<String>(
                          value: techStack['id'].toString(),
                          child: Text(
                            techStack['name'],
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ))
                    .toList(),
                validator: (value) {
                  if (value == null) {
                    return 'Please select a techstack';
                  }
                  return null;
                },
                onChanged: (value) {
                  //Do something when selected item is changed.
                  log(value.toString());
                  setState(() {
                    selectedTechStackId = value.toString();
                  });
                },
                iconStyleData: const IconStyleData(
                  icon: Icon(
                    Icons.arrow_drop_down,
                    color: Colors.black45,
                  ),
                  iconSize: 24,
                ),
                dropdownStyleData: DropdownStyleData(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                menuItemStyleData: const MenuItemStyleData(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Skillset',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              MultiSelectDropDown(
                controller: _controller,
                onOptionSelected: (options) {
                  debugPrint(options.toString());
                  debugPrint(_controller.selectedOptions.toString());
                },
                radiusGeometry: BorderRadius.circular(12),
                options: skillsetList,
                disabledOptions: _controller.selectedOptions,
                hint: "Select skillset",
                hintStyle: TextStyle(fontSize: 16, color: Colors.grey[600]!),
                selectionType: SelectionType.multi,
                chipConfig: const ChipConfig(
                    wrapType: WrapType.scroll,
                    spacing: 8,
                    runSpacing: 4,
                    radius: 8,
                    backgroundColor: Constant.primaryColor,
                    labelColor: Constant.onPrimaryColor,
                    deleteIconColor: Constant.onPrimaryColor),
                dropdownHeight: 300,
                optionTextStyle: const TextStyle(fontSize: 16),
                selectedOptionBackgroundColor: Colors.grey.shade200,
                selectedOptionTextColor: Constant.primaryColor,
                selectedOptionIcon: const Icon(
                  Icons.check_circle,
                  color: Constant.primaryColor,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  const Text(
                    'Language',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  IconButton(
                      onPressed: () {},
                      icon: const FaIcon(
                        FontAwesomeIcons.circlePlus,
                      )),
                  IconButton(
                      onPressed: () {},
                      icon: const FaIcon(
                        FontAwesomeIcons.penToSquare,
                      ))
                ],
              ),
              ...languageList.map(
                (item) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    item,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  const Text(
                    'Education',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  IconButton(
                      onPressed: () {},
                      icon: const FaIcon(
                        FontAwesomeIcons.circlePlus,
                      )),
                ],
              ),
              ...educationList.map((item) => Padding(
                    padding: const EdgeInsets.only(left: 20.0, top: 5),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['name'],
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(item['time'])
                          ],
                        ),
                        const Spacer(),
                        IconButton(
                            onPressed: () {},
                            icon: const FaIcon(FontAwesomeIcons.penToSquare)),
                        IconButton(
                            onPressed: () {},
                            icon: const FaIcon(FontAwesomeIcons.trashCan))
                      ],
                    ),
                  )),
              Container(
                  alignment: Alignment.bottomCenter,
                  margin: const EdgeInsets.only(bottom: 16, top: 32),
                  width: double.infinity,
                  height: 48,
                  child: TextButton(
                    onPressed: () {
                      log(selectedTechStackId);
                      log(_controller.selectedOptions.toString());
                      uploadProfileData();
                      // context.pushNamed(RouteConstants.createStudentProfile2);
                    },
                    style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        backgroundColor: Constant.primaryColor,
                        foregroundColor: Constant.onPrimaryColor),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          child: const Text(
                            'Next',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  )),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
