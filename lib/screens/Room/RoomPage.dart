import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:house_management_project/components/TextInput.dart';
import 'package:house_management_project/main.dart';
import 'package:house_management_project/screens/Room/ListRoomNotUsing.dart';
import 'package:house_management_project/screens/Room/ListRoomUsing.dart';
import 'package:house_management_project/fonts/my_flutter_app_icons.dart';
import 'package:http/http.dart' as http;

class RoomPage extends StatefulWidget {
  final String houseId;
  RoomPage({
    Key key,
    @required this.houseId,
  }) : super(key: key);

  @override
  _RoomPageState createState() => _RoomPageState();
}

class _RoomPageState extends State<RoomPage> {
  String showErr = "";
  TextEditingController name = new TextEditingController();
  TextEditingController price = new TextEditingController();
  TextEditingController square = new TextEditingController();
  String responseMsg = '';

  Future createRoom(String roomSquare, String price, String roomName) async {
    dynamic token = await FlutterSession().get("token");
    try {
      var jsonData = null;
      var url = Uri.parse('https://$serverHost/api/rooms');
      var response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: 'Bearer ${token.toString()}',
        },
        body: jsonEncode({
          "roomSquare": int.parse(roomSquare),
          "defaultPrice": int.parse(price),
          "houseId": widget.houseId,
          "name": roomName
        }),
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        jsonData = response.body;
        responseMsg = 'Tạo phòng thành công';
        Navigator.pop(context);
      }
    } catch (error) {
      throw (error);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: AppBar(
              elevation: 0,
              title: Text(
                'Danh Sách Phòng',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w700),
              ),
              centerTitle: true,
              automaticallyImplyLeading: false,
              leading: GestureDetector(
                  onTap: () {
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                  child: Icon(
                    MyFlutterApp.home,
                    color: Colors.white,
                    size: 30,
                  )),
              bottom: TabBar(
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)),
                  color: Colors.white,
                ),
                labelColor: PrimaryColor,
                labelStyle:
                    TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                unselectedLabelColor: Colors.white70,
                tabs: [
                  Tab(
                    child: Container(
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Phòng đang thuê',
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Tab(
                    child: Container(
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Phòng chưa thuê',
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
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
                    builder: (context) {
                      return StatefulBuilder(builder:
                          (BuildContext context, StateSetter stateModel) {
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 15),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Tạo phòng mới',
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w500),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              TextInput(
                                text: 'Nhập tên phòng',
                                hidePass: false,
                                controller: name,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              TextInput(
                                text: 'Nhập giá dự kiến',
                                hidePass: false,
                                controller: price,
                              ),
                              TextInput(
                                text: 'Nhập diện tích phòng',
                                hidePass: false,
                                controller: square,
                              ),
                              Text(
                                showErr.isEmpty ? '' : showErr,
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.red),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              TextButton(
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 15, horizontal: 20),
                                  backgroundColor: PrimaryColor,
                                ),
                                child: Text(
                                  'Xác nhận',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                                onPressed: () {
                                  stateModel(() {
                                    if (name.text.isEmpty ||
                                        price.text.isEmpty ||
                                        square.text.isEmpty) {
                                      showErr = 'Thông tin không được trống !!!';
                                    } else {
                                      createRoom(square.text, price.text, name.text).then((value) => {
                                        ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                  content: Text(
                                                    responseMsg,
                                                    style:
                                                        TextStyle(fontSize: 20),
                                                  ),
                                                )),
                                      });
                                    }
                                  });
                                },
                              ),
                              Padding(
                                  padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom,
                              )),
                            ],
                          ),
                        );
                      });
                    });
              },
              backgroundColor: PrimaryColor,
              child: Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
            body: TabBarView(
              children: [
                ListRoomUsing(
                  houseId: widget.houseId,
                ),
                ListRoomNotUsing(
                  houseId: widget.houseId,
                ),
              ],
            )),
      ),
    );
  }
}
