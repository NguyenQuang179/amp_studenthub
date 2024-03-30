import 'package:amp_studenthub/configs/constant.dart';
import 'package:amp_studenthub/screens/Message/message_list.dart';
import 'package:amp_studenthub/screens/Student_Projects/project_list.dart';
import 'package:amp_studenthub/screens/company_dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class NavigationMenu extends StatefulWidget {
  const NavigationMenu({super.key});

  @override
  State<NavigationMenu> createState() => _NavigationMenuState();
}

class _NavigationMenuState extends State<NavigationMenu> {
  int selectedIndex = 0;

  final screens = [
    const ProjectList(),
    const CompanyDashboardScreen(),
    const MessageList(),
    Container(color: Colors.yellow)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[selectedIndex],
      bottomNavigationBar: NavigationBar(
        height: 80,
        backgroundColor: Constant.backgroundWithOpacity,
        indicatorColor: Constant.primaryColor,
        surfaceTintColor: Constant.onPrimaryColor,
        selectedIndex: selectedIndex,
        onDestinationSelected: (value) => {
          setState(() {
            selectedIndex = value;
          })
        },
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
