import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:house_management_project/api/firebase_api.dart';
import 'package:house_management_project/components/TextInput.dart';
import 'package:house_management_project/fonts/my_flutter_app_icons.dart';
import 'package:house_management_project/main.dart';
import 'package:house_management_project/screens/Contract/ListContractPage.dart';
import 'package:house_management_project/screens/NotificationPage.dart';
import 'package:house_management_project/screens/Profile/LandLordProfile.dart';
import 'package:house_management_project/screens/House/ListHouseView.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  HomePage({
    Key key,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  dynamic username, name, email;
  TextEditingController houseName = new TextEditingController();
  TextEditingController address = new TextEditingController();
  TextEditingController paidDeadline = new TextEditingController();
  TextEditingController beforeNotiDate = new TextEditingController();
  TextEditingController billDate = new TextEditingController();
  String showErr = "";
  String responseMsg = '';
  UploadTask task;
  File file;
  String urlImage = "";

  createHouse(
      String name,
      String addressEnter,
      String urlImg,
      String deadline,
      String billDates,
      String beforeNoti,
      BuildContext context) async {
    print(urlImg);
    dynamic token = await FlutterSession().get("token");
    try {
      var jsonData = null;
      var url = Uri.parse('https://$serverHost/api/houses');
      var response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: 'Bearer ${token.toString()}',
        },
        body: jsonEncode({
          "houseInfos": {
            "name": name,
            "address": addressEnter,
            "image": urlImg,
            "paidDeadline": int.parse(deadline),
            "billDate": int.parse(billDates),
            "beforeNotiDate": int.parse(beforeNoti),
          }
        }),
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        jsonData = response.body;
        responseMsg = 'Tạo nhà thành công';
        showAlertDialog(context, responseMsg);
        file = null;
        houseName.clear();
        address.clear();
        paidDeadline.clear();
        beforeNotiDate.clear();
        billDate.clear(); 
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
            Navigator.popUntil(context, (route) => route.isFirst);
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

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);

    if (result == null) return;
    final path = result.files.single.path;

    setState(() => file = File(path));
    if (file == null) return;

    final fileName = basename(file.path);
    final destination = 'houses_image/$fileName';

    task = FirebaseApi.uploadFile(destination, file);
    setState(() {});

    if (task == null) return;

    final snapshot = await task.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();
    urlImage = urlDownload;
    print('Download-Link: $urlImage');
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final tabs = [
      ListHouseView(),
      // ListBillPage(),
      ListContractPage(),
      NotificationPage(),
      LandLordProfile(),
    ];

    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: PrimaryColor,
          onPressed: () {
            showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.grey.shade200,
                shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.only(
                    topLeft: Radius.circular(140),
                  ),
                ),
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
                            'Tạo nhà mới',
                            style: TextStyle(
                                color: Colors.blue,
                                fontSize: 22,
                                fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextInput(
                            text: 'Nhập tên nhà',
                            hidePass: false,
                            controller: houseName,
                          ),
                          Container(
                            width: size.width * 0.7,
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
                              controller: address,
                              textInputAction: TextInputAction.done,
                              decoration: InputDecoration(
                                hintText: 'Nhập địa chỉ nhà',
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
                            height: 20,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 50),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: size.width * 0.33,
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
                                    controller: paidDeadline,
                                    textInputAction: TextInputAction.done,
                                    decoration: InputDecoration(
                                      hintText: 'Nhập hạn đóng tiền',
                                      hintStyle: TextStyle(
                                          color: Color(0xFF707070),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      fillColor: Colors.white,
                                      filled: true,
                                    ),
                                  ),
                                ),
                                Container(
                                  width: size.width * 0.33,
                                  height: size.height * 0.08,
                                  child: TextField(
                                    controller: beforeNotiDate,
                                    textInputAction: TextInputAction.done,
                                    decoration: InputDecoration(
                                      hintText: 'Nhập ngày thông báo',
                                      hintStyle: TextStyle(
                                          color: Color(0xFF707070),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      fillColor: Colors.white,
                                      filled: true,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Container(
                            width: size.width * 0.7,
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
                              controller: billDate,
                              textInputAction: TextInputAction.done,
                              decoration: InputDecoration(
                                hintText: 'Nhập ngày đóng tiền',
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
                            height: 10,
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
                          Container(
                            height: size.height * 0.07,
                            width: size.width * 0.7,
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              children: [
                                Container(
                                  height: size.height * 0.08,
                                  width: size.width * 0.15,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.black, width: 1),
                                  ),
                                  child: GestureDetector(
                                    child: file == null
                                        ? Icon(
                                            Icons.add,
                                            size: 50,
                                          )
                                        : Image.file(file),
                                    onTap: () {
                                      stateModel(() {
                                        selectFile();
                                      });
                                    },
                                  ),
                                ),
                                TextButton(
                                  child: Text(
                                    'Refresh Image',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  onPressed: () {
                                    stateModel(() {});
                                  },
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextButton(
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 20),
                              backgroundColor: PrimaryColor,
                            ),
                            child: Text(
                              'Xác nhận',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                            onPressed: () {
                              stateModel(() {
                                if (houseName.text.isEmpty ||
                                    address.text.isEmpty ||
                                    paidDeadline.text.isEmpty ||
                                    billDate.text.isEmpty ||
                                    beforeNotiDate.text.isEmpty) {
                                  showErr = 'Thông tin không được trống !!!';
                                } else {
                                  createHouse(
                                          houseName.text,
                                          address.text,
                                          urlImage,
                                          paidDeadline.text,
                                          billDate.text,
                                          beforeNotiDate.text,
                                          context);
                                }
                              });
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
          },
          child: Icon(Icons.add),
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
                    MyFlutterApp.home,
                    size: 28,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      _currentIndex = 0;
                    });
                  },
                ),
                // SizedBox(width: size.width * 0.065),
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
                SizedBox(width: 30,),
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
