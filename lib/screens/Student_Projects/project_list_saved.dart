import 'package:amp_studenthub/components/project_item.dart';
import 'package:amp_studenthub/configs/constant.dart';
import 'package:amp_studenthub/widgets/auth_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProjectListSaved extends StatelessWidget {
  const ProjectListSaved({super.key});
  onClick(context) {
    GoRouter.of(context).push('/projectDetail');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constant.backgroundColor,
      appBar: AuthAppBar(),
      body: SafeArea(
        child: Center(
            child: Column(
          children: [
            Container(
              margin: EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                        onChanged: (value) {},
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                            contentPadding: const EdgeInsets.only(
                                top: 8, left: 16, right: 16),
                            filled: true,
                            fillColor: Constant.onPrimaryColor,
                            prefixIcon: Icon(Icons.search),
                            prefixStyle: TextStyle(),
                            hintText: "Search for job...",
                            labelStyle: TextStyle(color: Colors.grey[600]),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                    color: Colors.grey[500]!, width: 1)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                    color: Colors.grey[500]!, width: 1)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                    color: Colors.grey[500]!, width: 1)))),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 8),
                    child: IconButton(
                        style: IconButton.styleFrom(
                            padding: EdgeInsets.all(12),
                            backgroundColor: Constant.primaryColor,
                            foregroundColor: Constant.onPrimaryColor),
                        onPressed: () => GoRouter.of(context).pop(),
                        icon: const Icon(Icons.arrow_back_rounded)),
                  )
                ],
              ),
            ),
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
