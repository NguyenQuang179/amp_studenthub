import 'package:amp_studenthub/configs/constant.dart';
import 'package:amp_studenthub/providers/user_provider.dart';
import 'package:amp_studenthub/routes/routes_constants.dart';
import 'package:amp_studenthub/utilities/constant.dart';
import 'package:amp_studenthub/utilities/local_storage.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/company_dashboard_project.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CompanyDashboardScreen extends StatefulWidget {
  const CompanyDashboardScreen({super.key});

  @override
  State<CompanyDashboardScreen> createState() => _CompanyDashboardScreenState();
}

class _CompanyDashboardScreenState extends State<CompanyDashboardScreen> {
  bool isLoading = false;
  List<CompanyProject> allCompanyProjects = [];

  Set<DashboardFilterOptions> selectedFilterOptions = {
    DashboardFilterOptions.all
  };

  Future<void> fetchCompanyProjects(int? typeFlag) async {
    final dio = Dio();
    String? value =
        LocalStorage.instance.getString(key: StorageKey.accessToken);
    print('Local storage: $value');
    try {
      if (mounted) {
        setState(() {
          isLoading = true;
        });
      }
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final accessToken = userProvider.userToken;
      int companyId = userProvider.userInfo['company']?['id'];
      String endpoint = '${Constant.baseURL}/api/project/company/$companyId';
      final Response response = await dio.get(
        endpoint,
        queryParameters: typeFlag != null ? {"typeFlag": typeFlag} : {},
        options: Options(headers: {
          'Authorization': 'Bearer $accessToken',
        }),
      );

      final Map<String, dynamic> responseData =
          response.data as Map<String, dynamic>;
      final List<dynamic> result = responseData['result'];
      List<CompanyProject> companyList = [];
      for (var project in result) {
        CompanyProject companyProject = CompanyProject.fromJson(project);
        print(companyProject.companyId);
        companyList.add(companyProject);
      }
      print(companyList.length);
      if (mounted) {
        setState(() {
          allCompanyProjects = companyList;
        });
      }
    } on DioException catch (e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        if (e.response?.statusCode == 404) {
          if (mounted) {
            setState(() {
              allCompanyProjects = [];
            });
          }
        }
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

  Future<void> removeCompanyProject(int projectId) async {
    final dio = Dio();
    try {
      if (mounted) {
        setState(() {
          isLoading = true;
        });
      }
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final accessToken = userProvider.userToken;
      String endpoint = '${Constant.baseURL}/api/project/$projectId';
      await dio.delete(
        endpoint,
        options: Options(headers: {
          'Authorization': 'Bearer $accessToken',
        }),
      );
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

  Future<void> updateCompanyProjectTypeFlag(
      int typeFlag, int projectId, int numberOfStudents) async {
    final dio = Dio();
    try {
      if (mounted) {
        setState(() {
          isLoading = true;
        });
      }
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final accessToken = userProvider.userToken;
      String endpoint = '${Constant.baseURL}/api/project/$projectId';
      await dio.patch(endpoint,
          options: Options(headers: {
            'Authorization': 'Bearer $accessToken',
          }),
          data: {"numberOfStudents": numberOfStudents, "typeFlag": typeFlag});
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

  handleRemoveProject(int projectId) {
    removeCompanyProject(projectId);
    int? typeFlag;
    if (selectedFilterOptions.single == DashboardFilterOptions.working) {
      typeFlag = 1;
    } else if (selectedFilterOptions.single ==
        DashboardFilterOptions.archived) {
      typeFlag = 2;
    }
    fetchCompanyProjects(typeFlag);
    Navigator.pop(context);
  }

  handleUpdateProjectTypeFlag(
      int typeFlag, int projectId, int numberOfStudents) {
    updateCompanyProjectTypeFlag(typeFlag, projectId, numberOfStudents);
    int? viewTypeFlag;
    if (selectedFilterOptions.single == DashboardFilterOptions.working) {
      viewTypeFlag = Constant.projectTypeFlag['working'];
    } else if (selectedFilterOptions.single ==
        DashboardFilterOptions.archived) {
      viewTypeFlag = Constant.projectTypeFlag['archived'];
    }
    fetchCompanyProjects(viewTypeFlag);
    Fluttertoast.showToast(
        msg: 'Update Project Successfully',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 3,
        fontSize: 20.0);
    Navigator.pop(context);
  }

  refreshProjectList() {
    int? typeFlag;
    if (selectedFilterOptions.single == DashboardFilterOptions.working) {
      typeFlag = 1;
    } else if (selectedFilterOptions.single ==
        DashboardFilterOptions.archived) {
      typeFlag = 2;
    }
    fetchCompanyProjects(typeFlag);
  }

  @override
  void initState() {
    super.initState();
    fetchCompanyProjects(null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SizedBox.expand(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Expanded(
              // Layout Container Expand All Height
              child: Column(
            children: [
              // Title
              Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Text(
                    AppLocalizations.of(context)!.yourProjects,
                    style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.primary),
                  )),
              // Segment Filter Button
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.background,
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
                                return Theme.of(context).colorScheme.primary;
                              }
                              return Theme.of(context).colorScheme.background;
                            },
                          ),
                          foregroundColor:
                              MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                              if (states.contains(MaterialState.selected)) {
                                return Theme.of(context).colorScheme.onPrimary;
                              }
                              return Theme.of(context).colorScheme.onBackground;
                            },
                          ),
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12))),
                          textStyle: const MaterialStatePropertyAll(TextStyle(
                            fontSize: 16,
                          ))),
                      segments: const <ButtonSegment<DashboardFilterOptions>>[
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
                          (Set<DashboardFilterOptions> newSelection) {
                        int? typeFlag;
                        if (newSelection.single ==
                            DashboardFilterOptions.working) {
                          typeFlag = 1;
                        } else if (newSelection.single ==
                            DashboardFilterOptions.archived) typeFlag = 2;
                        if (mounted) {
                          setState(() {
                            selectedFilterOptions = newSelection;
                          });
                        }
                        fetchCompanyProjects(typeFlag);
                      },
                    ),
                  )
                ]),
              ),
              if (isLoading)
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          child: SpinKitThreeBounce(
                              size: 32,
                              duration: Durations.extralong4,
                              color: Theme.of(context).colorScheme.primary))
                    ],
                  ),
                )
              else if (allCompanyProjects.isEmpty)
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
                        child: Text(
                          'Your job list is empty',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
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
                              itemCount: allCompanyProjects.length,
                              itemBuilder: (BuildContext context, int index) {
                                CompanyProject project =
                                    allCompanyProjects[index];
                                return Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  child: InkWell(
                                    onTap: () => GoRouter.of(context).pushNamed(
                                        RouteConstants.companyProjectDetails,
                                        pathParameters: {
                                          'projectId': project.id.toString()
                                        }),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8, horizontal: 16),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 1,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .tertiary),
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
                                                        project.title,
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .secondary,
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                      ),
                                                      Container(
                                                        margin: const EdgeInsets
                                                            .only(top: 4),
                                                        child: Text(
                                                          DateFormat(
                                                                  'yyyy-MM-dd')
                                                              .format(DateTime
                                                                  .parse(project
                                                                      .createdAt)),
                                                          textAlign:
                                                              TextAlign.start,
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 12),
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
                                                                  onPressed: () => handleUpdateProjectTypeFlag(
                                                                      Constant.projectTypeFlag[
                                                                          'working']!,
                                                                      project
                                                                          .id,
                                                                      project
                                                                          .numberOfStudents),
                                                                  child:
                                                                      const ListTile(
                                                                    leading: FaIcon(
                                                                        FontAwesomeIcons
                                                                            .diagramNext),
                                                                    title: Text(
                                                                        'Start Working'),
                                                                  ),
                                                                ),
                                                                const Divider(),
                                                                TextButton(
                                                                  onPressed: () => handleUpdateProjectTypeFlag(
                                                                      Constant.projectTypeFlag[
                                                                          'archived']!,
                                                                      project
                                                                          .id,
                                                                      project
                                                                          .numberOfStudents),
                                                                  child:
                                                                      const ListTile(
                                                                    leading: FaIcon(
                                                                        FontAwesomeIcons
                                                                            .boxArchive),
                                                                    title: Text(
                                                                      'Archive Project',
                                                                    ),
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
                                                                            .solidPenToSquare),
                                                                    title: Text(
                                                                        'Edit Project'),
                                                                  ),
                                                                ),
                                                                const Divider(),
                                                                TextButton(
                                                                  onPressed: () =>
                                                                      handleRemoveProject(
                                                                          project
                                                                              .id),
                                                                  child:
                                                                      const ListTile(
                                                                    leading: FaIcon(
                                                                        FontAwesomeIcons
                                                                            .solidTrashCan),
                                                                    title: Text(
                                                                        'Remove Project'),
                                                                  ),
                                                                ),
                                                              ],
                                                            );
                                                          });
                                                    },
                                                    icon: const FaIcon(
                                                      FontAwesomeIcons.ellipsis,
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
                                                  project.description,
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  textAlign: TextAlign.justify,
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
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .tertiary),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8)),
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        vertical: 8,
                                                        horizontal: 8),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        const Text(
                                                          "Proposals:",
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: TextStyle(),
                                                        ),
                                                        Text(
                                                            '${project.countProposals}',
                                                            style: const TextStyle(
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
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .tertiary),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8)),
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        vertical: 8,
                                                        horizontal: 8),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        const Text(
                                                          "Messages:",
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: TextStyle(),
                                                        ),
                                                        Text(
                                                            '${project.countMessages}',
                                                            style: const TextStyle(
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
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .tertiary),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8)),
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        vertical: 8,
                                                        horizontal: 8),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        const Text(
                                                          "Hired:",
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: TextStyle(),
                                                        ),
                                                        Text(
                                                            '${project.countHired}',
                                                            style: const TextStyle(
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
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary),
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
