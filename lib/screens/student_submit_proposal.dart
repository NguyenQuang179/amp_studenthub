import 'package:amp_studenthub/configs/constant.dart';
import 'package:amp_studenthub/routes/routes_constants.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

class StudentSubmitProposal extends StatefulWidget {
  const StudentSubmitProposal({super.key});

  @override
  State<StudentSubmitProposal> createState() => _StudentSubmitProposalState();
}

class _StudentSubmitProposalState extends State<StudentSubmitProposal> {
  TextEditingController? controller;
  FocusNode? focusNode;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
    focusNode = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {},
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Cover letter',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Describe why do you fit for this project',
            ),
            const SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () {
                focusNode?.requestFocus();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SingleChildScrollView(
                  child: TextField(
                    focusNode: focusNode, // Assign the focus node
                    controller: controller,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                    ),
                    maxLines: null,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            OverflowBar(
              alignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  child: const SizedBox(
                      width: 130, child: Center(child: Text('Cancel'))),
                ),
                ElevatedButton(
                  onPressed: () {
                    context.goNamed(RouteConstants.company);
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  child: const SizedBox(
                      width: 130,
                      child: Center(child: Text('Submit Proposal'))),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
