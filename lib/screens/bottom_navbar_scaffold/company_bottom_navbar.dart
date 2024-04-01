import 'package:amp_studenthub/configs/constant.dart';
import 'package:amp_studenthub/widgets/auth_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

class CompanyNavbarScaffold extends StatefulWidget {
  final Widget child;
  final String location;
  const CompanyNavbarScaffold(
      {super.key, required this.child, required this.location});

  @override
  State<CompanyNavbarScaffold> createState() => _CompanyNavbarScaffoldState();
}

class _CompanyNavbarScaffoldState extends State<CompanyNavbarScaffold> {
  int selectedIndex = 0;

  final routePaths = ['/project', '/dashboard', '/message', '/notification'];

  void navigateTab(BuildContext context, int index) {
    if (index == selectedIndex) return;
    String location = routePaths[index];
    setState(() {
      selectedIndex = index;
    });
    GoRouter.of(context).go(location);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AuthAppBar(),
      body: widget.child,
      bottomNavigationBar: NavigationBar(
        height: 80,
        backgroundColor: Constant.backgroundWithOpacity,
        indicatorColor: Constant.primaryColor,
        surfaceTintColor: Constant.onPrimaryColor,
        selectedIndex: routePaths.contains(widget.location) &&
                routePaths.indexOf(widget.location) < routePaths.length
            ? routePaths.indexOf(widget.location)
            : 0,
        onDestinationSelected: (value) => {navigateTab(context, value)},
        destinations: const [
          NavigationDestination(
              icon: FaIcon(FontAwesomeIcons.house), label: "Home"),
          NavigationDestination(
              icon: FaIcon(FontAwesomeIcons.solidFolder), label: "Dashboard"),
          NavigationDestination(
              icon: FaIcon(FontAwesomeIcons.solidEnvelope), label: "Message"),
          NavigationDestination(
              icon: FaIcon(FontAwesomeIcons.solidBell), label: "Notification"),
        ],
      ),
    );
  }
}
