import 'package:amp_studenthub/components/project_item.dart';
import 'package:amp_studenthub/configs/constant.dart';
import 'package:amp_studenthub/routes/routes_constants.dart';
import 'package:amp_studenthub/widgets/auth_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProjectListSaved extends StatelessWidget {
  const ProjectListSaved({super.key});
  onClick(context) {
    GoRouter.of(context).pushNamed(RouteConstants.projectDetails);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constant.backgroundColor,
      appBar: const AuthAppBar(),
      body: SafeArea(
        child: Center(
            child: Column(
          children: [
            // Title
            Container(
                width: double.infinity,
                margin:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                child: const Text(
                  "Saved Projects: ",
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Constant.primaryColor),
                )),
            Expanded(
                child: ListView.builder(
              itemCount: 5,
              itemBuilder: (BuildContext context, int index) {
                return ProjectItem(
                  jobTitle: 'Front-End Developer (React JS)sssssss',
                  jobCreatedDate: '16/03/2024',
                  jobDuration: '1-3 months',
                  jobStudentNeeded: 5,
                  jobProposalNums: 10,
                  onClick: () => onClick(context),
                  isSaved: true,
                );
              },
            )),
          ],
        )),
      ),
    );
  }
}
