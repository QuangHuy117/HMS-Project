import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:house_management_project/fonts/my_flutter_app_icons.dart';
import 'package:house_management_project/main.dart';
import 'package:house_management_project/models/Contract.dart';
import 'package:house_management_project/models/Service.dart';
import 'package:house_management_project/models/ServiceContracts.dart';
import 'package:house_management_project/models/User.dart';
import 'package:house_management_project/screens/Contract/AddServiceContractPage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class ContractDetailPage extends StatefulWidget {
  final int contractId;
  final String houseId;
  const ContractDetailPage(
      {Key key, @required this.contractId, @required this.houseId})
      : super(key: key);

  @override
  _ContractDetailPageState createState() => _ContractDetailPageState();
}

class _ContractDetailPageState extends State<ContractDetailPage> {
  Contract contract = new Contract();
  bool _isEdit = false;
  List<bool> _isOpen = [];
  List<TextEditingController> _controllers = [];
  String houseName, ownerName, roomName;
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();
  TextEditingController startDatePicked,
      endDatePicked,
      custName,
      roomPrice,
      note;
  String userId = '';
  List<ServiceContracts> listServiceContract = [];
  List<Service> listService = [];
  bool _isLoading = true;
  String responseMsg = '';
  Map<String, dynamic> serviceContractData = new Map();
  List<Map<String, dynamic>> listMap = [];

  getContractDetail() async {
    var url =
        Uri.parse('https://$serverHost/api/contracts/${widget.contractId}');
    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        setState(() {
          contract = Contract.fromJson(jsonData);
          userId = contract.tenant.userId;
          for (var i in contract.serviceContracts) {
            listServiceContract.add(i);
            listService.add(i.service);
          }

          houseName = jsonData['houseName'];
          roomName = jsonData['roomName'];
          ownerName = jsonData['ownerName'];
          custName = new TextEditingController(
              text: contract.tenant == null ? 'N/A' : contract.tenant.name);
          startDatePicked = new TextEditingController(
              text: contract.startDate == null
                  ? ''
                  : DateFormat('dd/MM/yyyy').format(contract.startDate));
          endDatePicked = new TextEditingController(
              text: contract.endDate == null
                  ? ''
                  : DateFormat('dd/MM/yyyy').format(contract.endDate));
          roomPrice = new TextEditingController(
              text: contract.roomPrice == null
                  ? 'N/A'
                  : contract.roomPrice.toString());
          note = new TextEditingController(
              text: contract.note == null ? 'N/A' : contract.note);
          _isLoading = false;
        });
      }
    } catch (error) {
      throw (error);
    }
  }

  Future<List<User>> getListUser(String query) async {
    var url = Uri.parse('https://$serverHost/api/accounts');
    try {
      var response = await http.get(url);
      print(response.statusCode);
      if (response.statusCode == 200) {
        final List listUser = jsonDecode(response.body);
        return listUser.map((e) => User.fromJson(e)).where((user) {
          final nameLower = user.name.toLowerCase();
          final queryLower = query.toLowerCase();

          return nameLower.contains(queryLower);
        }).toList();
      }
    } catch (error) {
      throw (error);
    }
  }

  Future getMoreService(BuildContext context) async {
    var result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AddServiceContractPage(
                  listServiceContract: listService,
                  houseId: widget.houseId,
                )));
    setState(() {
      print(result);
      if (result == null) {
        return;
      } else {
        setState(() {
          listService = result;
          print(listService.length);
        });
      }
    });
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
        text.text = DateFormat('dd/MM/yyyy').format(_pickedDate);
      });
    }
  }

  updateContractDetail(String userId, String roomPrice, String startDate,
      String endDate, String note, List listServiceContract) async {
    dynamic token = await FlutterSession().get("token");
    var jsonData = null;
    var url = Uri.parse('https://$serverHost/api/contracts');
    try {
      var response = await http.put(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: 'Bearer ${token.toString()}'
        },
        body: jsonEncode({
          "id": widget.contractId,
          "tenantUserId": userId,
          "startDate": DateTime.parse(startDate).toIso8601String(),
          "endDate": DateTime.parse(endDate).toIso8601String(),
          "roomPrice": int.parse(roomPrice),
          "note": note,
          "updateServiceContracts": listServiceContract
        }),
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        jsonData = response.body;
        setState(() {
          responseMsg = 'Cập nhật hợp đồng thành công';
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
              responseMsg,
              style: TextStyle(fontSize: 20),
            ),
          ));
        });
        // Navigator.of(context).pushReplacement(MaterialPageRoute(
        //     builder: (_) => RoomNavigationBar(houseId: widget.houseId)));
      }
    } catch (error) {
      throw (error);
    }
  }

  getData(int serviceId, int price, String value) async {
    serviceContractData = {
      "serviceId": serviceId,
      "unitPrice": price,
      "startClockValue": int.parse(value),
    };
    listMap.add(serviceContractData);
  }

  @override
  void initState() {
    super.initState();
    getContractDetail();
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
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 20),
            width: size.width,
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Thông tin chi tiết',
                            style: TextStyle(
                                fontSize: 22,
                                color: Colors.black87,
                                fontWeight: FontWeight.w600),
                          ),
                          Text(
                            ownerName == null ? 'N/A' : 'Người tạo: $ownerName',
                            style: TextStyle(
                                fontSize: 20,
                                color: PrimaryColor,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Icon(
                            MyFlutterApp.home,
                            color: Colors.black54,
                            size: 30,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            houseName == null && roomName == null
                                ? 'N/A'
                                : 'Nhà: ' '$houseName' + '- ' + '$roomName',
                            style: TextStyle(
                                fontSize: 20,
                                color: PrimaryColor,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            child: Icon(
                              MyFlutterApp.calendar,
                              color: Colors.black54,
                              size: 30,
                            ),
                            onTap: () {
                              _isEdit = true;
                              _selectedDateTime(
                                  context, _startDate, startDatePicked);
                            },
                          ),
                          Container(
                            width: size.width * 0.68,
                            child: _isEdit
                                ? Container(
                                    margin:
                                        EdgeInsets.only(bottom: 10, left: 10),
                                    width: size.width * 0.68,
                                    child: TextField(
                                      controller: startDatePicked,
                                      style: TextStyle(
                                          color: Colors.blue, fontSize: 20),
                                      decoration: InputDecoration(
                                        hintText: 'Ngày thuê',
                                        hintStyle: TextStyle(fontSize: 20),
                                      ),
                                    ),
                                  )
                                : Container(
                                    width: size.width * 0.68,
                                    height: size.height * 0.061,
                                    alignment: Alignment.centerLeft,
                                    margin: EdgeInsets.only(left: 10),
                                    child: GestureDetector(
                                      child: Text(
                                        contract.startDate == null
                                            ? 'N/A'
                                            : 'Ngày thuê: ' +
                                                DateFormat('dd/MM/yyyy')
                                                    .format(contract.startDate),
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: PrimaryColor,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      onTap: () {
                                        setState(() {
                                          _isEdit = true;
                                        });
                                      },
                                    ),
                                  ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            child: Icon(
                              MyFlutterApp.calendar,
                              color: Colors.black54,
                              size: 30,
                            ),
                            onTap: () {
                              _isEdit = true;
                              _selectedDateTime(
                                  context, _endDate, endDatePicked);
                            },
                          ),
                          Container(
                            width: size.width * 0.68,
                            child: _isEdit
                                ? Container(
                                    margin:
                                        EdgeInsets.only(bottom: 10, left: 10),
                                    width: size.width * 0.68,
                                    child: TextField(
                                      controller: endDatePicked,
                                      style: TextStyle(
                                          color: Colors.blue, fontSize: 20),
                                      decoration: InputDecoration(
                                        hintText: 'Ngày hết hạn',
                                        hintStyle: TextStyle(fontSize: 20),
                                      ),
                                    ),
                                  )
                                : Container(
                                    width: size.width * 0.68,
                                    height: size.height * 0.06,
                                    alignment: Alignment.centerLeft,
                                    margin: EdgeInsets.only(left: 10),
                                    child: GestureDetector(
                                      child: Text(
                                        contract.endDate == null
                                            ? 'N/A'
                                            : 'Ngày hết hạn: ' +
                                                DateFormat('dd/MM/yyyy')
                                                    .format(contract.endDate),
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: PrimaryColor,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      onTap: () {
                                        setState(() {
                                          _isEdit = true;
                                        });
                                      },
                                    ),
                                  ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            MyFlutterApp.user,
                            color: Colors.black54,
                            size: 30,
                          ),
                          Container(
                            width: size.width * 0.68,
                            child: _isEdit || contract.tenant == null
                                ? Container(
                                    margin: EdgeInsets.only(left: 10),
                                    child: TypeAheadField<User>(
                                      textFieldConfiguration:
                                          TextFieldConfiguration(
                                        controller: custName,
                                        style: TextStyle(
                                            color: Colors.blue, fontSize: 20),
                                        decoration: InputDecoration(
                                            hintText: 'Tên khách'),
                                      ),
                                      suggestionsCallback: (pattern) async {
                                        return await getListUser(pattern);
                                      },
                                      itemBuilder: (context, user) {
                                        userId = user.userId;
                                        return ListTile(
                                          leading: Image.network(
                                            user.image,
                                            fit: BoxFit.cover,
                                          ),
                                          title: Text(user.name),
                                          subtitle: Text('${user.email}'),
                                        );
                                      },
                                      onSuggestionSelected: (user) {
                                        setState(() {
                                          custName.text = user.name;
                                        });
                                      },
                                    ),
                                  )
                                : Container(
                                    height: size.height * 0.05,
                                    alignment: Alignment.centerLeft,
                                    margin: EdgeInsets.only(left: 10),
                                    child: GestureDetector(
                                      child: Text(
                                        contract.tenant == null
                                            ? 'N/A'
                                            : 'Khách hàng: ' +
                                                contract.tenant.name,
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: PrimaryColor,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      onTap: () {
                                        setState(() {
                                          _isEdit = true;
                                        });
                                      },
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 10),
                      child: Icon(
                        Icons.attach_money_outlined,
                        color: Colors.black54,
                        size: 30,
                      ),
                    ),
                    Container(
                      width: size.width * 0.68,
                      child: _isEdit
                          ? Container(
                              margin: EdgeInsets.only(left: 10),
                              width: size.width * 0.68,
                              child: TextField(
                                controller: roomPrice,
                                style:
                                    TextStyle(color: Colors.blue, fontSize: 20),
                                decoration: InputDecoration(
                                  hintText: 'Giá phòng',
                                  hintStyle: TextStyle(fontSize: 20),
                                ),
                              ),
                            )
                          : Container(
                              width: size.width * 0.68,
                              height: size.height * 0.06,
                              alignment: Alignment.centerLeft,
                              margin: EdgeInsets.only(left: 10),
                              child: GestureDetector(
                                child: Text(
                                  contract.roomPrice == null
                                      ? 'N/A'
                                      : 'Giá phòng: ' +
                                          contract.roomPrice.toString() +
                                          "đ",
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: PrimaryColor,
                                      fontWeight: FontWeight.w600),
                                ),
                                onTap: () {
                                  setState(() {
                                    _isEdit = true;
                                  });
                                },
                              ),
                            ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 10),
                      child: Icon(
                        Icons.note,
                        color: Colors.black54,
                        size: 30,
                      ),
                    ),
                    Container(
                      width: size.width * 0.68,
                      child: _isEdit
                          ? Container(
                              margin: EdgeInsets.only(left: 10),
                              width: size.width * 0.68,
                              child: TextField(
                                controller: note,
                                style:
                                    TextStyle(color: Colors.blue, fontSize: 20),
                                decoration: InputDecoration(
                                  hintText: 'Ghi chú',
                                  hintStyle: TextStyle(fontSize: 20),
                                ),
                              ),
                            )
                          : Container(
                              width: size.width * 0.68,
                              height: size.height * 0.06,
                              alignment: Alignment.centerLeft,
                              margin: EdgeInsets.only(left: 10),
                              child: GestureDetector(
                                child: Text(
                                  contract.note == null
                                      ? 'N/A'
                                      : 'Ghi chú: ' + contract.note,
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: PrimaryColor,
                                      fontWeight: FontWeight.w600),
                                ),
                                onTap: () {
                                  setState(() {
                                    _isEdit = true;
                                  });
                                },
                              ),
                            ),
                    ),
                  ],
                ),
                Divider(
                  color: Colors.grey.shade200,
                  thickness: 10,
                ),
                SizedBox(
                  height: 10,
                ),
                _isLoading
                    ? Container(
                        alignment: Alignment.center,
                        child: SizedBox(
                            width: 30,
                            height: 30,
                            child: CircularProgressIndicator()))
                    : Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        width: size.width,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Dịch vụ',
                                  style: TextStyle(
                                      fontSize: 22,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w600),
                                ),
                                GestureDetector(
                                  child: Text(
                                    'Thêm dịch vụ ->',
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: PrimaryColor,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  onTap: () {
                                    getMoreService(context);
                                  },
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              height: size.height * 0.4,
                              width: size.width,
                              padding: EdgeInsets.symmetric(horizontal: 30),
                              child: ListView.builder(
                                itemBuilder: (context, index) {
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
                                          border: Border.all(
                                              color: Colors.black, width: 1),
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(15),
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
                                                backgroundColor: Colors.white,
                                                headerBuilder:
                                                    (BuildContext context,
                                                        bool isExpanded) {
                                                  return ListTile(
                                                    title: Text(
                                                      '${listService[index].name} - ${listService[index].price} / ${listService[index].calculationUnit}',
                                                      style: TextStyle(
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
                                                      height: 20,
                                                    ),
                                                    Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 18),
                                                      margin: EdgeInsets.only(
                                                          bottom: 20),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            'Loại dịch vụ: ',
                                                            style: TextStyle(
                                                                fontSize: 18,
                                                                color:
                                                                    Colors.grey,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                          ),
                                                          Container(
                                                            alignment: Alignment
                                                                .centerRight,
                                                            width: size.width *
                                                                0.5,
                                                            child: Text(
                                                                '${listService[index].serviceType.contains('chênh lệch') ? 'Chênh lệch' : 'Cố định'}',
                                                                style: listService[
                                                                            index]
                                                                        .serviceType
                                                                        .contains(
                                                                            'chênh lệch')
                                                                    ? TextStyle(
                                                                        fontSize:
                                                                            20,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w600,
                                                                        color:
                                                                            Colors
                                                                                .green)
                                                                    : TextStyle(
                                                                        fontSize:
                                                                            20,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w600,
                                                                        color: Colors
                                                                            .blue)),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Container(
                                                      child: listService[index]
                                                              .serviceType
                                                              .contains(
                                                                  'chênh lệch')
                                                          ? Container(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          20),
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      bottom:
                                                                          15),
                                                              child: listService[
                                                                          index]
                                                                      .serviceType
                                                                      .contains(
                                                                          'Thêm')
                                                                  ? Column(
                                                                      children: [
                                                                        Container(
                                                                          margin:
                                                                              EdgeInsets.only(bottom: 15),
                                                                          child:
                                                                              Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              Text(
                                                                                'Nhập chỉ số đầu: ',
                                                                                style: TextStyle(fontSize: 18, color: Colors.grey, fontWeight: FontWeight.w600),
                                                                              ),
                                                                              Container(
                                                                                width: size.width * 0.12,
                                                                                height: size.height * 0.03,
                                                                                decoration: BoxDecoration(
                                                                                  border: Border(bottom: BorderSide(color: Colors.black87, width: 2)),
                                                                                ),
                                                                                child: TextField(
                                                                                  controller: _controllers[index],
                                                                                  keyboardType: TextInputType.number,
                                                                                  textAlign: TextAlign.right,
                                                                                  decoration: InputDecoration(
                                                                                    hintText: '0',
                                                                                    hintStyle: TextStyle(fontSize: 17, color: Colors.black87),
                                                                                  ),
                                                                                  onSubmitted: (value) {
                                                                                    _controllers[index].text = value;
                                                                                    getData(
                                                                                  listService[index].id,
                                                                                  listService[index].price,
                                                                                  _controllers[index].text,
                                                                                );
                                                                                  },
                                                                                ),
                                                                              )
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            Text(
                                                                              'Nhập chỉ số cuối: ',
                                                                              style: TextStyle(fontSize: 18, color: Colors.grey, fontWeight: FontWeight.w600),
                                                                            ),
                                                                            Container(
                                                                              width: size.width * 0.12,
                                                                              height: size.height * 0.03,
                                                                              decoration: BoxDecoration(
                                                                                border: Border(bottom: BorderSide(color: Colors.black87, width: 2)),
                                                                              ),
                                                                              child: TextField(
                                                                                controller: _controllers[index],
                                                                                keyboardType: TextInputType.number,
                                                                                textAlign: TextAlign.right,
                                                                                decoration: InputDecoration(
                                                                                  hintText: '0',
                                                                                  hintStyle: TextStyle(fontSize: 17, color: Colors.black87),
                                                                                ),
                                                                                onSubmitted: (value) {
                                                                                  _controllers[index].text = value;
                                                                                 getData(
                                                                                  listService[index].id,
                                                                                  listService[index].price,
                                                                                  _controllers[index].text,
                                                                                );
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
                                                                          'Chỉ số đầu: ',
                                                                          style: TextStyle(
                                                                              fontSize: 18,
                                                                              color: Colors.grey,
                                                                              fontWeight: FontWeight.w600),
                                                                        ),
                                                                        Container(
                                                                            width: size.width *
                                                                                0.12,
                                                                            height: size.height *
                                                                                0.03,
                                                                            child:
                                                                                TextField(
                                                                              controller: _controllers[index],
                                                                              keyboardType: TextInputType.number,
                                                                              textAlign: TextAlign.right,
                                                                              decoration: InputDecoration(
                                                                                hintText: contract == null ? '' : contract.serviceContracts[index].clock.clockValues[0].indexValue.toString(),
                                                                                hintStyle: TextStyle(fontSize: 17, color: Colors.grey),
                                                                              ),
                                                                              onSubmitted: (value) {
                                                                                _controllers[index].text = value;
                                                                                getData(
                                                                                  listService[index].id,
                                                                                  listService[index].price,
                                                                                  _controllers[index].text,
                                                                                );
                                                                              },
                                                                            )
                                                                            )
                                                                      ],
                                                                    ))
                                                          : Container(),
                                                    ),
                                                    Divider(
                                                      indent: 60,
                                                      endIndent: 60,
                                                      thickness: 2,
                                                      color: PrimaryColor,
                                                    ),
                                                    CheckboxListTile(
                                                        dense: true,
                                                        value:
                                                            listService[index]
                                                                .status,
                                                        title: Text(
                                                          'Chọn dịch vụ',
                                                          style: TextStyle(
                                                            fontSize: 18,
                                                          ),
                                                        ),
                                                        activeColor:
                                                            PrimaryColor,
                                                        checkColor:
                                                            Colors.black,
                                                        onChanged:
                                                            (bool value) {
                                                          setState(() {
                                                            listService[index]
                                                                .status = value;
                                                            if (value ==
                                                                false) {
                                                              print(listService[
                                                                      index]
                                                                  .status);
                                                              print(listService[
                                                                      index]
                                                                  .id);
                                                            } else {
                                                              print(listService[
                                                                      index]
                                                                  .status);
                                                              print(listService[
                                                                      index]
                                                                  .id);
                                                            }
                                                          });
                                                        }),
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
                            )
                          ],
                        ),
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
                        try {
                          var list = startDatePicked.text.split("/");
                          String test = list[2] + "-" + list[1] + "-" + list[0];
                          DateTime time = DateTime.parse(test);
                          String startDateTest =
                              new DateFormat('yyyy-MM-dd').format(time);
                          list = endDatePicked.text.split("/");
                          test = list[2] + "-" + list[1] + "-" + list[0];
                          time = DateTime.parse(test);
                          String endDateTest =
                              new DateFormat('yyyy-MM-dd').format(time);

                          print(widget.contractId);
                          print(userId);
                          print(startDateTest);
                          print(endDateTest);
                          print(roomPrice.text);
                          print(note.text);
                          print(listMap);

                          updateContractDetail(userId, roomPrice.text, startDateTest, endDateTest, note.text, listServiceContract);
                        } catch (e) {
                          print(e.toString());
                        }
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
