import 'dart:convert';

import 'package:amp_studenthub/configs/constant.dart';
import 'package:amp_studenthub/network/dio.dart';
import 'package:amp_studenthub/providers/user_provider.dart';
import 'package:amp_studenthub/routes/routes_constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:multi_dropdown/models/value_item.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:provider/provider.dart';

class StudentProfileInput2 extends StatefulWidget {
  const StudentProfileInput2({super.key});

  @override
  State<StudentProfileInput2> createState() => _StudentProfileInput2State();
}

class _StudentProfileInput2State extends State<StudentProfileInput2> {
  bool isLoading = false;
  bool isSubmitting = false;
  List<ValueItem<dynamic>> skillsetList = [];
  List<dynamic> skillsetListMap = [];
  List<Map<String, dynamic>> experienceList = [];

  late TextEditingController titleController;
  late MultiSelectController<dynamic> skillSetsController;
  late TextEditingController descriptionController;
  late TextEditingController startMonthController;
  late TextEditingController endMonthController;

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
      // Get skill sets
      const skillsetEndpoint =
          '${Constant.baseURL}/api/skillset/getAllSkillSet';
      final Response skillsetResponse = await dio.get(skillsetEndpoint);
      final dynamic skillsetResData = skillsetResponse.data;
      final List<dynamic> skillsetJsonList = skillsetResData['result'] as List;
      setState(() {
        skillsetList = skillsetJsonList
            .map((skill) => ValueItem(label: skill['name'], value: skill['id']))
            .toList();
        skillsetListMap = skillsetJsonList;
      });
      print(skillsetListMap
          .firstWhere((skillset) => skillset['id'] == 3)['name']);
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

  Future<void> uploadExperiences() async {
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
        isSubmitting = true;
      });
      const studentProfileId = 170;

      // Update Experience
      String updateExperienceEndpoint =
          '${Constant.baseURL}/api/experience/updateByStudentId/$studentProfileId';
      var updateExperienceData = {"experience": experienceList};
      final Response updateExperienceResponse = await dio.put(
          updateExperienceEndpoint,
          data: jsonEncode(updateExperienceData));
      final dynamic updateExperienceResData = updateExperienceResponse.data;
      print(updateExperienceResData);
      Fluttertoast.showToast(
          msg: "Create Student Profile Successfully",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 3,
          fontSize: 20.0);
      if (!mounted) return;
      context.pushNamed(RouteConstants.createStudentProfile3);
    } on DioException catch (e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
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

  Future<Map<String, dynamic>?> openExperienceDialog(
          int? selectedExperienceIndex) =>
      showDialog<Map<String, dynamic>>(
          context: context,
          builder: (context) => AlertDialog(
                backgroundColor: Constant.backgroundColor,
                surfaceTintColor: Constant.backgroundColor,
                insetPadding: const EdgeInsets.symmetric(horizontal: 8),
                title: Text(selectedExperienceIndex is int
                    ? "Edit Experience:"
                    : 'Add New Experience:'),
                content: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          autofocus: true,
                          decoration:
                              const InputDecoration(hintText: "Enter title..."),
                          controller: titleController,
                        ),
                        TextFormField(
                          initialValue: null,
                          decoration: const InputDecoration(
                              hintText: "Enter description..."),
                          controller: descriptionController,
                        ),
                        TextFormField(
                          initialValue: null,
                          decoration: const InputDecoration(
                              hintText: "Enter start month..."),
                          controller: startMonthController,
                        ),
                        TextFormField(
                          initialValue: null,
                          decoration: const InputDecoration(
                              hintText: "Enter end month..."),
                          controller: endMonthController,
                        ),
                        MultiSelectDropDown(
                          controller: skillSetsController,
                          onOptionSelected: (options) {
                            debugPrint(options.toString());
                            debugPrint(
                                skillSetsController.selectedOptions.toString());
                          },
                          radiusGeometry: BorderRadius.circular(12),
                          options: skillsetList,
                          disabledOptions: skillSetsController.selectedOptions,
                          hint: "Select skillset",
                          hintStyle:
                              TextStyle(fontSize: 16, color: Colors.grey[600]!),
                          selectionType: SelectionType.multi,
                          chipConfig: const ChipConfig(
                              wrapType: WrapType.scroll,
                              spacing: 8,
                              runSpacing: 4,
                              radius: 8,
                              backgroundColor: Constant.primaryColor,
                              labelColor: Constant.onPrimaryColor,
                              deleteIconColor: Constant.onPrimaryColor),
                          dropdownHeight: 160,
                          optionTextStyle: const TextStyle(fontSize: 16),
                          selectedOptionBackgroundColor: Colors.grey.shade200,
                          selectedOptionTextColor: Constant.primaryColor,
                          selectedOptionIcon: const Icon(
                            Icons.check_circle,
                            color: Constant.primaryColor,
                          ),
                        ),
                      ],
                    )),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        titleController.clear();
                        descriptionController.clear();
                        startMonthController.clear();
                        endMonthController.clear();
                        skillSetsController.clearAllSelection();
                      },
                      child: const Text("Cancel")),
                  TextButton(
                      onPressed: () {
                        List<String> selectedSkillSetIds = skillSetsController
                            .selectedOptions
                            .map((opt) => opt.value.toString())
                            .toList();
                        if (selectedExperienceIndex is int) {
                          setState(() {
                            experienceList[selectedExperienceIndex] = {
                              'title': titleController.text,
                              'startMonth': startMonthController.text,
                              'endMonth': endMonthController.text,
                              'description': descriptionController.text,
                              'skillSets': selectedSkillSetIds
                            };
                          });
                          Navigator.of(context).pop();
                        } else {
                          print({
                            'title': titleController.text,
                            'startMonth': startMonthController.text,
                            'endMonth': endMonthController.text,
                            'description': descriptionController.text,
                            'skillSets': selectedSkillSetIds
                          });
                          print(skillsetListMap.firstWhere((skillset) =>
                              skillset['id'].toString() ==
                              selectedSkillSetIds[0])['name']);
                          Navigator.of(context).pop({
                            'title': titleController.text,
                            'startMonth': startMonthController.text,
                            'endMonth': endMonthController.text,
                            'description': descriptionController.text,
                            'skillSets': selectedSkillSetIds
                          });
                        }
                        titleController.clear();
                        descriptionController.clear();
                        startMonthController.clear();
                        endMonthController.clear();
                        skillSetsController.clearAllSelection();
                      },
                      child: const Text("Confirm"))
                ],
              ));

  @override
  void initState() {
    super.initState();
    skillSetsController = MultiSelectController();
    titleController = TextEditingController();
    descriptionController = TextEditingController();
    startMonthController = TextEditingController();
    endMonthController = TextEditingController();
    getInitData();
  }

  @override
  void dispose() {
    skillSetsController.dispose();
    titleController.dispose();
    descriptionController.dispose();
    startMonthController.dispose();
    endMonthController.dispose();
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
        padding: const EdgeInsets.all(16),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  'Your Experiences',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 16, bottom: 8),
                child: Row(
                  children: [
                    const Text(
                      'Experiences',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const Spacer(),
                    TextButton(
                      style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          side: const BorderSide(
                              color: Constant.primaryColor, width: 1),
                          foregroundColor: Constant.primaryColor),
                      onPressed: () async {
                        final newExperienceObj =
                            await openExperienceDialog(null);
                        if (newExperienceObj == null) return;
                        if (newExperienceObj['title'] == null ||
                            newExperienceObj['title'].isEmpty) {
                          return;
                        }
                        if (newExperienceObj['description'] == null ||
                            newExperienceObj['description'].isEmpty) return;
                        if (newExperienceObj['startMonth'] == null ||
                            newExperienceObj['startMonth'].isEmpty) return;
                        if (newExperienceObj['endMonth'] == null ||
                            newExperienceObj['endMonth'].isEmpty) return;
                        setState(() {
                          experienceList.add(newExperienceObj);
                        });
                      },
                      child: const Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: 8),
                            child: Text(
                              "Add",
                              style: TextStyle(fontWeight: FontWeight.w600),
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
              if (experienceList.isEmpty)
                Container(
                  constraints: BoxConstraints(
                      minHeight: MediaQuery.of(context).size.height * 0.5),
                  alignment: Alignment.center,
                  child: Text(
                    "No Experience Found",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ...experienceList.map((experience) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        child: Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(bottom: 4),
                                  child: Text(
                                    experience['title'].toString(),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16),
                                  ),
                                ),
                                Text(
                                  '${experience['startMonth']} - ${experience['endMonth']}',
                                  style: TextStyle(color: Colors.grey[600]!),
                                )
                              ],
                            ),
                            const Spacer(),
                            IconButton(
                                onPressed: () async {
                                  int index =
                                      experienceList.indexOf(experience);
                                  titleController.value = titleController.value
                                      .copyWith(
                                          text: experienceList[index]['title'],
                                          selection: TextSelection.collapsed(
                                              offset: experienceList[index]
                                                      ['title']
                                                  .length));
                                  startMonthController.value =
                                      startMonthController.value.copyWith(
                                          text: experienceList[index]
                                              ['startMonth'],
                                          selection: TextSelection.collapsed(
                                              offset: experienceList[index]
                                                      ['startMonth']
                                                  .length));
                                  endMonthController.value =
                                      endMonthController.value.copyWith(
                                          text: experienceList[index]
                                              ['endMonth'],
                                          selection: TextSelection.collapsed(
                                              offset: experienceList[index]
                                                      ['endMonth']
                                                  .length));
                                  await openExperienceDialog(index);
                                },
                                icon: const FaIcon(
                                  FontAwesomeIcons.penToSquare,
                                  size: 20,
                                )),
                            IconButton(
                                onPressed: () {
                                  int index =
                                      experienceList.indexOf(experience);
                                  if (index != -1) {
                                    setState(() {
                                      experienceList.removeAt(index);
                                    });
                                  }
                                },
                                icon: const FaIcon(
                                  FontAwesomeIcons.trashCan,
                                  size: 20,
                                ))
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: const Text(
                          'Description:',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                      Text(experience['description']),
                      const SizedBox(
                        height: 16,
                      ),
                      Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: const Text(
                          'Skillset:',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                      experience['skillSets'].isEmpty
                          ? Center(
                              child: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  "No Skillset Found",
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ),
                            )
                          : Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 16),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey[600]!),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(12)),
                                color: Colors.transparent,
                              ),
                              child: Wrap(
                                spacing: 8,
                                runSpacing: 4,
                                children: <Widget>[
                                  ...experience['skillSets']
                                      .map((skillsetId) => skillsetListMap
                                                  .firstWhere((skillset) =>
                                                      skillset['id']
                                                          .toString() ==
                                                      skillsetId) !=
                                              null
                                          ? Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 4),
                                              child: Chip(
                                                shape:
                                                    const RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    8))),
                                                label: Text(
                                                  skillsetListMap.firstWhere(
                                                      (skillset) =>
                                                          skillset['id']
                                                              .toString() ==
                                                          skillsetId)['name'],
                                                  style: const TextStyle(
                                                      color: Constant
                                                          .onPrimaryColor),
                                                ),
                                                backgroundColor:
                                                    Constant.primaryColor,
                                              ),
                                            )
                                          : Container())
                                      .toList(),
                                ],
                              ),
                            ),
                      const SizedBox(
                        height: 16,
                      ),
                      const Divider()
                    ],
                  )),
              Container(
                  alignment: Alignment.bottomCenter,
                  margin: const EdgeInsets.only(bottom: 16, top: 32),
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () {
                      print(experienceList);
                      uploadExperiences();
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
                          margin: const EdgeInsets.only(right: 8),
                          child: const Text(
                            'Update',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500),
                          ),
                        ),
                        if (isSubmitting)
                          const SpinKitCircle(
                              size: 20,
                              duration: Durations.extralong4,
                              color: Constant.onPrimaryColor)
                      ],
                    ),
                  )),
              Container(
                  alignment: Alignment.bottomCenter,
                  margin: const EdgeInsets.only(bottom: 8),
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () {
                      context.pushNamed(RouteConstants.createStudentProfile3);
                    },
                    style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        side: const BorderSide(
                            color: Constant.primaryColor, width: 2),
                        foregroundColor: Constant.primaryColor),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          child: const Text(
                            'Skip',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  )),
              Center(
                child: Text(
                  "You can update this in your student profile later",
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600]!,
                      fontStyle: FontStyle.italic),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
