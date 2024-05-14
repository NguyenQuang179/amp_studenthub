import 'dart:convert';
import 'dart:io';

import 'package:amp_studenthub/configs/constant.dart';
import 'package:amp_studenthub/models/student_profile.dart';
import 'package:amp_studenthub/network/dio.dart';
import 'package:amp_studenthub/providers/user_provider.dart';
import 'package:amp_studenthub/widgets/auth_app_bar.dart';
import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:provider/provider.dart';

class ViewStudentProfile extends StatefulWidget {
  const ViewStudentProfile({super.key});

  @override
  State<ViewStudentProfile> createState() => _ViewStudentProfileState();
}

class _ViewStudentProfileState extends State<ViewStudentProfile> {
  late StudentProfile studentProfile;
  bool isLoading = false;
  bool isEditing = false;
  bool isSubmitting = false;
  List techStacks = [];
  String selectedTechStackId = '';
  List<ValueItem<dynamic>> skillsetList = [];
  List<dynamic> skillsetListMap = [];
  List<dynamic> educationList = [];
  List<dynamic> languageList = [];
  List<Map<String, dynamic>> experienceList = [];
  String viewCVFileName = "";
  String viewTranscriptFileName = "";
  File? cvFile;
  File? transcriptFile;
  PlatformFile? cvFileDetails;
  PlatformFile? transcriptFileDetails;

  final MultiSelectController<dynamic> _controller = MultiSelectController();
  late TextEditingController languageNameController;
  late TextEditingController languageLevelController;
  late TextEditingController schoolNameController;
  late TextEditingController startYearController;
  late TextEditingController endYearController;
  late TextEditingController titleController;
  late MultiSelectController<dynamic> skillSetsController;
  late TextEditingController descriptionController;
  late TextEditingController startMonthController;
  late TextEditingController endMonthController;

  Future<void> getInitData() async {
    final dio = Dio();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    String accessToken = userProvider.userToken;
    dynamic studentInfo = userProvider.userInfo['student'];
    StudentProfile profile = StudentProfile.fromJson(studentInfo);

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

        List<ValueItem> selectedSkillsetList = [...profile.skillSets]
            .map((skill) => ValueItem(label: skill['name'], value: skill['id']))
            .where((skill) => skillsetList.contains(skill))
            .toList();
        _controller.setSelectedOptions(selectedSkillsetList);

        if (profile.resume != null) viewCVFileName = profile.resume ?? "";
        if (profile.transcript != null) {
          viewTranscriptFileName = profile.transcript ?? "";
        }

        studentProfile = profile;
        selectedTechStackId = profile.techStackId.toString();
        languageList = [...profile.languages];
        educationList = [...profile.educations];
        skillsetListMap = skillsetJsonList;
        List<Map<String, dynamic>> newExpList = profile.experiences.map((exp) {
          List<dynamic> newSkillsetList = exp['skillSets'].map((skillSet) {
            return skillSet['id'].toString();
          }).toList();
          return {
            ...Map<String, dynamic>.from(exp as Map),
            'skillSets': newSkillsetList
          };
        }).toList();
        experienceList = [...newExpList];
      });
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

  Future<void> updateProfileData() async {
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
      final studentProfileId = studentProfile.id;
      String endpoint =
          '${Constant.baseURL}/api/profile/student/$studentProfileId';
      List<String> selectedSkillSetIds = _controller.selectedOptions
          .map((opt) => opt.value.toString())
          .toList();
      var data = {
        "techStackId": selectedTechStackId,
        "skillSets": selectedSkillSetIds
      };
      // final Response updateStudentProfileResponse =
      await dio.put(endpoint, data: jsonEncode(data));

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

      // Update Experience
      String updateExperienceEndpoint =
          '${Constant.baseURL}/api/experience/updateByStudentId/$studentProfileId';
      var updateExperienceData = {"experience": experienceList};
      // final Response updateExperienceResponse =
      await dio.put(updateExperienceEndpoint,
          data: jsonEncode(updateExperienceData));

      // Update Resume
      if (cvFileDetails != null) {
        String updateResumeEndpoint =
            '${Constant.baseURL}/api/profile/student/$studentProfileId/resume';
        FormData resumeFormData = FormData.fromMap({
          "file": await MultipartFile.fromFile(cvFileDetails!.path ?? "",
              filename: cvFileDetails!.name),
        });
        await dio.put(updateResumeEndpoint, data: resumeFormData);
      }
      // Update Transcript
      if (transcriptFileDetails != null) {
        String updateTranscriptEndpoint =
            '${Constant.baseURL}/api/profile/student/$studentProfileId/transcript';
        FormData transcriptFormData = FormData.fromMap({
          "file": await MultipartFile.fromFile(
              transcriptFileDetails!.path ?? "",
              filename: transcriptFileDetails!.name),
        });
        await dio.put(updateTranscriptEndpoint, data: transcriptFormData);
      }

      // Use Provider to set the access token
      Provider.of<UserProvider>(context, listen: false)
          .updateToken(accessToken);
      // Get and store user data to provider
      const updateUserInfoEndpoint = '${Constant.baseURL}/api/auth/me';
      final Response userResponse = await dio.get(
        updateUserInfoEndpoint,
        options: Options(headers: {
          'Authorization': 'Bearer $accessToken',
        }),
      );

      final Map<String, dynamic> userResponseData =
          userResponse.data as Map<String, dynamic>;
      final dynamic userData = userResponseData['result'];

      Provider.of<UserProvider>(context, listen: false)
          .updateUserInfo(userData);

      Fluttertoast.showToast(
          msg: "Update Student Profile Successfully",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 3,
          fontSize: 20.0);
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
        isEditing = false;
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

  Future<Map<String, dynamic>?> openExperienceDialog(
          int? selectedExperienceIndex) =>
      showDialog<Map<String, dynamic>>(
          context: context,
          builder: (context) => AlertDialog(
                backgroundColor: Theme.of(context).colorScheme.background,
                surfaceTintColor: Theme.of(context).colorScheme.background,
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
                          hintStyle: TextStyle(
                              fontSize: 16,
                              color: Theme.of(context).colorScheme.tertiary),
                          selectionType: SelectionType.multi,
                          chipConfig: ChipConfig(
                              wrapType: WrapType.scroll,
                              spacing: 8,
                              runSpacing: 4,
                              radius: 8,
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                              labelColor:
                                  Theme.of(context).colorScheme.onPrimary,
                              deleteIconColor:
                                  Theme.of(context).colorScheme.onPrimary),
                          dropdownHeight: 160,
                          optionTextStyle: const TextStyle(fontSize: 16),
                          selectedOptionBackgroundColor: Colors.grey.shade200,
                          selectedOptionTextColor:
                              Theme.of(context).colorScheme.primary,
                          selectedOptionIcon: Icon(
                            Icons.check_circle,
                            color: Theme.of(context).colorScheme.primary,
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

  Future<void> pickFile(bool isCv) async {
    List<String> extensionType = ['doc', 'docx', 'pdf'];
    try {
      FilePickerResult? result = await FilePicker.platform
          .pickFiles(type: FileType.custom, allowedExtensions: extensionType);
      if (result != null) {
        PlatformFile file = result.files.first;
        setState(() {
          if (isCv) {
            cvFile = File(result.files.single.path!);
            cvFileDetails = file;
          } else {
            transcriptFile = File(result.files.single.path!);
            transcriptFileDetails = file;
          }
        });
      } else {
        // User canceled the picker
      }
    } catch (e) {
      print('Error picking file: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    languageNameController = TextEditingController();
    languageLevelController = TextEditingController();
    schoolNameController = TextEditingController();
    startYearController = TextEditingController();
    endYearController = TextEditingController();
    skillSetsController = MultiSelectController();
    titleController = TextEditingController();
    descriptionController = TextEditingController();
    startMonthController = TextEditingController();
    endMonthController = TextEditingController();
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
        appBar: const AuthAppBar(),
        body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            physics: const ClampingScrollPhysics(),
            child: isLoading
                ? SizedBox(
                    height: MediaQuery.of(context).size.height * 0.75,
                    child: Center(
                        child: SpinKitThreeBounce(
                            size: 32,
                            duration: Durations.extralong4,
                            color: Theme.of(context).colorScheme.primary)),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        Center(
                            child: Text(
                          "Student Profile",
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).colorScheme.primary),
                        )),
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
                            contentPadding: const EdgeInsets.only(
                                top: 8, left: 8, right: 8),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    width: 1)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    width: 2)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    width: 1)),
                            labelStyle: TextStyle(
                                color: Theme.of(context).colorScheme.tertiary),
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
                          onChanged: isEditing
                              ? (value) {
                                  //Do something when selected item is changed.
                                  setState(() {
                                    selectedTechStackId = value.toString();
                                  });
                                }
                              : null,
                          value: studentProfile.techStackId.toString(),
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
                          child: Row(
                            children: [
                              const Text(
                                'Skillset',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              Text(
                                ' \u002a',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Theme.of(context).colorScheme.error),
                              ),
                            ],
                          ),
                        ),
                        if (isEditing)
                          MultiSelectDropDown(
                            controller: _controller,
                            onOptionSelected: (options) {
                              debugPrint(options.toString());
                              debugPrint(
                                  _controller.selectedOptions.toString());
                            },
                            radiusGeometry: BorderRadius.circular(12),
                            options: skillsetList,
                            hint: "Select skillset",
                            hintStyle: TextStyle(
                                fontSize: 16,
                                color: Theme.of(context).colorScheme.tertiary),
                            selectionType: SelectionType.multi,
                            chipConfig: ChipConfig(
                                wrapType: WrapType.scroll,
                                spacing: 8,
                                runSpacing: 4,
                                radius: 8,
                                backgroundColor:
                                    Theme.of(context).colorScheme.primary,
                                labelColor:
                                    Theme.of(context).colorScheme.onPrimary,
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
                          )
                        else
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 16),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color:
                                      Theme.of(context).colorScheme.tertiary),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(12)),
                              color: Colors.transparent,
                            ),
                            child: Wrap(
                              spacing: 8,
                              runSpacing: 4,
                              children: <Widget>[
                                ..._controller.selectedOptions
                                    .map((skillset) => Padding(
                                          padding:
                                              const EdgeInsets.only(right: 4),
                                          child: Chip(
                                            shape: const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(8))),
                                            label: Text(
                                              skillset.label,
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onPrimary),
                                            ),
                                            backgroundColor: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                          ),
                                        )),
                              ],
                            ),
                          ),
                        Container(
                          margin: const EdgeInsets.only(top: 16, bottom: 8),
                          child: Row(
                            children: [
                              const Text(
                                'Language:',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              const Spacer(),
                              if (isEditing)
                                TextButton(
                                  style: TextButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      side: BorderSide(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          width: 1),
                                      foregroundColor: Theme.of(context)
                                          .colorScheme
                                          .primary),
                                  onPressed: () async {
                                    final newLanguageObj =
                                        await openLanguageDialog(null);
                                    if (newLanguageObj == null) return;
                                    if (newLanguageObj['languageName'] ==
                                            null ||
                                        newLanguageObj['languageName']
                                            .isEmpty) {
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
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600),
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
                                color: Theme.of(context).colorScheme.tertiary,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin:
                                            const EdgeInsets.only(bottom: 8),
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
                                  if (isEditing)
                                    IconButton(
                                        onPressed: () async {
                                          int index =
                                              languageList.indexOf(item);
                                          print('Selected Index: $index');
                                          languageNameController.value =
                                              languageNameController.value.copyWith(
                                                  text: languageList[index]
                                                      ['languageName'],
                                                  selection:
                                                      TextSelection.collapsed(
                                                          offset: languageList[
                                                                      index][
                                                                  'languageName']
                                                              .length));
                                          languageLevelController.value =
                                              languageLevelController.value
                                                  .copyWith(
                                                      text: languageList[index]
                                                          ['level'],
                                                      selection: TextSelection
                                                          .collapsed(
                                                              offset: languageList[
                                                                          index]
                                                                      ['level']
                                                                  .length));
                                          await openLanguageDialog(index);
                                        },
                                        icon: const FaIcon(
                                          FontAwesomeIcons.penToSquare,
                                          size: 20,
                                        )),
                                  if (isEditing)
                                    IconButton(
                                        onPressed: () {
                                          int index =
                                              languageList.indexOf(item);
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
                                'Education:',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              const Spacer(),
                              if (isEditing)
                                TextButton(
                                  style: TextButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      side: BorderSide(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          width: 1),
                                      foregroundColor: Theme.of(context)
                                          .colorScheme
                                          .primary),
                                  onPressed: () async {
                                    final newEducationObj =
                                        await openEducationDialog(null);
                                    print(newEducationObj);
                                    if (newEducationObj == null) return;
                                    if (newEducationObj['schoolName'] == null ||
                                        newEducationObj['schoolName'].isEmpty) {
                                      return;
                                    }
                                    if (newEducationObj['startYear'] == null ||
                                        newEducationObj['startYear'].isEmpty) {
                                      return;
                                    }
                                    if (newEducationObj['endYear'] == null ||
                                        newEducationObj['endYear'].isEmpty) {
                                      return;
                                    }
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
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600),
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
                                color: Theme.of(context).colorScheme.tertiary,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin:
                                            const EdgeInsets.only(bottom: 8),
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
                                  if (isEditing)
                                    IconButton(
                                        onPressed: () async {
                                          int index =
                                              educationList.indexOf(item);
                                          schoolNameController.value =
                                              schoolNameController.value.copyWith(
                                                  text: educationList[index]
                                                      ['schoolName'],
                                                  selection:
                                                      TextSelection.collapsed(
                                                          offset: educationList[
                                                                      index]
                                                                  ['schoolName']
                                                              .length));
                                          startYearController.value =
                                              startYearController.value.copyWith(
                                                  text:
                                                      '${educationList[index]['startYear']}',
                                                  selection:
                                                      TextSelection.collapsed(
                                                          offset: educationList[
                                                                      index]
                                                                  ['startYear']
                                                              .toString()
                                                              .length));
                                          endYearController.value =
                                              endYearController.value.copyWith(
                                                  text:
                                                      '${educationList[index]['endYear']}',
                                                  selection:
                                                      TextSelection.collapsed(
                                                          offset: educationList[
                                                                      index]
                                                                  ['endYear']
                                                              .toString()
                                                              .length));
                                          await openEducationDialog(index);
                                        },
                                        icon: const FaIcon(
                                          FontAwesomeIcons.penToSquare,
                                          size: 20,
                                        )),
                                  if (isEditing)
                                    IconButton(
                                        onPressed: () {
                                          int index =
                                              educationList.indexOf(item);
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
                        // Experiences
                        Container(
                          margin: const EdgeInsets.only(top: 16, bottom: 8),
                          child: Row(
                            children: [
                              const Text(
                                'Experiences:',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              const Spacer(),
                              if (isEditing)
                                TextButton(
                                  style: TextButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      side: BorderSide(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          width: 1),
                                      foregroundColor: Theme.of(context)
                                          .colorScheme
                                          .primary),
                                  onPressed: () async {
                                    final newExperienceObj =
                                        await openExperienceDialog(null);
                                    if (newExperienceObj == null) return;
                                    if (newExperienceObj['title'] == null ||
                                        newExperienceObj['title'].isEmpty) {
                                      return;
                                    }
                                    if (newExperienceObj['description'] ==
                                            null ||
                                        newExperienceObj['description']
                                            .isEmpty) {
                                      return;
                                    }
                                    if (newExperienceObj['startMonth'] ==
                                            null ||
                                        newExperienceObj['startMonth']
                                            .isEmpty) {
                                      return;
                                    }
                                    if (newExperienceObj['endMonth'] == null ||
                                        newExperienceObj['endMonth'].isEmpty) {
                                      return;
                                    }
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
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600),
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
                            margin: const EdgeInsets.only(bottom: 16),
                            alignment: Alignment.center,
                            child: Text(
                              "No Experience Found",
                              style: TextStyle(
                                fontSize: 16,
                                color: Theme.of(context).colorScheme.tertiary,
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.only(
                                                bottom: 4),
                                            child: Text(
                                              experience['title'].toString(),
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 16),
                                            ),
                                          ),
                                          Text(
                                            '${experience['startMonth']} - ${experience['endMonth']}',
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .tertiary),
                                          )
                                        ],
                                      ),
                                      const Spacer(),
                                      if (isEditing)
                                        IconButton(
                                            onPressed: () async {
                                              int index = experienceList
                                                  .indexOf(experience);
                                              titleController.value =
                                                  titleController.value.copyWith(
                                                      text:
                                                          experienceList[index]
                                                              ['title'],
                                                      selection: TextSelection
                                                          .collapsed(
                                                              offset: experienceList[
                                                                          index]
                                                                      ['title']
                                                                  .length));
                                              startMonthController.value =
                                                  startMonthController.value.copyWith(
                                                      text:
                                                          experienceList[index]
                                                              ['startMonth'],
                                                      selection: TextSelection
                                                          .collapsed(
                                                              offset: experienceList[
                                                                          index]
                                                                      [
                                                                      'startMonth']
                                                                  .length));
                                              endMonthController.value =
                                                  endMonthController.value.copyWith(
                                                      text:
                                                          experienceList[index]
                                                              ['endMonth'],
                                                      selection: TextSelection
                                                          .collapsed(
                                                              offset: experienceList[
                                                                          index]
                                                                      [
                                                                      'endMonth']
                                                                  .length));
                                              await openExperienceDialog(index);
                                            },
                                            icon: const FaIcon(
                                              FontAwesomeIcons.penToSquare,
                                              size: 20,
                                            )),
                                      if (isEditing)
                                        IconButton(
                                            onPressed: () {
                                              int index = experienceList
                                                  .indexOf(experience);
                                              if (index != -1) {
                                                setState(() {
                                                  experienceList
                                                      .removeAt(index);
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
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600),
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
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                ),
                                experience['skillSets'].isEmpty
                                    ? Center(
                                        child: Container(
                                          alignment: Alignment.center,
                                          child: Text(
                                            "No Skillset Found",
                                            style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .tertiary,
                                            ),
                                          ),
                                        ),
                                      )
                                    : Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8, horizontal: 16),
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .tertiary),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(12)),
                                          color: Colors.transparent,
                                        ),
                                        child: Wrap(
                                          spacing: 8,
                                          runSpacing: 4,
                                          children: <Widget>[
                                            ...experience['skillSets']
                                                .map((skillsetId) =>
                                                    skillsetListMap.firstWhere(
                                                                (skillset) =>
                                                                    skillset[
                                                                            'id']
                                                                        .toString() ==
                                                                    skillsetId) !=
                                                            null
                                                        ? Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    right: 4),
                                                            child: Chip(
                                                              shape: const RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              8))),
                                                              label: Text(
                                                                skillsetListMap.firstWhere((skillset) =>
                                                                    skillset[
                                                                            'id']
                                                                        .toString() ==
                                                                    skillsetId)['name'],
                                                                style: TextStyle(
                                                                    color: Theme.of(
                                                                            context)
                                                                        .colorScheme
                                                                        .onPrimary),
                                                              ),
                                                              backgroundColor:
                                                                  Theme.of(
                                                                          context)
                                                                      .colorScheme
                                                                      .primary,
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
                        // Resume & Trascript
                        const Text(
                          'CV (*)',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Stack(
                          children: [
                            if (cvFile == null)
                              Positioned.fill(
                                child: Icon(
                                  Icons.insert_drive_file,
                                  size: 100,
                                  color: Colors
                                      .grey[300], // Adjust color as needed
                                ),
                              ),
                            DottedBorder(
                                borderType: BorderType.RRect,
                                radius: const Radius.circular(8),
                                child: isEditing
                                    ? SizedBox(
                                        width: double.infinity,
                                        height: 100,
                                        child: Center(
                                          child: cvFile == null
                                              ? ElevatedButton(
                                                  onPressed: () =>
                                                      pickFile(true),
                                                  child:
                                                      const Text('Choose File'),
                                                )
                                              : cvFileDetails != null
                                                  ? Container(
                                                      alignment:
                                                          Alignment.center,
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 16,
                                                          vertical: 8),
                                                      child: Row(
                                                        children: [
                                                          Container(
                                                            margin:
                                                                const EdgeInsets
                                                                    .only(
                                                                    left: 8,
                                                                    right: 16),
                                                            child: cvFileDetails!
                                                                        .extension ==
                                                                    "pdf"
                                                                ? const FaIcon(
                                                                    FontAwesomeIcons
                                                                        .filePdf)
                                                                : const FaIcon(
                                                                    FontAwesomeIcons
                                                                        .file),
                                                          ),
                                                          Expanded(
                                                            child: Container(
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                    cvFileDetails!
                                                                        .name,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            16,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                  // Text(cvFileDetails!
                                                                  //         .extension ??
                                                                  //     ''),
                                                                  Text(!cvFileDetails!
                                                                          .size
                                                                          .isNaN
                                                                      ? '${(cvFileDetails!.size / 1024).toStringAsPrecision(3)}MB'
                                                                      : "")
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          Container(
                                                            margin:
                                                                const EdgeInsets
                                                                    .only(
                                                                    left: 16),
                                                            child: IconButton
                                                                .outlined(
                                                                    onPressed:
                                                                        () {
                                                                      setState(
                                                                          () {
                                                                        cvFile =
                                                                            null;
                                                                        cvFileDetails =
                                                                            null;
                                                                      });
                                                                    },
                                                                    icon:
                                                                        FaIcon(
                                                                      FontAwesomeIcons
                                                                          .xmark,
                                                                      color: Colors
                                                                              .red[
                                                                          800]!,
                                                                      size: 20,
                                                                    )),
                                                          )
                                                        ],
                                                      ),
                                                    )
                                                  : Container(),
                                        ),
                                      )
                                    : SizedBox(
                                        width: double.infinity,
                                        height: 100,
                                        child: Center(
                                          child: Container(
                                            alignment: Alignment.center,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16, vertical: 8),
                                            child: Row(
                                              children: [
                                                Container(
                                                  margin: const EdgeInsets.only(
                                                      left: 8, right: 16),
                                                  child: const FaIcon(
                                                      FontAwesomeIcons.file),
                                                ),
                                                Expanded(
                                                  child: Container(
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          viewCVFileName,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: const TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      )),
                          ],
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        const Text(
                          'Transcript (*)',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Stack(
                          children: [
                            if (transcriptFile == null)
                              Positioned.fill(
                                child: Icon(
                                  Icons.insert_drive_file,
                                  size: 100,
                                  color: Colors
                                      .grey[300], // Adjust color as needed
                                ),
                              ),
                            DottedBorder(
                                borderType: BorderType.RRect,
                                radius: const Radius.circular(8),
                                child: isEditing
                                    ? SizedBox(
                                        width: double.infinity,
                                        height: 100,
                                        child: Center(
                                          child: transcriptFile == null
                                              ? ElevatedButton(
                                                  onPressed: () =>
                                                      pickFile(false),
                                                  child:
                                                      const Text('Choose File'),
                                                )
                                              : transcriptFileDetails != null
                                                  ? Container(
                                                      alignment:
                                                          Alignment.center,
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 16,
                                                          vertical: 8),
                                                      child: Row(
                                                        children: [
                                                          Container(
                                                            margin:
                                                                const EdgeInsets
                                                                    .only(
                                                                    left: 8,
                                                                    right: 16),
                                                            child: transcriptFileDetails!
                                                                        .extension ==
                                                                    "pdf"
                                                                ? const FaIcon(
                                                                    FontAwesomeIcons
                                                                        .filePdf)
                                                                : const FaIcon(
                                                                    FontAwesomeIcons
                                                                        .file),
                                                          ),
                                                          Expanded(
                                                            child: Container(
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                    transcriptFileDetails!
                                                                        .name,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            16,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                  Text(!transcriptFileDetails!
                                                                          .size
                                                                          .isNaN
                                                                      ? '${(transcriptFileDetails!.size / 1024).toStringAsPrecision(3)}MB'
                                                                      : "")
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          Container(
                                                            margin:
                                                                const EdgeInsets
                                                                    .only(
                                                                    left: 16),
                                                            child: IconButton
                                                                .outlined(
                                                                    onPressed:
                                                                        () {
                                                                      setState(
                                                                          () {
                                                                        transcriptFile =
                                                                            null;
                                                                        transcriptFileDetails =
                                                                            null;
                                                                      });
                                                                    },
                                                                    icon:
                                                                        FaIcon(
                                                                      FontAwesomeIcons
                                                                          .xmark,
                                                                      color: Colors
                                                                              .red[
                                                                          800]!,
                                                                      size: 20,
                                                                    )),
                                                          )
                                                        ],
                                                      ),
                                                    )
                                                  : Container(),
                                        ),
                                      )
                                    : SizedBox(
                                        width: double.infinity,
                                        height: 100,
                                        child: Center(
                                          child: Container(
                                            alignment: Alignment.center,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16, vertical: 8),
                                            child: Row(
                                              children: [
                                                Container(
                                                  margin: const EdgeInsets.only(
                                                      left: 8, right: 16),
                                                  child: const FaIcon(
                                                      FontAwesomeIcons.file),
                                                ),
                                                Expanded(
                                                  child: Container(
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          viewTranscriptFileName,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: const TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      )),
                          ],
                        ),

                        // Button Edit & Cancel
                        Container(
                            alignment: Alignment.bottomCenter,
                            margin: const EdgeInsets.only(bottom: 16, top: 32),
                            width: double.infinity,
                            child: TextButton(
                              onPressed: () {
                                // Editing
                                if (isEditing) {
                                  if (selectedTechStackId == "" ||
                                      _controller.selectedOptions.isEmpty) {
                                    return;
                                  }
                                  updateProfileData();
                                } else {
                                  setState(() {
                                    isEditing = true;
                                  });
                                }
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
                                    child: Text(
                                      isEditing ? 'Save' : 'Edit',
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  if (isSubmitting)
                                    SpinKitCircle(
                                        size: 20,
                                        duration: Durations.extralong4,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary)
                                ],
                              ),
                            )),
                        if (isEditing)
                          Container(
                              alignment: Alignment.bottomCenter,
                              margin: const EdgeInsets.only(bottom: 8),
                              width: double.infinity,
                              child: TextButton(
                                onPressed: () {
                                  setState(() {
                                    isEditing = false;
                                  });
                                },
                                style: TextButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    side: BorderSide(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        width: 2),
                                    foregroundColor:
                                        Theme.of(context).colorScheme.primary),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      child: const Text(
                                        'Cancel',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                      ])));
  }
}
