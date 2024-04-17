import 'package:amp_studenthub/configs/constant.dart';
import 'package:amp_studenthub/providers/company_project_provider.dart';
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

  final List<String> timelineOptions = ['1 to 3 months', '3 to 6 months'];
  String selectedTimelineOption = "1 to 3 months";
  List<Step> getSteps() => [
        Step(
            state: currentStep > 0 ? StepState.complete : StepState.indexed,
            isActive: currentStep >= 0,
            title: const Text(""),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: const Text(
                    "Job Title:",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(),
                  child: RichText(
                    text: const TextSpan(
                        style: TextStyle(
                          fontSize: 16,
                          height: 1.8,
                          color: Constant.textColor,
                        ),
                        children: <TextSpan>[
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
                          fillColor: Constant.onPrimaryColor,
                          hintText: "Enter job title...",
                          labelStyle: TextStyle(color: Colors.grey[600]),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                  color: Constant.secondaryColor, width: 1)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                  color: Constant.secondaryColor, width: 1)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                  color: Constant.secondaryColor, width: 1)))),
                )
              ],
            )),
        Step(
            state: currentStep > 1 ? StepState.complete : StepState.indexed,
            isActive: currentStep >= 1,
            title: const Text(""),
            content: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Scope For Your Job:",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  Container(
                    decoration: const BoxDecoration(),
                    child: RichText(
                      text: const TextSpan(
                          style: TextStyle(
                            fontSize: 16,
                            height: 1.8,
                            color: Constant.textColor,
                          ),
                          children: <TextSpan>[
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
                  ListTile(
                    title: const Text("1 to 3 months"),
                    leading: Radio(
                      groupValue: selectedTimelineOption,
                      value: timelineOptions[0],
                      onChanged: (String? value) {
                        setState(() {
                          selectedTimelineOption = timelineOptions[0];
                        });
                      },
                    ),
                  ),
                  ListTile(
                    title: const Text("3 to 6 months"),
                    leading: Radio(
                      groupValue: selectedTimelineOption,
                      value: timelineOptions[1],
                      onChanged: (String? value) {
                        setState(() {
                          selectedTimelineOption = timelineOptions[1];
                        });
                      },
                    ),
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
                            fillColor: Constant.onPrimaryColor,
                            hintText: "Enter number of student...",
                            labelStyle: TextStyle(color: Colors.grey[600]),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                    color: Constant.secondaryColor, width: 1)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                    color: Constant.secondaryColor, width: 1)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                    color: Constant.secondaryColor,
                                    width: 1)))),
                  ),
                ],
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
                            fillColor: Constant.onPrimaryColor,
                            hintText: "Enter job description...",
                            labelStyle: TextStyle(color: Colors.grey[600]),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                    color: Constant.secondaryColor, width: 1)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                    color: Constant.secondaryColor, width: 1)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                    color: Constant.secondaryColor,
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
                      style: const TextStyle(
                          color: Constant.primaryColor,
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
                          style: const TextStyle(
                              color: Constant.textColor, fontSize: 16),
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
                      style: TextStyle(color: Constant.textColor, fontSize: 16),
                    ),
                  ),
                  Text(descriptionController.text,
                      textAlign: TextAlign.justify,
                      style: const TextStyle(
                          color: Constant.textColor, fontSize: 16))
                ],
              ),
            ))
      ];

  int currentStep = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: BackButton(
            onPressed: () => GoRouter.of(context).pop(),
          ),
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
                      child: const Text(
                        "Post New Job:",
                        style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w600,
                            color: Constant.primaryColor),
                      )),
                  Expanded(
                    child: Container(
                        child: Theme(
                      data: Theme.of(context).copyWith(
                          canvasColor: Constant.backgroundColor,
                          shadowColor: Colors.transparent,
                          colorScheme: const ColorScheme.light(
                              primary: Constant.primaryColor)),
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
                            print('Job Title: ${jobTitleController.text}');
                            print(
                                'Number Of Students: ${numberOfStudentController.text}');
                            print('Description: ${descriptionController.text}');
                            context.read<CompanyProjectProvider>().removeAll();
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
                            // if (step > currentStep) return;
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
                                        backgroundColor: Constant.primaryColor,
                                        foregroundColor:
                                            Constant.onPrimaryColor),
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
                                          side: const BorderSide(
                                              color: Constant.primaryColor,
                                              width: 2),
                                          foregroundColor:
                                              Constant.primaryColor),
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
