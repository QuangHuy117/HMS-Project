import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:house_management_project/fonts/my_flutter_app_icons.dart';
import 'package:house_management_project/main.dart';
import 'package:house_management_project/models/Service.dart';
import 'package:house_management_project/models/ServiceContracts.dart';
import 'package:http/http.dart' as http;

class AddServiceContractPage extends StatefulWidget {
  final List<ServiceContracts> listServiceContract;
  final String houseId;
  const AddServiceContractPage({Key key, @required this.listServiceContract, @required this.houseId}) : super(key: key);

  @override
  _AddServiceContractPageState createState() => _AddServiceContractPageState();
}

class _AddServiceContractPageState extends State<AddServiceContractPage> {

  List<Service> listService = [];
  List<ServiceContracts> list = [];

  getListServiceHouse() async {
    var url =
        Uri.parse('https://$serverHost/api/houses/${widget.houseId}');
    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        for (var i in jsonData['services']) {
            listService.add(Service.fromJson(i));
        }
        for (var u in listService) {
          for (var i in widget.listServiceContract) {
            if (i.service.id != u.id) {
              list.add(i);
            }
          }
        }
        print(list.length);
      }
    } catch (error) {
      throw (error);
    }
  }

  @override
  void initState() {
    super.initState();
    getListServiceHouse();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text(
            'Thêm dịch vụ',
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
                size: 30,
              )),
        ),
        body: Container(
          child: ListView.builder(itemBuilder: (context, index) {
            return ListTile(
              title: Text(widget.listServiceContract[index].service.name),
            );
          },
          itemCount: widget.listServiceContract.length,
          ),
        ),
      ),
    );
  }
}
