import 'dart:convert';
import 'dart:io';

import 'package:flutter_session/flutter_session.dart';
import 'package:house_management_project/api/firebase_api.dart';
import 'package:path/path.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:house_management_project/main.dart';
import 'package:house_management_project/models/House.dart';
import 'package:http/http.dart' as http;

class HouseDetailsPage extends StatefulWidget {
  final String houseId;
  const HouseDetailsPage({Key key, @required this.houseId}) : super(key: key);

  @override
  _HouseDetailsPageState createState() => _HouseDetailsPageState();
}

class _HouseDetailsPageState extends State<HouseDetailsPage> {
  bool _isEdit = false;
  House house = new House();
  UploadTask task;
  File file;
  String urlImage;
  String responseMsg = '';
  TextEditingController name;
  TextEditingController address;

  getDetailsByHouseId() async {
    var url = Uri.parse('https://$serverHost/api/houses/${widget.houseId}');
    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        setState(() {
          house = House.fromJson(jsonData);
          name = new TextEditingController(text: house.houseInfo.name);
          address = new TextEditingController(text: house.houseInfo.address);
        });
      }
    } catch (error) {
      throw (error);
    }
  }

  Future updateHouseDetail() async {
    dynamic token = await FlutterSession().get("token");
    try {
      var jsonData = null;
      var url = Uri.parse('https://localhost:44322/api/houses');
      var response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: 'Bearer ${token.toString()}',
        },
        body: jsonEncode({
          "id": widget.houseId,
          "houseInfo": {
            "name": name.text,
            "address": address.text,
            "image": urlImage == null ? house.houseInfo.image : urlImage,
          }
        }),
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        jsonData = response.body;
        responseMsg = 'Cập nhật nhà thành công';
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
  void initState() {
    super.initState();
    getDetailsByHouseId();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Container(
        color: Color(0xFFF5F5F5),
        width: size.width,
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(
                bottom: 10,
              ),
              child: Text(
                'Chi tiết nhà',
                style: TextStyle(
                  color: Colors.blueGrey,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 30, horizontal: 10),
              height: size.height * 0.8,
              width: size.width * 0.87,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  width: 2,
                  color: Color(0xFF707070),
                  style: BorderStyle.solid,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        'Tên nhà: ',
                        style: TextStyle(fontSize: 20, color: Colors.grey),
                      ),
                      _isEdit
                          ? Container(
                              width: size.width * 0.6,
                              child: TextFormField(
                                controller: name,
                                style: TextStyle(fontSize: 20),
                              ),
                            )
                          : Container(
                              width: size.width * 0.6,
                              child: GestureDetector(
                                child: Text(
                                  house.houseInfo == null
                                      ? ''
                                      : house.houseInfo.name,
                                  style: TextStyle(fontSize: 20),
                                ),
                                onTap: () {
                                  setState(() {
                                    _isEdit = true;
                                  });
                                },
                              ),
                            ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        'Địa chỉ: ',
                        style: TextStyle(fontSize: 20, color: Colors.grey),
                      ),
                      _isEdit
                          ? Container(
                              width: size.width * 0.6,
                              child: TextFormField(
                                controller: address,
                                style: TextStyle(fontSize: 18),
                              ),
                            )
                          : Container(
                              width: size.width * 0.6,
                              child: GestureDetector(
                                child: Text(
                                  house.houseInfo == null
                                      ? ''
                                      : house.houseInfo.address,
                                  style: TextStyle(fontSize: 18),
                                ),
                                onTap: () {
                                  setState(() {
                                    _isEdit = true;
                                  });
                                },
                              ),
                            ),
                    ],
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 20),
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      child: Container(
                        height: size.height * 0.1,
                        width: size.width * 0.2,
                        child: house.houseInfo == null ? Container() : Image.network(
                          '${house.houseInfo.image}',
                          fit: BoxFit.cover,
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          _isEdit = true;
                          selectFile();
                        });
                      },
                    ),
                  ),
                  SizedBox(
                    height: 40,
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
                          onPressed: _isEdit
                              ? () => updateHouseDetail().then((value) => {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: Text(
                                        responseMsg == null ? "" : responseMsg,
                                        style: TextStyle(fontSize: 20),
                                      ),
                                    )),
                                  })
                              : null),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
