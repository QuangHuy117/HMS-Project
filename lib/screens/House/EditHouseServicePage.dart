import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:house_management_project/fonts/my_flutter_app_icons.dart';
import 'package:house_management_project/main.dart';
import 'package:house_management_project/models/Service.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class EditHouseServicePage extends StatefulWidget {
  final int serviceId;
  const EditHouseServicePage({Key key, @required this.serviceId})
      : super(key: key);

  @override
  _EditHouseServicePageState createState() => _EditHouseServicePageState();
}

class _EditHouseServicePageState extends State<EditHouseServicePage> {
  Service service = new Service();
  var format = NumberFormat('#,###,000');
  bool _isEdit = false;
  // bool _isDiff = false;
  TextEditingController name = new TextEditingController();
  TextEditingController type = new TextEditingController();
  TextEditingController price = new TextEditingController();
  TextEditingController unit = new TextEditingController();
  String responseMsg = '';

  getServiceById() async {
    var url = Uri.parse('https://$serverHost/api/services/${widget.serviceId}');
    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        setState(() {
          service = Service.fromJson(jsonData);
          name = TextEditingController(text: service.name);
          type = TextEditingController(
              text: service.serviceType.contains("chênh lệch")
                  ? "Chênh lệch"
                  : "Cố định");
          price = TextEditingController(text: service.price.toString());
          unit = TextEditingController(text: service.calculationUnit);
          print(service);
        });
      }
    } catch (error) {
      throw (error);
    }
  }

  getAnotherServiceById(int serviceId) async {
    var url = Uri.parse('https://$serverHost/api/services/$serviceId');
    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        setState(() {
          service = Service.fromJson(jsonData);
          name = TextEditingController(text: service.name);
          type = TextEditingController(
              text: service.serviceType.contains("chênh lệch")
                  ? "Chênh lệch"
                  : "Cố định");
          price = TextEditingController(text: service.price.toString());
          unit = TextEditingController(text: service.calculationUnit);
          print(service);
        });
      }
    } catch (error) {
      throw (error);
    }
  }

  updateService(String nameService, String typeService, String priceService,
      String unitService, int serviceId) async {
    dynamic token = await FlutterSession().get("token");
    try {
      var jsonData = null;
      var url = Uri.parse('https://$serverHost/api/services');
      var response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: 'Bearer ${token.toString()}',
        },
        body: jsonEncode({
          "id": widget.serviceId,
          "name": nameService,
          "calculationUnit": unitService,
          "price": int.parse(priceService),
          "serviceType": typeService,
        }),
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        jsonData = response.body;
        responseMsg = 'Cập nhật thành công';
        getAnotherServiceById(serviceId);
        showAlertDialog(context, responseMsg);
        _isEdit = false;
      }
    } catch (error) {
      throw (error);
    }
  }

  showAlertDialog(BuildContext context, String responseMsg) {
    AlertDialog alert = AlertDialog(
      title: Text("Tiêu đề"),
      content: Text(responseMsg),
      actions: [
        TextButton(
          child: Text("OK"),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  void initState() {
    super.initState();
    getServiceById();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
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
          centerTitle: true,
          title: Text(
            'Chỉnh Sửa Dịch Vụ',
            style: TextStyle(
                color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700),
          ),
        ),
        body: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.only(top: 10, left: 20),
                child: Text(
                  'Thông tin',
                  style: TextStyle(fontSize: 22),
                ),
              ),
              Divider(
                color: Colors.grey.shade300,
                thickness: 1,
              ),
              SizedBox(
                height: 10,
              ),
              _isEdit
                  ? Container(
                      padding: EdgeInsets.only(left: 10),
                      child: Text(
                        '*Loại dịch vụ chỉ có Chênh lệch và Cố định',
                        style: TextStyle(fontSize: 16, color: Colors.red),
                      ),
                    )
                  : Container(),
              Container(
                padding: EdgeInsets.only(left: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('Tên dịch vụ: ',
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.w600)),
                    SizedBox(
                      width: 10,
                    ),
                    _isEdit
                        ? service.serviceType.contains("Mặc định")
                            ? Container(
                                height: size.height * 0.05,
                                alignment: Alignment.centerLeft,
                                child: Text(
                                    service.name == null ? "N/A" : service.name,
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600)),
                              )
                            : Container(
                                width: size.width * 0.5,
                                child: TextFormField(
                                  controller: name,
                                  style: TextStyle(fontSize: 18),
                                ),
                              )
                        : Container(
                            height: size.height * 0.05,
                            alignment: Alignment.centerLeft,
                            child: Text(
                                service.name == null ? "N/A" : service.name,
                                style: TextStyle(
                                    color: PrimaryColor,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600)),
                          ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                padding: EdgeInsets.only(left: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('Loại dịch vụ: ',
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.w600)),
                    SizedBox(
                      width: 10,
                    ),
                    _isEdit
                        ? service.serviceType.contains('Mặc định')
                            ? Container(
                                height: size.height * 0.05,
                                alignment: Alignment.centerLeft,
                                child: Text(
                                    service.serviceType == null ? "N/A" : service.serviceType.contains('chênh lệch') ? 'Chênh lệch' : 'Cố định',
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600)),
                              )
                            : Container(
                                width: size.width * 0.5,
                                child: TextFormField(
                                  controller: type,
                                  style: TextStyle(fontSize: 18),
                                ),
                              )
                        : Container(
                            height: size.height * 0.05,
                            alignment: Alignment.centerLeft,
                            child: Text(
                                service.serviceType == null
                                    ? "N/A"
                                    : service.serviceType.contains("chênh lệch")
                                        ? 'Chênh lệch'
                                        : 'Cố định',
                                style: TextStyle(
                                    color: PrimaryColor,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600)),
                          ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                padding: EdgeInsets.only(left: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('Đơn giá: ',
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.w600)),
                    SizedBox(
                      width: 10,
                    ),
                    _isEdit
                        ? Container(
                            width: size.width * 0.5,
                            child: TextFormField(
                              controller: price,
                              style: TextStyle(fontSize: 18),
                              decoration: InputDecoration(
                                suffixText: 'đ',
                              ),
                            ),
                          )
                        : Container(
                            height: size.height * 0.05,
                            alignment: Alignment.centerLeft,
                            child: Text(
                                service.price == null
                                    ? "N/A"
                                    : service.price.toString() + "đ",
                                style: TextStyle(
                                    color: PrimaryColor,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600)),
                          ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                padding: EdgeInsets.only(left: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('Đơn vị đo: ',
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.w600)),
                    SizedBox(
                      width: 10,
                    ),
                    _isEdit
                        ? Container(
                            width: size.width * 0.5,
                            child: TextFormField(
                              controller: unit,
                              style: TextStyle(fontSize: 18),
                            ),
                          )
                        : Container(
                            height: size.height * 0.05,
                            alignment: Alignment.centerLeft,
                            child: Text(
                                service.calculationUnit == null
                                    ? "N/A"
                                    : service.calculationUnit,
                                style: TextStyle(
                                    color: PrimaryColor,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600)),
                          ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: size.width * 0.24,
                height: size.height * 0.05,
                margin: EdgeInsets.only(left: 180),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: PrimaryColor,
                      ),
                      child: Text(
                        _isEdit ? 'Cập nhật' : 'Chỉnh sửa',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w700),
                      ),
                      onPressed: () {
                        setState(() {
                          if (_isEdit == false) {
                            _isEdit = true;
                          } else {
                            updateService(
                                name.text,
                                service.serviceType.contains('Mặc định')
                                    ? 'Mặc định ' + type.text
                                    : 'Thêm ' + type.text,
                                price.text,
                                unit.text, service.id);
                          }
                        });
                      }),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Divider(
                color: Colors.grey.shade300,
                thickness: 10,
              ),
              SizedBox(height: 10,),
              Container(
                padding: EdgeInsets.only(left: 10),
                child: Text('Các dịch vụ khác: ', style: TextStyle(fontSize: 18),),
              ),
              TextButton(
                onPressed: () {
                  getAnotherServiceById(2);
                },
                child: Text("luu"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
