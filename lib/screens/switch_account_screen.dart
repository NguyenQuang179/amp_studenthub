import 'package:amp_studenthub/configs/constant.dart';
import 'package:amp_studenthub/models/account.dart';
import 'package:amp_studenthub/widgets/account_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SwitchAccountScreen extends StatefulWidget {
  const SwitchAccountScreen({super.key});

  @override
  State<SwitchAccountScreen> createState() => _SwitchAccountScreenState();
}

class _SwitchAccountScreenState extends State<SwitchAccountScreen> {
  @override
  Widget build(BuildContext context) {
    Account currentAccount =
        Account(fullName: 'Nguyễn Duy Niên', type: 'Student');
    List<Account> accountList = [
      Account(fullName: 'Niên', type: 'Company'),
      Account(fullName: 'Niên 2', type: 'Student')
    ];

    Color customColor = const Color(0xFF3F72AF);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "StudentHub",
          style: TextStyle(color: Constant.onPrimaryColor),
        ),
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.arrow_back),
          color: Constant.onPrimaryColor,
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
            color: Constant.onPrimaryColor,
          )
        ],
        backgroundColor: customColor,
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: AccountListView(
              currentAccount: currentAccount,
              accountList: accountList,
            ),
          ),
        ],
      ),
    );
  }
}
