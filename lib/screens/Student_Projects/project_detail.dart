import 'package:amp_studenthub/configs/constant.dart';
import 'package:amp_studenthub/models/company_dashboard_project.dart';
import 'package:amp_studenthub/providers/user_provider.dart';
import 'package:amp_studenthub/routes/routes_constants.dart';
import 'package:amp_studenthub/widgets/auth_app_bar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
  bool isLoading = false;
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
      if (mounted) {
        setState(() {
          companyProject = fetchedCompanyProject;
        });
      }
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

  Future<void> favorite(id, isSaved) async {
    // Implement submit proposal logic here
    //api request
    final dio = Dio();

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final accessToken = userProvider.userToken;
    final studentId = userProvider.userInfo['student']?['id'];
    final endpoint = '${Constant.baseURL}/api/favoriteProject/$studentId';

    print(id);
    final submitData = {
      "projectId": id,
      "disableFlag": isSaved ? "1" : "0",
    };

    print(submitData);
    print(endpoint);
    print(accessToken);
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

      await getProjectDetail(id);
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
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
              Text(
                "Project Detail",
                style: TextStyle(
                    fontSize: 20,
                    color: Theme.of(context).colorScheme.secondary),
              ),
              Text(companyProject.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 30,
                      color: Theme.of(context).colorScheme.primary)),
              Divider(
                color: Theme.of(context).colorScheme.primary,
              ),
              const Text("Students are expecting:"),
              Text("- ${companyProject.description}"),
              Divider(
                color: Theme.of(context).colorScheme.primary,
              ),
              Text("Created:",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: 20,
                      color: Theme.of(context).colorScheme.primary)),
              Text("- ${companyProject.createdAt}"),
              Text("Duration:",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: 20,
                      color: Theme.of(context).colorScheme.primary)),
              Text("- ${companyProject.projectScopeFlag}"),
              Text("Available Slots:",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: 20,
                      color: Theme.of(context).colorScheme.primary)),
              Text("- ${companyProject.countHired} Students"),
              Text("Total Slots:",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: 20,
                      color: Theme.of(context).colorScheme.primary)),
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
                                Theme.of(context).colorScheme.primary),
                            foregroundColor: MaterialStateProperty.all<Color>(
                                Theme.of(context).colorScheme.onPrimary)),
                        onPressed: () {
                          GoRouter.of(context).pushNamed(
                            RouteConstants.submitProposal,
                            queryParameters: {
                              'id': companyProject.id.toString()
                            },
                          );
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
                                Theme.of(context).colorScheme.onPrimary),
                            foregroundColor: MaterialStateProperty.all<Color>(
                                Theme.of(context).colorScheme.primary)),
                        onPressed: isLoading
                            ? null // Disable button if loading
                            : () {
                                if (mounted) {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  favorite(companyProject.id,
                                      companyProject.isFavorite);
                                }
                              },
                        child: isLoading
                            ? const CircularProgressIndicator() // Show loading indicator if loading
                            : companyProject.isFavorite
                                ? const Text("Unsave")
                                : const Text("Save"),
                      ),
                    ),
                    Flexible(
                      fit: FlexFit.loose,
                      child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Theme.of(context).colorScheme.onPrimary),
                            foregroundColor: MaterialStateProperty.all<Color>(
                                Theme.of(context).colorScheme.primary)),
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
