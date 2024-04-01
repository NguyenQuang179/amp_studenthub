import 'dart:io';

import 'package:amp_studenthub/configs/constant.dart';
import 'package:amp_studenthub/routes/routes_constants.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

class StudentProfileInput3 extends StatefulWidget {
  const StudentProfileInput3({super.key});

  @override
  State<StudentProfileInput3> createState() => _StudentProfileInput3State();
}

class _StudentProfileInput3State extends State<StudentProfileInput3> {
  File? cvFile;
  File? transcriptFile;

  PlatformFile? cvFileDetails;
  PlatformFile? transcriptFileDetails;

  Future<void> pickFile(bool isCv) async {
    List<String> extensionType = ['doc', 'docx', 'pdf'];
    try {
      FilePickerResult? result = await FilePicker.platform
          .pickFiles(type: FileType.custom, allowedExtensions: extensionType);
      if (result != null) {
        PlatformFile file = result.files.first;
        setState(() {
          if (isCv) {
            cvFile = File(result.files.single.path!);
            cvFileDetails = file;
          } else {
            transcriptFile = File(result.files.single.path!);
            transcriptFileDetails = file;
          }
        });
      } else {
        // User canceled the picker
      }
    } catch (e) {
      print('Error picking file: $e');
    }
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
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    const Center(
                      child: Text(
                        'CV & Resume',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                          'Tell us about your self and you will be on your way connect with real-world project'),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      'CV (*)',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Stack(
                      children: [
                        if (cvFile == null)
                          Positioned.fill(
                            child: Icon(
                              Icons.insert_drive_file,
                              size: 100,
                              color: Colors.grey[300], // Adjust color as needed
                            ),
                          ),
                        DottedBorder(
                          borderType: BorderType.RRect,
                          radius: const Radius.circular(8),
                          child: SizedBox(
                            width: double.infinity,
                            height: 100,
                            child: Center(
                              child: cvFile == null
                                  ? ElevatedButton(
                                      onPressed: () => pickFile(true),
                                      child: const Text('Choose file to Up'),
                                    )
                                  : cvFileDetails != null
                                      ? Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 5),
                                          child: Row(
                                            children: [
                                              Column(
                                                children: [
                                                  Text(
                                                    cvFileDetails!.name,
                                                    style: const TextStyle(
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Text(cvFileDetails!
                                                          .extension ??
                                                      '')
                                                ],
                                              ),
                                              const Spacer(),
                                              Text(cvFileDetails!.size
                                                  .toString())
                                            ],
                                          ),
                                        )
                                      : Container(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    const Text(
                      'Transcript (*)',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Stack(
                      children: [
                        if (transcriptFile == null)
                          Positioned.fill(
                            child: Icon(
                              Icons.insert_drive_file,
                              size: 100,
                              color: Colors.grey[300], // Adjust color as needed
                            ),
                          ),
                        DottedBorder(
                          borderType: BorderType.RRect,
                          radius: const Radius.circular(8),
                          child: SizedBox(
                            width: double.infinity,
                            height: 100,
                            child: Center(
                              child: ElevatedButton(
                                onPressed: () => pickFile(false),
                                child: const Text('Choose file to Up'),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: YourEndWidget(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class YourEndWidget extends StatelessWidget {
  const YourEndWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ElevatedButton(
        onPressed: () {
          context.goNamed(RouteConstants.welcome);
        },
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
        child: const Text(
          'Continue',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
