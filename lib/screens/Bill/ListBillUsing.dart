import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:house_management_project/models/Bill.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class ListBillUsing extends StatefulWidget {
  const ListBillUsing({
    Key key,
  }) : super(key: key);

  @override
  _ListBillUsingState createState() => _ListBillUsingState();
}

class _ListBillUsingState extends State<ListBillUsing> {
  List<Bill> listBill = [];
  List _listPrice = [];
  int _price = 0;
  var format = NumberFormat('#,###,000');
  List<bool> _isOpen = [];

  getListBill() async {
    dynamic token = await FlutterSession().get("token");
    // dynamic username = await FlutterSession().get("username");
    var url = Uri.parse(
        'https://localhost:44322/api/bills?contractId=1&status=true');
    try {
      var response = await http.get(url, 
      headers: {
      HttpHeaders.authorizationHeader: 'Bearer ${token.toString()}',
    },
      );
      if (response.statusCode == 200) {
        setState(() {
          listBill = billFromJson(response.body);
          for (var u in listBill) {
            for (var i in u.billItems) {
              _price += i.totalPrice;
            }
            _listPrice.add(_price);
            _price = 0;
          }
          print(_listPrice);
        });
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
    Size size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.only(top: 20, right: 20, left: 20),
      child: ListView.builder(
        itemBuilder: (context, index) {
          _isOpen.add(false);
          return Container(
            height: size.height * 0.31,
            margin: EdgeInsets.only(bottom: 20),
            child: Card(
              // shape: RoundedRectangleBorder(
              //   borderRadius: BorderRadius.only(
              //       topLeft: Radius.circular(10),
              //       bottomLeft: Radius.circular(10),
              //       topRight: Radius.circular(10),
              //       bottomRight: Radius.circular(10)),
              // ),
              elevation: 5,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.only(
                        top: 10,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              alignment: Alignment.center,
                              child: Text(
                                'Hóa đơn tháng ' +
                                    DateFormat('M/yyyy')
                                        .format(listBill[index].issueDate),
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w700),
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
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Ngày tạo hóa đơn: ',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey.shade700),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  DateFormat('dd/MM/yyyy')
                                      .format(listBill[index].issueDate),
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.blue),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Người thanh toán: ',
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.grey.shade700,
                                      fontWeight: FontWeight.w600),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  '${listBill[index].contract.tenant.name}',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.blue),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Tổng tiền: ',
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.grey.shade700,
                                      fontWeight: FontWeight.w600),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  format.format(_listPrice[index]) + 'đ',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.blue),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Trạng thái: ',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey.shade700),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  '${listBill[index].status == true ? 'Đã thanh toán' : ''}',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.blue),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Divider(
                            color: Colors.grey,
                            indent: 60,
                            endIndent: 60,
                            thickness: 1,
                          ),
                          Container(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: ExpansionPanelList(
                                expandedHeaderPadding: EdgeInsets.only(
                                  bottom: 5,
                                ),
                                expansionCallback: (int u, bool isExpanded) {
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
                                          'Ghi chú',
                                          style: TextStyle(
                                              color: Colors.grey.shade700,
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      );
                                    },
                                    body: listBill[index].note == null
                                        ? Container(
                                            padding: EdgeInsets.only(
                                                right: 20,
                                                left: 20,
                                                bottom: 10),
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              'N/A',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          )
                                        : Container(
                                            child: Text(
                                                '${listBill[index].note}',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.w600)),
                                          ),
                                    isExpanded: _isOpen[index],
                                  ),
                                ],
                              ),
                            ),
                            // Text(
                            //   '${listBill[index].note == null ? 'N/A' : listBill[index]}',
                            //   style: TextStyle(
                            //       fontSize: 18, fontWeight: FontWeight.w500),
                            // ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        itemCount: listBill.length,
      ),
    );
  }
}
