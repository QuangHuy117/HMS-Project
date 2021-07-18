import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:house_management_project/fonts/my_flutter_app_icons.dart';
import 'package:house_management_project/main.dart';
import 'package:house_management_project/models/Bill.dart';
import 'package:house_management_project/screens/Room/RoomNavigationBar.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class DisplayBillPage extends StatefulWidget {
  final dynamic bill;
  final String houseId;
  const DisplayBillPage({
    Key key,
    @required this.bill,
    @required this.houseId,
  }) : super(key: key);

  @override
  _DisplayBillPageState createState() => _DisplayBillPageState();
}

class _DisplayBillPageState extends State<DisplayBillPage> {
  String valueChoose;
  Bill bill = new Bill();
  List<bool> _isOpen = [];
  int _totalPrice = 0;
  TextEditingController note = new TextEditingController();
  var format = NumberFormat('#,###,000');
  String responseMsg = '';

  getBillData() async {
    bill = Bill.fromJson(widget.bill);
    for (var u in bill.billItems) {
      _totalPrice += u.totalPrice;
    }
    print(bill);
  }

  Future confirmBill(BuildContext context) async {
    dynamic token = await FlutterSession().get("token");
    var jsonData = null;
    var url = Uri.parse('https://$serverHost/api/bills/confirm?id=${bill.id}');
    try {
      var response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: 'Bearer ${token.toString()}'
        },
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        jsonData = response.body;
        responseMsg = 'Xác nhận hóa đơn thành công';
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (_) => RoomNavigationBar(houseId: widget.houseId)));
      }
    } catch (error) {
      throw (error);
    }
  }

  @override
  void initState() {
    super.initState();
    getBillData();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Hóa Đơn',
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
              )),
        ),
        body: SingleChildScrollView(
          child: Container(
            color: Color(0xFFF5F5F5),
            width: size.width,
            height: size.height * 0.92,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(25),
                  height: size.height * 0.84,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 4,
                        spreadRadius: 1,
                        offset: Offset(0, 5),
                      ),
                    ],
                    color: Colors.white,
                    border: Border.all(
                      width: 1,
                      color: Color(0xFFFEAF45),
                      style: BorderStyle.solid,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: 20),
                        child: Text(
                          'Chi tiết hóa đơn',
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF707070).withOpacity(1)),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 20),
                        width: size.width * 0.75,
                        child: TextField(
                          controller: note,
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              MyFlutterApp.clipboard,
                              size: 26,
                            ),
                            hintText: 'Ghi chú',
                            hintStyle: TextStyle(
                                fontSize: 20,
                                color: Color(0xFF707070).withOpacity(0.5),
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                        height: size.height * 0.4,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.grey.shade50,
                                Colors.grey.shade50
                              ],
                              stops: [0.4, 0.8],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 5,
                                spreadRadius: 2,
                                offset: Offset(2, 2),
                              ),
                            ],
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.white),
                        child: ListView.builder(
                          itemBuilder: (context, index) {
                            _isOpen.add(false);
                            return Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(bottom: 15),
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 4,
                                        spreadRadius: 1,
                                        offset: const Offset(0, 3),
                                      )
                                    ],
                                    border: Border.all(
                                        color: Colors.black, width: 1),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: ExpansionPanelList(
                                      expandedHeaderPadding:
                                          EdgeInsets.only(bottom: 15),
                                      expansionCallback:
                                          (int u, bool isExpanded) {
                                        setState(() {
                                          _isOpen[index] = !isExpanded;
                                        });
                                      },
                                      children: [
                                        ExpansionPanel(
                                          canTapOnHeader: true,
                                          headerBuilder: (BuildContext context,
                                              bool isExpanded) {
                                            return ListTile(
                                              title: Text(
                                                '${bill.billItems[index].serviceContract.service.name} - ${format.format(bill.billItems[index].serviceContract.service.price)}đ / ${bill.billItems[index].serviceContract.service.calculationUnit}',
                                                style: TextStyle(
                                                    color: Color(0xFF575757)
                                                        .withOpacity(1),
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            );
                                          },
                                          body: Column(
                                            children: [
                                              Divider(
                                                indent: 60,
                                                endIndent: 60,
                                                thickness: 2,
                                                color: PrimaryColor,
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      'Tổng ${bill.billItems[index].serviceContract.service.name} ',
                                                      style: TextStyle(
                                                          fontSize: 17,
                                                          color: Colors.blue,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                    Container(
                                                      alignment:
                                                          Alignment.centerRight,
                                                      padding: EdgeInsets.only(
                                                          top: 5),
                                                      width: size.width * 0.2,
                                                      height:
                                                          size.height * 0.03,
                                                      child: Text(
                                                          '${format.format(bill.billItems[index].totalPrice)}đ',
                                                          style: TextStyle(
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600)),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              bill
                                                      .billItems[index]
                                                      .serviceContract
                                                      .service
                                                      .serviceType
                                                      .contains('chênh lệch')
                                                  ? Container(
                                                      height:
                                                          size.height * 0.05,
                                                      margin: EdgeInsets.only(
                                                          bottom: 10),
                                                      child: Container(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 10),
                                                        margin: EdgeInsets.only(
                                                            bottom: 10),
                                                        child: Row(
                                                          children: [
                                                            Container(
                                                              width:
                                                                  size.width *
                                                                      0.35,
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceAround,
                                                                children: [
                                                                  Text(
                                                                    'Chỉ Số Đầu: ',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            17,
                                                                        color: Colors
                                                                            .blue,
                                                                        fontWeight:
                                                                            FontWeight.w600),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 10,
                                                                  ),
                                                                  Text(
                                                                    '${bill.billItems[index].startValue == null ? '0' : bill.billItems[index].startValue}',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            18,
                                                                        fontWeight:
                                                                            FontWeight.w600),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            VerticalDivider(
                                                              indent: 5,
                                                              endIndent: 5,
                                                              thickness: 2,
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                            Container(
                                                              width:
                                                                  size.width *
                                                                      0.35,
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceAround,
                                                                children: [
                                                                  Text(
                                                                    'Chỉ Số Cuối: ',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            17,
                                                                        color: Colors
                                                                            .blue,
                                                                        fontWeight:
                                                                            FontWeight.w600),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 10,
                                                                  ),
                                                                  Text(
                                                                    '${bill.billItems[index].endValue == null ? '0' : '${bill.billItems[index].endValue}'}',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            18,
                                                                        fontWeight:
                                                                            FontWeight.w600),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    )
                                                  : Container(),
                                            ],
                                          ),
                                          isExpanded: _isOpen[index],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                          itemCount: bill.billItems.length,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Tổng hóa đơn: ',
                              style: TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.w500),
                            ),
                            Text(
                              format.format(_totalPrice) + 'đ',
                              style: TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Divider(
                        thickness: 2,
                        indent: 20,
                        endIndent: 20,
                        color: Colors.grey,
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              width: size.width * 0.22,
                              height: size.height * 0.048,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                    backgroundColor: PrimaryColor,
                                  ),
                                  child: Text(
                                    'Xác nhận',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  onPressed: () {
                                    confirmBill(context).then(
                                      (value) => ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text(
                                          responseMsg,
                                          style: TextStyle(fontSize: 20),
                                        ),
                                      )),
                                    );
                                  },
                                ),
                              ),
                            ),
                            Container(
                              width: size.width * 0.22,
                              height: size.height * 0.048,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                    backgroundColor: Colors.red,
                                  ),
                                  child: Text(
                                    'Hủy bỏ',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  onPressed: () {},
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
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
