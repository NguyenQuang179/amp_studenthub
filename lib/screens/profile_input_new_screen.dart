import 'package:amp_studenthub/configs/constant.dart';
import 'package:amp_studenthub/screens/input_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ProfileInputNew extends StatefulWidget {
  const ProfileInputNew({super.key});

  @override
  State<ProfileInputNew> createState() => _ProfileInputNewState();
}

class _ProfileInputNewState extends State<ProfileInputNew> {
  Map<String, int> option = {
    'It\'s just me': 1,
    '2-9 employees': 2,
    '10-100 employees': 3,
    '100-1000 employees': 4,
    'More than 1000 employees': 5
  };

  int _selectedOption = 1;
  final companyNameController = TextEditingController();
  final websiteController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Profile",
          style: TextStyle(color: Constant.onPrimaryColor),
        ),
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.arrow_back),
          color: Constant.onPrimaryColor,
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.person),
            color: Constant.onPrimaryColor,
          )
        ],
        backgroundColor: const Color(0xFF3F72AF),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),
            const Center(
              child: Text(
                'Welcome to Student Hub',
                style: TextStyle(
                    fontFamily: 'sans serif',
                    fontWeight: FontWeight.bold,
                    fontSize: 25),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 10),
              child: Text(
                'Tell us about your company and you will be your way connect with high-skilled students',
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontFamily: 'sans serif',
                    fontWeight: FontWeight.normal,
                    fontSize: 18),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 15.0),
              child: Text(
                'How many people are there in your company?',
                style: TextStyle(
                    fontFamily: 'sans serif',
                    fontWeight: FontWeight.normal,
                    fontSize: 18,
                    decoration: TextDecoration.underline),
              ),
            ),
            Column(
              children: option.entries
                  .map(
                    (entry) => GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedOption = entry.value;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.only(top: 5, left: 15, bottom: 10),
                        child: Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(right: 20),
                              height: 20,
                              width: 20,
                              child: Radio(
                                value: entry.value,
                                groupValue: _selectedOption,
                                onChanged: (int? value) {
                                  setState(() {
                                    _selectedOption = value!;
                                  });
                                },
                              ),
                            ),
                            Text(
                              entry.key,
                              style: TextStyle(fontSize: 15),
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 15.0),
              child: Text(
                'Company Name',
                style: TextStyle(
                    fontFamily: 'sans serif',
                    fontWeight: FontWeight.normal,
                    fontSize: 18,
                    decoration: TextDecoration.underline),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
              child: TextField(
                controller: companyNameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Company Name',
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Padding(
              padding: EdgeInsets.only(left: 15.0),
              child: Text(
                'Website',
                style: TextStyle(
                    fontFamily: 'sans serif',
                    fontWeight: FontWeight.normal,
                    fontSize: 18,
                    decoration: TextDecoration.underline),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
              child: TextField(
                controller: websiteController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Website',
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 15.0),
              child: Text(
                'Description',
                style: TextStyle(
                    fontFamily: 'sans serif',
                    fontWeight: FontWeight.normal,
                    fontSize: 18,
                    decoration: TextDecoration.underline),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
              child: TextField(
                controller: descriptionController,
                onTap: () async {
                  final String? newText = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          InputScreen(initialText: descriptionController.text),
                    ),
                  );
                  if (newText != null) {
                    setState(() {
                      descriptionController.text = newText;
                    });
                  }
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Description',
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 15.0),
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.arrow_forward),
                  label: Text('Continue'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
