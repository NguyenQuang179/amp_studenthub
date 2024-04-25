import 'package:amp_studenthub/configs/constant.dart';
import 'package:amp_studenthub/routes/routes_constants.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

class AuthAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AuthAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Constant.backgroundColor,
      toolbarHeight: 56,
      title: const Text(
        'StudentHub',
        style: TextStyle(
            color: Constant.primaryColor, fontWeight: FontWeight.bold),
      ),
      actions: [
        if (GoRouter.of(context).routeInformationProvider.value.uri.path != "/")
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
                onPressed: () {
                  GoRouter.of(context).pushNamed(RouteConstants.switchAccount);
                },
              ),
            ),
          ),
      ],
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
