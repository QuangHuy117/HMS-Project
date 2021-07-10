import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:house_management_project/fonts/my_flutter_app_icons.dart';
import 'package:house_management_project/models/Bill.dart';
import 'package:http/http.dart' as http;

class BillHistoryPage extends StatefulWidget {
  final int contractId;
  const BillHistoryPage({Key key, @required this.contractId}) : super(key: key);

  @override
  _BillHistoryPageState createState() => _BillHistoryPageState();
}

class _BillHistoryPageState extends State<BillHistoryPage> {
  List<Bill> listBill = [];

  getListBill() async {
    var url = Uri.parse('https://localhost:44322/api/bills?contractId=1&status=false');
    try {
      var response = await http.get(url);
      print(response.statusCode);
      if (response.statusCode == 200) {
        var items = jsonDecode(response.body);
        listBill = billFromJson(items);
        print(listBill);
      }
    } catch (error) {
      throw (error);
    }
  }

  @override
  void initState() {
    super.initState();
    getListBill();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Lịch Sử Hóa Đơn',
            style: TextStyle(
                color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700),
          ),
          centerTitle: true,
          automaticallyImplyLeading: false,
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              MyFlutterApp.left,
              color: Colors.white,
              size: 27,
            ),
          ),
        ),
        body: Container(
          
        ),
      ),
    );
  }
}
