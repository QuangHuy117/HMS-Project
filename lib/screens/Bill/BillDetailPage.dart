import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:house_management_project/fonts/my_flutter_app_icons.dart';
import 'package:house_management_project/main.dart';
import 'package:house_management_project/models/Bill.dart';
import 'package:house_management_project/models/BillItem.dart';
import 'package:house_management_project/models/Payment.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class BillDetailPage extends StatefulWidget {
  final int billId;
  const BillDetailPage({Key key, @required this.billId}) : super(key: key);

  @override
  _BillDetailPageState createState() => _BillDetailPageState();
}

class _BillDetailPageState extends State<BillDetailPage> {
  Bill bill = new Bill();
  List<BillItem> listBillItem = [];
  List<Payment> listPayment = [];
  var format = NumberFormat('#,###,000');
  List<bool> _isOpen = [];
  TextEditingController note = new TextEditingController();

  getBillById() async {
    var url = Uri.parse('https://$serverHost/api/bills/${widget.billId}');
    try {
      var response = await http.get(url);
      print(response.statusCode);
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        setState(() {
          bill = Bill.fromJson(jsonData);
          listBillItem = bill.billItems;
          listPayment = bill.payments;
          // _isLoading = false;
          print(bill);
        });
      }
    } catch (error) {
      throw (error);
    }
  }

  Widget checkInstance(Size size, bool status) {
    if (status == true) {
      return Container(
        padding: EdgeInsets.only(left: size.width * 0.01),
          child: Text(
            'Chấp nhận',
            style: TextStyle(
                color: Colors.black, fontSize: 14, fontWeight: FontWeight.w700),
          ),
        );
    } else if (status == false) {
      return Container(
        padding: EdgeInsets.only(left: size.width * 0.01),
          child: Text(
            'Từ chối',
            style: TextStyle(
                color: Colors.black, fontSize: 14, fontWeight: FontWeight.w700),
          ),
        );
    } else {
      return Container(
        padding: EdgeInsets.only(left: size.width * 0.01),
          child: Text(
            'Đã xác nhận',
            style: TextStyle(
                color: Colors.black, fontSize: 14, fontWeight: FontWeight.w700),
          ),
        );
    }
     
  }

  @override
  void initState() {
    super.initState();
    getBillById();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Thông Tin Hóa Đơn',
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
        body: SingleChildScrollView(
          child: Container(
            height: size.height,
            width: size.width,
            padding: EdgeInsets.only(top: 15),
            child: Column(
              children: [
                Container(
                    alignment: Alignment.center,
                    child: Text(
                      bill.issueDate == null
                          ? 'N/A'
                          : 'Hóa đơn tháng ' +
                              DateFormat('M/yyyy').format(bill.issueDate),
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                    )),
                Divider(
                  color: Colors.grey.shade300,
                  thickness: 1,
                  indent: 20,
                  endIndent: 20,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        child: Text(
                          'Ngày tạo hóa đơn: ',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                      ),
                      Container(
                        child: Text(
                          bill.issueDate == null
                              ? 'N/A'
                              : DateFormat('dd/MM/yyyy').format(bill.issueDate),
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: size.height * 0.01,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        child: Text(
                          'Ngày bắt đầu: ',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                      ),
                      Container(
                        child: Text(
                          bill.startDate == null
                              ? 'N/A'
                              : DateFormat('dd/MM/yyyy').format(bill.startDate),
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: size.height * 0.01,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        child: Text(
                          'Ngày kết thúc: ',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                      ),
                      Container(
                        child: Text(
                          bill.endDate == null
                              ? 'N/A'
                              : DateFormat('dd/MM/yyyy').format(bill.endDate),
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: size.height * 0.01,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        child: Text(
                          'Trạng thái hóa đơn: ',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                      ),
                      Container(
                        child: Text(
                          bill.status == null
                              ? 'N/A'
                              : bill.status
                                  ? 'Đã thanh toán'
                                  : 'Chưa thanh toán',
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: size.height * 0.01,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        child: Text(
                          'Ghi chú: ',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                      ),
                      Container(
                        child: Text(
                          bill.note == null ? 'N/A' : bill.note,
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(
                  color: Colors.grey.shade300,
                  thickness: 8,
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left: size.width * 0.02),
                  child: Text('Hóa đơn gồm: ',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: Colors.black)),
                ),
                SizedBox(
                  height: size.height * 0.01,
                ),
                Container(
                  width: size.width * 0.8,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                        height: size.height * 0.3,
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
                                                '${listBillItem[index].serviceContract.service.name} - ${format.format(listBillItem[index].totalPrice)}đ',
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
                                                    horizontal: 20),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      'Đơn Giá: ',
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
                                                      width: size.width * 0.35,
                                                      height:
                                                          size.height * 0.03,
                                                      child: Text(
                                                          '${format.format(listBillItem[index].serviceContract.service.price)}đ / ${listBillItem[index].serviceContract.service.calculationUnit}',
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
                                                                    '${listBillItem[index].startValue == null ? '0' : listBillItem[index].startValue}',
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
                                                                    '${listBillItem[index].endValue == null ? '0' : '${listBillItem[index].endValue}'}',
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
                          itemCount: listBillItem.length,
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.01,
                      ),
                      Container(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'Tổng hóa đơn: ' +
                              format.format(bill.totalPrice) +
                              'đ',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.01,
                      ),
                    ],
                  ),
                ),
                Divider(
                  color: Colors.grey.shade300,
                  thickness: 10,
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left: size.width * 0.02),
                  child: Text('Lịch sử thanh toán: ',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: Colors.black)),
                ),
                SizedBox(
                  height: size.height * 0.01,
                ),
                Container(
                  height: size.height * 0.35,
                  width: size.width,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      return Container(
                        height: size.height * 0.1,
                        width: size.width,
                        margin: EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.only(left: size.width * 0.01),
                              width: size.width * 0.18,
                              height: size.height * 0.2,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  border: Border(
                                      right: BorderSide(
                                          color: Colors.grey, width: 1))),
                              child: Text(
                                listPayment[index].date == null
                                    ? 'N/A'
                                    : DateFormat('dd/MM/yyyy')
                                        .format(listPayment[index].date),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(left: 10),
                              alignment: Alignment.centerLeft,
                              height: size.height * 0.2,
                              width: size.width * 0.42,
                              decoration: BoxDecoration(
                                  border: Border(
                                      right: BorderSide(
                                          color: Colors.grey, width: 1))),
                              child: Container(
                                child: Text(listPayment[index].note == null
                                    ? 'N/A'
                                    : listPayment[index].note),
                              ),
                            ),
                            listPayment[index].isConfirmed
                                ? checkInstance(size, listPayment[index].status)
                                : Container(
                                    width: size.width * 0.16,
                                    height: size.height * 0.048,
                                    margin: EdgeInsets.only(right: 5, left: 5),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10.0),
                                      child: TextButton(
                                        style: TextButton.styleFrom(
                                          backgroundColor: Colors.green,
                                        ),
                                        child: Text(
                                          'Xác nhận',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w700),
                                        ),
                                        onPressed: () {
                                          showNoteModal();
                                        },
                                      ),
                                    ),
                                  ),
                            listPayment[index].isConfirmed
                                ? Container()
                                : Container(
                                    width: size.width * 0.16,
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
                                              fontSize: 14,
                                              fontWeight: FontWeight.w700),
                                        ),
                                        onPressed: () {
                                          showNoteModal();
                                        },
                                      ),
                                    ),
                                  ),
                          ],
                        ),
                      );
                    },
                    itemCount: listPayment.length,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  showNoteModal() {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.grey.shade200,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter stateModel) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Lý Do',
                    style: TextStyle(
                        color: Colors.blue,
                        fontSize: 22,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.7,
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
                      controller: note,
                      textInputAction: TextInputAction.done,
                      maxLines: 2,
                      decoration: InputDecoration(
                        hintText: 'Lý do',
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
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                      backgroundColor: PrimaryColor,
                    ),
                    child: Text(
                      'Gửi',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    onPressed: () {
                      stateModel(() {});
                    },
                  ),
                  Padding(
                      padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  )),
                ],
              ),
            );
          });
        });
  }
}
