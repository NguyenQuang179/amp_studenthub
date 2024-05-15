import 'dart:developer';

import 'package:amp_studenthub/configs/constant.dart';
import 'package:amp_studenthub/models/project.dart';
import 'package:amp_studenthub/models/proposal.dart';
import 'package:amp_studenthub/providers/user_provider.dart';
import 'package:amp_studenthub/routes/routes_constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class StudentDashboard extends StatefulWidget {
  const StudentDashboard({super.key});

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard>
    with SingleTickerProviderStateMixin {
  late final TabController tabController;
  List<String> tabHeader = ['All', 'Working', 'Archived'];

  List<Project> activeProposalList = [];
  List<Project> submittedProposalList = [];
  List<Project> workingList = [];
  List<Project> archivedList = [];

  final Set<int> selectedSegmentIndex = {0};

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
    tabController.addListener(() {
      setState(() {
        selectedSegmentIndex.clear();
        selectedSegmentIndex.add(tabController.index);
      });
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  didChangeDependencies() async {
    await getProposals(context);
    super.didChangeDependencies();
  }

  Future<void> getProposals(BuildContext context) async {
    final dio = Dio();
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      // Get access token from provider
      final accessToken = userProvider.userToken;
      var studentId = userProvider.userInfo['student']['id'];
      var endpoint = '${Constant.baseURL}/api/proposal/project/$studentId';
      final Response response = await dio.get(
        endpoint,
        options: Options(headers: {
          'Authorization': 'Bearer $accessToken',
        }),
      );

      final Map<String, dynamic> responseData =
          response.data as Map<String, dynamic>;
      final dynamic result = responseData['result'];
      if (result != null) {
        for (var proposal in result) {
          Proposal temp = Proposal.fromJson(proposal);
          log(temp.statusFlag.toString());
          switch (temp.statusFlag) {
            case 0:
              setState(() {
                submittedProposalList.add(temp.project);
              });
              break;
            case 1:
              setState(() {
                activeProposalList.add(temp.project);
              });
              break;
            case 2:
              setState(() {
                activeProposalList.add(temp.project);
              });
              break;
            case 3:
              setState(() {
                workingList.add(temp.project);
              });
              break;
          }
        }
      } else {
        print('User data not found in the response');
      }
    } on DioError catch (e) {
      // Handle Dio errors
      if (e.response != null) {
        final responseData = e.response?.data;
        print(responseData);
      } else {
        print(e.message);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.yourProjects,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.background,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(children: [
                        Expanded(
                          flex: 1,
                          child: SegmentedButton(
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.resolveWith<Color>(
                                  (Set<MaterialState> states) {
                                    if (states
                                        .contains(MaterialState.selected)) {
                                      return Theme.of(context)
                                          .colorScheme
                                          .primary;
                                    }
                                    return Theme.of(context)
                                        .colorScheme
                                        .background;
                                  },
                                ),
                                foregroundColor:
                                    MaterialStateProperty.resolveWith<Color>(
                                  (Set<MaterialState> states) {
                                    if (states
                                        .contains(MaterialState.selected)) {
                                      return Theme.of(context)
                                          .colorScheme
                                          .onPrimary;
                                    }
                                    return Theme.of(context)
                                        .colorScheme
                                        .onBackground;
                                  },
                                ),
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12))),
                                textStyle:
                                    const MaterialStatePropertyAll(TextStyle(
                                  fontSize: 15,
                                ))),
                            segments: tabHeader.map((header) {
                              return ButtonSegment<int>(
                                value: tabHeader.indexOf(header),
                                label: Text(header),
                              );
                            }).toList(),
                            selected: selectedSegmentIndex,
                            onSelectionChanged: (newSelection) {
                              setState(() {
                                selectedSegmentIndex.clear();
                                selectedSegmentIndex.addAll(newSelection);
                                tabController.animateTo(newSelection.first);
                              });
                            },
                          ),
                        ),
                      ]),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Expanded(
                      child: TabBarView(
                        controller: tabController,
                        children: [
                          AllProjectContainer(
                            activeProposalList: activeProposalList,
                            submittedProposalList: submittedProposalList,
                          ),
                          ProjectContainer(projectList: workingList),
                          ProjectContainer(projectList: archivedList),
                        ],
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

class AllProjectContainer extends StatefulWidget {
  const AllProjectContainer({
    super.key,
    required this.activeProposalList,
    required this.submittedProposalList,
  });

  final List<Project> activeProposalList;
  final List<Project> submittedProposalList;

  @override
  State<AllProjectContainer> createState() => _AllProjectContainerState();
}

class _AllProjectContainerState extends State<AllProjectContainer>
    with SingleTickerProviderStateMixin {
  int activeProposalIndex = -1;
  int submittedProposalIndex = -1;
  List<bool> isHoveredSubmittedList = [];
  late final tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    isHoveredSubmittedList = List<bool>.filled(
        widget.submittedProposalList.length, false,
        growable: false);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.black87)),
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Active Proposal (${widget.activeProposalList.length})',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                if (widget.activeProposalList.isEmpty)
                  Column(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        child: SvgPicture.asset(
                          'assets/empty.svg',
                          height: 320,
                          fit: BoxFit.contain,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 24),
                        child: Text(
                          "Your Proposal list is empty",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      )
                    ],
                  )
                else
                  ...widget.activeProposalList.asMap().entries.map((entry) {
                    final index = entry.key;
                    final project = entry.value;
                    final isSelected = index == activeProposalIndex;
                    return InkWell(
                      onTap: () {
                        setState(() {
                          activeProposalIndex = isSelected ? -1 : index;
                        });
                      },
                      onHover: (isHovering) {},
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: isSelected
                              ? Colors.blue.withOpacity(0.1)
                              : Colors.transparent,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                project.title,
                                style: const TextStyle(color: Colors.green),
                              ),
                              Text(
                                'Submitted ${project.createdDate} ago',
                                style: TextStyle(color: Colors.grey.shade500),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(project.description),
                              const Divider(
                                thickness: 2,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.black87)),
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Submitted Proposal (${widget.submittedProposalList.length})',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                if (widget.submittedProposalList.isEmpty)
                  Column(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        child: SvgPicture.asset(
                          'assets/empty.svg',
                          height: 320,
                          fit: BoxFit.contain,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 24),
                        child: Text(
                          "Your Proposal list is empty",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      )
                    ],
                  )
                else
                  ...widget.submittedProposalList.asMap().entries.map((entry) {
                    final index = entry.key;
                    final project = entry.value;
                    final isSelected = index == submittedProposalIndex;
                    return InkWell(
                      onTap: () {
                        setState(() {
                          submittedProposalIndex = isSelected ? -1 : index;
                        });
                        GoRouter.of(context).pushNamed(
                          RouteConstants.projectDetails,
                          queryParameters: {'id': entry.value.id.toString()},
                        );
                      },
                      onHover: (isHovering) {},
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.transparent),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                project.title,
                                style: const TextStyle(color: Colors.green),
                              ),
                              Text(
                                'Submitted ${project.createdDate} ago',
                                style: TextStyle(color: Colors.grey.shade500),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(project.description),
                              const Divider(
                                thickness: 2,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProjectContainer extends StatefulWidget {
  const ProjectContainer({
    super.key,
    required this.projectList,
  });

  final List<Project> projectList;

  @override
  _ProjectContainerState createState() => _ProjectContainerState();
}

class _ProjectContainerState extends State<ProjectContainer> {
  int selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    if (widget.projectList.isEmpty) {
      return Column(
        children: [
          Container(
            alignment: Alignment.center,
            child: SvgPicture.asset(
              'assets/empty.svg',
              height: 320,
              fit: BoxFit.contain,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 24),
            child: Text(
              "Your Project list is empty",
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontWeight: FontWeight.w600,
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
            ),
          )
        ],
      );
    } else {
      return ListView.builder(
        itemCount: widget.projectList.length,
        itemBuilder: (context, index) {
          final project = widget.projectList[index];
          final isSelected = index == selectedIndex;
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedIndex = isSelected ? -1 : index;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.black87),
                color: isSelected
                    ? Colors.blue.withOpacity(0.1)
                    : Colors.transparent,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    project.title,
                    style: const TextStyle(color: Colors.green),
                  ),
                  Text(
                    'Submitted ${project.createdDate} ago',
                    style: TextStyle(color: Colors.grey.shade500),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(project.description),
                  const Divider(
                    thickness: 2,
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
  }
}
