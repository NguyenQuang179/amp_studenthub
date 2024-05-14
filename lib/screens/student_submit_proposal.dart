import 'package:amp_studenthub/configs/constant.dart';
import 'package:amp_studenthub/providers/user_provider.dart';
import 'package:amp_studenthub/routes/routes_constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class StudentSubmitProposal extends StatefulWidget {
  final String projectId;
  const StudentSubmitProposal({super.key, required this.projectId});

  @override
  State<StudentSubmitProposal> createState() =>
      _StudentSubmitProposalState(projectId: projectId);
}

class _StudentSubmitProposalState extends State<StudentSubmitProposal> {
  _StudentSubmitProposalState({required this.projectId});
  TextEditingController? controller;
  FocusNode? focusNode;
  final String projectId;

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

  Future<void> submitProposal() async {
    // Implement submit proposal logic here
    //api request
    final dio = Dio();
    if (controller == null) {
      return;
    }
    if (controller!.text.isEmpty) {
      Fluttertoast.showToast(
        msg: 'Please write a cover letter',
      );
      return;
    }
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final accessToken = userProvider.userToken;

    const endpoint = '${Constant.baseURL}/api/proposal';
    final submitData = {
      "projectId": int.parse(projectId),
      "studentId": userProvider.userInfo['student']?['id'],
      "coverLetter": controller!.text
    };
    print(submitData);
    try {
      final Response response = await dio.post(
        endpoint,
        data: submitData,
        options: Options(headers: {
          'Authorization': 'Bearer $accessToken',
        }),
      );

      final responseData = response.data;
      print(responseData);
      if (responseData['result'] != null) {
        Fluttertoast.showToast(
            msg: "Apply Successfully",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        GoRouter.of(context).goNamed(RouteConstants.companyProject);
      } else {
        Fluttertoast.showToast(
            msg: 'An error occurred',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } catch (error) {
      print(error);
      Fluttertoast.showToast(
          msg: 'An error occurred',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        toolbarHeight: 64,
        title: Text(
          'StudentHub',
          style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            GoRouter.of(context).pop();
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: CircleAvatar(
              radius: 24,
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: IconButton(
                icon: FaIcon(
                  FontAwesomeIcons.user,
                  size: 20,
                  color: Theme.of(context).colorScheme.onPrimary,
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
                  onPressed: () {
                    GoRouter.of(context).pop();
                  },
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
                    // context.goNamed(RouteConstants.company);
                    submitProposal();
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
