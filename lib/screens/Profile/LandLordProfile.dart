import 'dart:convert';
import 'dart:io';

import 'package:house_management_project/models/Room.dart';
import 'package:path/path.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:house_management_project/api/firebase_api.dart';
import 'package:house_management_project/main.dart';
import 'package:house_management_project/models/House.dart';
import 'package:house_management_project/screens/Profile/UserInfoPage.dart';
import 'package:house_management_project/screens/SignIn/SignInPage.dart';
import 'package:http/http.dart' as http;

class LandLordProfile extends StatefulWidget {
  const LandLordProfile({
    Key key,
  }) : super(key: key);

  @override
  _LandLordProfileState createState() => _LandLordProfileState();
}

class _LandLordProfileState extends State<LandLordProfile> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SetUserForm(),
      ),
    );
  }

  // Widget setUserForm(String username) {
  //   return
  // }
}

class SetUserForm extends StatefulWidget {
  const SetUserForm({Key key}) : super(key: key);

  @override
  _SetUserFormState createState() => _SetUserFormState();
}

class _SetUserFormState extends State<SetUserForm> {
  List<House> listHouse = [];
  List<Room> listRoom = [];
  List<Room> listRoomUsing = [];
  List<Room> listRoomNotUsing = [];
  int _numberOfHouse = 0;
  int _numberOfRoom = 0;
  UploadTask task;
  File file;
  dynamic name, image;

  // String token =
  // 'https://firebasestorage.googleapis.com/v0/b/hms-project-5d6b1.appspot.com/o/files%2F205558665_949919552234828_8681075534449186613_n.jpg?alt=media&token=3e6351f0-915f-4b07-9cfd-d5e6540fed68';

  countHouse() async {
    name = await FlutterSession().get("name");
    image = await FlutterSession().get("image");
    dynamic token = await FlutterSession().get("token");
    var url = Uri.parse('https://localhost:44322/api/houses/count');
    try {
      var response = await http.get(
        url,
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer ${token.toString()}',
        },
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        setState(() {
          _numberOfHouse = int.parse(response.body);
        });
      }
    } catch (error) {
      throw (error);
    }
  }

  getHouseData() async {
    dynamic token = await FlutterSession().get("token");
    var url = Uri.parse('https://localhost:44322/api/houses');
    try {
      var response = await http.get(
        url,
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer ${token.toString()}',
        },
      );
      if (response.statusCode == 200) {
        setState(() {
          listHouse = houseFromJson(response.body);
          for (var i in listHouse) {
            countRoom(i.id);
            countRoomSeperate(i.id);
          }
        });
      }
    } catch (error) {
      throw (error);
    }
  }

  countRoom(String id) async {
    var url = Uri.parse('https://localhost:44322/api/rooms/count?HouseId=$id');
    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        setState(() {
          _numberOfRoom += int.parse(response.body);
        });
      }
    } catch (error) {
      throw (error);
    }
  }

  countRoomSeperate(String id) async {
    var url = Uri.parse('https://localhost:44322/api/rooms?HouseId=$id');
    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        setState(() {
          listRoom = roomFromJson(response.body);
          for (var i in listRoom) {
            if (i.status == true) {
              listRoomUsing.add(i);
            } else {
              listRoomNotUsing.add(i);
            }
          }
        });
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
    if (file == null) return;

    final fileName = basename(file.path);
    final destination = 'files/$fileName';

    task = FirebaseApi.uploadFile(destination, file);
    // setState(() {});

    if (task == null) return;

    final snapshot = await task.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();

    print('Download-Link: $urlDownload');
  }

  @override
  void initState() {
    super.initState();
    countHouse();
    getHouseData();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(40),
              bottomRight: Radius.circular(40),
            ),
            color: PrimaryColor,
          ),
          height: MediaQuery.of(context).size.height * 0.25),
      Container(
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.26,
              child: Card(
                  elevation: 20.0,
                  margin: EdgeInsets.only(left: 25.0, right: 25.0, top: 100.0),
                  child: ListView(
                      padding: EdgeInsets.only(
                          top: 15.0, left: 20.0, right: 20.0, bottom: 15.0),
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Column(
                                children: [
                                  Text(
                                    'Số tòa nhà',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    _numberOfHouse.toString(),
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Column(
                                children: [
                                  Text(
                                    'Số phòng',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    _numberOfRoom.toString(),
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: Column(
                                children: [
                                  Text(
                                    'Số phòng đang thuê',
                                    style: TextStyle(
                                        fontSize: 19,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    listRoomUsing.length.toString(),
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              child: Column(
                                children: [
                                  Text(
                                    'Số phòng chưa thuê',
                                    style: TextStyle(
                                        fontSize: 19,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    listRoomNotUsing.length.toString(),
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ])),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              color: Colors.white,
              height: MediaQuery.of(context).size.height * 0.45,
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(
                      Icons.person_outline_outlined,
                      size: 28,
                    ),
                    title: Text('Thông tin của tôi'),
                    trailing: Icon(Icons.arrow_forward_ios_outlined),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => UserInfoPage()));
                    },
                  ),
                  Divider(
                    color: Colors.grey,
                    thickness: 1,
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.contact_page_outlined,
                      size: 28,
                    ),
                    title: Text('Liên hệ'),
                    trailing: Icon(Icons.arrow_forward_ios_outlined),
                    onTap: () {
                      // var test = token.split("&");
                      // var demo = test[1].split("=");
                      // print(demo[1]);
                    },
                  ),
                  Divider(
                    color: Colors.grey,
                    thickness: 1,
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.star_border_outlined,
                      size: 28,
                    ),
                    title: Text('Đánh giá'),
                    trailing: Icon(Icons.arrow_forward_ios_outlined),
                  ),
                  Divider(
                    color: Colors.grey.shade200,
                    thickness: 10,
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.info_outline_rounded,
                      size: 28,
                    ),
                    title: Text('Về ứng dụng'),
                    trailing: Icon(Icons.arrow_forward_ios_outlined),
                  ),
                  Divider(
                    color: Colors.grey,
                    thickness: 1,
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.help_outline_outlined,
                      size: 28,
                    ),
                    title: Text('Trợ giúp'),
                    trailing: Icon(Icons.arrow_forward_ios_outlined),
                  ),
                  Divider(
                    color: Colors.grey.shade200,
                    thickness: 10,
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.logout,
                      size: 28,
                    ),
                    title: Text('Đăng xuất'),
                    trailing: Icon(Icons.arrow_forward_ios_outlined),
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (_) => SignInPage()),
                          (route) => false);
                    },
                  ),
                  Divider(
                    color: Colors.grey,
                    thickness: 1,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      Positioned(
        top: 20,
        left: 5,
        right: 0,
        child: AppBar(
          automaticallyImplyLeading: false,
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          title: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Xin chào,',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  Text(
                    name.toString().contains('null') ? '' : name.toString(),
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  ),
                ],
              ),
              // SizedBox(
              //   width: 40,
              // ),
            ],
          ),
        ),
      ),
      Positioned(
        top: 20,
        right: 10,
        child: GestureDetector(
          child: CircleAvatar(
            radius: 25,
            // backgroundImage: image == null ? AssetImage('assets/images/user.png') : image,
            backgroundImage: AssetImage('assets/images/user.png'),
            backgroundColor: Colors.transparent,
          ),
          onTap: selectFile,
        ),
      )
      // Positioned(
      //   top: 20,
      //   right: 10,
      //   child: Container(
      //     child: TextButton(child: Text('upload'), onPressed: selectFile),
      //   ),
      // )
    ]);
  }
}
