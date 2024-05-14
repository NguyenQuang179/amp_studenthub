import 'dart:convert';
import 'dart:developer';

import 'package:amp_studenthub/configs/constant.dart';
import 'package:amp_studenthub/network/dio.dart';
import 'package:amp_studenthub/providers/user_provider.dart';
import 'package:amp_studenthub/routes/routes_constants.dart';
import 'package:dio/dio.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:provider/provider.dart';

class StudentProfileInput1 extends StatefulWidget {
  const StudentProfileInput1({super.key});

  @override
  State<StudentProfileInput1> createState() => _StudentProfileInput1State();
}

class _StudentProfileInput1State extends State<StudentProfileInput1> {
  bool isLoading = false;
  bool isSubmitting = false;
  List techStacks = [];
  String selectedTechStackId = '';
  List<ValueItem<dynamic>> skillsetList = [];
  List<Map<String, dynamic>> educationList = [];
  List<Map<String, dynamic>> languageList = [];

  final MultiSelectController<dynamic> _controller = MultiSelectController();
  late TextEditingController languageNameController;
  late TextEditingController languageLevelController;
  late TextEditingController schoolNameController;
  late TextEditingController startYearController;
  late TextEditingController endYearController;

  Future<void> getInitData() async {
    final dio = Dio();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final accessToken = userProvider.userToken;

    Map<String, String> headers = {
      CONTENT_TYPE: APPLICATION_JSON,
      ACCEPT: APPLICATION_JSON,
      AUTHORIZATION: 'Bearer $accessToken',
      DEFAULT_LANGUAGE: "en"
    };

    dio.options = BaseOptions(
      baseUrl: Constant.baseURL,
      headers: headers,
    );
    try {
      setState(() {
        isLoading = true;
      });
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
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> uploadProfileData() async {
    final dio = Dio();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final accessToken = userProvider.userToken;

    Map<String, String> headers = {
      CONTENT_TYPE: APPLICATION_JSON,
      ACCEPT: APPLICATION_JSON,
      AUTHORIZATION: 'Bearer $accessToken',
      DEFAULT_LANGUAGE: "en"
    };
    dio.options = BaseOptions(
      headers: headers,
    );
    try {
      setState(() {
        isSubmitting = true;
      });
      const endpoint = '${Constant.baseURL}/api/profile/student';
      List<String> selectedSkillSetIds = _controller.selectedOptions
          .map((opt) => opt.value.toString())
          .toList();
      var data = {
        "techStackId": selectedTechStackId,
        "skillSets": selectedSkillSetIds
      };
      final Response createStudentProfileResponse =
          await dio.post(endpoint, data: jsonEncode(data));
      final dynamic resData = createStudentProfileResponse.data;
      final studentProfileId = resData['result']['id'];

      // Update Language
      String updateLanguageEndpoint =
          '${Constant.baseURL}/api/language/updateByStudentId/$studentProfileId';
      var updateLanguageData = {"languages": languageList};
      // final Response updateLanguageResponse =
      await dio.put(updateLanguageEndpoint,
          data: jsonEncode(updateLanguageData));
      // final dynamic updateLanguageResData = updateLanguageResponse.data;

      // Update Education
      String updateEducationEndpoint =
          '${Constant.baseURL}/api/education/updateByStudentId/$studentProfileId';
      var updateEducationData = {"education": educationList};
      // final Response updateEducationResponse =
      await dio.put(updateEducationEndpoint,
          data: jsonEncode(updateEducationData));
      // final dynamic updateEducationResData = updateEducationResponse.data;

      Fluttertoast.showToast(
          msg: "Create Student Profile Successfully",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 3,
          fontSize: 20.0);

      if (!mounted) return;
      context.pushNamed(RouteConstants.createStudentProfile2);
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
    } finally {
      setState(() {
        isSubmitting = false;
      });
    }
  }

  Future<Map<String, dynamic>?> openLanguageDialog(
          int? selectedLanguageIndex) =>
      showDialog<Map<String, dynamic>>(
          context: context,
          builder: (context) => AlertDialog(
                backgroundColor: Theme.of(context).colorScheme.background,
                surfaceTintColor: Theme.of(context).colorScheme.background,
                insetPadding: const EdgeInsets.symmetric(horizontal: 8),
                title: Text(selectedLanguageIndex is int
                    ? "Edit Language"
                    : 'Add New Language:'),
                content: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          autofocus: true,
                          decoration: const InputDecoration(
                              hintText: "Enter language name..."),
                          controller: languageNameController,
                        ),
                        TextFormField(
                          initialValue: null,
                          decoration: const InputDecoration(
                              hintText: "Enter language level..."),
                          controller: languageLevelController,
                        ),
                      ],
                    )),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        languageNameController.clear();
                        languageLevelController.clear();
                      },
                      child: const Text("Cancel")),
                  TextButton(
                      onPressed: () {
                        if (selectedLanguageIndex is int) {
                          setState(() {
                            languageList[selectedLanguageIndex] = {
                              'languageName': languageNameController.text,
                              'level': languageLevelController.text
                            };
                          });
                          Navigator.of(context).pop();
                        } else {
                          Navigator.of(context).pop({
                            'languageName': languageNameController.text,
                            'level': languageLevelController.text
                          });
                        }

                        languageNameController.clear();
                        languageLevelController.clear();
                      },
                      child: const Text("Confirm"))
                ],
              ));

  Future<Map<String, dynamic>?> openEducationDialog(
          int? selectedEducationIndex) =>
      showDialog<Map<String, dynamic>>(
          context: context,
          builder: (context) => AlertDialog(
                backgroundColor: Theme.of(context).colorScheme.background,
                surfaceTintColor: Theme.of(context).colorScheme.background,
                insetPadding: const EdgeInsets.symmetric(horizontal: 8),
                title: Text(selectedEducationIndex is int
                    ? "Edit Education"
                    : 'Add New Education:'),
                content: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          autofocus: true,
                          decoration: const InputDecoration(
                              hintText: "Enter school name..."),
                          controller: schoolNameController,
                        ),
                        TextFormField(
                          initialValue: null,
                          decoration: const InputDecoration(
                              hintText: "Enter start year..."),
                          controller: startYearController,
                        ),
                        TextFormField(
                          initialValue: null,
                          decoration: const InputDecoration(
                              hintText: "Enter end year..."),
                          controller: endYearController,
                        ),
                      ],
                    )),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        schoolNameController.clear();
                        startYearController.clear();
                        endYearController.clear();
                      },
                      child: const Text("Cancel")),
                  TextButton(
                      onPressed: () {
                        if (selectedEducationIndex is int) {
                          setState(() {
                            educationList[selectedEducationIndex] = {
                              'schoolName': schoolNameController.text,
                              'startYear': startYearController.text,
                              'endYear': endYearController.text
                            };
                          });
                          Navigator.of(context).pop();
                        } else {
                          Navigator.of(context).pop({
                            'schoolName': schoolNameController.text,
                            'startYear': startYearController.text,
                            'endYear': endYearController.text
                          });
                        }
                        schoolNameController.clear();
                        startYearController.clear();
                        endYearController.clear();
                      },
                      child: const Text("Confirm"))
                ],
              ));

  @override
  void initState() {
    super.initState();
    languageNameController = TextEditingController();
    languageLevelController = TextEditingController();
    schoolNameController = TextEditingController();
    startYearController = TextEditingController();
    endYearController = TextEditingController();
    getInitData();
  }

  @override
  void dispose() {
    _controller.dispose();
    languageNameController.dispose();
    languageLevelController.dispose();
    schoolNameController.dispose();
    startYearController.dispose();
    endYearController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        toolbarHeight: 64,
        title: Text(
          'StudentHub',
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
                onPressed: () {},
              ),
            ),
          ),
        ],
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: isLoading
            ? Center(
                child: SpinKitThreeBounce(
                    size: 32,
                    duration: Durations.extralong4,
                    color: Theme.of(context).colorScheme.primary))
            : Form(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(
                      child: Text(
                        'Welcome to StudentHub',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 5.0, vertical: 10),
                      child: Text(
                          'Tell us about your self and you will be on your way connect with real-world project'),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 16, bottom: 8),
                      child: const Row(
                        children: [
                          Text(
                            'Techstack',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          Text(
                            ' \u002a',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                    DropdownButtonFormField2<String>(
                      isExpanded: true,
                      decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.only(top: 8, left: 8, right: 8),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.primary,
                                width: 1)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.primary,
                                width: 2)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.secondary,
                                width: 1)),
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
                    Container(
                      margin: const EdgeInsets.only(top: 16, bottom: 8),
                      child: const Row(
                        children: [
                          Text(
                            'Skillset',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          Text(
                            ' \u002a',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.red),
                          ),
                        ],
                      ),
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
                      hintStyle:
                          TextStyle(fontSize: 16, color: Colors.grey[600]!),
                      selectionType: SelectionType.multi,
                      chipConfig: ChipConfig(
                          wrapType: WrapType.scroll,
                          spacing: 8,
                          runSpacing: 4,
                          radius: 8,
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          labelColor: Theme.of(context).colorScheme.onPrimary,
                          deleteIconColor:
                              Theme.of(context).colorScheme.onPrimary),
                      dropdownHeight: 300,
                      optionTextStyle: const TextStyle(fontSize: 16),
                      selectedOptionBackgroundColor: Colors.grey.shade200,
                      selectedOptionTextColor:
                          Theme.of(context).colorScheme.primary,
                      selectedOptionIcon: Icon(
                        Icons.check_circle,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 16, bottom: 8),
                      child: Row(
                        children: [
                          const Text(
                            'Language',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          const Spacer(),
                          TextButton(
                            style: TextButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                side: BorderSide(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    width: 1),
                                foregroundColor:
                                    Theme.of(context).colorScheme.primary),
                            onPressed: () async {
                              final newLanguageObj =
                                  await openLanguageDialog(null);
                              if (newLanguageObj == null) return;
                              if (newLanguageObj['languageName'] == null ||
                                  newLanguageObj['languageName'].isEmpty) {
                                return;
                              }
                              if (newLanguageObj['level'] == null ||
                                  newLanguageObj['level'].isEmpty) return;
                              setState(() {
                                languageList.add(newLanguageObj);
                              });
                            },
                            child: const Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(right: 8),
                                  child: Text(
                                    "Add",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                ),
                                FaIcon(
                                  FontAwesomeIcons.plus,
                                  size: 16,
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    if (languageList.isEmpty)
                      Container(
                        alignment: Alignment.center,
                        child: Text(
                          "No Language Found",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    ...languageList.map(
                      (item) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 0),
                        child: Column(children: [
                          Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(bottom: 8),
                                    child: Text(
                                      item['languageName'].toString(),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16),
                                    ),
                                  ),
                                  Text('Level: ${item['level']}')
                                ],
                              ),
                              const Spacer(),
                              IconButton(
                                  onPressed: () async {
                                    int index = languageList.indexOf(item);
                                    print('Selected Index: $index');
                                    languageNameController.value =
                                        languageNameController.value.copyWith(
                                            text: languageList[index]
                                                ['languageName'],
                                            selection: TextSelection.collapsed(
                                                offset: languageList[index]
                                                        ['languageName']
                                                    .length));
                                    languageLevelController.value =
                                        languageLevelController.value.copyWith(
                                            text: languageList[index]['level'],
                                            selection: TextSelection.collapsed(
                                                offset: languageList[index]
                                                        ['level']
                                                    .length));
                                    await openLanguageDialog(index);
                                  },
                                  icon: const FaIcon(
                                    FontAwesomeIcons.penToSquare,
                                    size: 20,
                                  )),
                              IconButton(
                                  onPressed: () {
                                    int index = languageList.indexOf(item);
                                    if (index != -1) {
                                      setState(() {
                                        languageList.removeAt(index);
                                      });
                                    }
                                  },
                                  icon: const FaIcon(
                                    FontAwesomeIcons.trashCan,
                                    size: 20,
                                  ))
                            ],
                          ),
                          const Divider()
                        ]),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 16, bottom: 8),
                      child: Row(
                        children: [
                          const Text(
                            'Education',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          const Spacer(),
                          TextButton(
                            style: TextButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                side: BorderSide(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    width: 1),
                                foregroundColor:
                                    Theme.of(context).colorScheme.primary),
                            onPressed: () async {
                              final newEducationObj =
                                  await openEducationDialog(null);
                              print(newEducationObj);
                              if (newEducationObj == null) return;
                              if (newEducationObj['schoolName'] == null ||
                                  newEducationObj['schoolName'].isEmpty) return;
                              if (newEducationObj['startYear'] == null ||
                                  newEducationObj['startYear'].isEmpty) return;
                              if (newEducationObj['endYear'] == null ||
                                  newEducationObj['endYear'].isEmpty) return;
                              setState(() {
                                educationList.add(newEducationObj);
                              });
                            },
                            child: const Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(right: 8),
                                  child: Text(
                                    "Add",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                ),
                                FaIcon(
                                  FontAwesomeIcons.plus,
                                  size: 16,
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    if (educationList.isEmpty)
                      Container(
                        alignment: Alignment.center,
                        child: Text(
                          "No Education Found",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    ...educationList.map(
                      (item) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 0),
                        child: Column(children: [
                          Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(bottom: 8),
                                    child: Text(
                                      item['schoolName'].toString(),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16),
                                    ),
                                  ),
                                  Text(
                                      '${item['startYear']}-${item['endYear']}')
                                ],
                              ),
                              const Spacer(),
                              IconButton(
                                  onPressed: () async {
                                    int index = educationList.indexOf(item);
                                    schoolNameController.value =
                                        schoolNameController.value.copyWith(
                                            text: educationList[index]
                                                ['schoolName'],
                                            selection: TextSelection.collapsed(
                                                offset: educationList[index]
                                                        ['schoolName']
                                                    .length));
                                    startYearController.value =
                                        startYearController.value.copyWith(
                                            text: educationList[index]
                                                ['startYear'],
                                            selection: TextSelection.collapsed(
                                                offset: educationList[index]
                                                        ['startYear']
                                                    .length));
                                    endYearController.value =
                                        endYearController.value.copyWith(
                                            text: educationList[index]
                                                ['endYear'],
                                            selection: TextSelection.collapsed(
                                                offset: educationList[index]
                                                        ['endYear']
                                                    .length));
                                    await openEducationDialog(index);
                                  },
                                  icon: const FaIcon(
                                    FontAwesomeIcons.penToSquare,
                                    size: 20,
                                  )),
                              IconButton(
                                  onPressed: () {
                                    int index = educationList.indexOf(item);
                                    if (index != -1) {
                                      setState(() {
                                        educationList.removeAt(index);
                                      });
                                    }
                                  },
                                  icon: const FaIcon(
                                    FontAwesomeIcons.trashCan,
                                    size: 20,
                                  ))
                            ],
                          ),
                          const Divider()
                        ]),
                      ),
                    ),
                    Container(
                        alignment: Alignment.bottomCenter,
                        margin: const EdgeInsets.only(bottom: 16, top: 32),
                        width: double.infinity,
                        child: TextButton(
                          onPressed: () {
                            if (selectedTechStackId == "" ||
                                _controller.selectedOptions.isEmpty) return;
                            uploadProfileData();
                            context.pushNamed(
                                RouteConstants.createStudentProfile2);
                          },
                          style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                              foregroundColor:
                                  Theme.of(context).colorScheme.onPrimary),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(right: 8),
                                child: const Text(
                                  'Create',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              if (isSubmitting)
                                SpinKitCircle(
                                    size: 20,
                                    duration: Durations.extralong4,
                                    color:
                                        Theme.of(context).colorScheme.onPrimary)
                            ],
                          ),
                        )),
                  ],
                ),
              ),
      ),
    );
  }
}
