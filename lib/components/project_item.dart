import 'package:amp_studenthub/configs/constant.dart';
import 'package:flutter/material.dart';

class ProjectItem extends StatelessWidget {
  final String projectDate;
  final String projectPosition;
  final String projectExpectation;
  final String projectDuration;
  final int projectStudentNeeded;
  final int projectProposalNums;

  const ProjectItem(
      {super.key,
      required this.projectDate,
      required this.projectPosition,
      required this.projectExpectation,
      required this.projectDuration,
      required this.projectStudentNeeded,
      required this.projectProposalNums});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Constant.backgroundColor,
          border: Border.all(color: Constant.primaryColor),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 7,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(projectPosition,
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                          fontSize: 20, color: Constant.primaryColor)),
                  Text(
                    "Created $projectDate",
                    textAlign: TextAlign.left,
                  ),
                  Text("Students are expecting:"),
                  Text("- $projectExpectation"),
                  Text("Duration: $projectDuration"),
                  Text("Avaialbe Slots: $projectStudentNeeded Students"),
                  Text("Total Slots: $projectProposalNums Students"),
                ],
              ),
            ),
            Column(children: [
              IconButton(
                  onPressed: () {}, icon: const Icon(Icons.favorite_border))
            ])
          ],
        ),
      ),
    );
  }
}
