import 'package:amp_studenthub/configs/constant.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProjectItem extends StatelessWidget {
  final String jobTitle;
  final String jobDuration;
  final String jobCreatedDate;
  final int jobStudentNeeded;
  final int jobProposalNums;
  final onClick;
  final isSaved;
  const ProjectItem(
      {super.key,
      required this.jobTitle,
      required this.jobDuration,
      required this.jobCreatedDate,
      required this.jobStudentNeeded,
      required this.jobProposalNums,
      required this.onClick,
      required this.isSaved});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: GestureDetector(
        onTap: onClick,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Constant.backgroundColor,
            border: Border.all(color: Colors.grey[500]!),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 16),
                child: Row(
                  children: [
                    Flexible(
                      fit: FlexFit.loose,
                      child: Text(jobTitle,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                              fontSize: 20,
                              color: Constant.primaryColor,
                              fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          margin: EdgeInsets.only(bottom: 16),
                          child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                    width: 20,
                                    height: 20,
                                    margin: EdgeInsets.only(right: 8),
                                    child: FaIcon(FontAwesomeIcons.clock,
                                        size: 16)),
                                Text(
                                  jobDuration,
                                  style: TextStyle(fontSize: 16),
                                ),
                                Container(
                                    width: 20,
                                    height: 20,
                                    margin: EdgeInsets.only(left: 24, right: 8),
                                    child: FaIcon(FontAwesomeIcons.user,
                                        size: 16)),
                                Text(
                                  '${jobStudentNeeded}',
                                  style: TextStyle(fontSize: 16),
                                )
                              ]),
                        ),
                        Container(
                            margin: EdgeInsets.only(bottom: 8),
                            child: Text(
                              "Proposals: ${jobProposalNums}",
                              style: TextStyle(color: Colors.grey[600]),
                            )),
                        Text("Created at $jobCreatedDate",
                            textAlign: TextAlign.left,
                            style: TextStyle(color: Colors.grey[600])),
                      ],
                    ),
                  ),
                  Column(children: [
                    IconButton(
                        splashColor: Constant.primaryColor,
                        style: IconButton.styleFrom(
                            padding: EdgeInsets.all(12),
                            foregroundColor: Constant.textColor,
                            backgroundColor: isSaved
                                ? Constant.primaryColor
                                : Constant.backgroundColor,
                            side: BorderSide(
                                width: 1, color: Constant.primaryColor)),
                        onPressed: () {},
                        icon: Icon(
                            isSaved ? Icons.favorite : Icons.favorite_border,
                            color: isSaved
                                ? Constant.backgroundColor
                                : Constant.primaryColor,
                            size: 24))
                  ])
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
