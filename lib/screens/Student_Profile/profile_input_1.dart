import 'package:amp_studenthub/configs/constant.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class StudentProfileInput1 extends StatefulWidget {
  const StudentProfileInput1({Key? key}) : super(key: key);

  @override
  State<StudentProfileInput1> createState() => _StudentProfileInput1State();
}

class _StudentProfileInput1State extends State<StudentProfileInput1> {
  final List<String> items = [
    'Item1',
    'Item2',
    'Item3',
    'Item4',
    'Item5',
    'Item6',
    'Item7',
    'Item8',
  ];

  final List<String> skillsetList = [
    'C#',
    'C++',
    'Python',
    'Java',
    'JavaScript'
  ];

  final List<Map<String, dynamic>> educationList = [
    {'name': 'HCMUS', 'time': '2020-2024'}
  ];

  final List<String> languageList = ['English'];

  List<String> selectedSkills = [];
  List<String> filteredSkills = [];

  bool isInputting = false;

  FocusNode textFieldFocusNode = FocusNode();
  final skillsetTextController = TextEditingController();

  void _printLatestValue() {
    final text = skillsetTextController.text;
    print('Second text field: $text (${text.characters.length})');
  }

  @override
  void initState() {
    super.initState();
    textFieldFocusNode = FocusNode();
    skillsetTextController.addListener(_printLatestValue);
    filteredSkills = skillsetList;
  }

  @override
  void dispose() {
    textFieldFocusNode.dispose();
    super.dispose();
  }

  void filterSkills(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredSkills =
            List<String>.from(skillsetList); // Create a copy of skillsetList
      });
    } else {
      setState(() {
        filteredSkills = skillsetList
            .where((skill) => skill.toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var selectedValue;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        setState(() {
          isInputting = false;
        });
      },
      child: Scaffold(
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
                    'Welcome to Student Hub',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 10),
                  child: Text(
                      'Tell us about your self and you will be on your way connect with real-world project'),
                ),
                const Text(
                  'Techstack',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                DropdownButtonFormField2<String>(
                  isExpanded: true,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(vertical: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  hint: const Text(
                    'Select Your Techstack',
                    style: TextStyle(fontSize: 14),
                  ),
                  items: items
                      .map((item) => DropdownMenuItem<String>(
                            value: item,
                            child: Text(
                              item,
                              style: const TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ))
                      .toList(),
                  validator: (value) {
                    if (value == null) {
                      return 'Please select techstack.';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    //Do something when selected item is changed.
                  },
                  onSaved: (value) {
                    selectedValue = value.toString();
                  },
                  iconStyleData: const IconStyleData(
                    icon: Icon(
                      Icons.arrow_drop_down,
                      color: Colors.black45,
                    ),
                    iconSize: 24,
                  ),
                  dropdownStyleData: DropdownStyleData(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  menuItemStyleData: const MenuItemStyleData(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  'Skillset',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                Column(children: [
                  GestureDetector(
                    onTap: () {
                      FocusScope.of(context).requestFocus(textFieldFocusNode);
                      setState(() {
                        isInputting = true;
                      });
                    },
                    child: Container(
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
                          ...selectedSkills
                              .map(
                                (skill) => Padding(
                                  padding: const EdgeInsets.only(right: 5),
                                  child: InputChip(
                                    label: Text(
                                      skill,
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                    onDeleted: () {},
                                    backgroundColor: Colors.lightBlue,
                                    deleteIconColor: Colors.white,
                                  ),
                                ),
                              )
                              .toList(),
                          IntrinsicWidth(
                            child: TextField(
                              controller: skillsetTextController,
                              focusNode: textFieldFocusNode,
                              onChanged: (text) {
                                print(text);
                                filterSkills(text);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 3,
                            blurRadius: 7,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: isInputting
                          ? ListView.builder(
                              shrinkWrap: true,
                              itemCount: filteredSkills.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  title: Text(filteredSkills[index]),
                                  onTap: () {
                                    setState(() {
                                      selectedSkills.add(filteredSkills[index]);
                                      skillsetTextController.clear();
                                      filterSkills('');
                                    });
                                  },
                                );
                              },
                            )
                          : const SizedBox()),
                ]),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    const Text(
                      'Language',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    IconButton(
                        onPressed: () {},
                        icon: const FaIcon(
                          FontAwesomeIcons.circlePlus,
                        )),
                    IconButton(
                        onPressed: () {},
                        icon: const FaIcon(
                          FontAwesomeIcons.penToSquare,
                        ))
                  ],
                ),
                ...languageList.map(
                  (item) => Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      item,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    const Text(
                      'Education',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    IconButton(
                        onPressed: () {},
                        icon: const FaIcon(
                          FontAwesomeIcons.circlePlus,
                        )),
                  ],
                ),
                ...educationList.map((item) => Padding(
                      padding: const EdgeInsets.only(left: 20.0, top: 5),
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item['name'],
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(item['time'])
                            ],
                          ),
                          const Spacer(),
                          IconButton(
                              onPressed: () {},
                              icon: FaIcon(FontAwesomeIcons.penToSquare)),
                          IconButton(
                              onPressed: () {},
                              icon: FaIcon(FontAwesomeIcons.trashCan))
                        ],
                      ),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
