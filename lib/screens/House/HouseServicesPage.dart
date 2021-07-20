import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:house_management_project/main.dart';
import 'package:house_management_project/models/HouseServices.dart';
import 'package:house_management_project/screens/House/EditHouseServicePage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:intl/intl.dart';

class HouseServicesPage extends StatefulWidget {
  final String houseId;
  const HouseServicesPage({Key key, this.houseId}) : super(key: key);

  @override
  _HouseServicesPageState createState() => _HouseServicesPageState();
}

class _HouseServicesPageState extends State<HouseServicesPage> {
  List<HouseServices> listService = [];
  TextEditingController serviceName = new TextEditingController();
  TextEditingController unitPrice = new TextEditingController();
  TextEditingController serviceUnit = new TextEditingController();
  var format = NumberFormat('#,###,000');

  String showErr = '';
  bool expandCheck = false;
  bool _isLoading = true;
  String valueChoose;
  List listServices = ["Chênh lệch", "Cố định"];
  String responseMsg = '';

  getServicesByHouseId() async {
    listService.clear();
    var url = Uri.parse('https://$serverHost/api/houses/${widget.houseId}');
    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        setState(() {
          for (var u in jsonData['services']) {
            HouseServices houseServices = new HouseServices.fromJson(u);
            listService.add(houseServices);
            _isLoading = false;
          }
        });
      }
    } catch (error) {
      throw (error);
    }
  }

  createService(String name, String calUnit, String price, String type) async {
    dynamic token = await FlutterSession().get("token");
    var url = Uri.parse('https://$serverHost/api/services');
    try {
      var response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: 'Bearer ${token.toString()}',
        },
        body: jsonEncode({
          "houseId": widget.houseId,
          "name": name,
          "calculationUnit": calUnit,
          "price": int.parse(price),
          "serviceTypeName": "Thêm " + type
        }),
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        setState(() {
          responseMsg = "Tạo dịch vụ thành công";
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
              responseMsg,
              style: TextStyle(fontSize: 20),
            ),
          ));
          Navigator.pop(context);
          serviceName.clear();
          unitPrice.clear();
          serviceUnit.clear();
          getServicesByHouseId();
        });
      }
    } catch (error) {
      throw (error);
    }
  }

  @override
  void initState() {
    super.initState();
    getServicesByHouseId();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Color(0xFFF5F5F5),
            shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.only(
                topLeft: Radius.circular(5),
                topRight: Radius.circular(5),
              ),
            ),
            builder: (context) => StatefulBuilder(
              builder: (BuildContext context, StateSetter setModal) {
                return Padding(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Thêm dịch vụ',
                          style: TextStyle(
                              color: Colors.blue,
                              fontSize: 22,
                              fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          width: size.width * 0.7,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 5,
                                  offset: const Offset(0, 5),
                                )
                              ]),
                          child: TextField(
                            controller: serviceName,
                            textInputAction: TextInputAction.done,
                            decoration: InputDecoration(
                              hintText: 'Nhập tên dịch vụ',
                              hintStyle: TextStyle(
                                  color: Color(0xFF707070),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              fillColor: Colors.white,
                              filled: true,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          width: size.width * 0.7,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 5,
                                  offset: const Offset(0, 5),
                                )
                              ]),
                          child: TextField(
                            controller: unitPrice,
                            textInputAction: TextInputAction.done,
                            decoration: InputDecoration(
                              hintText: 'Nhập đơn giá',
                              hintStyle: TextStyle(
                                  color: Color(0xFF707070),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              fillColor: Colors.white,
                              filled: true,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 70, right: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.only(right: 10),
                                width: size.width * 0.4,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 15,
                                  ),
                                  child: DropdownButton(
                                    icon: Icon(Icons.arrow_drop_down),
                                    iconSize: 35,
                                    hint: Text('Chọn loại dịch vụ'),
                                    isExpanded: true,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    value: valueChoose,
                                    onChanged: (newValue) {
                                      setModal(() {
                                        valueChoose = newValue;
                                      });
                                    },
                                    items: listServices.map((valueItem) {
                                      return DropdownMenuItem(
                                        value: valueItem,
                                        child: Text(valueItem),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                              Container(
                                  height: size.height * 0.05,
                                  margin: EdgeInsets.only(top: 5),
                                  child: Container(
                                    width: size.width * 0.3,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black12,
                                            blurRadius: 5,
                                            offset: const Offset(0, 5),
                                          )
                                        ]),
                                    child: TextField(
                                      textAlign: TextAlign.center,
                                      controller: serviceUnit,
                                      textInputAction: TextInputAction.done,
                                      decoration: InputDecoration(
                                        labelText: "Nhập đơn vị đo",
                                        labelStyle: TextStyle(
                                            color: Color(0xFF707070),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15),
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        fillColor: Colors.white,
                                        filled: true,
                                      ),
                                    ),
                                  ))
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          showErr.isEmpty ? '' : showErr,
                          style: TextStyle(color: Colors.red),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                                vertical: 15, horizontal: 20),
                            backgroundColor: PrimaryColor,
                          ),
                          child: Text(
                            'Xác nhận',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          onPressed: () {
                            setModal(() {
                              if (serviceName.text.isEmpty ||
                                  unitPrice.text.isEmpty ||
                                  valueChoose.isEmpty ||
                                  serviceUnit.text.isEmpty) {
                                showErr = 'Thông tin không được trống !!!';
                              } else {
                                createService(
                                    serviceName.text,
                                    serviceUnit.text,
                                    unitPrice.text,
                                    valueChoose);
                              }
                            });
                          },
                        ),
                        Padding(
                            padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom,
                        )),
                      ],
                    ));
              },
            ),
          );
        },
        child: Icon(Icons.add),
        tooltip: 'Create Service',
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(top: 20),
          child: _isLoading
              ? Center(
                  child: Container(
                      height: 30,
                      width: 30,
                      child: CircularProgressIndicator()),
                )
              : Container(
                  color: Colors.white,
                  height: size.height * 0.8,
                  width: size.width,
                  padding: EdgeInsets.only(top: 15, left: 20),
                  child: RefreshIndicator(
                    onRefresh: () => getServicesByHouseId(),
                    child: GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      scrollDirection: Axis.vertical,
                      children: List.generate(listService.length, (index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => EditHouseServicePage(
                                          serviceId: listService[index].id,
                                        )));
                          },
                          child: Card(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  color: Color(0xFF707070), width: 2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Container(
                              height: size.height * 0.4,
                              padding: EdgeInsets.symmetric(
                                horizontal: 5,
                                vertical: 5,
                              ),
                              child: Column(
                                children: [
                                  Chip(
                                    label: Container(
                                        height: size.height * 0.04,
                                        width: size.width * 0.22,
                                        alignment: Alignment.center,
                                        child: Text(
                                          '${listService[index].name}',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 22,
                                              fontWeight: FontWeight.w500),
                                        )),
                                    backgroundColor: Colors.green.shade300,
                                  ),
                                  Divider(
                                    color: Colors.grey,
                                    indent: 20,
                                    endIndent: 20,
                                    thickness: 1,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            padding: EdgeInsets.only(left: 5),
                                            child: Text(
                                              'Loại dịch vụ: ',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Container(
                                            padding: EdgeInsets.only(left: 15),
                                            child: Text(
                                              'Đơn giá: ',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Container(
                                            padding: EdgeInsets.only(left: 10),
                                            child: Text(
                                              'Đơn vị tính: ',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            '${listService[index].serviceType.contains("chênh lệch") ? 'Chênh lệch' : 'Cố định'}',
                                            style: TextStyle(
                                              color: listService[index]
                                                      .serviceType
                                                      .contains("chênh lệch")
                                                  ? Colors.green
                                                  : Colors.blue,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Text(
                                            '${format.format(listService[index].price)}đ',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 18,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Text(
                                            '${listService[index].calculationUnit}',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 18,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
        ),
      ),
      // Column(
      //     children: [
      //       Container(
      //         padding: EdgeInsets.all(20),
      //         height: size.height * 0.8,
      //         decoration: BoxDecoration(
      //           color: Colors.white,
      //         ),
      //         child: ListView.builder(
      //           itemBuilder: (context, index) {
      //             listIsEdit.add(false);
      //             listIsOpen.add(false);
      //             return Row(children: [
      //               Column(
      //                 crossAxisAlignment:
      //                     CrossAxisAlignment.start,
      //                 children: [
      //                   Container(
      //                     margin: EdgeInsets.only(
      //                       bottom: 15,
      //                     ),
      //                     child: GestureDetector(
      //                       onTap: () {
      //                         setState(() {
      //                           listIsEdit[index] =
      //                               !listIsEdit[index];
      //                         });
      //                       },
      //                       child: Card(
      //                         elevation: 3,
      //                         shape: RoundedRectangleBorder(
      //                           side: BorderSide(
      //                               color:
      //                                   Color(0xFF707070),
      //                               width: 2),
      //                           borderRadius:
      //                               BorderRadius.circular(
      //                                   10),
      //                         ),
      //                         child: Container(
      //                           height: size.height * 0.07,
      //                           width: size.width * 0.4,
      //                           padding:
      //                               EdgeInsets.symmetric(
      //                             horizontal: 10,
      //                           ),
      //                           child: Row(
      //                             children: [
      //                               Text(
      //                                 '${listService[index].name}',
      //                                 style: TextStyle(
      //                                   color: Colors.black,
      //                                   fontSize: 18,
      //                                   fontWeight:
      //                                       FontWeight.w500,
      //                                 ),
      //                               ),
      //                               // Positioned(
      //                               //   top: 25,
      //                               //   left: 100,
      //                               //   child: Text(
      //                               //     '${listService[index].serviceType.contains("chênh lệch") ? 'Chênh lệch' : 'Cố định'}',
      //                               //     style: TextStyle(
      //                               //       color: listService[
      //                               //                   index]
      //                               //               .serviceType
      //                               //               .contains(
      //                               //                   "chênh lệch")
      //                               //           ? Colors.green
      //                               //           : Colors.blue,
      //                               //       fontSize: 18,
      //                               //       fontWeight:
      //                               //           FontWeight.w500,
      //                               //     ),
      //                               //   ),
      //                               // ),
      //                               // Positioned(
      //                               //   top: 25,
      //                               //   right: 5,
      //                               //   child: Text(
      //                               //     '${listService[index].price}đ/${listService[index].calculationUnit}',
      //                               //     style: TextStyle(
      //                               //       color: Colors.black,
      //                               //       fontSize: 18,
      //                               //       fontWeight:
      //                               //           FontWeight.w500,
      //                               //     ),
      //                               //   ),
      //                               // ),
      //                             ],
      //                           ),
      //                         ),
      //                       ),
      //                     ),
      //                   ),
      //                 ],
      //               ),
      //               Visibility(
      //                 visible: listIsOpen[index],
      //                 child: Container(
      //                   child: Row(
      //                     children: [Text('aaa')],
      //                   ),
      //                 ),
      //               ),
      //             ]);
      //           },
      //           itemCount: listService.length,
      //         ),
      //       ),
      //   ],
      // ),
    );
  }

  // expandUnitText(bool value) {
  //   if (value == true) {
  //     return Container(
  //       child: Text('Expand'),
  //     );
  //   } else {
  //     return Container();
  //   }
  // }
}
