import 'package:amp_studenthub/configs/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';

class StudentDashboard extends StatefulWidget {
  const StudentDashboard({super.key});

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard>
    with SingleTickerProviderStateMixin {
  late final TabController tabController;
  List<String> tabHeader = ['All', 'Working', 'Archieved'];

  List<Map<String, dynamic>> activeProposalList = [
    // {
    //   'name': 'Senior frontend Developer (Fintech)',
    //   'lastSubmitted': '3',
    //   'description':
    //       'Students are looking for \n \t\u2022 Clear expectation about your project or deliverables'
    // }
  ];
  List<Map<String, dynamic>> submittedProposalList = [
    {
      'name': 'Senior frontend Developer (Fintech)',
      'lastSubmitted': '3',
      'description':
          'Students are looking for \n \t\u2022 Clear expectation about your project or deliverables'
    },
    {
      'name': 'Senior frontend Developer (Fintech)',
      'lastSubmitted': '3',
      'description':
          'Students are looking for \n \t\u2022 Clear expectation about your project or deliverables'
    }
  ];

  List<Map<String, dynamic>> workingList = [
    {
      'name': 'Senior frontend Developer (Fintech)',
      'lastSubmitted': '3',
      'description':
          'Students are looking for \n \t\u2022 Clear expectation about your project or deliverables'
    }
  ];

  List<Map<String, dynamic>> archivedList = [
    {
      'name': 'Senior frontend Developer (Fintech)',
      'lastSubmitted': '3',
      'description':
          'Students are looking for \n \t\u2022 Clear expectation about your project or deliverables'
    }
  ];

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
                    const Text(
                      'Your Projects',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: Constant.primaryColor,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Constant.backgroundColor,
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
                                      return Constant.primaryColor;
                                    }
                                    return Constant.backgroundColor;
                                  },
                                ),
                                foregroundColor:
                                    MaterialStateProperty.resolveWith<Color>(
                                  (Set<MaterialState> states) {
                                    if (states
                                        .contains(MaterialState.selected)) {
                                      return Constant.onPrimaryColor;
                                    }
                                    return Constant.textColor;
                                  },
                                ),
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12))),
                                textStyle:
                                    const MaterialStatePropertyAll(TextStyle(
                                  fontSize: 16,
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

  final List<Map<String, dynamic>> activeProposalList;
  final List<Map<String, dynamic>> submittedProposalList;

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
                        child: const Text(
                          "Welcome, Quang!\nYour job list is empty",
                          style: TextStyle(
                            color: Constant.secondaryColor,
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
                                project['name'],
                                style: const TextStyle(color: Colors.green),
                              ),
                              Text(
                                'Submitted ${project['lastSubmitted']} ago',
                                style: TextStyle(color: Colors.grey.shade500),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(project['description']),
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
                ...widget.submittedProposalList.asMap().entries.map((entry) {
                  final index = entry.key;
                  final project = entry.value;
                  final isSelected = index == submittedProposalIndex;
                  return InkWell(
                    onTap: () {
                      setState(() {
                        submittedProposalIndex = isSelected ? -1 : index;
                      });
                    },
                    onHover: (isHovering) {
                      setState(() {
                        isHoveredSubmittedList[index] = isHovering;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: isSelected
                            ? Colors.blue.withOpacity(0.1)
                            : isHoveredSubmittedList[index]
                                ? Colors.blue.withOpacity(0.1)
                                : Colors.transparent,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              project['name'],
                              style: const TextStyle(color: Colors.green),
                            ),
                            Text(
                              'Submitted ${project['lastSubmitted']} ago',
                              style: TextStyle(color: Colors.grey.shade500),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(project['description']),
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

  final List<Map<String, dynamic>> projectList;

  @override
  _ProjectContainerState createState() => _ProjectContainerState();
}

class _ProjectContainerState extends State<ProjectContainer> {
  int selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
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
                  project['name'],
                  style: const TextStyle(color: Colors.green),
                ),
                Text(
                  'Submitted ${project['lastSubmitted']} ago',
                  style: TextStyle(color: Colors.grey.shade500),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(project['description']),
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
