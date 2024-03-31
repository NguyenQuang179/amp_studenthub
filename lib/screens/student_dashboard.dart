import 'package:amp_studenthub/configs/constant.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class StudentDashboard extends StatefulWidget {
  const StudentDashboard({super.key});

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard>
    with TickerProviderStateMixin {
  late final TabController tabController;
  List<String> tabHeader = ['All Projects', 'Working', 'Archieved'];

  List<Map<String, dynamic>> activeProposalList = [
    {
      'name': 'Senior frontend Developer (Fintech)',
      'lastSubmitted': '3',
      'description':
          'Students are looking for \n \t\u2022 Clear expectation about your project or deliverables'
    }
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

  List<Map<String, dynamic>> archievedList = [
    {
      'name': 'Senior frontend Developer (Fintech)',
      'lastSubmitted': '3',
      'description':
          'Students are looking for \n \t\u2022 Clear expectation about your project or deliverables'
    }
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
                onPressed: () {},
              ),
            ),
          ),
        ],
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Your Projects',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              DefaultTabController(
                length: 3,
                child: Container(
                  height: kToolbarHeight - 8,
                  decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(8)),
                  child: TabBar(
                      controller: tabController,
                      labelColor: Colors.white,
                      indicatorColor: Colors.white,
                      indicatorSize: TabBarIndicatorSize.tab,
                      indicator: BoxDecoration(
                          color: Colors.blue.shade400,
                          borderRadius: BorderRadius.circular(8)),
                      tabs: tabHeader.map<Widget>((tab) {
                        return Text(
                          tab,
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        );
                      }).toList()),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                height: MediaQuery.of(context).size.height,
                child: TabBarView(controller: tabController, children: [
                  AllProjectContainer(
                      activeProposalList: activeProposalList,
                      submittedProposalList: submittedProposalList),
                  ProjectContainer(projectList: workingList),
                  ProjectContainer(projectList: archievedList),
                ]),
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

class _AllProjectContainerState extends State<AllProjectContainer> {
  int activeProposalIndex = -1;
  int submittedProposalIndex = -1;
  List<bool> isHoveredSubmittedList = [];

  @override
  void initState() {
    super.initState();
    // Initialize the list with false values for each item
    isHoveredSubmittedList = List<bool>.filled(
        widget.submittedProposalList.length, false,
        growable: false);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
                  onHover: (isHovering) {
                    // No need to handle hover state for active proposal
                  },
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 300),
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
              }).toList(),
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
              SizedBox(
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
                    duration: Duration(milliseconds: 300),
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
              }).toList(),
            ],
          ),
        ),
      ],
    );
  }
}

class ProjectContainer extends StatefulWidget {
  const ProjectContainer({
    Key? key,
    required this.projectList,
  }) : super(key: key);

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
            duration: Duration(milliseconds: 300),
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
