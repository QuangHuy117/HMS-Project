import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:house_management_project/fonts/my_flutter_app_icons.dart';
import 'package:house_management_project/main.dart';
import 'package:house_management_project/models/Contract.dart';
import 'package:house_management_project/models/ServiceContracts.dart';
import 'package:house_management_project/models/User.dart';
import 'package:house_management_project/screens/Contract/AddServiceContractPage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class ContractDetailPage extends StatefulWidget {
  final int contractId;
  final String houseId;
  const ContractDetailPage({Key key, @required this.contractId, @required this.houseId})
      : super(key: key);

  @override
  _ContractDetailPageState createState() => _ContractDetailPageState();
}

class _ContractDetailPageState extends State<ContractDetailPage> {
  Contract contract = new Contract();
  bool _isEdit = false;
  String houseName;
  String roomName;
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();
  TextEditingController startDatePicked;
  TextEditingController endDatePicked;
  TextEditingController name = new TextEditingController();
  TextEditingController custName;
  TextEditingController elecNum;
  TextEditingController waterNum;
  List<ServiceContracts> listServiceContract = [];

  getContractDetail() async {
    var url =
        Uri.parse('https://$serverHost/api/contracts/${widget.contractId}');
    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        setState(() {
          contract = Contract.fromJson(jsonData);
          for (var i in contract.serviceContracts) {
            listServiceContract.add(i);
          }
          houseName = jsonData['houseName'];
          roomName = jsonData['roomName'];
          custName = new TextEditingController(
              text: contract.tenant == null ? '' : contract.tenant.name);
          startDatePicked = new TextEditingController(
              text: contract.startDate == null
                  ? ''
                  : DateFormat('dd/MM/yyyy').format(contract.startDate));
          endDatePicked = new TextEditingController(
              text: contract.endDate == null
                  ? ''
                  : DateFormat('dd/MM/yyyy').format(contract.endDate));
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
    var result = await Navigator.push(context, 
    MaterialPageRoute(builder: (context) => AddServiceContractPage(listServiceContract: listServiceContract, houseId: widget.houseId,)));
    setState(() {
      if (result == null) {
        return;
      } else {
        listServiceContract = result;
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
                      Text(
                        'Thông tin chi tiết',
                        style: TextStyle(
                            fontSize: 22,
                            color: Colors.black87,
                            fontWeight: FontWeight.w600),
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
                                            ? ''
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
                                            ? ''
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
                      // Row(
                      //   children: [
                      //     Icon(MyFlutterApp.user),
                      //     Text('Người tạo: ${contract.tenant.name}'),
                      //   ],
                      // ),
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
                                            ? ''
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
                Divider(
                  color: Colors.grey.shade200,
                  thickness: 10,
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
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
                      Container(
                        height: size.height * 0.4,
                        width: size.width,
                        child: ListView.builder(
                          itemBuilder: (context, index) {
                            return Container();
                          },
                          itemCount: listServiceContract.length,
                        ),
                      )
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {
                    for (var i in listServiceContract) {
                      print(i.service.name);
                    }
                  },
                  child: Text('Luu'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

}
