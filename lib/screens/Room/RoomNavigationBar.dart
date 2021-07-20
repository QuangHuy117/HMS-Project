import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:house_management_project/components/TextInput.dart';
import 'package:house_management_project/fonts/my_flutter_app_icons.dart';
import 'package:house_management_project/main.dart';
import 'package:house_management_project/screens/Bill/ListBillPage.dart';
import 'package:house_management_project/screens/Contract/ListContractPage.dart';
import 'package:house_management_project/screens/NotificationPage.dart';
import 'package:house_management_project/screens/Room/RoomPage.dart';
import 'package:house_management_project/screens/Profile/LandLordProfile.dart';
import 'package:http/http.dart' as http;

class RoomNavigationBar extends StatefulWidget {
  final String houseId;
  const RoomNavigationBar(
      {Key key,
      @required this.houseId})
      : super(key: key);

  @override
  _RoomNavigationBarState createState() => _RoomNavigationBarState();
}

class _RoomNavigationBarState extends State<RoomNavigationBar> {
  int _currentIndex = 0;
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
    final tabs = [
      RoomPage(
        houseId: widget.houseId,
      ),
      // ListBillPage(),
      ListContractPage(),
      NotificationPage(),
      LandLordProfile(),
    ];
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
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
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomAppBar(
          color: PrimaryColor,
          shape: CircularNotchedRectangle(),
          notchMargin: 5,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.meeting_room,
                    size: 28,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      _currentIndex = 0;
                    });
                  },
                ),
                // IconButton(
                //   icon: Icon(
                //     MyFlutterApp.clipboard,
                //     color: Colors.white,
                //   ),
                //   onPressed: () {
                //     setState(() {
                //       _currentIndex = 1;
                //     });
                //   },
                // ),
                IconButton(
                  icon: Icon(
                    MyFlutterApp.file_contract,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      _currentIndex = 1;
                    });
                  },
                ),
                SizedBox(width: size.width * 0.1),
                IconButton(
                  icon: Icon(
                    MyFlutterApp.bell,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      _currentIndex = 2;
                    });
                  },
                ),
                IconButton(
                  icon: Icon(
                    MyFlutterApp.user,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      _currentIndex = 3;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
        body: tabs[_currentIndex],
      ),
    );
  }
}
