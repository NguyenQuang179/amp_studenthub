import 'package:amp_studenthub/configs/constant.dart';
import 'package:amp_studenthub/models/student_proposal.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProposalTab extends StatefulWidget {
  const ProposalTab({super.key});

  @override
  State<ProposalTab> createState() => _ProposalTabState();
}

class _ProposalTabState extends State<ProposalTab> {
  final List<StudentProposal> studentProposals = [
    StudentProposal(
        'student1',
        "Quang Nguyen",
        'Frontend Engineer',
        3,
        "Excellent",
        'I have gone through your project and it seem like a great project. I will commit for your project...'),
    StudentProposal('student2', "Huy Truong", 'Backend Engineer', 3, "Good",
        'I have gone through your project and it seem like a great project. I will commit for your project...'),
    StudentProposal(
        'student3',
        "Nien Nguyen",
        'Fullstack Engineer',
        3,
        "Excellent",
        'I have gone through your project and it seem like a great project. I will commit for your project...'),
    StudentProposal('student4', "Lam Ha", 'Software Engineer', 4, "Good",
        'I have gone through your project and it seem like a great project. I will commit for your project...'),
    StudentProposal('student5', "Minmin", 'Software Engineer', 4, "Excellent",
        'I have gone through your project and it seem like a great project. I will commit for your project...')
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Expanded(
                  // Layout Container Expand All Height
                  child: Column(children: [
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: Container(
                          child: ListView.builder(
                              physics: const ClampingScrollPhysics(),
                              itemCount: studentProposals.length,
                              itemBuilder: (BuildContext context, int index) {
                                StudentProposal proposal =
                                    studentProposals[index];
                                return InkWell(
                                  onTap: () =>
                                      GoRouter.of(context).push('/jobDetails'),
                                  child: Container(
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 8),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12, horizontal: 16),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 1, color: Colors.grey[500]!),
                                        borderRadius: BorderRadius.circular(8)),
                                    // Column Layout Of Card
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    right: 16),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12), // Image border
                                                  child: SizedBox.fromSize(
                                                    size: const Size.fromRadius(
                                                        32), // Image radius
                                                    child: Image.asset(
                                                        'assets/sampleAvatar.png'),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      proposal.name,
                                                      style: const TextStyle(
                                                          color: Constant
                                                              .secondaryColor,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                    Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              top: 4),
                                                      child: Text(
                                                        '${proposal.studentYear}th year student',
                                                        textAlign:
                                                            TextAlign.start,
                                                        style: const TextStyle(
                                                            fontSize: 12),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          const Divider(),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(proposal.jobPosition),
                                              Text(proposal.studentGrade)
                                            ],
                                          ),
                                          Container(
                                            margin: const EdgeInsets.only(
                                                top: 8, bottom: 16),
                                            child: Text(
                                              proposal.proposal,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: TextButton(
                                                    style: TextButton.styleFrom(
                                                        shape:
                                                            RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            6)),
                                                        side: BorderSide(
                                                            color: Colors
                                                                .grey[600]!,
                                                            width: 1),
                                                        foregroundColor:
                                                            Constant.textColor),
                                                    onPressed: () {},
                                                    child:
                                                        const Text("Message")),
                                              ),
                                              const SizedBox(
                                                width: 8,
                                              ),
                                              Expanded(
                                                child: TextButton(
                                                    style: TextButton.styleFrom(
                                                        shape:
                                                            RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            6)),
                                                        backgroundColor:
                                                            Constant
                                                                .primaryColor,
                                                        foregroundColor: Constant
                                                            .onPrimaryColor),
                                                    onPressed: () {
                                                      showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return Align(
                                                            alignment: Alignment
                                                                .center,
                                                            child: Wrap(
                                                              children: [
                                                                Container(
                                                                    decoration: BoxDecoration(
                                                                        color: Constant
                                                                            .backgroundColor,
                                                                        borderRadius:
                                                                            BorderRadius
                                                                                .circular(
                                                                                    12)),
                                                                    padding: const EdgeInsets
                                                                        .symmetric(
                                                                        vertical:
                                                                            16,
                                                                        horizontal:
                                                                            16),
                                                                    margin:
                                                                        const EdgeInsets
                                                                            .all(
                                                                            16),
                                                                    width: double
                                                                        .infinity,
                                                                    child:
                                                                        Column(
                                                                      children: [
                                                                        Container(
                                                                          margin: const EdgeInsets
                                                                              .only(
                                                                              bottom: 8),
                                                                          child:
                                                                              const Text(
                                                                            "Hire Offer",
                                                                            style: TextStyle(
                                                                                fontSize: 20,
                                                                                fontWeight: FontWeight.w600,
                                                                                color: Constant.primaryColor),
                                                                          ),
                                                                        ),
                                                                        Container(
                                                                          margin: const EdgeInsets
                                                                              .only(
                                                                              bottom: 16),
                                                                          child:
                                                                              const Text(
                                                                            "Do you really want to send hired offer to <this student> to do this project?",
                                                                            style:
                                                                                TextStyle(
                                                                              fontSize: 16,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Row(
                                                                          children: [
                                                                            Expanded(
                                                                              child: TextButton(style: TextButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)), side: BorderSide(color: Colors.grey[600]!, width: 1), foregroundColor: Constant.textColor), onPressed: () {}, child: const Text("Cancel")),
                                                                            ),
                                                                            const SizedBox(
                                                                              width: 8,
                                                                            ),
                                                                            Expanded(
                                                                              child: TextButton(style: TextButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)), backgroundColor: Constant.primaryColor, foregroundColor: Constant.onPrimaryColor), onPressed: () {}, child: const Text("Send Offer")),
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
                                                    },
                                                    child: const Text("Hired")),
                                              )
                                            ],
                                          )
                                        ]),
                                  ),
                                );
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
