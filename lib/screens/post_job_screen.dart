import 'dart:convert';
import 'dart:developer';

import 'package:amp_studenthub/configs/constant.dart';
import 'package:amp_studenthub/providers/user_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class PostJobScreen extends StatefulWidget {
  const PostJobScreen({super.key});

  @override
  State<PostJobScreen> createState() => _PostJobScreenState();
}

class _PostJobScreenState extends State<PostJobScreen> {
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
  List<Step> getSteps() => [
        Step(
            state: currentStep > 0 ? StepState.complete : StepState.indexed,
            isActive: currentStep >= 0,
            title: const Text(""),
            content: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: const Text(
                      "Job Title:",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(),
                    child: RichText(
                      text: TextSpan(
                          style: TextStyle(
                            fontSize: 16,
                            height: 1.8,
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                          children: const <TextSpan>[
                            TextSpan(
                                text: "Let's start with a strong name\n",
                                style: TextStyle(fontWeight: FontWeight.w500)),
                            TextSpan(
                                text:
                                    "This helps your post stand out to the right students. It's the first thing they'll see, so make it impressive!")
                          ]),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 16, bottom: 32),
                    child: TextFormField(
                        controller: jobTitleController,
                        decoration: InputDecoration(
                            contentPadding: const EdgeInsets.only(
                                top: 8, left: 16, right: 16),
                            filled: true,
                            fillColor: Theme.of(context).colorScheme.onPrimary,
                            hintText: "Enter job title...",
                            labelStyle: TextStyle(color: Colors.grey[600]),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    width: 1)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    width: 1)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    width: 1)))),
                  ),
                ],
              ),
            )),
        Step(
            state: currentStep > 1 ? StepState.complete : StepState.indexed,
            isActive: currentStep >= 1,
            title: const Text(""),
            content: Container(
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Scope For Your Job:",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                    Container(
                      decoration: const BoxDecoration(),
                      child: RichText(
                        text: TextSpan(
                            style: TextStyle(
                              fontSize: 16,
                              height: 1.8,
                              color: Theme.of(context).colorScheme.onBackground,
                            ),
                            children: const <TextSpan>[
                              TextSpan(
                                  text:
                                      "Estimate the scope for your job. Consider the size of your project and the timeline")
                            ]),
                      ),
                    ),
                    Container(
                        margin: const EdgeInsets.symmetric(vertical: 16),
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
                                setState(() {
                                  selectedTimelineOption =
                                      timelineOptions[index];
                                  selectedProjectScope = index;
                                });
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
                      margin: const EdgeInsets.only(bottom: 32),
                      child: TextFormField(
                          keyboardType: TextInputType.number,
                          controller: numberOfStudentController,
                          decoration: InputDecoration(
                              contentPadding: const EdgeInsets.only(
                                  top: 8, left: 16, right: 16),
                              filled: true,
                              fillColor:
                                  Theme.of(context).colorScheme.onPrimary,
                              hintText: "Enter number of student...",
                              labelStyle: TextStyle(color: Colors.grey[600]),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      width: 1)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      width: 1)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      width: 1)))),
                    ),
                  ],
                ),
              ),
            )),
        Step(
            state: currentStep > 2 ? StepState.complete : StepState.indexed,
            isActive: currentStep >= 2,
            title: const Text(""),
            content: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: const Text(
                      "Job Description:",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: const Text("Students are looking for:")),
                      Container(
                        margin: const EdgeInsets.only(bottom: 8, left: 16),
                        child: const Text(
                            "\u2022 Clear expectation about your project or deliverables."),
                      ),
                      Container(
                          margin: const EdgeInsets.only(bottom: 8, left: 16),
                          child: const Text(
                              "\u2022 The skills required for your project.")),
                      Container(
                          margin: const EdgeInsets.only(bottom: 8, left: 16),
                          child: const Text("\u2022 Detail about your project"))
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 8, bottom: 32),
                    child: TextFormField(
                        maxLines: 5,
                        controller: descriptionController,
                        decoration: InputDecoration(
                            contentPadding: const EdgeInsets.only(
                                top: 16, left: 16, right: 16),
                            filled: true,
                            fillColor: Theme.of(context).colorScheme.onPrimary,
                            hintText: "Enter job description...",
                            labelStyle: TextStyle(color: Colors.grey[600]),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    width: 1)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    width: 1)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    width: 1)))),
                  ),
                ],
              ),
            )),
        Step(
            isActive: currentStep >= 3,
            title: const Text(""),
            content: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: const Text(
                      "Job Details:",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: Text(
                      jobTitleController.text,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 20,
                          fontWeight: FontWeight.w600),
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
                          'Project scope: $selectedTimelineOption',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.onBackground,
                              fontSize: 16),
                        ),
                      ],
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
                            FontAwesomeIcons.user,
                            size: 16,
                          ),
                        ),
                        Text(
                          'Student required: ${numberOfStudentController.text}',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.onBackground,
                              fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      "Description: ",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onBackground,
                          fontSize: 16),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 24),
                    child: Text(descriptionController.text,
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onBackground,
                            fontSize: 16)),
                  )
                ],
              ),
            ))
      ];

  int currentStep = 0;

  Future<void> postNewProject() async {
    final dio = Dio();
    try {
      const endpoint = '${Constant.baseURL}/api/project';
      final userProvider = Provider.of<UserProvider>(context, listen: false);

      final accessToken = userProvider.userToken;
      int companyId = userProvider.userInfo['company']?['id'];

      var data = {
        "companyId": companyId.toString(),
        "projectScopeFlag": selectedProjectScope,
        "title": jobTitleController.text,
        "numberOfStudents": int.parse(numberOfStudentController.text),
        "description": descriptionController.text,
        "typeFlag": 0
      };
      final Response response = await dio.post(endpoint,
          data: jsonEncode(data),
          options: Options(headers: {
            'Authorization': 'Bearer $accessToken',
          }));
      log(response.toString());
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
        appBar: AppBar(
          leading: BackButton(
            onPressed: () => GoRouter.of(context).pop(),
          ),
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
        body: SizedBox.expand(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Expanded(
                  child: Column(
                children: [
                  Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(
                          bottom: 16, left: 24, right: 24),
                      child: Text(
                        "Post New Job:",
                        style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.primary),
                      )),
                  Expanded(
                    child: Container(
                        child: Theme(
                      data: Theme.of(context).copyWith(
                        canvasColor: Theme.of(context).colorScheme.background,
                      ),
                      child: Stepper(
                        elevation: 0,
                        physics: const ClampingScrollPhysics(),
                        type: StepperType.horizontal,
                        steps: getSteps(),
                        currentStep: currentStep,
                        onStepContinue: () {
                          final isLastStep =
                              currentStep == getSteps().length - 1;
                          if (isLastStep) {
                            print("Completed post a job");
                            print({
                              "projectScopeFlag": selectedProjectScope,
                              "title": jobTitleController.text,
                              "numberOfStudents":
                                  numberOfStudentController.text,
                              "description": descriptionController.text,
                              "typeFlag": 0
                            });
                            postNewProject();
                            GoRouter.of(context).pop();
                            return;
                          }
                          setState(() => currentStep += 1);
                        },
                        onStepCancel: currentStep == 0
                            ? null
                            : () {
                                setState(() => currentStep -= 1);
                              },
                        onStepTapped: (step) {
                          setState(() {
                            if (step > currentStep) return;
                            currentStep = step;
                          });
                        },
                        controlsBuilder: (context, details) {
                          final isLastStep =
                              currentStep == getSteps().length - 1;
                          return Column(
                            children: [
                              Container(
                                  margin: const EdgeInsets.only(bottom: 16),
                                  width: double.infinity,
                                  height: 48,
                                  child: TextButton(
                                    onPressed: details.onStepContinue,
                                    style: TextButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12)),
                                        backgroundColor: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        foregroundColor: Theme.of(context)
                                            .colorScheme
                                            .onPrimary),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          child: Text(
                                            (isLastStep ? "Post" : 'Next'),
                                            style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                              if (currentStep > 0)
                                Container(
                                    margin: const EdgeInsets.only(bottom: 16),
                                    width: double.infinity,
                                    height: 48,
                                    child: TextButton(
                                      onPressed: details.onStepCancel,
                                      style: TextButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12)),
                                          side: BorderSide(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              width: 2),
                                          foregroundColor: Theme.of(context)
                                              .colorScheme
                                              .primary),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            child: const Text(
                                              'Back',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )),
                            ],
                          );
                        },
                      ),
                    )),
                  ),
                ],
              )),
            ]),
          ),
        ));
  }
}
