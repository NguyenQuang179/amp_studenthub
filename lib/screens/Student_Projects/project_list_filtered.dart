import 'package:amp_studenthub/components/project_item.dart';
import 'package:amp_studenthub/configs/constant.dart';
import 'package:amp_studenthub/widgets/auth_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class ProjectListFiltered extends StatefulWidget {
  const ProjectListFiltered({super.key});

  @override
  State<ProjectListFiltered> createState() => _ProjectListFilteredState();
}

enum ProjectLength { option1, option2, option3, option4 }

class _ProjectListFilteredState extends State<ProjectListFiltered> {
  onClick(context) {
    GoRouter.of(context).push('/projectDetail');
  }

  ProjectLength? selectedOption = ProjectLength.option1;

  onLengthSelected(value, setState) {
    print('selected');
    setState(() {
      print(selectedOption);
      selectedOption = value;
    });
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
                        onPressed: () => showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            builder: (BuildContext context) {
                              return StatefulBuilder(
                                  builder: (context, setState) {
                                return SingleChildScrollView(
                                    child: Padding(
                                  padding: EdgeInsets.only(
                                      bottom: MediaQuery.of(context)
                                          .viewInsets
                                          .bottom),
                                  child: SizedBox(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20.0),
                                      child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: Text("Filter By",
                                                  style:
                                                      TextStyle(fontSize: 20),
                                                  textAlign: TextAlign.center),
                                            ),
                                            Divider(),
                                            Text(
                                              "Project Length",
                                            ),
                                            RadioListTile<ProjectLength>(
                                              title: Text('Option 1'),
                                              value: ProjectLength.option1,
                                              groupValue: selectedOption,
                                              onChanged: (value) {
                                                onLengthSelected(
                                                    value, setState);
                                              },
                                            ),
                                            RadioListTile<ProjectLength>(
                                              title: Text('Option 2'),
                                              value: ProjectLength.option2,
                                              groupValue: selectedOption,
                                              onChanged: (value) {
                                                onLengthSelected(
                                                    value, setState);
                                              },
                                            ),
                                            RadioListTile<ProjectLength>(
                                                title: Text('Option 3'),
                                                value: ProjectLength.option3,
                                                groupValue: selectedOption,
                                                onChanged: (value) {
                                                  onLengthSelected(
                                                      value, setState);
                                                }),
                                            RadioListTile<ProjectLength>(
                                              title: Text('Option 4'),
                                              value: ProjectLength.option4,
                                              groupValue: selectedOption,
                                              onChanged: (value) {
                                                onLengthSelected(
                                                    value, setState);
                                              },
                                            ),
                                            Text("Student needed"),
                                            TextField(
                                                decoration: new InputDecoration(
                                                    labelText:
                                                        "Enter your number"),
                                                keyboardType:
                                                    TextInputType.number,
                                                inputFormatters: <TextInputFormatter>[
                                                  FilteringTextInputFormatter
                                                      .digitsOnly
                                                ]),
                                            Text("Proposals less than"),
                                            TextField(
                                                decoration: new InputDecoration(
                                                    labelText:
                                                        "Enter your number"),
                                                keyboardType:
                                                    TextInputType.number,
                                                inputFormatters: <TextInputFormatter>[
                                                  FilteringTextInputFormatter
                                                      .digitsOnly
                                                ]),
                                            Container(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(20.0),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: ElevatedButton(
                                                        style: ButtonStyle(
                                                            backgroundColor:
                                                                MaterialStateProperty
                                                                    .all<Color>(
                                                                        Constant
                                                                            .primaryColor),
                                                            foregroundColor:
                                                                MaterialStateProperty
                                                                    .all<Color>(
                                                                        Constant
                                                                            .onPrimaryColor)),
                                                        onPressed: () {},
                                                        child:
                                                            const Text("Apply"),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 16,
                                                    ),
                                                    Expanded(
                                                      child: ElevatedButton(
                                                        style: ButtonStyle(
                                                            backgroundColor:
                                                                MaterialStateProperty
                                                                    .all<Color>(
                                                                        Constant
                                                                            .onPrimaryColor),
                                                            foregroundColor:
                                                                MaterialStateProperty
                                                                    .all<Color>(
                                                                        Constant
                                                                            .primaryColor)),
                                                        onPressed: () =>
                                                            GoRouter.of(context)
                                                                .pop('/'),
                                                        child: const Text(
                                                            "Clear Filter"),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ]),
                                    ),
                                  ),
                                ));
                              });
                            }),
                        icon: const Icon(Icons.filter_alt)),
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
