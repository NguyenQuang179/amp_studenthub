import 'package:amp_studenthub/configs/constant.dart';
import 'package:amp_studenthub/routes/routes_constants.dart';
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
              const Text(
                "Project Detail",
                style: TextStyle(fontSize: 20, color: Constant.secondaryColor),
              ),
              Text(jobTitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 30, color: Constant.primaryColor)),
              const Divider(
                color: Constant.primaryColor,
              ),
              const Text("Students are expecting:"),
              Text("- $jobExpectation"),
              Text("- $jobExpectation"),
              Text("- $jobExpectation"),
              const Divider(
                color: Constant.primaryColor,
              ),
              const Text("Created:",
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 20, color: Constant.primaryColor)),
              Text("- $jobCreatedDate"),
              const Text("Duration:",
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 20, color: Constant.primaryColor)),
              Text("- $jobDuration"),
              const Text("Available Slots:",
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 20, color: Constant.primaryColor)),
              Text("- $jobStudentNeeded Students"),
              const Text("Total Slots:",
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 20, color: Constant.primaryColor)),
              Text("- $jobProposalNums Students"),
              const SizedBox(
                height: 40,
              ),
              // Spacer to create flexible space between items
              const Spacer(),
              // Second item with no flexible space
              Container(
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Constant.primaryColor),
                            foregroundColor: MaterialStateProperty.all<Color>(
                                Constant.onPrimaryColor)),
                        onPressed: () {
                          context.pushNamed(RouteConstants.submitProposal);
                        },
                        child: const Text("Apply"),
                      ),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    Expanded(
                      child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Constant.onPrimaryColor),
                            foregroundColor: MaterialStateProperty.all<Color>(
                                Constant.primaryColor)),
                        onPressed: () {},
                        child: const Text("Save"),
                      ),
                    ),
                    Expanded(
                      child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Constant.onPrimaryColor),
                            foregroundColor: MaterialStateProperty.all<Color>(
                                Constant.primaryColor)),
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
