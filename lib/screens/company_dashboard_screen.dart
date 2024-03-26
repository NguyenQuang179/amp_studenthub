import 'package:amp_studenthub/configs/constant.dart';
import 'package:amp_studenthub/models/job.dart';
import 'package:amp_studenthub/utilities/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

class CompanyDashboardScreen extends StatefulWidget {
  const CompanyDashboardScreen({super.key});

  @override
  State<CompanyDashboardScreen> createState() => _CompanyDashboardScreenState();
}

class _CompanyDashboardScreenState extends State<CompanyDashboardScreen> {
  Set<DashboardFilterOptions> selectedFilterOptions = {
    DashboardFilterOptions.all
  };

  final List<Job> allJobs = [
    Job('job1', "Front End Job", '1 to 3 months', 2, "Description...",
        '2024-03-19'),
    Job('job2', "Back End Job", '3 to 6 months', 2, "Description...",
        '2024-03-19'),
    Job('job3', "React JS Job", '1 to 3 months', 2, "Description...",
        '2024-03-19'),
    Job('job4', "Nest JS Job", '3 to 6 months', 2, "Description...",
        '2024-03-19'),
    Job('job5', "Data Engineer Job", '1 to 3 months', 2, "Description...",
        '2024-03-19')
  ];

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
        body: SizedBox.expand(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Expanded(
                  // Layout Container Expand All Height
                  child: Column(
                children: [
                  // Title
                  Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 16),
                      child: const Text(
                        "Your Jobs: ",
                        style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w600,
                            color: Constant.primaryColor),
                      )),
                  // Segment Filter Button
                  Container(
                    decoration: const BoxDecoration(
                      color: Constant.backgroundColor,
                    ),
                    child: Row(children: [
                      Expanded(
                        flex: 1,
                        child: SegmentedButton<DashboardFilterOptions>(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) {
                                  if (states.contains(MaterialState.selected)) {
                                    return Constant.primaryColor;
                                  }
                                  return Constant.backgroundColor;
                                },
                              ),
                              foregroundColor:
                                  MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) {
                                  if (states.contains(MaterialState.selected)) {
                                    return Constant.onPrimaryColor;
                                  }
                                  return Constant.textColor;
                                },
                              ),
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12))),
                              textStyle:
                                  const MaterialStatePropertyAll(TextStyle(
                                fontSize: 16,
                              ))),
                          segments: const <ButtonSegment<
                              DashboardFilterOptions>>[
                            ButtonSegment<DashboardFilterOptions>(
                                value: DashboardFilterOptions.all,
                                label: Text("All")),
                            ButtonSegment<DashboardFilterOptions>(
                                value: DashboardFilterOptions.working,
                                label: Text("Working")),
                            ButtonSegment<DashboardFilterOptions>(
                                value: DashboardFilterOptions.archived,
                                label: Text("Archived")),
                          ],
                          selected: selectedFilterOptions,
                          onSelectionChanged:
                              (Set<DashboardFilterOptions> newSelection) {},
                        ),
                      )
                    ]),
                  ),
                  // Render Job List
                  if (allJobs.isEmpty)
                    Expanded(
                      child: Column(
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
                              "Welcome, Quang!\nYour job list is empty",
                              style: TextStyle(
                                color: Constant.secondaryColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 20,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          )
                        ],
                      ),
                    )
                  else
                    Expanded(
                      child: Column(
                        children: [
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 16),
                              child: ListView.builder(
                                  physics: const ClampingScrollPhysics(),
                                  itemCount: allJobs.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    Job job = allJobs[index];
                                    return InkWell(
                                      onTap: () => GoRouter.of(context)
                                          .push('/jobDetails'),
                                      child: Container(
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 8),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8, horizontal: 16),
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                width: 1,
                                                color: Constant.textColor),
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                        // Column Layout Of Card
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          job.title,
                                                          style: const TextStyle(
                                                              color: Constant
                                                                  .secondaryColor,
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                        ),
                                                        Container(
                                                          margin:
                                                              const EdgeInsets
                                                                  .only(top: 4),
                                                          child: Text(
                                                            job.createdAt,
                                                            textAlign:
                                                                TextAlign.start,
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        12),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  IconButton.outlined(
                                                      onPressed: () {
                                                        showModalBottomSheet(
                                                            context: context,
                                                            builder: (context) {
                                                              return Wrap(
                                                                children: [
                                                                  TextButton(
                                                                    onPressed:
                                                                        () {},
                                                                    child:
                                                                        const ListTile(
                                                                      leading: FaIcon(
                                                                          FontAwesomeIcons
                                                                              .solidPenToSquare),
                                                                      title: Text(
                                                                          'Edit Job'),
                                                                    ),
                                                                  ),
                                                                  const Divider(),
                                                                  TextButton(
                                                                    onPressed:
                                                                        () {},
                                                                    child:
                                                                        const ListTile(
                                                                      leading: FaIcon(
                                                                          FontAwesomeIcons
                                                                              .solidTrashCan),
                                                                      title: Text(
                                                                          'Remove Job'),
                                                                    ),
                                                                  ),
                                                                  const Divider(),
                                                                  TextButton(
                                                                    onPressed:
                                                                        () {},
                                                                    child:
                                                                        const ListTile(
                                                                      leading: FaIcon(
                                                                          FontAwesomeIcons
                                                                              .diagramNext),
                                                                      title: Text(
                                                                          'Start Working'),
                                                                    ),
                                                                  ),
                                                                ],
                                                              );
                                                            });
                                                      },
                                                      icon: const FaIcon(
                                                        FontAwesomeIcons
                                                            .ellipsis,
                                                        size: 20,
                                                      ))
                                                ],
                                              ),
                                              const Divider(),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const Text(
                                                    "Description: ",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                  Text(
                                                    job.description,
                                                    textAlign:
                                                        TextAlign.justify,
                                                  )
                                                ],
                                              ),
                                              Container(
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 16),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                        child: Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              right: 8),
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                              width: 1,
                                                              color: Constant
                                                                  .textColor),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8)),
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          vertical: 8,
                                                          horizontal: 8),
                                                      child: const Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            "Proposals:",
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(),
                                                          ),
                                                          Text("1",
                                                              style: TextStyle(
                                                                  fontSize: 20,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600))
                                                        ],
                                                      ),
                                                    )),
                                                    Expanded(
                                                        child: Container(
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                              width: 1,
                                                              color: Constant
                                                                  .textColor),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8)),
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          vertical: 8,
                                                          horizontal: 8),
                                                      child: const Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            "Messages:",
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(),
                                                          ),
                                                          Text("1",
                                                              style: TextStyle(
                                                                  fontSize: 20,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600))
                                                        ],
                                                      ),
                                                    )),
                                                    Expanded(
                                                        child: Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              left: 8),
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                              width: 1,
                                                              color: Constant
                                                                  .textColor),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8)),
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          vertical: 8,
                                                          horizontal: 8),
                                                      child: const Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            "Hired:",
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(),
                                                          ),
                                                          Text("1",
                                                              style: TextStyle(
                                                                  fontSize: 20,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600))
                                                        ],
                                                      ),
                                                    )),
                                                  ],
                                                ),
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
                ],
              )),
              Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  width: double.infinity,
                  height: 48,
                  child: TextButton(
                    onPressed: () => GoRouter.of(context).push('/postJob'),
                    style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        backgroundColor: Constant.primaryColor,
                        foregroundColor: Constant.onPrimaryColor),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(left: 16),
                          child: const Text(
                            'Post new job',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500),
                          ),
                        ),
                        Container(
                            margin: const EdgeInsets.only(left: 16),
                            child: const Icon(Icons.add)),
                      ],
                    ),
                  )),
            ]),
          ),
        ));
  }
}
