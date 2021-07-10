import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:house_management_project/main.dart';
import 'package:house_management_project/models/Contract.dart';
import 'package:house_management_project/screens/Contract/ListContractNotUsing.dart';
import 'package:house_management_project/screens/Contract/ListContractUsing.dart';
import 'package:http/http.dart' as http;

class ListContractPage extends StatefulWidget {
  const ListContractPage({Key key}) : super(key: key);

  @override
  _ListContractPageState createState() => _ListContractPageState();
}

class _ListContractPageState extends State<ListContractPage> {

  List<Contract> listContract = [];
  List<Contract> listContractUsing = [];
  List<Contract> listContractNotUsing = [];

  getListContract() async {
    dynamic username = await FlutterSession().get("username");
    var url = Uri.parse('https://localhost:44322/api/contracts?username=$username');
    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
          var items = jsonDecode(response.body);
          setState(() {
            for (var u in items) {
              Contract contract = new Contract.fromJson(u);
              listContract.add(contract);
            }
            getListContractSeperate(listContract);
          });
      }
    } catch(error) {
      throw(error);
    }
  }

  getListContractSeperate(List<Contract> list) {
    for (var i in list) {
      if (i.status == true) {
        listContractUsing.add(i);
      } else {
        listContractNotUsing.add(i);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getListContract();
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            title: Text(
              'Danh Sách Hợp Đồng',
              style: TextStyle(
                  color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700),
            ),
            centerTitle: true,
            backgroundColor: PrimaryColor,
            automaticallyImplyLeading: false,
            bottom: TabBar(
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)),
                  color: Colors.white,
                ),
                labelColor: PrimaryColor,
                labelStyle:
                    TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                unselectedLabelColor: Colors.white70,
                tabs: [
                  Tab(
                    child: Container(
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Hợp đồng còn hạn',
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Tab(
                    child: Container(
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Hợp đồng hết hạn',
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
          ),
          body: TabBarView(
            children: [
              ListContractUsing(list: listContractUsing,),
              ListContractNotUsing(list: listContractNotUsing),
            ],
          ),
        ),
      ),
    );
  }
}