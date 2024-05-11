import 'package:amp_studenthub/configs/constant.dart';
import 'package:amp_studenthub/routes/routes_constants.dart';
import 'package:amp_studenthub/screens/job_details_tabs/detail_tab.dart';
import 'package:amp_studenthub/screens/job_details_tabs/hired_tab.dart';
import 'package:amp_studenthub/screens/job_details_tabs/message_tab.dart';
import 'package:amp_studenthub/screens/job_details_tabs/proposal_tab.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

class JobDetailsScreen extends StatefulWidget {
  final String projectId;
  const JobDetailsScreen({super.key, required this.projectId});

  @override
  State<JobDetailsScreen> createState() => _JobDetailsScreenState();
}

class _JobDetailsScreenState extends State<JobDetailsScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

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
                  onPressed: () {
                    context.pushNamed(RouteConstants.switchAccount);
                  },
                ),
              ),
            ),
          ],
          centerTitle: true,
        ),
        body: Container(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Expanded(
              // Layout Container Expand All Height
              child: Column(children: [
            // Title
            // Container(
            //     width: double.infinity,
            //     margin:
            //         const EdgeInsets.only(bottom: 16, left: 24, right: 24),
            //     child: const Text(
            //       "Project Details",
            //       style: TextStyle(
            //           overflow: TextOverflow.ellipsis,
            //           fontSize: 24,
            //           fontWeight: FontWeight.w600,
            //           color: Constant.primaryColor),
            //     )),
            Container(
              width: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                  color: Constant.backgroundColor,
                  borderRadius: BorderRadius.circular(8)),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    child: TabBar(
                      controller: tabController,
                      indicatorColor: Constant.primaryColor,
                      labelColor: Constant.primaryColor,
                      unselectedLabelColor: Constant.textColor,
                      tabs: const [
                        Tab(
                          text: "Detail",
                        ),
                        Tab(
                          text: "Proposal",
                        ),
                        Tab(
                          text: "Message",
                        ),
                        Tab(
                          text: "Hired",
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Expanded(
                child: TabBarView(controller: tabController, children: [
              JobDetailTab(
                projectId: widget.projectId,
              ),
              ProposalTab(
                projectId: widget.projectId,
              ),
              MessageTab(
                projectId: widget.projectId,
              ),
              HiredTab(
                projectId: widget.projectId,
              )
            ]))
          ]))
        ])));
  }
}
