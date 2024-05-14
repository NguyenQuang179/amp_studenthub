import 'package:amp_studenthub/components/project_item.dart';
import 'package:amp_studenthub/configs/constant.dart';
import 'package:amp_studenthub/models/company_dashboard_project.dart';
import 'package:amp_studenthub/providers/user_provider.dart';
import 'package:amp_studenthub/routes/routes_constants.dart';
import 'package:amp_studenthub/widgets/search_project_modal.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ProjectList extends StatefulWidget {
  const ProjectList({super.key});

  @override
  _ProjectListState createState() => _ProjectListState();
}

class _ProjectListState extends State<ProjectList> {
  bool isLoading = false;
  static const perPage = 10;
  int page = 1;
  late List<CompanyProject> companyProjectsList = [];
  List<String> projectScopeList = [
    "Less than 1 months",
    "1-3 months",
    "3-6 months",
    "More than 6 months"
  ];

  get dio => null;
  // checkDetail({id = String}) {
  //   GoRouter.of(context)
  //       .pushNamed(RouteConstants.projectDetails, queryParameters: {'id': id});
  // }

  final ScrollController _scrollController = ScrollController();

  checkSaved(context) {
    GoRouter.of(context).push('/projectListSaved');
  }

  handleSubmit(context, value) {
    GoRouter.of(context).push('/projectListFiltered');
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

      Fluttertoast.showToast(
          msg: "Apply Successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);

      getProjects();
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
  void initState() {
    super.initState();
    getProjects();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (mounted) {
          setState(() {
            isLoading = true;
          });
        }
      }
    });
  }

  Future<void> _handleScrollEnd() async {
    if (isLoading) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
      await loadMoreProjects();
    }
  }

  Future<void> getProjects() async {
    print('Fetching projects for page $page');

    final dio = Dio();
    try {
      if (mounted) {
        setState(() {
          isLoading = true;
        });
      }

      final userProvider = Provider.of<UserProvider>(context, listen: false);
      // Get access token from provider
      final accessToken = userProvider.userToken;
      var endpoint =
          '${Constant.baseURL}/api/project?page=$page&perPage=$perPage';
      print(endpoint);
      final Response response = await dio.get(
        endpoint,
        options: Options(headers: {
          'Authorization': 'Bearer $accessToken',
        }),
      );
      final Map<String, dynamic> responseData =
          response.data as Map<String, dynamic>;
      final dynamic result = responseData['result'];
      List<CompanyProject> newProjects = [];
      for (var project in result) {
        CompanyProject companyProject = CompanyProject.fromJson(project);
        newProjects.add(companyProject);
      }
      print("SUCCESS");
      if (mounted) {
        setState(() {
          companyProjectsList.addAll(newProjects);
        });
      }
      print(companyProjectsList.length);
    } on DioException catch (e) {
      // Handle DioException
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> loadMoreProjects() async {
    page++;
    await getProjects();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constant.backgroundColor,
      body: SafeArea(
        child: Center(
            child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                        readOnly: true,
                        onTap: () {
                          showModalBottomSheet(
                              isScrollControlled: true,
                              context: context,
                              builder: (BuildContext context) {
                                return Padding(
                                  padding: EdgeInsets.only(
                                      bottom: MediaQuery.of(context)
                                          .viewInsets
                                          .bottom),
                                  child: const SearchProjectModal(),
                                );
                              });
                        },
                        onChanged: (value) {},
                        onSubmitted: (String value) =>
                            handleSubmit(context, value),
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                            contentPadding: const EdgeInsets.only(
                                top: 8, left: 16, right: 16),
                            filled: true,
                            fillColor: Constant.onPrimaryColor,
                            prefixIcon: const Icon(Icons.search),
                            prefixStyle: const TextStyle(),
                            hintText: "Search for job...",
                            labelStyle: TextStyle(color: Colors.grey[600]),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                    color: Colors.grey[500]!, width: 1)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                    color: Colors.grey[500]!, width: 1)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                    color: Colors.grey[500]!, width: 1)))),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 8),
                    child: IconButton(
                        style: IconButton.styleFrom(
                            padding: const EdgeInsets.all(12),
                            backgroundColor: Constant.primaryColor,
                            foregroundColor: Constant.onPrimaryColor),
                        onPressed: () => checkSaved(context),
                        icon: const Icon(Icons.favorite_border)),
                  )
                ],
              ),
            ),
            if (isLoading && companyProjectsList.isEmpty)
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        child: const SpinKitThreeBounce(
                            size: 32,
                            duration: Durations.extralong4,
                            color: Constant.primaryColor))
                  ],
                ),
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
                      final companyProject = companyProjectsList[index];
                      return ProjectItem(
                        id: companyProject.id,
                        jobTitle: companyProject.title,
                        jobCreatedDate: DateFormat('yyyy-MM-dd')
                            .format(DateTime.parse(companyProject.createdAt)),
                        jobDuration:
                            projectScopeList[companyProject.projectScopeFlag],
                        jobStudentNeeded: companyProject.numberOfStudents,
                        jobProposalNums: companyProject.countProposals,
                        onClick: () {
                          // Navigate to project details page
                          GoRouter.of(context).pushNamed(
                            RouteConstants.projectDetails,
                            queryParameters: {
                              'id': companyProject.id.toString()
                            },
                          );
                        },
                        favorite: () {
                          favorite(
                              companyProject.id, companyProject.isFavorite);
                        },
                        isSaved: companyProject.isFavorite,
                      );
                    },
                  ),
                ),
              )),
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
