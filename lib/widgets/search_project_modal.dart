import 'package:amp_studenthub/providers/student_project_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SearchProjectModal extends StatefulWidget {
  const SearchProjectModal({super.key});

  @override
  State<SearchProjectModal> createState() => _SearchProjectModalState();
}

class _SearchProjectModalState extends State<SearchProjectModal> {
  TextEditingController controller = TextEditingController();
  List<String> historyList = ['reactjs', 'flutter', 'education app'];

  @override
  void initState() {
    super.initState();
    controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {});
  }

  handleSubmit(context, value) async {
    await getSearchedProject(context);
    GoRouter.of(context).push('/projectListFiltered');
  }

  Future<void> getSearchedProject(BuildContext context) async {
    // final dio = Dio();
    // try {
    final studentProjectProvider =
        Provider.of<StudentProjectProvider>(context, listen: false);
    // final userProvider = Provider.of<UserProvider>(context, listen: false);
    // // Get access token from provider
    // final accessToken = userProvider.userToken;
    studentProjectProvider.updateSearchQuery(controller.text);
    // var endpoint =
    //     '${Constant.baseURL}/api/project?title=${controller.text}&page=1&perPage=6';
    // final Response response = await dio.get(
    //   endpoint,
    //   options: Options(headers: {
    //     'Authorization': 'Bearer $accessToken',
    //   }),
    // );

    print('query: ${controller.text}');
    // final Map<String, dynamic> responseData =
    //     response.data as Map<String, dynamic>;
    // final dynamic result = responseData['result'];
    // if (result != null) {
    //   List<Project> resultList = [];
    //   for (var item in result) {
    //     resultList.add(Project.fromJson(item));
    //   }
    //   studentProjectProvider.updateList(resultList);
    //   } else {
    //     print('User data not found in the response');
    //   }
    // } on DioError catch (e) {
    //   // Handle Dio errors
    //   if (e.response != null) {
    //     final responseData = e.response?.data;
    //     print(responseData);
    //   } else {
    //     print(e.message);
    //   }
    //}
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12.0),
          topRight: Radius.circular(12.0),
        ),
        child: SizedBox(
          height: 400,
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).colorScheme.background,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextField(
                    controller: controller,
                    onSubmitted: (String value) => handleSubmit(context, value),
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(context)!.searchForJob,
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: controller.text.isNotEmpty
                          ? IntrinsicWidth(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      controller.clear();
                                    },
                                    icon: const Icon(Icons.close),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      handleSubmit(context, controller.text);
                                    },
                                    icon: const Icon(Icons.forward),
                                  ),
                                ],
                              ),
                            )
                          : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    onChanged: (_) {},
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Divider(
                    thickness: 2,
                  ),
                ),
                SingleChildScrollView(
                  child: Column(
                    children: [
                      ListView.separated(
                        shrinkWrap: true,
                        itemCount: historyList.length,
                        separatorBuilder: (context, index) => const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          child: Divider(
                            thickness: 2,
                          ),
                        ),
                        itemBuilder: (context, index) {
                          final String historyItem = historyList[index];
                          return ListTile(
                            title: Text(historyItem),
                            onTap: () {
                              controller.text = historyItem;
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
