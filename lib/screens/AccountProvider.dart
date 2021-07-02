import 'package:flutter/material.dart';
import 'package:house_management_project/models/Account.dart';
import 'package:house_management_project/screens/HomePage.dart';
import 'package:provider/provider.dart';

class AccountProvider extends StatelessWidget {
  final dynamic account;
  AccountProvider({ Key key, this.account }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Account accountData = new Account();
    accountData = Account.fromJson(account);

    return Provider<Account>(
      create: (_) => accountData,
      child: HomePage(username: accountData.username),
    );
  }
}