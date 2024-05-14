import 'dart:io';

import 'package:amp_studenthub/configs/constant.dart';
import 'package:amp_studenthub/network/dio.dart';
import 'package:amp_studenthub/providers/user_provider.dart';
import 'package:amp_studenthub/routes/routes_constants.dart';
import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class StudentProfileInput3 extends StatefulWidget {
  const StudentProfileInput3({super.key});

  @override
  State<StudentProfileInput3> createState() => _StudentProfileInput3State();
}

class _StudentProfileInput3State extends State<StudentProfileInput3> {
  bool isSubmitting = false;
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

  Future<void> uploadResumeTranscript() async {
    final dio = Dio();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final accessToken = userProvider.userToken;

    Map<String, String> headers = {
      CONTENT_TYPE: APPLICATION_JSON,
      ACCEPT: APPLICATION_JSON,
      AUTHORIZATION: 'Bearer $accessToken',
      DEFAULT_LANGUAGE: "en"
    };
    dio.options = BaseOptions(
      baseUrl: Constant.baseURL,
      headers: headers,
    );
    try {
      setState(() {
        isSubmitting = true;
      });
      int studentProfileId = userProvider.userInfo['student']['id'];
      print(studentProfileId);
      if (cvFileDetails == null || transcriptFileDetails == null) {
        Fluttertoast.showToast(
            msg: "CV & transcript is required files to update",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 3,
            fontSize: 20.0);
        return;
      }
      // Update Resume
      String updateResumeEndpoint =
          '${Constant.baseURL}/api/profile/student/$studentProfileId/resume';
      FormData resumeFormData = FormData.fromMap({
        "file": await MultipartFile.fromFile(cvFileDetails!.path ?? "",
            filename: cvFileDetails!.name),
      });
      await dio.put(updateResumeEndpoint, data: resumeFormData);
      // Update Transcript
      String updateTranscriptEndpoint =
          '${Constant.baseURL}/api/profile/student/$studentProfileId/transcript';
      FormData transcriptFormData = FormData.fromMap({
        "file": await MultipartFile.fromFile(transcriptFileDetails!.path ?? "",
            filename: transcriptFileDetails!.name),
      });
      await dio.put(updateTranscriptEndpoint, data: transcriptFormData);
      Fluttertoast.showToast(
          msg: "Update CV & Transcript Successfully",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 3,
          fontSize: 20.0);
      if (!mounted) return;
      context.goNamed(RouteConstants.welcome);
    } on DioException catch (e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        print(e.response?.statusCode);
        print(e.response?.data);
        print(e.response?.headers);
        print(e.response?.requestOptions);
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        print(e.requestOptions);
        print(e.message);
      }
    } finally {
      setState(() {
        isSubmitting = false;
      });
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
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(
                      child: Text(
                        'Your Resume',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
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
                                      child: const Text('Choose File'),
                                    )
                                  : cvFileDetails != null
                                      ? Container(
                                          alignment: Alignment.center,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 8),
                                          child: Row(
                                            children: [
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    left: 8, right: 16),
                                                child: cvFileDetails!
                                                            .extension ==
                                                        "pdf"
                                                    ? const FaIcon(
                                                        FontAwesomeIcons
                                                            .filePdf)
                                                    : const FaIcon(
                                                        FontAwesomeIcons.file),
                                              ),
                                              Expanded(
                                                child: Container(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        cvFileDetails!.name,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: const TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      // Text(cvFileDetails!
                                                      //         .extension ??
                                                      //     ''),
                                                      Text(!cvFileDetails!
                                                              .size.isNaN
                                                          ? '${(cvFileDetails!.size / 1024).toStringAsPrecision(3)}MB'
                                                          : "")
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    left: 16),
                                                child: IconButton.outlined(
                                                    onPressed: () {
                                                      setState(() {
                                                        cvFile = null;
                                                        cvFileDetails = null;
                                                      });
                                                    },
                                                    icon: FaIcon(
                                                      FontAwesomeIcons.xmark,
                                                      color: Colors.red[800]!,
                                                      size: 20,
                                                    )),
                                              )
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
                              child: transcriptFile == null
                                  ? ElevatedButton(
                                      onPressed: () => pickFile(false),
                                      child: const Text('Choose File'),
                                    )
                                  : transcriptFileDetails != null
                                      ? Container(
                                          alignment: Alignment.center,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 8),
                                          child: Row(
                                            children: [
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    left: 8, right: 16),
                                                child: transcriptFileDetails!
                                                            .extension ==
                                                        "pdf"
                                                    ? const FaIcon(
                                                        FontAwesomeIcons
                                                            .filePdf)
                                                    : const FaIcon(
                                                        FontAwesomeIcons.file),
                                              ),
                                              Expanded(
                                                child: Container(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        transcriptFileDetails!
                                                            .name,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: const TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      Text(!transcriptFileDetails!
                                                              .size.isNaN
                                                          ? '${(transcriptFileDetails!.size / 1024).toStringAsPrecision(3)}MB'
                                                          : "")
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    left: 16),
                                                child: IconButton.outlined(
                                                    onPressed: () {
                                                      setState(() {
                                                        transcriptFile = null;
                                                        transcriptFileDetails =
                                                            null;
                                                      });
                                                    },
                                                    icon: FaIcon(
                                                      FontAwesomeIcons.xmark,
                                                      color: Colors.red[800]!,
                                                      size: 20,
                                                    )),
                                              )
                                            ],
                                          ),
                                        )
                                      : Container(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                        alignment: Alignment.bottomCenter,
                        margin: const EdgeInsets.only(bottom: 16, top: 32),
                        width: double.infinity,
                        child: TextButton(
                          onPressed: () {
                            uploadResumeTranscript();
                          },
                          style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                              foregroundColor:
                                  Theme.of(context).colorScheme.onPrimary),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(right: 8),
                                child: const Text(
                                  'Update',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              if (isSubmitting)
                                SpinKitCircle(
                                    size: 20,
                                    duration: Durations.extralong4,
                                    color:
                                        Theme.of(context).colorScheme.onPrimary)
                            ],
                          ),
                        )),
                    Container(
                        alignment: Alignment.bottomCenter,
                        margin: const EdgeInsets.only(bottom: 8),
                        width: double.infinity,
                        child: TextButton(
                          onPressed: () {
                            context.goNamed(RouteConstants.welcome);
                          },
                          style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              side: BorderSide(
                                  color: Theme.of(context).colorScheme.primary,
                                  width: 2),
                              foregroundColor:
                                  Theme.of(context).colorScheme.primary),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                child: const Text(
                                  'Skip',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ],
                          ),
                        )),
                    Center(
                      child: Text(
                        "You can update this in your student profile later",
                        style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).colorScheme.tertiary,
                            fontStyle: FontStyle.italic),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
