import 'package:amp_studenthub/components/button.dart';
import 'package:amp_studenthub/configs/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class StudentProfileInput2 extends StatefulWidget {
  const StudentProfileInput2({super.key});

  @override
  State<StudentProfileInput2> createState() => _StudentProfileInput2State();
}

class _StudentProfileInput2State extends State<StudentProfileInput2> {
  List<Map<String, dynamic>> projectList = [
    {
      'name': 'StudentHub',
      'startTime': '1/2024',
      'endTime': '5/2024',
      'duration': 4,
      'description':
          'It is a project made in the course of Advance Mobile Programming',
      'skillset': ['flutter', 'nodejs'],
    },
    {
      'name': 'StudentHub',
      'startTime': '1/2024',
      'endTime': '5/2024',
      'duration': 4,
      'description':
          'It is a project made in the course of Advance Mobile Programming',
      'skillset': ['flutter', 'nodejs'],
    }
  ];

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
        padding: const EdgeInsets.all(20),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              const Center(
                child: Text(
                  'Experiences',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 10),
                child: Text(
                    'Tell us about your self and you will be on your way connect with real-world project'),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  const Text(
                    'Projects',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  IconButton(
                      onPressed: () {},
                      icon: FaIcon(FontAwesomeIcons.circlePlus))
                ],
              ),
              ...projectList.map((project) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(project['name']),
                          const Spacer(),
                          IconButton(
                              onPressed: () {},
                              icon: FaIcon(
                                FontAwesomeIcons.penToSquare,
                                size: 20,
                              )),
                          IconButton(
                              onPressed: () {},
                              icon: FaIcon(
                                FontAwesomeIcons.trashCan,
                                size: 20,
                              ))
                        ],
                      ),
                      Text(
                        project['startTime'] +
                            " - " +
                            project['endTime'] +
                            ', ' +
                            project['duration'].toString() +
                            ' months',
                        style: TextStyle(color: Colors.black45),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(project['description']),
                      SizedBox(
                        height: 10,
                      ),
                      Text('Skillset'),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding: const EdgeInsets.all(5),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          color: Colors.transparent,
                        ),
                        child: Wrap(
                          spacing: 5,
                          runSpacing: 5,
                          children: <Widget>[
                            ...project['skillset']
                                .map(
                                  (skill) => Padding(
                                    padding: const EdgeInsets.only(right: 5),
                                    child: InputChip(
                                      label: Text(
                                        skill,
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                      onDeleted: () {},
                                      backgroundColor: Colors.lightBlue,
                                      deleteIconColor: Colors.white,
                                    ),
                                  ),
                                )
                                .toList(),
                          ],
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        child: Divider(
                          thickness: 2,
                          color: Colors.black87,
                        ),
                      )
                    ],
                  )),
              Row(
                children: [
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () {},
                    child: Text(
                      'Next',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
