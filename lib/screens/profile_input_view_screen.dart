import 'package:amp_studenthub/configs/constant.dart';
import 'package:flutter/material.dart';

class ProfileInputView extends StatefulWidget {
  const ProfileInputView({super.key});

  @override
  State<ProfileInputView> createState() => _ProfileInputViewState();
}

class _ProfileInputViewState extends State<ProfileInputView> {
  var option = 'It\'s just me';

  var companyName = 'Nizo';
  var website = 'abc.com';
  var description = 'This is a company';

  @override
  void initState() {
    super.initState();
  }

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
            Container(
              padding: EdgeInsets.only(top: 5, left: 15, bottom: 10),
              child: Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(right: 20),
                    height: 20,
                    width: 20,
                    child: const Radio(
                      value: 1,
                      groupValue: 1,
                      onChanged: null,
                    ),
                  ),
                  Text(
                    option,
                    style: TextStyle(fontSize: 15),
                  )
                ],
              ),
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
            Container(
              width: double.infinity,
              height: 50,
              margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  companyName,
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 16),
                ),
              ),
              decoration: BoxDecoration(
                  border: Border.all(color: Color(0xFF3F72AF), width: 2)),
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
            Container(
              width: double.infinity,
              height: 50,
              margin: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
              decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFF3F72AF), width: 2)),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  website,
                  textAlign: TextAlign.left,
                  style: const TextStyle(fontSize: 16),
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
            Container(
              width: double.infinity,
              height: 50,
              margin: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
              decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFF3F72AF), width: 2)),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  website,
                  textAlign: TextAlign.left,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 0.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              width: 130,
              margin: EdgeInsets.only(right: 10),
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: Icon(Icons.edit),
                label: Text('Edit'),
              ),
            ),
            Container(
              width: 130,
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: Icon(Icons.cancel),
                label: Text('Cancel'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
