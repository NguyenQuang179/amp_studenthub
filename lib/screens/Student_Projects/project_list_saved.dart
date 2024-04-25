import 'package:amp_studenthub/components/project_item.dart';
import 'package:amp_studenthub/configs/constant.dart';
import 'package:amp_studenthub/models/company_dashboard_project.dart';
import 'package:amp_studenthub/providers/user_provider.dart';
import 'package:amp_studenthub/routes/routes_constants.dart';
import 'package:amp_studenthub/widgets/auth_app_bar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ProjectListSaved extends StatefulWidget {
  const ProjectListSaved({Key? key}) : super(key: key);

  @override
  _ProjectListSavedState createState() => _ProjectListSavedState();
}

class _ProjectListSavedState extends State<ProjectListSaved> {
  late List<CompanyProject> companyProjectsList = [];

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
      final endpoint = '${Constant.baseURL}/api/favoriteProject/${studentId}';
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
        CompanyProject companyProject = CompanyProject.fromJson(project);
        print(companyProject);
        companyProjects.add(companyProject);
      }
      print(companyProjects);
      print("SUCCESS");

      setState(() {
        companyProjectsList = companyProjects;
      });
      print(this.companyProjectsList);
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
    } catch (e) {
      print(e);
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
            Expanded(
                child: ListView.builder(
              itemCount: companyProjectsList.length,
              itemBuilder: (BuildContext context, int index) {
                final companyProject = companyProjectsList[index];
                return ProjectItem(
                  jobTitle: companyProject.title,
                  jobCreatedDate: companyProject.createdAt,
                  jobDuration: "companyProject",
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
