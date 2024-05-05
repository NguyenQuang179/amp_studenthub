import 'dart:convert';
import 'dart:developer';

import 'package:amp_studenthub/configs/constant.dart';
import 'package:amp_studenthub/models/company_dashboard_project.dart';
import 'package:amp_studenthub/providers/user_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class JobDetailTab extends StatefulWidget {
  final String projectId;
  const JobDetailTab({super.key, required this.projectId});

  @override
  State<JobDetailTab> createState() => _JobDetailTabState();
}

class _JobDetailTabState extends State<JobDetailTab> {
  bool isLoading = false;
  bool isEditing = false;
  bool isSubmitting = false;
  late CompanyProject projectDetails;

  final jobTitleController = TextEditingController();
  final numberOfStudentController = TextEditingController();
  final descriptionController = TextEditingController();

  final List<String> timelineOptions = [
    'Less than 1 month',
    '1 to 3 months',
    '3 to 6 months',
    'More than 6 month'
  ];
  String selectedTimelineOption = "Less than 1 month";
  int selectedProjectScope = 0;

  Future<void> fetchCompanyProjectDetails() async {
    final dio = Dio();
    try {
      if (mounted) {
        setState(() {
          isLoading = true;
        });
      }
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final accessToken = userProvider.userToken;
      String endpoint = '${Constant.baseURL}/api/project/${widget.projectId}';
      final Response response = await dio.get(
        endpoint,
        options: Options(headers: {
          'Authorization': 'Bearer $accessToken',
        }),
      );

      final Map<String, dynamic> responseData =
          response.data as Map<String, dynamic>;
      final dynamic result = responseData['result'];
      final CompanyProject projectDetailRes = CompanyProject.fromJson(result);
      if (mounted) {
        setState(() {
          projectDetails = projectDetailRes;
          jobTitleController.text = projectDetailRes.title;
          selectedProjectScope = projectDetailRes.projectScopeFlag;
          selectedTimelineOption =
              timelineOptions[projectDetailRes.projectScopeFlag];
          numberOfStudentController.text =
              projectDetailRes.numberOfStudents.toString();
          descriptionController.text = projectDetailRes.description;
        });
      }
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
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> updateProject() async {
    final dio = Dio();
    if (mounted) {
      setState(() {
        isSubmitting = true;
      });
    }
    try {
      String endpoint = '${Constant.baseURL}/api/project/${projectDetails.id}';
      final userProvider = Provider.of<UserProvider>(context, listen: false);

      final accessToken = userProvider.userToken;

      var data = {
        "projectScopeFlag": selectedProjectScope,
        "title": jobTitleController.text,
        "numberOfStudents": int.parse(numberOfStudentController.text),
        "description": descriptionController.text,
        "typeFlag": projectDetails.typeFlag
      };
      print(data);
      final Response response = await dio.patch(endpoint,
          data: jsonEncode(data),
          options: Options(headers: {
            'Authorization': 'Bearer $accessToken',
          }));
      log(response.toString());
      final Map<String, dynamic> responseData =
          response.data as Map<String, dynamic>;
      final dynamic result = responseData['result'];
      final CompanyProject projectDetailRes = CompanyProject.fromJson(result);
      if (mounted) {
        setState(() {
          projectDetails = projectDetailRes;
          jobTitleController.text = projectDetailRes.title;
          selectedProjectScope = projectDetailRes.projectScopeFlag;
          selectedTimelineOption =
              timelineOptions[projectDetailRes.projectScopeFlag];
          numberOfStudentController.text =
              projectDetailRes.numberOfStudents.toString();
          descriptionController.text = projectDetailRes.description;
        });
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
    } finally {
      if (mounted) {
        setState(() {
          isSubmitting = false;
          isEditing = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    fetchCompanyProjectDetails();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        child: Container(
          child: isLoading
              ? SizedBox(
                  height: MediaQuery.of(context).size.height * 0.75,
                  child: const Center(
                      child: SpinKitThreeBounce(
                          size: 32,
                          duration: Durations.extralong4,
                          color: Constant.primaryColor)),
                )
              : isEditing
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                          Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            child: const Text(
                              "Edit Project Details: ",
                              style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                  color: Constant.primaryColor),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            child: const Text(
                              "Title:",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(bottom: 24),
                            child: TextFormField(
                                controller: jobTitleController,
                                decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.only(
                                        top: 8, left: 16, right: 16),
                                    filled: true,
                                    fillColor: Constant.onPrimaryColor,
                                    hintText: "Enter job title...",
                                    labelStyle:
                                        TextStyle(color: Colors.grey[600]),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(
                                            color: Constant.secondaryColor,
                                            width: 1)),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(
                                            color: Constant.secondaryColor,
                                            width: 1)),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(
                                            color: Constant.secondaryColor,
                                            width: 1)))),
                          ),
                          // Step 2
                          Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            child: const Text(
                              "Scope For Your Job:",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              child: const Text(
                                "1. How long will your project take?",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 16),
                              )),
                          Column(
                            children: timelineOptions.map((option) {
                              int index = timelineOptions.indexOf(option);

                              return ListTile(
                                  title: Text(option),
                                  leading: Radio(
                                    groupValue: selectedTimelineOption,
                                    value: timelineOptions[index],
                                    onChanged: (String? value) {
                                      if (mounted) {
                                        setState(() {
                                          selectedTimelineOption =
                                              timelineOptions[index];
                                          selectedProjectScope = index;
                                        });
                                      }
                                    },
                                  ));
                            }).toList(),
                          ),
                          Container(
                              margin: const EdgeInsets.symmetric(vertical: 16),
                              child: const Text(
                                "2. How many student do you want for this project?",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 16),
                              )),
                          Container(
                            margin: const EdgeInsets.only(bottom: 24),
                            child: TextFormField(
                                keyboardType: TextInputType.number,
                                controller: numberOfStudentController,
                                decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.only(
                                        top: 8, left: 16, right: 16),
                                    filled: true,
                                    fillColor: Constant.onPrimaryColor,
                                    hintText: "Enter number of student...",
                                    labelStyle:
                                        TextStyle(color: Colors.grey[600]),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(
                                            color: Constant.secondaryColor,
                                            width: 1)),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(
                                            color: Constant.secondaryColor,
                                            width: 1)),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(
                                            color: Constant.secondaryColor,
                                            width: 1)))),
                          ),
                          // Step 3
                          Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            child: const Text(
                              "Description:",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),

                          Container(
                            margin: const EdgeInsets.only(top: 8, bottom: 32),
                            child: TextFormField(
                                maxLines: 10,
                                controller: descriptionController,
                                decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.only(
                                        top: 16, left: 16, right: 16),
                                    filled: true,
                                    fillColor: Constant.onPrimaryColor,
                                    hintText: "Enter job description...",
                                    labelStyle:
                                        TextStyle(color: Colors.grey[600]),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(
                                            color: Constant.secondaryColor,
                                            width: 1)),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(
                                            color: Constant.secondaryColor,
                                            width: 1)),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(
                                            color: Constant.secondaryColor,
                                            width: 1)))),
                          ),
                          // Save & Cancel Button
                          Column(
                            children: [
                              Container(
                                  margin: const EdgeInsets.only(bottom: 16),
                                  width: double.infinity,
                                  height: 48,
                                  child: TextButton(
                                    onPressed: () {
                                      updateProject();
                                    },
                                    style: TextButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12)),
                                        backgroundColor: Constant.primaryColor,
                                        foregroundColor:
                                            Constant.onPrimaryColor),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 8),
                                          child: const Text(
                                            'Save',
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w500),
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
                              SizedBox(
                                  width: double.infinity,
                                  height: 48,
                                  child: TextButton(
                                    onPressed: () {
                                      if (mounted) {
                                        setState(() {
                                          isEditing = false;
                                          jobTitleController.text =
                                              projectDetails.title;
                                          selectedProjectScope =
                                              projectDetails.projectScopeFlag;
                                          selectedTimelineOption =
                                              timelineOptions[projectDetails
                                                  .projectScopeFlag];
                                          numberOfStudentController.text =
                                              projectDetails.numberOfStudents
                                                  .toString();
                                          descriptionController.text =
                                              projectDetails.description;
                                        });
                                      }
                                    },
                                    style: TextButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12)),
                                        side: const BorderSide(
                                            color: Constant.primaryColor,
                                            width: 2),
                                        foregroundColor: Constant.primaryColor),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                            ],
                          )
                        ])
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          child: Text(
                            projectDetails.title,
                            style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                                color: Constant.primaryColor),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(right: 8),
                                child: const FaIcon(
                                  FontAwesomeIcons.clock,
                                  size: 16,
                                ),
                              ),
                              Text(
                                'Project scope: ${Constant.timelineOptions[projectDetails.projectScopeFlag]}',
                                style: const TextStyle(
                                  color: Constant.textColor,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(right: 8),
                                child: const FaIcon(
                                  FontAwesomeIcons.user,
                                  size: 16,
                                ),
                              ),
                              Text(
                                'Student required: ${projectDetails.numberOfStudents}',
                                style: const TextStyle(
                                    color: Constant.textColor, fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: const Text(
                            "Description: ",
                            style: TextStyle(
                                color: Constant.textColor, fontSize: 16),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(bottom: 32),
                          child: Text(projectDetails.description,
                              textAlign: TextAlign.justify,
                              style: const TextStyle(
                                  color: Constant.textColor, fontSize: 16)),
                        ),
                        Column(
                          children: [
                            Container(
                                margin: const EdgeInsets.only(bottom: 16),
                                width: double.infinity,
                                height: 48,
                                child: TextButton(
                                  onPressed: () {
                                    if (mounted) {
                                      setState(() {
                                        isEditing = true;
                                      });
                                    }
                                  },
                                  style: TextButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                      backgroundColor: Constant.primaryColor,
                                      foregroundColor: Constant.onPrimaryColor),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        child: const Text(
                                          'Edit Project',
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                            SizedBox(
                                width: double.infinity,
                                height: 48,
                                child: TextButton(
                                  onPressed: () {},
                                  style: TextButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                      side: const BorderSide(
                                          color: Constant.primaryColor,
                                          width: 2),
                                      foregroundColor: Constant.primaryColor),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        child: const Text(
                                          'Remove Project',
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                          ],
                        )
                      ],
                    ),
        ),
      ),
    ));
  }
}
