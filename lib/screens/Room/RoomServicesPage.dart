import 'package:flutter/material.dart';
import 'package:house_management_project/fonts/my_flutter_app_icons.dart';
import 'package:house_management_project/main.dart';
import 'package:house_management_project/models/ServiceContracts.dart';
import 'package:house_management_project/screens/Bill/DisplayBillPage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:intl/intl.dart';

class RoomServicesPage extends StatefulWidget {
  final int roomId;
  final String houseId;
  RoomServicesPage({Key key,
  @required this.roomId,
  @required this.houseId,}) : super(key: key);

  @override
  _RoomServicesPageState createState() => _RoomServicesPageState();
}

class _RoomServicesPageState extends State<RoomServicesPage> {
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();
  List<TextEditingController> _controllers = [];
  List listServiceContractId = [];
  List listServiceValue = [];
  int contractIdValue = 0;
  TextEditingController startDatePicked = new TextEditingController();
  TextEditingController endDatePicked = new TextEditingController();
  List<ServiceContracts> listService = [];
  Map<String, dynamic> test = new Map();
  List<Map<String, dynamic>> listMap = [];
  String valueChoose;
  List<bool> _isOpen = [];

  getRoomService() async {
    var url = Uri.parse('https://localhost:44322/api/rooms/${widget.roomId}');
    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        setState(() {
          for (var u in jsonData['contract']['serviceContracts']) {
            ServiceContracts service = ServiceContracts.fromJson(u);
            listService.add(service);
          }
        });
      }
    } catch (error) {
      throw (error);
    }
  }

  getData(String value, int serviceContractId, int contractId) {
    test = {
      "serviceContractId": serviceContractId,
      "startValue": 0,
      "endValue": int.parse(value),
    };
    listMap.add(test);
    contractIdValue = contractId;
  }

  sendServiceRoomData(
      int conId, String startDate, String endDate, List createBillItems) async {
    var jsonData = null;
    var url = Uri.parse('https://localhost:44322/api/bills');
    try {
      var response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          "contractId": conId,
          "issueDate": DateTime.now().toIso8601String(),
          "startDate": DateTime.parse(startDate).toIso8601String(),
          "endDate": DateTime.parse(endDate).toIso8601String(),
          "createBillItems": createBillItems,
        }),
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        jsonData = jsonDecode(response.body);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DisplayBillPage(
                      bill: jsonData,
                      houseId: widget.houseId,
                    )));
      }
    } catch (error) {
      throw (error);
    }
  }

  _selectedDateTime(
      BuildContext context, DateTime date, TextEditingController text) async {
    var _pickedDate = await showDatePicker(
        context: context,
        initialDate: date,
        firstDate: DateTime(2000),
        lastDate: DateTime(2025));

    if (_pickedDate != null) {
      setState(() {
        date = _pickedDate;
        text.text = DateFormat('dd/MM/yyyy').format(date);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getRoomService();
  }

  @override
  void dispose() {
    super.dispose();
    for (TextEditingController c in _controllers) {
      c.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Container(
        color: Colors.white,
        width: size.width,
        height: size.height * 0.9,
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        child: Align(
          alignment: Alignment.topCenter,
          child: Container(
            height: size.height * 0.8,
            padding: EdgeInsets.only(
              top: 15,
              right: 20,
              left: 20,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 5,
                  spreadRadius: 3,
                  offset: const Offset(0, 3),
                )
              ],
              border: Border.all(
                width: 2,
                color: Color(0xFFFEAF45),
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Text(
                  'Bảng dịch vụ',
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Colors.blue),
                ),
                SizedBox(
                  height: 10,
                ),
                Divider(
                  indent: 10,
                  endIndent: 10,
                  thickness: 2,
                  color: Color(0xFFFEAF45),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  height: size.height * 0.42,
                  decoration: BoxDecoration(
                      // gradient: LinearGradient(
                      //   colors: [Colors.grey.shade100, Colors.grey.shade100],
                      //   stops: [0.4, 0.8],
                      //   begin: Alignment.topLeft,
                      //   end: Alignment.bottomRight,
                      // ),
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
                      listServiceContractId.add(listService[index].id);
                      _controllers.add(new TextEditingController());
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
                              border: Border.all(color: Colors.black, width: 1),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: ExpansionPanelList(
                                expandedHeaderPadding:
                                    EdgeInsets.only(bottom: 15),
                                expansionCallback: (int u, bool isExpanded) {
                                  setState(() {
                                    _isOpen[index] = !isExpanded;
                                  });
                                },
                                children: [
                                  ExpansionPanel(
                                    canTapOnHeader: true,
                                    backgroundColor: Colors.white,
                                    headerBuilder: (BuildContext context,
                                        bool isExpanded) {
                                      return ListTile(
                                        title: Text(
                                          '${listService[index].service.name} - ${listService[index].unitPrice} / ${listService[index].service.calculationUnit}',
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600),
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
                                          height: 20,
                                        ),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 18),
                                          margin: EdgeInsets.only(bottom: 20),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'Loại dịch vụ: ',
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.grey,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                              Container(
                                                alignment:
                                                    Alignment.centerRight,
                                                width: size.width * 0.5,
                                                // decoration: BoxDecoration(
                                                // border: Border.all(
                                                //     color: Colors.black,
                                                //     width: 2),
                                                // borderRadius:
                                                //     BorderRadius.circular(10),
                                                // ),
                                                child: Text(
                                                    '${listService[index].service.serviceType.contains('chênh lệch') ? 'Chênh lệch' : 'Cố định'}',
                                                    style: listService[index]
                                                            .service
                                                            .serviceType
                                                            .contains(
                                                                'chênh lệch')
                                                        ? TextStyle(
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: Colors.green)
                                                        : TextStyle(
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color:
                                                                Colors.blue)),
                                              ),
                                            ],
                                          ),
                                        ),
                                        listService[index]
                                                .service
                                                .serviceType
                                                .contains('chênh lệch')
                                            ? Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 20),
                                                margin:
                                                    EdgeInsets.only(bottom: 15),
                                                child:
                                                    listService[index]
                                                            .service
                                                            .serviceType
                                                            .contains('Thêm')
                                                        ? Column(
                                                            children: [
                                                              Container(
                                                                margin: EdgeInsets
                                                                    .only(
                                                                        bottom:
                                                                            15),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Text(
                                                                      'Nhập chỉ số đầu: ',
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              18,
                                                                          color: Colors
                                                                              .grey,
                                                                          fontWeight:
                                                                              FontWeight.w600),
                                                                    ),
                                                                    Container(
                                                                      width: size
                                                                              .width *
                                                                          0.12,
                                                                      height: size
                                                                              .height *
                                                                          0.03,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        border: Border(
                                                                            bottom:
                                                                                BorderSide(color: Colors.black87, width: 2)),
                                                                      ),
                                                                      child:
                                                                          TextField(
                                                                        controller:
                                                                            _controllers[index],
                                                                        keyboardType:
                                                                            TextInputType.number,
                                                                        textAlign:
                                                                            TextAlign.right,
                                                                        decoration:
                                                                            InputDecoration(
                                                                          hintText:
                                                                              '0',
                                                                          hintStyle: TextStyle(
                                                                              fontSize: 17,
                                                                              color: Colors.black87),
                                                                        ),
                                                                        onSubmitted:
                                                                            (value) {
                                                                          _controllers[index].text =
                                                                              value;
                                                                          getData(
                                                                              _controllers[index].text,
                                                                              listService[index].id,
                                                                              listService[index].contractId);
                                                                        },
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Text(
                                                                    'Nhập chỉ số cuối: ',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            18,
                                                                        color: Colors
                                                                            .grey,
                                                                        fontWeight:
                                                                            FontWeight.w600),
                                                                  ),
                                                                  Container(
                                                                    width: size
                                                                            .width *
                                                                        0.12,
                                                                    height: size
                                                                            .height *
                                                                        0.03,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      border: Border(
                                                                          bottom: BorderSide(
                                                                              color: Colors.black87,
                                                                              width: 2)),
                                                                    ),
                                                                    child:
                                                                        TextField(
                                                                      controller:
                                                                          _controllers[
                                                                              index],
                                                                      keyboardType:
                                                                          TextInputType
                                                                              .number,
                                                                      textAlign:
                                                                          TextAlign
                                                                              .right,
                                                                      decoration:
                                                                          InputDecoration(
                                                                        hintText:
                                                                            '0',
                                                                        hintStyle: TextStyle(
                                                                            fontSize:
                                                                                17,
                                                                            color:
                                                                                Colors.black87),
                                                                      ),
                                                                      onSubmitted:
                                                                          (value) {
                                                                        _controllers[index].text =
                                                                            value;
                                                                        getData(
                                                                            _controllers[index].text,
                                                                            listService[index].id,
                                                                            listService[index].contractId);
                                                                      },
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                            ],
                                                          )
                                                        : Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                'Nhập chỉ số: ',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        18,
                                                                    color: Colors
                                                                        .grey,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600),
                                                              ),
                                                              Container(
                                                                width:
                                                                    size.width *
                                                                        0.12,
                                                                height:
                                                                    size.height *
                                                                        0.03,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  border: Border(
                                                                      bottom: BorderSide(
                                                                          color: Colors
                                                                              .black87,
                                                                          width:
                                                                              2)),
                                                                ),
                                                                child:
                                                                    TextField(
                                                                  controller:
                                                                      _controllers[
                                                                          index],
                                                                  keyboardType:
                                                                      TextInputType
                                                                          .number,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .right,
                                                                  decoration:
                                                                      InputDecoration(
                                                                    hintText:
                                                                        // '${listService[index].clock.clockValues[index].status == true ? listService[index].clock.clockValues[index].indexValue : ''}',
                                                                        '0',
                                                                    hintStyle: TextStyle(
                                                                        fontSize:
                                                                            17,
                                                                        color: Colors
                                                                            .black87),
                                                                  ),
                                                                  onSubmitted:
                                                                      (value) {
                                                                    _controllers[
                                                                            index]
                                                                        .text = value;
                                                                    getData(
                                                                        _controllers[index]
                                                                            .text,
                                                                        listService[index]
                                                                            .id,
                                                                        listService[index]
                                                                            .contractId);
                                                                  },
                                                                ),
                                                              )
                                                            ],
                                                          ))
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
                    itemCount: listService.length,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Ngày tính hóa đơn',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.blue),
                ),
                SizedBox(
                  height: 10,
                ),
                Divider(
                  indent: 60,
                  endIndent: 60,
                  thickness: 2,
                  color: Color(0xFFFEAF45),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 20),
                  width: size.width * 0.78,
                  child: TextField(
                    controller: startDatePicked,
                    decoration: InputDecoration(
                      icon: GestureDetector(
                        onTap: () {
                          _selectedDateTime(
                              context, _startDate, startDatePicked);
                        },
                        child: Icon(
                          MyFlutterApp.calendar,
                          size: 30,
                        ),
                      ),
                      hintText: 'Ngày đầu tháng hóa đơn',
                      hintStyle: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 20),
                  width: size.width * 0.78,
                  child: TextField(
                    controller: endDatePicked,
                    decoration: InputDecoration(
                      icon: GestureDetector(
                        onTap: () {
                          _selectedDateTime(context, _endDate, endDatePicked);
                        },
                        child: Icon(
                          MyFlutterApp.calendar,
                          size: 30,
                        ),
                      ),
                      hintText: 'Ngày cuối tháng hóa đơn',
                      hintStyle: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  width: size.width * 0.2,
                  height: size.height * 0.045,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: PrimaryColor,
                      ),
                      child: Text(
                        'Lưu',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w700),
                      ),
                      onPressed: () {
                        // try {
                        var list = startDatePicked.text.split("/");
                        String test = list[2] + "-" + list[1] + "-" + list[0];
                        DateTime time = DateTime.parse(test);
                        String startDateTest =
                            new DateFormat('yyyy-MM-dd').format(time);
                        print(startDateTest);
                        list = endDatePicked.text.split("/");
                        test = list[2] + "-" + list[1] + "-" + list[0];
                        time = DateTime.parse(test);
                        String endDateTest =
                            new DateFormat('yyyy-MM-dd').format(time);
                        print(endDateTest);
                        sendServiceRoomData(contractIdValue, startDateTest,
                            endDateTest, listMap);
                        // } catch (e) {
                        //   print(e.toString());
                        // }
                        // DateFormat("yyyy-MM-dd").parse(endDatePicked.text);
                        // print(listMap);
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => DisplayBillPage()));
                      },
                    ),
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
