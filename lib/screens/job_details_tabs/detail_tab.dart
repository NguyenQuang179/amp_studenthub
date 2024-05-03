import 'package:amp_studenthub/configs/constant.dart';
import 'package:amp_studenthub/models/company_dashboard_project.dart';
import 'package:amp_studenthub/providers/user_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class JobDetailTab extends StatefulWidget {
  final String projectId;
  const JobDetailTab({super.key, required this.projectId});

  @override
  State<JobDetailTab> createState() => _JobDetailTabState();
}

class _JobDetailTabState extends State<JobDetailTab> {
  bool isLoading = false;
  late CompanyProject projectDetails;

  Future<void> fetchCompanyProjectDetails() async {
    final dio = Dio();
    try {
      setState(() {
        isLoading = true;
      });
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final accessToken = userProvider.userToken;
      String endpoint = '${Constant.baseURL}/api/project/${widget.projectId}';
      final Response response = await dio.get(
        endpoint,
        options: Options(headers: {
          'Authorization': 'Bearer $accessToken',
        }),
      );

      final Map<String, dynamic> responseData =
          response.data as Map<String, dynamic>;
      final dynamic result = responseData['result'];
      final CompanyProject projectDetailRes = CompanyProject.fromJson(result);
      setState(() {
        projectDetails = projectDetailRes;
      });
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
  void initState() {
    super.initState();
    fetchCompanyProjectDetails();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        child: Container(
          child: isLoading
              ? const Center(
                  child: SpinKitThreeBounce(
                      size: 32,
                      duration: Durations.extralong4,
                      color: Constant.primaryColor))
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Text(
                        projectDetails.title,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w600),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(right: 8),
                            child: const FaIcon(
                              FontAwesomeIcons.clock,
                              size: 16,
                            ),
                          ),
                          Text(
                            'Project scope: ${Constant.timelineOptions[projectDetails.projectScopeFlag]}',
                            style: const TextStyle(
                                color: Constant.textColor, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(right: 8),
                            child: const FaIcon(
                              FontAwesomeIcons.user,
                              size: 16,
                            ),
                          ),
                          Text(
                            'Student required: ${projectDetails.numberOfStudents}',
                            style: const TextStyle(
                                color: Constant.textColor, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: const Text(
                        "Description: ",
                        style:
                            TextStyle(color: Constant.textColor, fontSize: 16),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 32),
                      child: Text(projectDetails.description,
                          textAlign: TextAlign.justify,
                          style: const TextStyle(
                              color: Constant.textColor, fontSize: 16)),
                    ),
                    Column(
                      children: [
                        Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            width: double.infinity,
                            height: 48,
                            child: TextButton(
                              onPressed: () {},
                              style: TextButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                  backgroundColor: Constant.primaryColor,
                                  foregroundColor: Constant.onPrimaryColor),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    child: const Text(
                                      'Edit Project',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ],
                              ),
                            )),
                        SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: TextButton(
                              onPressed: () {},
                              style: TextButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                  side: const BorderSide(
                                      color: Constant.primaryColor, width: 2),
                                  foregroundColor: Constant.primaryColor),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    child: const Text(
                                      'Remove Project',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ],
                              ),
                            )),
                      ],
                    )
                  ],
                ),
        ),
      ),
    ));
  }
}
