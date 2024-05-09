import 'package:amp_studenthub/configs/constant.dart';
import 'package:amp_studenthub/models/company_dashboard_project.dart';
import 'package:amp_studenthub/providers/user_provider.dart';
import 'package:amp_studenthub/routes/routes_constants.dart';
import 'package:amp_studenthub/widgets/auth_app_bar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ProjectDetail extends StatefulWidget {
  final String id;
  const ProjectDetail({super.key, required this.id});

  @override
  _ProjectDetailState createState() => _ProjectDetailState(id: id);
}

class _ProjectDetailState extends State<ProjectDetail> {
  final String id;
  late CompanyProject companyProject;
  _ProjectDetailState({
    required this.id,
  });

  Future<void> getProjectDetail(id) async {
    print('Fetching projects');
    final dio = Dio();
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      // Get access token from provider
      final accessToken = userProvider.userToken;
      final endpoint = '${Constant.baseURL}/api/project/$id';
      final Response response = await dio.get(
        endpoint,
        options: Options(headers: {
          'Authorization': 'Bearer $accessToken',
        }),
      );

      final Map<String, dynamic> responseData =
          response.data as Map<String, dynamic>;
      final dynamic result = responseData['result'];
      print(result);
      CompanyProject fetchedCompanyProject = CompanyProject.fromJson(result);
      print(fetchedCompanyProject);

      setState(() {
        companyProject = fetchedCompanyProject;
      });
      print(companyProject);
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
  void initState() {
    super.initState();
    // Fetch jobs when the widget is initialized
    print(id);
    getProjectDetail(id);
    companyProject = CompanyProject.empty();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constant.backgroundColor,
      appBar: const AuthAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                height: 40,
              ),
              const Text(
                "Project Detail",
                style: TextStyle(fontSize: 20, color: Constant.secondaryColor),
              ),
              Text(companyProject.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 30, color: Constant.primaryColor)),
              const Divider(
                color: Constant.primaryColor,
              ),
              const Text("Students are expecting:"),
              Text("- ${companyProject.description}"),
              const Divider(
                color: Constant.primaryColor,
              ),
              const Text("Created:",
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 20, color: Constant.primaryColor)),
              Text("- ${companyProject.createdAt}"),
              const Text("Duration:",
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 20, color: Constant.primaryColor)),
              Text("- ${companyProject.projectScopeFlag}"),
              const Text("Available Slots:",
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 20, color: Constant.primaryColor)),
              Text("- ${companyProject.countHired} Students"),
              const Text("Total Slots:",
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 20, color: Constant.primaryColor)),
              Text("- ${companyProject.countProposals}s Students"),
              const SizedBox(
                height: 40,
              ),

              // Second item with no flexible space
              Container(
                child: Row(
                  children: [
                    Flexible(
                      fit: FlexFit.loose,
                      child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Constant.primaryColor),
                            foregroundColor: MaterialStateProperty.all<Color>(
                                Constant.onPrimaryColor)),
                        onPressed: () {
                          context.pushNamed(RouteConstants.submitProposal);
                        },
                        child: const Text("Apply"),
                      ),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    Flexible(
                      fit: FlexFit.loose,
                      child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Constant.onPrimaryColor),
                            foregroundColor: MaterialStateProperty.all<Color>(
                                Constant.primaryColor)),
                        onPressed: () {},
                        child: const Text("Save"),
                      ),
                    ),
                    Flexible(
                      fit: FlexFit.loose,
                      child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Constant.onPrimaryColor),
                            foregroundColor: MaterialStateProperty.all<Color>(
                                Constant.primaryColor)),
                        onPressed: () => GoRouter.of(context).pop('/'),
                        child: const Text("Return"),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
