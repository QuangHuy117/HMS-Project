import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:house_management_project/fonts/my_flutter_app_icons.dart';
import 'package:house_management_project/main.dart';
import 'package:house_management_project/models/Contract.dart';
import 'package:house_management_project/models/House.dart';
import 'package:house_management_project/screens/Tenant/TenantRoomPage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class TenantContractPage extends StatefulWidget {
  const TenantContractPage({ Key key }) : super(key: key);

  @override
  _TenantContractPageState createState() => _TenantContractPageState();
}

class _TenantContractPageState extends State<TenantContractPage> {

  List<Contract> listContract = [];
  String ownerName = '';
  String houseName = '';
  String roomName = '';

  getContractData() async {
    listContract.clear();
    dynamic token = await FlutterSession().get("token");
    var url = Uri.parse('https://$serverHost/api/contracts?status=true');
    try {
      var response = await http.get(
        url,
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer ${token.toString()}',
        },
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        var items = jsonDecode(response.body);
        setState(() {
          for (var u in items) {
            ownerName = u['ownerName'];
            houseName = u['houseName'];
            roomName = u['roomName'];
            print(ownerName);
            // House house = new House.fromJson(u);
            Contract contract = new Contract.fromJson(u);
            listContract.add(contract);
          }
        });
      }
    } catch (error) {
      throw (error);
    }
  }

  @override
  void initState() {
    super.initState();
    getContractData();
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
              elevation: 0,
              title: Text(
                'Hợp đồng',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w700),
              ),
              centerTitle: true,
              backgroundColor: PrimaryColor,
            ),
        body: Container(
              child: SingleChildScrollView(
                child: Container(
                  height: size.height * 0.85,
                  width: size.width,
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: RefreshIndicator(
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        return Container(
                          height: size.height * 0.25,
                          padding: EdgeInsets.symmetric(
                            horizontal: 25,
                          ),
                          margin: EdgeInsets.only(
                            top: 30,
                          ),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => TenantRoomPage(
                                          roomId: listContract[index].roomId,
                                        )),
                              );
                            },
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                elevation: 6,
                                shadowColor: Colors.black,
                                child: Column(
                                        children: [
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            'Hợp đồng',
                                            style: TextStyle(
                                                fontSize: 19,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          Divider(
                                            indent: 30,
                                            endIndent: 30,
                                            thickness: 1,
                                            color: Colors.grey,
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 20),
                                            child: Row(
                                              children: [
                                                Text(
                                                  'Tên Chủ trọ: ',
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                                SizedBox(
                                                  width: 20,
                                                ),
                                                Text(
                                                  ownerName== null
                                                      ? 'N/A'
                                                      : ownerName,
                                                  style:
                                                      TextStyle(fontSize: 18, color: Colors.blue),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 10,),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 20),
                                            child: Row(
                                              children: [
                                                Text(
                                                  'Tên Nhà: ',
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                                SizedBox(
                                                  width: 20,
                                                ),
                                                Text(
                                                  houseName == null
                                                      ? 'N/A'
                                                      : houseName,
                                                  style:
                                                      TextStyle(fontSize: 18, color: Colors.blue),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 10,),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 20),
                                            child: Row(
                                              children: [
                                                Text(
                                                  'Tên Phòng: ',
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                                SizedBox(
                                                  width: 20,
                                                ),
                                                Text(
                                                  roomName == null
                                                      ? 'N/A'
                                                      : roomName,
                                                  style:
                                                      TextStyle(fontSize: 18, color: Colors.blue),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 20),
                                            child: Row(
                                              children: [
                                                Text(
                                                  'Ngày Bắt Đầu: ',
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                                SizedBox(
                                                  width: 20,
                                                ),
                                                Text(
                                                  listContract[index].startDate == null
                                                      ? ''
                                                      : DateFormat('dd/MM/yyyy')
                                                          .format(listContract[index]
                                                              .startDate),
                                                  style:
                                                      TextStyle(fontSize: 18, color: Colors.blue),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 20),
                                            child: Row(
                                              children: [
                                                Text(
                                                  'Ngày Kết Thúc: ',
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                                SizedBox(
                                                  width: 20,
                                                ),
                                                Text(
                                                  listContract[index].endDate == null
                                                      ? ''
                                                      : DateFormat('dd/MM/yyyy')
                                                          .format(listContract[index]
                                                              .endDate),
                                                  style:
                                                      TextStyle(fontSize: 18, color: Colors.blue),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                // Stack(
                                //   children: [
                                //     Positioned(
                                //       top: 30,
                                //       left: 5,
                                //       child: Icon(
                                //         MyFlutterApp.home,
                                //         color: PrimaryColor,
                                //         size: 60,
                                //       ),
                                //     ),
                                //     Positioned(
                                //       top: 28,
                                //       left: 70,
                                //       child: Container(
                                //         width: size.width * 0.6,
                                //         padding: EdgeInsets.only(
                                //           right: 10,
                                //         ),
                                //         child: Column(
                                //           crossAxisAlignment:
                                //               CrossAxisAlignment.start,
                                //           children: [
                                //             Text(
                                //               'Nhà ở ${listContract[index].startDate}',
                                //               style: TextStyle(
                                //                 fontSize: 20,
                                //                 fontWeight: FontWeight.w700,
                                //               ),
                                //             ),
                                //             SizedBox(
                                //               height: 5,
                                //             ),
                                //             Text(
                                //               '${listContract[index]}',
                                //               style: TextStyle(
                                //                 fontSize: 16,
                                //               ),
                                //             ),
                                //           ],
                                //         ),
                                //       ),
                                //     ),
                                //     Positioned(
                                //       top: 15,
                                //       right: 10,
                                //       child: Text(
                                //         '${listContract[index] }',
                                //         style: TextStyle(
                                //           color: listContract[index].status
                                //               ? PrimaryColor
                                //               : Color(0xFF707070),
                                //           fontSize: 20,
                                //           fontWeight: FontWeight.w700,
                                //         ),
                                //       ),
                                //     ),
                                //   ],
                                // ),
                              ),
                          ),
                        );
                      },
                      itemCount: listContract.length,
                    ),
                    onRefresh: () => getContractData(),
                  ),
                ),
              ),
        ),
      ),
    );
  }
}