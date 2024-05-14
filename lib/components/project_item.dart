import 'package:amp_studenthub/configs/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProjectItem extends StatefulWidget {
  final int id;
  final String jobTitle;
  final String jobDuration;
  final String jobCreatedDate;
  final int jobStudentNeeded;
  final int jobProposalNums;
  final onClick;
  final isSaved;
  final favorite;
  const ProjectItem(
      {super.key,
      required this.id,
      required this.jobTitle,
      required this.jobDuration,
      required this.jobCreatedDate,
      required this.jobStudentNeeded,
      required this.jobProposalNums,
      this.onClick,
      required this.favorite,
      this.isSaved});

  @override
  _ProjectItemState createState() => _ProjectItemState(id,
      jobTitle: jobTitle,
      jobDuration: jobDuration,
      jobCreatedDate: jobCreatedDate,
      jobStudentNeeded: jobStudentNeeded,
      jobProposalNums: jobProposalNums,
      onClick: onClick,
      favorite: favorite,
      isSaved: isSaved);
}

class _ProjectItemState extends State<ProjectItem> {
  final int id;
  final String jobTitle;
  final String jobDuration;
  final String jobCreatedDate;
  final int jobStudentNeeded;
  final int jobProposalNums;
  final onClick;
  final favorite;
  final isSaved;
  _ProjectItemState(
    this.id, {
    required this.jobTitle,
    required this.jobDuration,
    required this.jobCreatedDate,
    required this.jobStudentNeeded,
    required this.jobProposalNums,
    required this.onClick,
    required this.isSaved,
    required this.favorite,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: GestureDetector(
        onTap: onClick,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,
            border: Border.all(color: Theme.of(context).colorScheme.tertiary),
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                child: Row(
                  children: [
                    Flexible(
                      fit: FlexFit.loose,
                      child: Text(jobTitle,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 20,
                              color: Theme.of(context).colorScheme.primary,
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
                          margin: const EdgeInsets.only(bottom: 16),
                          child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                    width: 20,
                                    height: 20,
                                    margin: const EdgeInsets.only(right: 8),
                                    child: const FaIcon(FontAwesomeIcons.clock,
                                        size: 16)),
                                Expanded(
                                  child: Text(
                                    jobDuration,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ),
                                Container(
                                    width: 20,
                                    height: 20,
                                    margin: const EdgeInsets.only(
                                        left: 24, right: 8),
                                    child: const FaIcon(FontAwesomeIcons.user,
                                        size: 16)),
                                Expanded(
                                  child: Text(
                                    '$jobStudentNeeded',
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                )
                              ]),
                        ),
                        Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            child: Text(
                              "Proposals: $jobProposalNums",
                              style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.tertiary),
                            )),
                        Text("Created at $jobCreatedDate",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.tertiary)),
                      ],
                    ),
                  ),
                  Column(children: [
                    IconButton(
                        splashColor: Theme.of(context).colorScheme.primary,
                        style: IconButton.styleFrom(
                            padding: const EdgeInsets.all(12),
                            foregroundColor:
                                Theme.of(context).colorScheme.onBackground,
                            backgroundColor: isSaved
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.background,
                            side: BorderSide(
                                width: 1,
                                color: Theme.of(context).colorScheme.primary)),
                        onPressed: () {
                          favorite();
                        },
                        icon: Icon(
                            isSaved ? Icons.favorite : Icons.favorite_border,
                            color: isSaved
                                ? Theme.of(context).colorScheme.background
                                : Theme.of(context).colorScheme.primary,
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
