import 'dart:convert';
import 'dart:math';

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

  Future<List<Service>> getListServiceHouse() async {
    print('test1');
    list.clear();
    listService.clear();
    print(list.length);
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
        print("after");
        print(list.length);
        return list;
      }
    } catch (error) {
      throw (error);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text(
            'Th??m d???ch v???',
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
                print('test2');
                if (snapshot.connectionState == ConnectionState.done) {
                  return snapshot.data.length == 0
                      ? Container(
                          alignment: Alignment.center,
                          child: Text(
                            'Kh??ng c?? d???ch v??? ????? th??m !!!',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w600),
                          ))
                      : Container(
                          height: size.height * 0.5,
                          padding: EdgeInsets.only(top: 20, bottom: 10, left: 30, right: 30),
                          child: ListView.builder(
                            itemBuilder: (context, index) {
                              return Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: Colors.black87),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.shade200,
                                      offset: const Offset(0,5,),
                                      blurRadius: 10.0,
                                      spreadRadius: 2.0,
                                    ),
                                    BoxShadow(
                                      color: Colors.white,
                                      offset: const Offset(0.0, 0.0),
                                      blurRadius: 0.0,
                                      spreadRadius: 0.0,
                                    ),
                                  ],
                                ),
                                child: CheckboxListTile(
                                    value: !snapshot.data[index].status,
                                    title: Text('${snapshot.data[index].name}'),
                                    secondary: CircleAvatar(
                                      backgroundColor: Colors.primaries[Random().nextInt(Colors.primaries.length)],
                                        child: Text(
                                            '${snapshot.data[index].name.substring(0, 1).toUpperCase()}')),
                                    subtitle: Text(
                                        '${snapshot.data[index].price} / ${snapshot.data[index].calculationUnit}'),
                                    activeColor: Colors.green,
                                    checkColor: Colors.black,
                                    onChanged: (bool value) {
                                      setState(() {
                                        snapshot.data[index].status = value;
                                        if (value == true) {
                                          widget.listServiceContract
                                              .add(snapshot.data[index]);
                                          snapshot.data
                                              .remove(snapshot.data[index]);
                                        }
                                      });
                                    }),
                              );
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
              },
            )),
      ),
    );
  }
}
