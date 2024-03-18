import 'package:amp_studenthub/configs/constant.dart';
import 'package:amp_studenthub/utilities/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

class CompanyDashboardScreen extends StatefulWidget {
  const CompanyDashboardScreen({super.key});

  @override
  State<CompanyDashboardScreen> createState() => _CompanyDashboardScreenState();
}

class _CompanyDashboardScreenState extends State<CompanyDashboardScreen> {
  Set<DashboardFilterOptions> selectedFilterOptions = {
    DashboardFilterOptions.all
  };
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Constant.backgroundColor,
          toolbarHeight: 64,
          title: const Text(
            'StudentHub',
            style: TextStyle(
                color: Constant.primaryColor, fontWeight: FontWeight.bold),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: CircleAvatar(
                radius: 24,
                backgroundColor: Constant.primaryColor,
                child: IconButton(
                  icon: const FaIcon(
                    FontAwesomeIcons.user,
                    size: 20,
                    color: Constant.onPrimaryColor,
                  ),
                  onPressed: () {},
                ),
              ),
            ),
          ],
          centerTitle: true,
        ),
        body: SizedBox.expand(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Expanded(
                  child: Column(
                children: [
                  Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 16),
                      child: const Text(
                        "Your Jobs: ",
                        style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w600,
                            color: Constant.primaryColor),
                      )),
                  Container(
                    decoration: const BoxDecoration(
                      color: Constant.backgroundColor,
                    ),
                    child: Row(children: [
                      Expanded(
                        flex: 1,
                        child: SegmentedButton<DashboardFilterOptions>(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) {
                                  if (states.contains(MaterialState.selected)) {
                                    return Constant.primaryColor;
                                  }
                                  return Constant.backgroundColor;
                                },
                              ),
                              foregroundColor:
                                  MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) {
                                  if (states.contains(MaterialState.selected)) {
                                    return Constant.onPrimaryColor;
                                  }
                                  return Constant.textColor;
                                },
                              ),
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12))),
                              textStyle: MaterialStatePropertyAll(TextStyle(
                                fontSize: 16,
                              ))),
                          segments: const <ButtonSegment<
                              DashboardFilterOptions>>[
                            ButtonSegment<DashboardFilterOptions>(
                                value: DashboardFilterOptions.all,
                                label: Text("All")),
                            ButtonSegment<DashboardFilterOptions>(
                                value: DashboardFilterOptions.working,
                                label: Text("Working")),
                            ButtonSegment<DashboardFilterOptions>(
                                value: DashboardFilterOptions.archived,
                                label: Text("Archived")),
                          ],
                          selected: selectedFilterOptions,
                          onSelectionChanged:
                              (Set<DashboardFilterOptions> newSelection) {},
                        ),
                      )
                    ]),
                  ),
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
                            "Welcome, Quang!\nYour job list is empty",
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
                  ),
                ],
              )),
              Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  width: double.infinity,
                  height: 48,
                  child: TextButton(
                    onPressed: () => GoRouter.of(context).push('/postJob'),
                    style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        backgroundColor: Constant.primaryColor,
                        foregroundColor: Constant.onPrimaryColor),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 16),
                          child: const Text(
                            'Post new job',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500),
                          ),
                        ),
                        Container(
                            margin: EdgeInsets.only(left: 16),
                            child: const Icon(Icons.add)),
                      ],
                    ),
                  )),
            ]),
          ),
        ));
  }
}
