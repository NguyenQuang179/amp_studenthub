import 'package:amp_studenthub/configs/constant.dart';
import 'package:amp_studenthub/models/student_proposal.dart';
import 'package:amp_studenthub/network/dio.dart';
import 'package:amp_studenthub/providers/user_provider.dart';
import 'package:amp_studenthub/widgets/auth_app_bar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class StudentProposalDetails extends StatefulWidget {
  final String proposalId;
  const StudentProposalDetails({super.key, required this.proposalId});

  @override
  State<StudentProposalDetails> createState() => _StudentProposalDetailsState();
}

class _StudentProposalDetailsState extends State<StudentProposalDetails> {
  bool isLoading = false;
  Proposal? proposalDetails;

  Future<void> getInitData() async {
    final dio = Dio();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    String accessToken = userProvider.userToken;

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
        isLoading = true;
      });
      // Get proposalDetails details
      String endpoint = '${Constant.baseURL}/api/proposal/${widget.proposalId}';
      final Response response = await dio.get(endpoint);
      final dynamic resData = response.data;
      final jsonData = resData['result'];
      print(jsonData);
      final proposal = Proposal.fromJson(jsonData);
      if (mounted) {
        setState(() {
          proposalDetails = proposal;
        });
      }
    } on DioException catch (e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
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
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getInitData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const AuthAppBar(),
        body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            physics: const ClampingScrollPhysics(),
            child: isLoading
                ? SizedBox(
                    height: MediaQuery.of(context).size.height * 0.75,
                    child: const Center(
                        child: SpinKitThreeBounce(
                            size: 32,
                            duration: Durations.extralong4,
                            color: Constant.primaryColor)),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        Container(
                            width: double.infinity,
                            margin: const EdgeInsets.only(bottom: 24),
                            child: const Text(
                              "Proposal Details: ",
                              style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                  color: Constant.primaryColor),
                            )),
                        Container(
                          alignment: AlignmentDirectional.center,
                          margin: const EdgeInsets.only(bottom: 16),
                          child: ClipRRect(
                            borderRadius:
                                BorderRadius.circular(100), // Image border
                            child: SizedBox.fromSize(
                              size: const Size.fromRadius(52), // Image radius
                              child: Image.asset('assets/sampleAvatar.png'),
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      proposalDetails
                                              ?.student?.user['fullname'] ??
                                          "",
                                      style: const TextStyle(
                                          color: Constant.primaryColor,
                                          fontSize: 24,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(top: 8),
                                      child: Text(
                                        '${proposalDetails?.student?.techStack['name'] ?? ""}',
                                        textAlign: TextAlign.start,
                                        style: const TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(top: 8),
                                      child: Text(
                                        '${proposalDetails?.student?.user['email'] ?? ""}',
                                        textAlign: TextAlign.start,
                                        style: const TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Divider(),
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: const Row(
                            children: [
                              Text(
                                'Cover Letter:',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          child: Row(
                            children: [
                              Text(
                                proposalDetails?.coverLetter ?? "",
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          child: Row(
                            children: [
                              const Text(
                                'Techstack: ',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              Text(
                                proposalDetails?.student?.techStack['name'] ??
                                    "",
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: const Row(
                            children: [
                              Text(
                                'Skillsets:',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                        proposalDetails?.student?.skillSets != null &&
                                proposalDetails!.student!.skillSets.isEmpty
                            ? Center(
                                child: Container(
                                  alignment: Alignment.center,
                                  child: Text(
                                    "No Skillset Found",
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ),
                              )
                            : Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 16),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey[600]!),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(12)),
                                  color: Colors.transparent,
                                ),
                                child: Wrap(
                                  spacing: 8,
                                  runSpacing: 4,
                                  children: <Widget>[
                                    ...proposalDetails!.student!.skillSets.map(
                                        (skillset) => skillset['name'] != null
                                            ? Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 4),
                                                child: Chip(
                                                  shape:
                                                      const RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          8))),
                                                  label: Text(
                                                    skillset['name'],
                                                    style: const TextStyle(
                                                        color: Constant
                                                            .onPrimaryColor),
                                                  ),
                                                  backgroundColor:
                                                      Constant.primaryColor,
                                                ),
                                              )
                                            : Container()),
                                  ],
                                ),
                              ),
                        Container(
                          margin: const EdgeInsets.only(top: 16, bottom: 8),
                          child: const Row(
                            children: [
                              Text(
                                'Language:',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              Spacer(),
                            ],
                          ),
                        ),
                        if (proposalDetails!.student!.languages.isEmpty)
                          Container(
                            alignment: Alignment.center,
                            child: Text(
                              "No Language Found",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                        ...proposalDetails!.student!.languages.map(
                          (item) => Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 0),
                            child: Column(children: [
                              Row(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin:
                                            const EdgeInsets.only(bottom: 8),
                                        child: Text(
                                          item['languageName'].toString(),
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16),
                                        ),
                                      ),
                                      Text('Level: ${item['level']}')
                                    ],
                                  ),
                                  const Spacer(),
                                ],
                              ),
                              const Divider()
                            ]),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 16, bottom: 8),
                          child: const Row(
                            children: [
                              Text(
                                'Education:',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              Spacer(),
                            ],
                          ),
                        ),
                        if (proposalDetails!.student!.educations.isEmpty)
                          Container(
                            alignment: Alignment.center,
                            child: Text(
                              "No Education Found",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                        ...proposalDetails!.student!.educations.map(
                          (item) => Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 0),
                            child: Column(children: [
                              Row(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin:
                                            const EdgeInsets.only(bottom: 8),
                                        child: Text(
                                          item['schoolName'].toString(),
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16),
                                        ),
                                      ),
                                      Text(
                                          '${item['startYear']}-${item['endYear']}')
                                    ],
                                  ),
                                  const Spacer(),
                                ],
                              ),
                              const Divider()
                            ]),
                          ),
                        ),
                      ])));
  }
}
