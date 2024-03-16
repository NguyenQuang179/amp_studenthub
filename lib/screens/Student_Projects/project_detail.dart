import 'package:amp_studenthub/configs/constant.dart';
import 'package:flutter/material.dart';

class ProjectDetail extends StatelessWidget {
  final String projectDate;
  final String projectPosition;
  final String projectExpectation;
  final String projectDuration;
  final int projectStudentNeeded;
  final int projectProposalNums;

  const ProjectDetail(
      {super.key,
      required this.projectDate,
      required this.projectPosition,
      required this.projectExpectation,
      required this.projectDuration,
      required this.projectStudentNeeded,
      required this.projectProposalNums});

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
              Text(projectPosition,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 30, color: Constant.primaryColor)),
              Divider(
                color: Constant.primaryColor,
              ),
              Text("Students are expecting:"),
              Text("- $projectExpectation"),
              Text("- $projectExpectation"),
              Text("- $projectExpectation"),
              Divider(
                color: Constant.primaryColor,
              ),
              Text("Created:",
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                      fontSize: 20, color: Constant.primaryColor)),
              Text("- $projectDate"),
              Text("Duration:",
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                      fontSize: 20, color: Constant.primaryColor)),
              Text("- $projectDuration"),
              Text("Available Slots:",
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                      fontSize: 20, color: Constant.primaryColor)),
              Text("- $projectStudentNeeded Students"),
              Text("Total Slots:",
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                      fontSize: 20, color: Constant.primaryColor)),
              Text("- $projectProposalNums Students"),
            ],
          ),
        ),
      ),
    );
  }
}
