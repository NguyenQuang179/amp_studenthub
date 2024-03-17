import 'package:amp_studenthub/configs/constant.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProjectDetail extends StatelessWidget {
  final String jobTitle;
  final String jobDuration;
  final String jobCreatedDate;
  final int jobStudentNeeded;
  final int jobProposalNums;
  final String jobExpectation;
  const ProjectDetail({
    super.key,
    required this.jobTitle,
    required this.jobDuration,
    required this.jobCreatedDate,
    required this.jobStudentNeeded,
    required this.jobProposalNums,
    required this.jobExpectation,
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constant.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(
                height: 40,
              ),
              Text(
                "Project Detail",
                style: const TextStyle(
                    fontSize: 20, color: Constant.secondaryColor),
              ),
              Text(jobTitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 30, color: Constant.primaryColor)),
              Divider(
                color: Constant.primaryColor,
              ),
              Text("Students are expecting:"),
              Text("- $jobExpectation"),
              Text("- $jobExpectation"),
              Text("- $jobExpectation"),
              Divider(
                color: Constant.primaryColor,
              ),
              Text("Created:",
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                      fontSize: 20, color: Constant.primaryColor)),
              Text("- $jobCreatedDate"),
              Text("Duration:",
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                      fontSize: 20, color: Constant.primaryColor)),
              Text("- $jobDuration"),
              Text("Available Slots:",
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                      fontSize: 20, color: Constant.primaryColor)),
              Text("- $jobStudentNeeded Students"),
              Text("Total Slots:",
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                      fontSize: 20, color: Constant.primaryColor)),
              Text("- $jobProposalNums Students"),
              const SizedBox(
                height: 40,
              ),
              // Spacer to create flexible space between items
              Spacer(),
              // Second item with no flexible space
              Container(
                color: Colors.red,
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        child: const Text("Apply"),
                      ),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        child: const Text("Save"),
                      ),
                    ),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => GoRouter.of(context).pop('/'),
                        child: const Text("Return"),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
