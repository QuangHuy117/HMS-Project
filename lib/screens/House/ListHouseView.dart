import 'dart:convert';
import 'dart:io';

import 'package:flutter_session/flutter_session.dart';
import 'package:house_management_project/api/firebase_api.dart';
import 'package:path/path.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:house_management_project/components/TextInput.dart';
import 'package:house_management_project/main.dart';
import 'package:house_management_project/screens/House/ListHouseNotUsing.dart';
import 'package:house_management_project/screens/House/ListHouseUsing.dart';
import 'package:http/http.dart' as http;

class ListHouseView extends StatefulWidget {
  ListHouseView({
    Key key,
  }) : super(key: key);

  @override
  _ListHouseViewState createState() => _ListHouseViewState();
}

class _ListHouseViewState extends State<ListHouseView> {
  TextEditingController name = new TextEditingController();
  TextEditingController address = new TextEditingController();
  String showErr = "";
  String responseMsg = '';
  UploadTask task;
  File file;
  String urlImage = "";

  Future createHouse(String name, String address, String urlImg, BuildContext context) async {
    dynamic token = await FlutterSession().get("token");
    try {
      var jsonData = null;
      var url = Uri.parse('https://$serverHost/api/houses');
      var response = await http.post(
        url,
        headers:{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: 'Bearer ${token.toString()}',
        },
        body: jsonEncode({
            "houseInfos": {"name": name, "address": address, "image": urlImg}
        }),
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        jsonData = response.body;
        responseMsg = 'Tạo nhà thành công';
        Navigator.pop(context);
      }
    } catch (error) {
      throw (error);
    }
  }

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);

    if (result == null) return;
    final path = result.files.single.path;

    setState(() => file = File(path));
    // }

    // Future uploadFile() async {
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
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: DefaultTabController(
        length: 2,
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
                                controller: name,
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
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    fillColor: Colors.white,
                                    filled: true,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 15,
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
                                      height: size.height * 0.07,
                                      width: size.width * 0.145,
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
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                                onPressed: () {
                                  stateModel(() {
                                    if (name.text.isEmpty ||
                                        address.text.isEmpty) {
                                      showErr =
                                          'Thông tin không được trống !!!';
                                    } else {
                                      createHouse(
                                              name.text, address.text, urlImage, context)
                                          .then((value) => {
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
            appBar: AppBar(
              elevation: 0,
              title: Text(
                'Danh Sách Nhà',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w700),
              ),
              centerTitle: true,
              backgroundColor: PrimaryColor,
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
                          'Nhà đang thuê',
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
                          'Nhà chưa thuê',
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
            body: TabBarView(
              children: [
                ListHouseUsing(),
                ListHouseNotUsing(),
              ],
            )),
      ),
    );
  }
}
