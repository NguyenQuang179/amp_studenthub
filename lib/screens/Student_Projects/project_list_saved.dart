import 'package:amp_studenthub/components/project_item.dart';
import 'package:amp_studenthub/configs/constant.dart';
import 'package:amp_studenthub/models/company_dashboard_project.dart';
import 'package:amp_studenthub/providers/user_provider.dart';
import 'package:amp_studenthub/routes/routes_constants.dart';
import 'package:amp_studenthub/widgets/auth_app_bar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ProjectListSaved extends StatefulWidget {
  const ProjectListSaved({super.key});

  @override
  _ProjectListSavedState createState() => _ProjectListSavedState();
}

class _ProjectListSavedState extends State<ProjectListSaved> {
  bool isLoading = false;
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

  checkSaved(context) {
    GoRouter.of(context).push('/projectListSaved');
  }

  handleSubmit(context, value) {
    GoRouter.of(context).push('/projectListFiltered');
    print(value);
  }

  @override
  void initState() {
    super.initState();
    // Fetch jobs when the widget is initialized
    getProjects();
  }

  Future<void> getProjects() async {
    print('Fetching projects');
    final dio = Dio();
    try {
      setState(() {
        isLoading = true;
      });
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      // Get access token from provider
      final accessToken = userProvider.userToken;
      final meResponse = await dio.get(
        '${Constant.baseURL}/api/auth/me',
        options: Options(headers: {
          'Authorization': 'Bearer $accessToken',
        }),
      );
      final Map<String, dynamic> meData =
          meResponse.data as Map<String, dynamic>;
      final studentId = meData['result']['student']['id'];
      print(studentId);
      if (studentId == null) {
        print('studentId is null');
        GoRouter.of(context).pop();
      }
      final endpoint = '${Constant.baseURL}/api/favoriteProject/$studentId';
      final Response response = await dio.get(
        endpoint,
        options: Options(headers: {
          'Authorization': 'Bearer $accessToken',
        }),
      );

      final Map<String, dynamic> responseData =
          response.data as Map<String, dynamic>;
      final dynamic result = responseData['result'];
      print(responseData);
      List<CompanyProject> companyProjects = [];
      for (var project in result) {
        CompanyProject companyProject =
            CompanyProject.fromJson(project['project']);
        print(companyProject);
        companyProjects.add(companyProject);
      }
      print(companyProjects);
      print("SUCCESS");

      setState(() {
        companyProjectsList = companyProjects;
      });
      print(companyProjectsList);
      // if (responseData.containsKey('result')) {
      //   // Assuming your API returns a list of jobs under 'jobs' key
      //   print(result);
      //   final List<dynamic> jobsData = result;
      //   print(result[0]);

      //   setState(() {
      //     companyProjects =
      //         jobsData.map((job) => CompanyProject.fromJson(job)).toList();
      //   });
      //   print(companyProjects);
      // } else {}
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
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constant.backgroundColor,
      appBar: const AuthAppBar(),
      body: SafeArea(
        child: Center(
            child: Column(
          children: [
            // Title
            Container(
                width: double.infinity,
                margin:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                child: const Text(
                  "Saved Projects: ",
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Constant.primaryColor),
                )),
            if (isLoading)
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
            else if (companyProjectsList.isEmpty)
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
                        "No project saved yet",
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
                  child: ListView.builder(
                itemCount: companyProjectsList.length,
                itemBuilder: (BuildContext context, int index) {
                  final companyProject = companyProjectsList[index];
                  return ProjectItem(
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
                        queryParameters: {'id': companyProject.id.toString()},
                      );
                    },
                    isSaved: companyProject.isFavorite,
                  );
                },
              )),
          ],
        )),
      ),
    );
  }
}
