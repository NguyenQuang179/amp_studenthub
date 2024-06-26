import 'dart:developer';

import 'package:amp_studenthub/components/project_item.dart';
import 'package:amp_studenthub/configs/constant.dart';
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
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProjectListFiltered extends StatefulWidget {
  const ProjectListFiltered({super.key});

  @override
  State<ProjectListFiltered> createState() => _ProjectListFilteredState();
}

class _ProjectListFilteredState extends State<ProjectListFiltered> {
  late StudentProjectProvider _studentProjectProvider;
  late List<Project> companyProjectsList = [];
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  bool isLoading = false;
  static const perPage = 6;
  int page = 1;

  @override
  void initState() {
    super.initState();
    _studentProjectProvider =
        Provider.of<StudentProjectProvider>(context, listen: false);
    _scrollController.addListener(_scrollListener);
    final studentProjectProvider =
        Provider.of<StudentProjectProvider>(context, listen: false);
    if (studentProjectProvider.projectScopeFlag != -1) {
      selectedOption = studentProjectProvider.projectScopeFlag;
    }
    proposalsController.text = studentProjectProvider.proposals;
    studentNeededController.text = studentProjectProvider.students;
    setState(() {});
    filterProjects(context);
  }

  @override
  void dispose() {
    _studentProjectProvider.clear();
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (!isLoading &&
        _scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
      setState(() {
        isLoading = true;
      });
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
    await filterProjects(context);
  }

  Future<void> favorite(id, isSaved) async {
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
    final studentProjectProvider =
        Provider.of<StudentProjectProvider>(context, listen: false);
    studentProjectProvider.updateProjectScopeFlag(value);
    setState(() {
      selectedOption = value;
      print(selectedOption);
    });
  }

  String curQuery = '';
  Future<void> filterProjects(BuildContext context) async {
    final dio = Dio();
    try {
      String filterQuery = '';
      bool isChanged = false;
      if (selectedOption != null) {
        filterQuery += '&projectScopeFlag=$selectedOption';
      }

      if (studentNeededController.text != '') {
        filterQuery += '&numberOfStudents=${studentNeededController.text}';
      }

      if (proposalsController.text != '') {
        filterQuery += '&proposalsLessThan=${proposalsController.text}';
      }

      if (filterQuery != curQuery) {
        page = 1;
        curQuery = filterQuery;
        isChanged = true;
      }

      filterQuery += '&page=$page&perPage=$perPage';

      final studentProjectProvider =
          Provider.of<StudentProjectProvider>(context, listen: false);
      var titleQuery = studentProjectProvider.searchQuery;

      var finalURL = '${Constant.baseURL}/api/project?title=$titleQuery';
      if (filterQuery != '') finalURL = '$finalURL$filterQuery';

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
      final Map<String, dynamic> responseData =
          response.data as Map<String, dynamic>;
      final dynamic result = responseData['result'];

      if (result != null) {
        List<Project> newProjects = [];
        for (var project in result) {
          Project companyProject = Project.fromJson(project);
          newProjects.add(companyProject);
        }
        if (isChanged == true) {
          companyProjectsList.clear();
          setState(() {});
        }
        companyProjectsList.addAll(newProjects);
        setState(() {});
        log(companyProjectsList.map((e) => e.companyId).toString());
      } else {
        print('User data not found in the response');
      }
    } on DioError catch (e) {
      // Handle Dio errors
      page--;
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
      studentProjectProvider.clear();
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
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        toolbarHeight: 56,
        title: Row(
          children: [
            Expanded(
              child: TextField(
                  controller: _searchController,
                  onSubmitted: (value) {
                    final studentProjectProvider =
                        Provider.of<StudentProjectProvider>(context,
                            listen: false);
                    log('submitted');
                    studentProjectProvider.updateSearchQuery(value);
                    context.pop();
                    context.pushNamed(RouteConstants.projectListFiltered);
                  },
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                      contentPadding:
                          const EdgeInsets.only(top: 8, left: 16, right: 16),
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.background,
                      prefixIcon: const Icon(Icons.search),
                      prefixStyle: const TextStyle(),
                      hintText: AppLocalizations.of(context)!.searchForJob,
                      labelStyle: TextStyle(
                          color: Theme.of(context).colorScheme.tertiary),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.tertiary,
                              width: 1)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.tertiary,
                              width: 1)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.tertiary,
                              width: 1)))),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: IconButton(
                style: IconButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary),
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
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12),
                                      child: Text("Filter By",
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              fontWeight: FontWeight.w600),
                                          textAlign: TextAlign.center),
                                    ),
                                    const Divider(),
                                    Text(
                                      "Project Length:",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onBackground),
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
                                      child: Text(
                                        "Student needed",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onBackground),
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
                                      child: Text(
                                        "Proposals less than",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onBackground),
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
                                                            .all<Color>(
                                                                Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .primary),
                                                    foregroundColor:
                                                        MaterialStateProperty
                                                            .all<Color>(Theme
                                                                    .of(context)
                                                                .colorScheme
                                                                .onPrimary)),
                                                onPressed: () {
                                                  var studentProjectProvider =
                                                      Provider.of<
                                                              StudentProjectProvider>(
                                                          context,
                                                          listen: false);
                                                  studentProjectProvider
                                                      .updateProposals(
                                                          proposalsController
                                                              .text);
                                                  studentProjectProvider
                                                      .updateStudents(
                                                          studentNeededController
                                                              .text);
                                                  setState(() {});
                                                  GoRouter.of(context).pop('/');
                                                  context.pop();
                                                  context.pushNamed(
                                                      RouteConstants
                                                          .projectListFiltered);
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
                                                            .all<Color>(
                                                                Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .onPrimary),
                                                    foregroundColor:
                                                        MaterialStateProperty
                                                            .all<Color>(Theme
                                                                    .of(context)
                                                                .colorScheme
                                                                .primary)),
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
                child: Text(
                  "${AppLocalizations.of(context)!.searchResult}:",
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.primary),
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
                    child: Text(
                      "The search list is empty",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
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
