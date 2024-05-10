import 'package:amp_studenthub/configs/constant.dart';
import 'package:amp_studenthub/models/student_proposal.dart';
import 'package:amp_studenthub/providers/user_provider.dart';
import 'package:amp_studenthub/routes/routes_constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ProposalTab extends StatefulWidget {
  final String projectId;
  const ProposalTab({super.key, required this.projectId});

  @override
  State<ProposalTab> createState() => _ProposalTabState();
}

class _ProposalTabState extends State<ProposalTab> {
  bool isLoading = false;
  bool isSubmitting = false;
  List<Proposal> studentProposals = [];
  final offset = 0;
  final limit = 100;

  Future<void> fetchCompanyProjectProposals() async {
    final dio = Dio();
    try {
      if (mounted) {
        setState(() {
          isLoading = true;
        });
      }
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final accessToken = userProvider.userToken;
      String proposalsEndpoint =
          '${Constant.baseURL}/api/proposal/getByProjectId/${widget.projectId}';
      final Response response = await dio.get(proposalsEndpoint,
          options: Options(headers: {
            'Authorization': 'Bearer $accessToken',
          }),
          queryParameters: {'offset': offset, 'limit': limit});

      final Map<String, dynamic> responseData =
          response.data as Map<String, dynamic>;
      final Map<String, dynamic> result = responseData['result'];
      List<dynamic> listProposalsJson = result['items'];
      List<Proposal> listStudentProposals =
          listProposalsJson.map<Proposal>((e) => Proposal.fromJson(e)).toList();
      if (mounted) {
        setState(() {
          studentProposals = listStudentProposals;
        });
      }
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
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> updateProposalStatusFlag(int statusFlag, int proposalId) async {
    final dio = Dio();
    try {
      if (mounted) {
        setState(() {
          isSubmitting = true;
        });
      }
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final accessToken = userProvider.userToken;
      String updateStatusFlagEndpoint =
          '${Constant.baseURL}/api/proposal/$proposalId';
      await dio.patch(updateStatusFlagEndpoint,
          data: {'statusFlag': statusFlag},
          options: Options(
            headers: {
              'Authorization': 'Bearer $accessToken',
            },
          ));
      if (mounted) {
        Navigator.of(context).pop();
        fetchCompanyProjectProposals();
      }
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
      if (mounted) {
        setState(() {
          isSubmitting = false;
        });
      }
    }
  }

  Future<void> openEducationDialog(String? fullname, int proposalId) =>
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Align(
            alignment: Alignment.center,
            child: Wrap(
              children: [
                Container(
                    decoration: BoxDecoration(
                        color: Constant.backgroundColor,
                        borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 16),
                    margin: const EdgeInsets.all(16),
                    width: double.infinity,
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: const Text(
                            "Hire Offer",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Constant.primaryColor),
                          ),
                        ),
                        Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            child: RichText(
                                text: TextSpan(
                                    style: const TextStyle(
                                      fontSize: 16,
                                      height: 1.6,
                                      color: Constant.textColor,
                                    ),
                                    children: <TextSpan>[
                                  const TextSpan(
                                    text:
                                        'By click on "Confirm" button you will send a hire offer to ',
                                  ),
                                  TextSpan(
                                      text: '$fullname',
                                      style: const TextStyle(
                                          color: Constant.primaryColor,
                                          fontWeight: FontWeight.w500)),
                                  const TextSpan(
                                    text: ' to do this project?',
                                  ),
                                ]))),
                        Row(
                          children: [
                            Expanded(
                              child: TextButton(
                                  style: TextButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(6)),
                                      side: BorderSide(
                                          color: Colors.grey[600]!, width: 1),
                                      foregroundColor: Constant.textColor),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text("Cancel")),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Expanded(
                              child: TextButton(
                                style: TextButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(6)),
                                    backgroundColor: Constant.primaryColor,
                                    foregroundColor: Constant.onPrimaryColor),
                                onPressed: () {
                                  updateProposalStatusFlag(2, proposalId);
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 8),
                                      child: const Text(
                                        'Confirm',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    if (isSubmitting)
                                      const SpinKitCircle(
                                          size: 20,
                                          duration: Durations.extralong4,
                                          color: Constant.onPrimaryColor)
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    )),
              ],
            ),
          );
        },
      );

  @override
  void initState() {
    super.initState();
    fetchCompanyProjectProposals();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            child: isLoading
                ? const Center(
                    child: SpinKitThreeBounce(
                        size: 32,
                        duration: Durations.extralong4,
                        color: Constant.primaryColor))
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                        Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            width: double.infinity,
                            child: Text(
                              'Total Proposals: (${studentProposals.length})',
                              style: const TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: Constant.primaryColor),
                            )),
                        Expanded(
                            // Layout Container Expand All Height
                            child: studentProposals.isEmpty
                                ? Column(
                                    children: [
                                      Container(
                                        alignment: Alignment.center,
                                        child: SvgPicture.asset(
                                          'assets/empty.svg',
                                          height: 320,
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(top: 24),
                                        child: const Text(
                                          "No Proposals Yet",
                                          style: TextStyle(
                                            color: Constant.secondaryColor,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 20,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      )
                                    ],
                                  )
                                : Column(children: [
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Expanded(
                                            child: Container(
                                              child: ListView.builder(
                                                  physics:
                                                      const ClampingScrollPhysics(),
                                                  itemCount:
                                                      studentProposals.length,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    Proposal proposal =
                                                        studentProposals[index];
                                                    return Stack(children: [
                                                      Container(
                                                        margin: const EdgeInsets
                                                            .symmetric(
                                                            vertical: 8),
                                                        child: InkWell(
                                                          onTap: () {
                                                            context.pushNamed(
                                                                RouteConstants
                                                                    .studentProposalDetails,
                                                                pathParameters: {
                                                                  'proposalId':
                                                                      proposal
                                                                          .id
                                                                          .toString()
                                                                });
                                                          },
                                                          child: Container(
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    vertical:
                                                                        12,
                                                                    horizontal:
                                                                        16),
                                                            decoration: BoxDecoration(
                                                                border: Border.all(
                                                                    width: 1,
                                                                    color: Colors
                                                                            .grey[
                                                                        500]!),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8)),
                                                            // Column Layout Of Card
                                                            child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      Container(
                                                                        margin: const EdgeInsets
                                                                            .only(
                                                                            right:
                                                                                16),
                                                                        child:
                                                                            ClipRRect(
                                                                          borderRadius:
                                                                              BorderRadius.circular(12), // Image border
                                                                          child:
                                                                              SizedBox.fromSize(
                                                                            size:
                                                                                const Size.fromRadius(32), // Image radius
                                                                            child:
                                                                                Image.asset('assets/sampleAvatar.png'),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Expanded(
                                                                        child:
                                                                            Column(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            Text(
                                                                              proposal.student?.user['fullname'] ?? "",
                                                                              style: const TextStyle(color: Constant.secondaryColor, fontSize: 16, fontWeight: FontWeight.w600),
                                                                            ),
                                                                            Container(
                                                                              margin: const EdgeInsets.only(top: 4),
                                                                              child: Text(
                                                                                '${proposal.student?.techStack['name'] ?? ""}',
                                                                                textAlign: TextAlign.start,
                                                                                style: const TextStyle(fontSize: 12),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  const Divider(),
                                                                  Row(
                                                                    children: [
                                                                      Expanded(
                                                                        child: TextButton(
                                                                            style: TextButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)), side: BorderSide(color: Colors.grey[600]!, width: 1), foregroundColor: Constant.textColor),
                                                                            onPressed: () {
                                                                              if (proposal.statusFlag == 0) {
                                                                                updateProposalStatusFlag(1, proposal.id);
                                                                                //send MEssage to client
                                                                              }
                                                                              //move to chat details
                                                                              final userProvider = Provider.of<UserProvider>(context, listen: false);
                                                                              final userId = userProvider.userInfo['id'];
                                                                              print("P1 " + userId.toString());
                                                                              print(proposal.student?.userId);
                                                                              print("P3 " + proposal.projectId.toString());

                                                                              GoRouter.of(context).pushNamed(
                                                                                RouteConstants.messageDetail,
                                                                                queryParameters: {
                                                                                  'userId': userId.toString(),
                                                                                  'receiverId': proposal.student?.userId.toString(),
                                                                                  'projectId': proposal.projectId.toString(),
                                                                                  'receiverName': proposal.student?.user['fullname'] ?? 'user',
                                                                                },
                                                                              );
                                                                            },
                                                                            child: const Text("Message")),
                                                                      ),
                                                                      const SizedBox(
                                                                        width:
                                                                            8,
                                                                      ),
                                                                      Expanded(
                                                                        child: TextButton(
                                                                            style: TextButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)), backgroundColor: Constant.primaryColor, foregroundColor: Constant.onPrimaryColor, disabledBackgroundColor: Colors.grey[500], disabledForegroundColor: Constant.onPrimaryColor),
                                                                            onPressed: proposal.statusFlag == 2 || proposal.statusFlag == 3
                                                                                ? null
                                                                                : () {
                                                                                    openEducationDialog(proposal.student?.user['fullname'] ?? "", proposal.id);
                                                                                  },
                                                                            child: Text(proposal.statusFlag == 2
                                                                                ? "Offered"
                                                                                : proposal.statusFlag == 3
                                                                                    ? "Hired"
                                                                                    : "Hire")),
                                                                      )
                                                                    ],
                                                                  )
                                                                ]),
                                                          ),
                                                        ),
                                                      ),
                                                      if (proposal.statusFlag ==
                                                          0)
                                                        Positioned(
                                                            right: 8.0,
                                                            top: 16.0,
                                                            child: Text(
                                                              "(New)",
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  color: Colors
                                                                          .red[
                                                                      700]!),
                                                            )),
                                                    ]);
                                                  }),
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  ])),
                      ])));
  }
}
