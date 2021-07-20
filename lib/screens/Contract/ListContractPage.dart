import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:house_management_project/main.dart';
import 'package:house_management_project/models/Contract.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class ListContractPage extends StatefulWidget {
  const ListContractPage({Key key}) : super(key: key);

  @override
  _ListContractPageState createState() => _ListContractPageState();
}

class _ListContractPageState extends State<ListContractPage> {
  List<Contract> listContract = [];
  String valueChoose;
  List listItem = ['Còn hiệu lực', 'Hết hiệu lực', 'Đã hủy'];
  var _currentItemSelected = 'Còn hiệu lực';
  String responseMsg = '';
  bool _isLoading = true;
  var format = NumberFormat('#,###,000');

  getList(String value) async {
    dynamic token = await FlutterSession().get("token");
    if (value == 'Còn hiệu lực') {
      var url = Uri.parse(
          'https://$serverHost/api/contracts?Status=true&IsDeleted=false');
      try {
        var response = await http.get(url, headers: {
          HttpHeaders.authorizationHeader: 'Bearer ${token.toString()}'
        });
        print(response.statusCode);
        if (response.statusCode == 200) {
          print(response.body);
          setState(() {
            listContract = contractFromJson(response.body);
            _isLoading = false;
            print(listContract.length);
          });
        }
        if (response.statusCode == 404) {
          setState(() {
            responseMsg = 'Không có hợp đồng';
          });
        }
      } catch (error) {
        throw (error);
      }
    } else if (value == 'Hết hiệu lực') {
      var url = Uri.parse(
          'https://$serverHost/api/contracts?Status=false&IsDeleted=false');
      try {
        var response = await http.get(url);
        print(response.statusCode);
        if (response.statusCode == 200) {
          print(response.body);
          setState(() {
            listContract = contractFromJson(response.body);
            _isLoading = false;
            print(listContract.length);
          });
        }
        if (response.statusCode == 404) {
          setState(() {
            responseMsg = 'Không có hợp đồng';
          });
        }
      } catch (error) {
        throw (error);
      }
    } else {
      var url = Uri.parse('https://$serverHost/api/contracts?IsDeleted=true');
      try {
        var response = await http.get(url);
        print(response.statusCode);
        if (response.statusCode == 200) {
          print(response.body);
          setState(() {
            listContract = contractFromJson(response.body);
            _isLoading = false;
            print(listContract.length);
          });
        }
        if (response.statusCode == 404) {
          setState(() {
            responseMsg = 'Không có hợp đồng';
          });
        }
      } catch (error) {
        throw (error);
      }
    }
  }

  getListContract() async {
    dynamic token = await FlutterSession().get("token");
    var url = Uri.parse('https://$serverHost/api/contracts');
    try {
      var response = await http.get(
        url,
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer ${token.toString()}',
        },
      );
      if (response.statusCode == 200) {
        var items = jsonDecode(response.body);
        print(items);
        setState(() {
          _isLoading = false;
          for (var u in items) {
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
    // getListContract();
    getList(_currentItemSelected);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
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
        ),
        body: SingleChildScrollView(
          child: Container(
            height: size.height * 0.95,
            width: size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: size.width,
                  height: size.height * 0.08,
                  padding: EdgeInsets.only(top: 5, right: 10, left: 25),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                        ),
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 2,
                              offset:
                                  Offset(0, 3),
                            ),
                          ],
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: DropdownButton(
                          icon: Icon(Icons.arrow_drop_down),
                          iconSize: 40,
                          underline: SizedBox(),
                          items: listItem.map((valueItem) {
                            return DropdownMenuItem<String>(
                              value: valueItem,
                              child: Text(valueItem),
                            );
                          }).toList(),
                          onChanged: (String newValue) {
                            setState(() {
                              _isLoading = true;
                              responseMsg = '';
                              this._currentItemSelected = newValue;
                              getList(this._currentItemSelected);
                            });
                          },
                          value: _currentItemSelected,
                        ),
                      ),
                    ],
                  ),
                ),
                responseMsg.isNotEmpty
                    ? Center(
                        child: Text(
                          responseMsg,
                          style: TextStyle(fontSize: 20),
                        ),
                      )
                    : _isLoading
                        ? Center(
                            child: Container(
                              alignment: Alignment.bottomCenter,
                              height: 50,
                              width: 50,
                              child: CircularProgressIndicator(),
                            ),
                          )
                        : Container(
                            height: size.height * 0.83,
                            width: size.width,
                            padding:
                                EdgeInsets.only(top: 10, right: 20, left: 20),
                            child: ListView.builder(
                              itemBuilder: (context, index) {
                                return Container(
                                  height: size.height * 0.25,
                                  margin: EdgeInsets.only(bottom: 20),
                                  child: GestureDetector(
                                    onTap: () {
                                      // Navigator.push(context, MaterialPageRoute(builder: (_) =>
                                      // Contrac))
                                    },
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(20),
                                            bottomLeft: Radius.circular(20),
                                            topRight: Radius.circular(20),
                                            bottomRight: Radius.circular(20)),
                                      ),
                                      elevation: 5,
                                      child: SingleChildScrollView(
                                        child: Column(
                                          children: [
                                            Container(
                                              padding: EdgeInsets.only(
                                                top: 10,
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                      alignment: Alignment.center,
                                                      child: Text(
                                                        'Hợp đồng khách hàng: ' +
                                                            listContract[index]
                                                                .tenant
                                                                .name,
                                                        style: TextStyle(
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight.w700),
                                                      )),
                                                  Divider(
                                                    color: Colors.grey,
                                                    indent: 20,
                                                    endIndent: 20,
                                                    thickness: 1,
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Container(
                                                    padding: EdgeInsets.symmetric(
                                                        horizontal: 15),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          'Tên phòng: ',
                                                          style: TextStyle(
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight.w600,
                                                              color: Colors
                                                                  .grey.shade700),
                                                        ),
                                                        SizedBox(
                                                          width: 20,
                                                        ),
                                                        Text(
                                                          listContract[index]
                                                              .roomName,
                                                          style: TextStyle(
                                                              fontSize: 17,
                                                              fontWeight:
                                                                  FontWeight.w500,
                                                              color: Colors.blue),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Container(
                                                    padding: EdgeInsets.symmetric(
                                                        horizontal: 15),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          'Ngày bắt đầu: ',
                                                          style: TextStyle(
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight.w600,
                                                              color: Colors
                                                                  .grey.shade700),
                                                        ),
                                                        SizedBox(
                                                          width: 20,
                                                        ),
                                                        Text(
                                                          DateFormat('dd/MM/yyyy')
                                                              .format(
                                                                  listContract[
                                                                          index]
                                                                      .startDate),
                                                          style: TextStyle(
                                                              fontSize: 17,
                                                              fontWeight:
                                                                  FontWeight.w500,
                                                              color: Colors.blue),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Container(
                                                    padding: EdgeInsets.symmetric(
                                                        horizontal: 15),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          'Ngày kết thúc: ',
                                                          style: TextStyle(
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight.w600,
                                                              color: Colors
                                                                  .grey.shade700),
                                                        ),
                                                        SizedBox(
                                                          width: 20,
                                                        ),
                                                        Text(
                                                          DateFormat('dd/MM/yyyy')
                                                              .format(
                                                                  listContract[
                                                                          index]
                                                                      .endDate),
                                                          style: TextStyle(
                                                              fontSize: 17,
                                                              fontWeight:
                                                                  FontWeight.w500,
                                                              color: Colors.blue),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Container(
                                                    padding: EdgeInsets.symmetric(
                                                        horizontal: 15),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          'Tiền phòng: ',
                                                          style: TextStyle(
                                                              fontSize: 20,
                                                              color: Colors
                                                                  .grey.shade700,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                        ),
                                                        SizedBox(
                                                          width: 20,
                                                        ),
                                                        Text(
                                                          '${listContract[index].roomPrice == null ? "N/A" : format.format(listContract[index].roomPrice)}đ',
                                                          style: TextStyle(
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight.w500,
                                                              color: Colors.blue),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Container(
                                                    padding: EdgeInsets.symmetric(
                                                        horizontal: 15),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          'Trạng thái: ',
                                                          style: TextStyle(
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight.w600,
                                                              color: Colors
                                                                  .grey.shade700),
                                                        ),
                                                        SizedBox(
                                                          width: 20,
                                                        ),
                                                        Text(
                                                          '${listContract[index].isDeleted == true ? 'Đã hủy' : listContract[index].status == true ? 'Còn hiệu lực' : 'Hết hiệu lực'}',
                                                          style: TextStyle(
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight.w500,
                                                              color: Colors.blue),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  // Container(
                                                  //   child: ClipRRect(
                                                  //     borderRadius: BorderRadius.circular(10),
                                                  //     child: ExpansionPanelList(
                                                  //       expandedHeaderPadding:
                                                  //           EdgeInsets.only(
                                                  //         bottom: 5,
                                                  //       ),
                                                  //       expansionCallback:
                                                  //           (int u, bool isExpanded) {
                                                  //         setState(() {
                                                  //           _isOpen[index] = !isExpanded;
                                                  //         });
                                                  //       },
                                                  //       children: [
                                                  //         ExpansionPanel(
                                                  //           canTapOnHeader: true,
                                                  //           headerBuilder:
                                                  //               (BuildContext context,
                                                  //                   bool isExpanded) {
                                                  //             return ListTile(
                                                  //               title: Text(
                                                  //                 'Ghi chú',
                                                  //                 style: TextStyle(
                                                  //                     color: Colors
                                                  //                         .grey.shade700,
                                                  //                     fontSize: 20,
                                                  //                     fontWeight:
                                                  //                         FontWeight.w600),
                                                  //               ),
                                                  //             );
                                                  //           },
                                                  //           body: listBill[index].note == null
                                                  //               ? Container(
                                                  //                   padding: EdgeInsets.only(
                                                  //                       right: 20,
                                                  //                       left: 20,
                                                  //                       bottom: 10),
                                                  //                   alignment:
                                                  //                       Alignment.centerLeft,
                                                  //                   child: Text(
                                                  //                     'N/A',
                                                  //                     style: TextStyle(
                                                  //                         fontSize: 16,
                                                  //                         color: Colors.black,
                                                  //                         fontWeight:
                                                  //                             FontWeight
                                                  //                                 .w600),
                                                  //                   ),
                                                  //                 )
                                                  //               : Container(
                                                  //                   child: Text(
                                                  //                       '${listBill[index].note}',
                                                  //                       style: TextStyle(
                                                  //                           fontSize: 16,
                                                  //                           color:
                                                  //                               Colors.black,
                                                  //                           fontWeight:
                                                  //                               FontWeight
                                                  //                                   .w600)),
                                                  //                 ),
                                                  //         ),
                                                  //       ],
                                                  //     ),
                                                  //   ),
                                                  // ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                              itemCount: listContract.length,
                            ),
                          ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
