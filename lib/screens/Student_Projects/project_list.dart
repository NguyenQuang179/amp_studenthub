import 'package:amp_studenthub/components/project_item.dart';
import 'package:amp_studenthub/configs/constant.dart';
import 'package:amp_studenthub/models/job.dart';
import 'package:amp_studenthub/models/company_dashboard_project.dart';
import 'package:amp_studenthub/providers/user_provider.dart';
import 'package:amp_studenthub/routes/routes_constants.dart';
import 'package:dio/dio.dart';
import 'package:amp_studenthub/widgets/search_project_modal.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ProjectList extends StatefulWidget {
  const ProjectList({Key? key}) : super(key: key);

  @override
  _ProjectListState createState() => _ProjectListState();
}

class _ProjectListState extends State<ProjectList> {
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
      const endpoint = '${Constant.baseURL}/api/project';
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
                                  child: SearchProjectModal(),
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
