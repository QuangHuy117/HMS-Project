import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:house_management_project/fonts/my_flutter_app_icons.dart';
import 'package:house_management_project/main.dart';
import 'package:house_management_project/models/Room.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class RoomDetailsPage extends StatefulWidget {
  final int roomId;
  const RoomDetailsPage({Key key, @required this.roomId}) : super(key: key);

  @override
  _RoomDetailsPageState createState() => _RoomDetailsPageState();
}

class _RoomDetailsPageState extends State<RoomDetailsPage> {
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();
  TextEditingController startDatePicked = new TextEditingController();
  TextEditingController endDatePicked = new TextEditingController();
  Room detail = new Room();

  getRoomDetailFromRoomId() async {
    var url = Uri.parse('https://localhost:44322/api/rooms/${widget.roomId}');
    try {
      var response = await http.get(url);
      print(response.statusCode);
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        setState(() {
          detail = Room.fromJson(jsonData);
        });
      }
    } catch (error) {
      throw (error);
    }
  }

  @override
  void initState() {
    super.initState();
    getRoomDetailFromRoomId();
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
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Container(
        color: Colors.white,
        width: size.width,
        height: size.height * 0.9,
        padding: EdgeInsets.all(20),
        child: Align(
          alignment: Alignment.topCenter,
          child: Container(
            height: size.height * 0.8,
            padding: EdgeInsets.only(
              top: 20,
              right: 10,
              left: 10,
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
                width: 1,
                color: Color(0xFFFEAF45),
                style: BorderStyle.solid,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Chi tiết phòng',
                  style: TextStyle(
                      fontSize: 22,
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
                  color: Colors.blue,
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 20),
                  width: size.width * 0.75,
                  child: TextField(
                    decoration: InputDecoration(
                      icon: Icon(
                        Icons.room,
                        size: 30,
                      ),
                      hintText: '${detail.name == null ? 'Tên phòng' : detail.name}',
                      hintStyle: detail.name == null
                          ? TextStyle(fontSize: 18)
                          : TextStyle(
                              fontSize: 20,
                              color: Colors.black54,
                              fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 20),
                  width: size.width * 0.75,
                  child: TextField(
                    decoration: InputDecoration(
                      icon: Icon(
                        MyFlutterApp.user,
                        size: 30,
                      ),
                      hintText:
                          '${detail.contract == null ? 'Tên khách' : detail.contract.tenant.name}',
                      hintStyle: detail.contract == null
                          ? TextStyle(fontSize: 18)
                          : TextStyle(
                              fontSize: 20,
                              color: Colors.black54,
                              fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Mở rộng',
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Colors.blue),
                ),
                Divider(
                  indent: 60,
                  endIndent: 60,
                  thickness: 2,
                  color: Colors.blue,
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 20),
                  width: size.width * 0.75,
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
                      hintText: 'Ngày thuê',
                      hintStyle: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 20),
                  width: size.width * 0.75,
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
                      hintText: 'Ngày hết hạn',
                      hintStyle: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 20),
                  width: size.width * 0.75,
                  child: TextField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      icon: Icon(
                        MyFlutterApp.lightning_bolt,
                        size: 30,
                      ),
                      hintText: 'Nhập chỉ số điện đầu kì',
                      hintStyle: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                 Container(
                    margin: EdgeInsets.only(bottom: 20),
                    width: size.width * 0.75,
                    child: TextField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        icon: Icon(
                          MyFlutterApp.water_drop,
                          size: 30,
                        ),
                        hintText: 'Nhập chỉ số nước đầu kì',
                        hintStyle: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 120,
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
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => BillHistoryPage()));
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
