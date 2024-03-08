import 'package:amp_studenthub/models/account.dart';
import 'package:amp_studenthub/widgets/account_card.dart';
import 'package:flutter/material.dart';

class AccountListView extends StatefulWidget {
  final List<Account>? accountList;
  final Account currentAccount;

  const AccountListView({
    super.key,
    this.accountList,
    required this.currentAccount,
  });

  @override
  State<AccountListView> createState() => _AccountListViewState();
}

class _AccountListViewState extends State<AccountListView> {
  @override
  Widget build(BuildContext context) {
    int length = widget.accountList?.length ?? 1;
    return Flexible(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: 1,
        itemBuilder: (BuildContext context, int index) =>
            _buildList(widget.accountList, widget.currentAccount),
      ),
    );
  }

  Widget? _buildList(List<Account>? list, Account currentAcc) {
    if (list == null || list.isEmpty) {
      return null; // Return null when the list is null or empty
    }
    return ClipRRect(
      borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
      child: ExpansionTile(
        collapsedBackgroundColor: Color(0xFF3F72AF),
        backgroundColor: Color(0xFF3F72AF),
        shape: Border(top: BorderSide(color: Colors.white)),
        title: AccountCard(
          account: currentAcc,
        ),
        children: list.map((account) => AccountCard(account: account)).toList(),
      ),
    );
  }
}
