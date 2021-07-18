import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:house_management_project/fonts/my_flutter_app_icons.dart';
import 'package:house_management_project/main.dart';
import 'package:house_management_project/models/Service.dart';
import 'package:house_management_project/models/ServiceContracts.dart';
import 'package:http/http.dart' as http;

class AddServiceContractPage extends StatefulWidget {
  // final List<ServiceContracts> listServiceContract;
  final List<Service> listServiceContract;
  final String houseId;
  const AddServiceContractPage(
      {Key key, @required this.listServiceContract, @required this.houseId})
      : super(key: key);

  @override
  _AddServiceContractPageState createState() => _AddServiceContractPageState();
}

class _AddServiceContractPageState extends State<AddServiceContractPage> {
  List<Service> listService = [];
  List<Service> list = [];
  List<bool> _isCheck = [];

  Future<List<Service>> getListServiceHouse() async {
    list.clear();
    var url = Uri.parse('https://$serverHost/api/houses/${widget.houseId}');
    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        for (var i in jsonData['services']) {
          listService.add(Service.fromJson(i));
        }
        bool find;
        for (var u in listService) {
          // print("ServiceId: " + u.id.toString());
          find = false;
          for (var i in widget.listServiceContract) {
            // print("ServiceContract_ServiceId: " + i.id.toString());
            if (u.id == i.id) {
              find = true;
              break;
            }
          }
          if (find == false) {
            list.add(u);
            print("New ServiceId: " + u.id.toString());
          }
        }
        return list;
      }
    } catch (error) {
      throw (error);
    }
  }

  // @override
  // void initState() {
  //   super.initState();
  // }

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
                Navigator.pop(context, widget.listServiceContract);
              },
              child: Icon(
                MyFlutterApp.left,
                color: Colors.white,
                size: 30,
              )),
        ),
        body: Container(
            height: size.height * 0.5,
            width: size.width,
            child: FutureBuilder<List<Service>>(
              future: getListServiceHouse(), // async work
              builder: (BuildContext context,
                  AsyncSnapshot<List<Service>> snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return snapshot.data.length == 0
                      ? Container(
                          alignment: Alignment.center,
                          child: Text(
                            'Không có dịch vụ để thêm !!!',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w600),
                          ))
                      : Container(
                          width: size.width,
                          height: size.height * 0.5,
                          child: ListView.builder(
                            itemBuilder: (context, index) {
                              _isCheck.add(false);
                              return CheckboxListTile(
                                  value: _isCheck[index],
                                  title: Text('${snapshot.data[index].name}'),
                                  // Text('${list[index].name}'),
                                  subtitle: Text(
                                      '${snapshot.data[index].price} / ${snapshot.data[index].calculationUnit}'),
                                  // Text(
                                  //     '${list[index].price} / ${list[index].calculationUnit}'),
                                  activeColor: Colors.green,
                                  checkColor: Colors.black,
                                  onChanged: (bool value) {
                                    setState(() {
                                      _isCheck[index] = value;
                                      if (value == true) {
                                        widget.listServiceContract
                                            .add(snapshot.data[index]);
                                        snapshot.data
                                            .remove(snapshot.data[index]);
                                      }
                                    });
                                  });
                            },
                            itemCount: snapshot.data.length,
                          ),
                        );
                } else {
                  return Center(
                      child: SizedBox(
                          width: 30,
                          height: 30,
                          child: CircularProgressIndicator()));
                }
                // switch (snapshot.connectionState) {
                //   case ConnectionState.waiting:
                //     return Text('Loading....');
                //   default:
                //     if (snapshot.hasError)
                //       return Text('Error: ${snapshot.error}');
                //     else
                //       return
                // }
              },
            )),
      ),
    );
  }
}
