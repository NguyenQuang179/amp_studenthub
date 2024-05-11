import 'dart:developer';

import 'package:amp_studenthub/components/project_item.dart';
import 'package:amp_studenthub/configs/constant.dart';
import 'package:amp_studenthub/models/company_dashboard_project.dart';
import 'package:amp_studenthub/models/project.dart';
import 'package:amp_studenthub/providers/student_project_provider.dart';
import 'package:amp_studenthub/providers/user_provider.dart';
import 'package:amp_studenthub/routes/routes_constants.dart';
import 'package:amp_studenthub/utilities/constant.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ProjectListFiltered extends StatefulWidget {
  const ProjectListFiltered({super.key});

  @override
  State<ProjectListFiltered> createState() => _ProjectListFilteredState();
}

class _ProjectListFilteredState extends State<ProjectListFiltered> {
  late List<Project> companyProjectsList = [];
  final ScrollController _scrollController = ScrollController();
  bool isLoading = false;
  static const perPage = 6;
  int page = 1;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    filterProjects(context);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    log(isLoading.toString());
    if (!isLoading &&
        _scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
      setState(() {
        isLoading = true;
      });
      log('scroll');
    }
  }

  Future<void> _handleScrollEnd() async {
    if (isLoading) {
      setState(() {
        isLoading = false;
      });
      await loadMoreProjects();
    }
  }

  Future<void> loadMoreProjects() async {
    page++;
    log(page.toString());
    await filterProjects(context);
  }

  Future<void> favorite(id, isSaved) async {
    // Implement submit proposal logic here
    //api request
    final dio = Dio();

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final accessToken = userProvider.userToken;
    final studentId = userProvider.userInfo['student']?['id'];
    final endpoint = '${Constant.baseURL}/api/favoriteProject/$studentId';

    final submitData = {
      "projectId": id,
      "disableFlag": isSaved ? "1" : "0",
    };

    try {
      final Response response = await dio.patch(
        endpoint,
        data: submitData,
        options: Options(headers: {
          'Authorization': 'Bearer $accessToken',
        }),
      );

      final responseData = response.data;
      print(responseData);

      Fluttertoast.showToast(
          msg: "Apply Successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
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

  onClick(project) {
    GoRouter.of(context).pushNamed(
      RouteConstants.projectDetails,
      queryParameters: {'id': project.id.toString()},
    );
  }

  int? selectedOption;
  TextEditingController studentNeededController = TextEditingController();
  TextEditingController proposalsController = TextEditingController();

  onLengthSelected(value, setState) {
    setState(() {
      selectedOption = value;
      print(selectedOption);
    });
  }

  Future<void> filterProjects(BuildContext context) async {
    final dio = Dio();
    try {
      String filterQuery = '';
      if (selectedOption != null) {
        filterQuery += '&projectScopeFlag=$selectedOption';
      }

      if (studentNeededController.text != '') {
        filterQuery += '&numberOfStudents=${studentNeededController.text}';
      }

      if (proposalsController.text != '') {
        filterQuery += '&proposalsLessThan=${proposalsController.text}';
      }

      filterQuery += '&page=$page&perPage=$perPage';

      final studentProjectProvider =
          Provider.of<StudentProjectProvider>(context, listen: false);
      var titleQuery = studentProjectProvider.searchQuery;

      var finalURL = '${Constant.baseURL}/api/project?title=$titleQuery';
      if (filterQuery != '') finalURL = '$finalURL&$filterQuery';

      log(finalURL);

      final userProvider = Provider.of<UserProvider>(context, listen: false);
      // Get access token from provider
      final accessToken = userProvider.userToken;
      var endpoint = finalURL;
      final Response response = await dio.get(
        endpoint,
        options: Options(headers: {
          'Authorization': 'Bearer $accessToken',
        }),
      );
      log(titleQuery);
      final Map<String, dynamic> responseData =
          response.data as Map<String, dynamic>;
      final dynamic result = responseData['result'];
      if (result != null) {
        log(result.toString());
        List<Project> newProjects = [];
        for (var project in result) {
          Project companyProject = Project.fromJson(project);
          newProjects.add(companyProject);
        }
        setState(() {
          companyProjectsList.addAll(newProjects);
        });
      } else {
        print('User data not found in the response');
      }
    } on DioError catch (e) {
      // Handle Dio errors
      if (e.response != null) {
        final responseData = e.response?.data;
        print(responseData);
      } else {
        print(e.message);
      }
    }
  }

  Future<void> clearFilters(BuildContext context) async {
    final dio = Dio();
    try {
      final studentProjectProvider =
          Provider.of<StudentProjectProvider>(context, listen: false);
      var titleQuery = studentProjectProvider.searchQuery;

      var finalURL = '${Constant.baseURL}/api/project?title=$titleQuery';

      final userProvider = Provider.of<UserProvider>(context, listen: false);
      // Get access token from provider
      final accessToken = userProvider.userToken;
      var endpoint = finalURL;
      final Response response = await dio.get(
        endpoint,
        options: Options(headers: {
          'Authorization': 'Bearer $accessToken',
        }),
      );

      final Map<String, dynamic> responseData =
          response.data as Map<String, dynamic>;
      final dynamic result = responseData['result'];
      if (result != null) {
        List<Project> resultList = [];
        for (var item in result) {
          resultList.add(Project.fromJson(item));
        }
        studentProjectProvider.updateList(resultList);

        setState(() {});
      } else {
        print('User data not found in the response');
      }
    } on DioError catch (e) {
      // Handle Dio errors
      if (e.response != null) {
        final responseData = e.response?.data;
        print(responseData);
      } else {
        print(e.message);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constant.backgroundColor,
      appBar: AppBar(
        backgroundColor: Constant.backgroundColor,
        toolbarHeight: 56,
        title: Row(
          children: [
            Expanded(
              child: TextField(
                  onChanged: (value) {},
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                      contentPadding:
                          const EdgeInsets.only(top: 8, left: 16, right: 16),
                      filled: true,
                      fillColor: Constant.onPrimaryColor,
                      prefixIcon: const Icon(Icons.search),
                      prefixStyle: const TextStyle(),
                      hintText: "Search for job...",
                      labelStyle: TextStyle(color: Colors.grey[600]),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              BorderSide(color: Colors.grey[500]!, width: 1)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              BorderSide(color: Colors.grey[500]!, width: 1)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              BorderSide(color: Colors.grey[500]!, width: 1)))),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: IconButton(
                style: IconButton.styleFrom(
                    backgroundColor: Constant.primaryColor,
                    foregroundColor: Constant.onPrimaryColor),
                onPressed: () => showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (BuildContext context) {
                      return StatefulBuilder(builder: (context, setState) {
                        return SingleChildScrollView(
                            child: Padding(
                          padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom),
                          child: SizedBox(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    const Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 12),
                                      child: Text("Filter By",
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Constant.primaryColor,
                                              fontWeight: FontWeight.w600),
                                          textAlign: TextAlign.center),
                                    ),
                                    const Divider(),
                                    const Text(
                                      "Project Length:",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Constant.textColor),
                                    ),
                                    RadioListTile<int>(
                                      title: const Text('Less than 1 month'),
                                      value: 0,
                                      groupValue: selectedOption,
                                      onChanged: (value) {
                                        onLengthSelected(value, setState);
                                      },
                                    ),
                                    RadioListTile<int>(
                                      title: const Text('1-3 months'),
                                      value: 1,
                                      groupValue: selectedOption,
                                      onChanged: (value) {
                                        onLengthSelected(value, setState);
                                      },
                                    ),
                                    RadioListTile<int>(
                                        title: const Text('3-6 months'),
                                        value: 2,
                                        groupValue: selectedOption,
                                        onChanged: (value) {
                                          onLengthSelected(value, setState);
                                        }),
                                    RadioListTile<int>(
                                      title: const Text('More than 6 months'),
                                      value: 3,
                                      groupValue: selectedOption,
                                      onChanged: (value) {
                                        onLengthSelected(value, setState);
                                      },
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(
                                          top: 16, bottom: 8),
                                      child: const Text(
                                        "Student needed",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: Constant.textColor),
                                      ),
                                    ),
                                    TextField(
                                        controller: studentNeededController,
                                        decoration: const InputDecoration(
                                            labelText: "Enter your number"),
                                        keyboardType: TextInputType.number,
                                        inputFormatters: <TextInputFormatter>[
                                          FilteringTextInputFormatter.digitsOnly
                                        ]),
                                    Container(
                                      margin: const EdgeInsets.only(
                                          top: 16, bottom: 8),
                                      child: const Text(
                                        "Proposals less than",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: Constant.textColor),
                                      ),
                                    ),
                                    TextField(
                                        controller: proposalsController,
                                        decoration: const InputDecoration(
                                            labelText: "Enter your number"),
                                        keyboardType: TextInputType.number,
                                        inputFormatters: <TextInputFormatter>[
                                          FilteringTextInputFormatter.digitsOnly
                                        ]),
                                    Container(
                                      child: Padding(
                                        padding: const EdgeInsets.all(20.0),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: ElevatedButton(
                                                style: ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .all<Color>(Constant
                                                                .primaryColor),
                                                    foregroundColor:
                                                        MaterialStateProperty
                                                            .all<Color>(Constant
                                                                .onPrimaryColor)),
                                                onPressed: () async {
                                                  await filterProjects(context);
                                                  GoRouter.of(context).pop('/');
                                                },
                                                child: const Text("Apply"),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 16,
                                            ),
                                            Expanded(
                                              child: ElevatedButton(
                                                style: ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .all<Color>(Constant
                                                                .onPrimaryColor),
                                                    foregroundColor:
                                                        MaterialStateProperty
                                                            .all<Color>(Constant
                                                                .primaryColor)),
                                                onPressed: () async {
                                                  setState(() {
                                                    selectedOption = null;
                                                    studentNeededController
                                                        .text = '';
                                                    proposalsController.text =
                                                        '';
                                                  });
                                                  await clearFilters(context);
                                                  GoRouter.of(context).pop('/');
                                                },
                                                child:
                                                    const Text("Clear Filter"),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ]),
                            ),
                          ),
                        ));
                      });
                    }),
                icon: const Icon(Icons.filter_alt)),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
            child: Column(
          children: [
            Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                child: const Text(
                  "Search Result:",
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Constant.primaryColor),
                )),
            if (companyProjectsList.isEmpty)
              Column(
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
                      "The search list is empty",
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
            else
              Expanded(
                child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onVerticalDragEnd: (details) {
                      _handleScrollEnd();
                    },
                    child: NotificationListener<ScrollNotification>(
                      onNotification: (scrollInfo) {
                        if (scrollInfo is ScrollEndNotification) {
                          _handleScrollEnd();
                        }
                        return false;
                      },
                      child: ListView.builder(
                        controller: _scrollController,
                        itemCount: companyProjectsList.length,
                        itemBuilder: (BuildContext context, int index) {
                          final Project project = companyProjectsList[index];
                          return ProjectItem(
                            id: project.id as int,
                            jobTitle: project.title,
                            jobCreatedDate: project.createdDate,
                            jobDuration:
                                ProjectScopeToString[project.projectScopeFlag],
                            jobStudentNeeded: project.numberOfStudents,
                            jobProposalNums: project.countProposals,
                            onClick: () => onClick(project),
                            isSaved: project.isFavorite,
                            favorite: () {
                              favorite(project.id, project.isFavorite);
                              companyProjectsList[index].isFavorite =
                                  !project.isFavorite;
                            },
                          );
                        },
                      ),
                    )),
              ),
            if (isLoading && companyProjectsList.isNotEmpty)
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: CircularProgressIndicator(),
              ),
          ],
        )),
      ),
    );
  }
}
