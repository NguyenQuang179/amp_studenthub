import 'package:amp_studenthub/configs/constant.dart';
import 'package:amp_studenthub/models/account.dart';
import 'package:amp_studenthub/providers/user_provider.dart';
import 'package:amp_studenthub/widgets/account_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AccountListView extends StatefulWidget {
  final List<Account> accountList;
  final Account currentAccount;
  final Function(Account) onAccountChange;

  const AccountListView(
      {super.key,
      required this.accountList,
      required this.currentAccount,
      required this.onAccountChange,
      s});

  @override
  State<AccountListView> createState() => _AccountListViewState();
}

class _AccountListViewState extends State<AccountListView> {
  final expansionTileController = ExpansionTileController();

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: 1,
        itemBuilder: (BuildContext context, int index) =>
            _buildList(widget.accountList, widget.currentAccount, context),
      ),
    );
  }

  Widget? _buildList(
      List<Account> list, Account currentAcc, BuildContext context) {
    // if (list == null || list.isEmpty) {
    //   return null; // Return null when the list is null or empty
    // }
    return ClipRRect(
      borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
      child: ExpansionTile(
          controller: expansionTileController,
          collapsedBackgroundColor: Theme.of(context).colorScheme.background,
          backgroundColor: Theme.of(context).colorScheme.background,
          title: AccountCard(
            account: currentAcc,
          ),
          children: [
            Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    ...list.map((account) => GestureDetector(
                        onTap: () {
                          var userProvider =
                              Provider.of<UserProvider>(context, listen: false);
                          userProvider.updateCurrentAccount(account);
                          List<Account> list = [];
                          list.add(currentAcc);
                          userProvider.updateAccountList(list);
                          var role = account.type == 0 ? 'Student' : 'Company';
                          userProvider.updateRole(role);
                          if (expansionTileController.isExpanded) {
                            expansionTileController.collapse();
                          }
                          widget.onAccountChange(account);
                          setState(() {});
                        },
                        child: AccountCard(account: account)))
                  ],
                )),
          ]),
    );
  }
}
