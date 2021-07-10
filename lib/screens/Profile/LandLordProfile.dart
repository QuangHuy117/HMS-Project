import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
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
  List<House> list = [];
  int _numberOfRoom = 0;
  dynamic username, name, email;

  getHouseData() async {
    username = await FlutterSession().get("username");
    name = await FlutterSession().get("name");
    email = await FlutterSession().get("email");
    var url = Uri.parse(
        'https://localhost:44322/api/houses?username=$username');
    try {
      var response = await http.get(url);
      print(response.statusCode);
      if (response.statusCode == 200) {
        var items = jsonDecode(response.body);
        setState(() {
          for (var u in items) {
            print(u);
            House house = new House.fromJson(u);
            list.add(house);
          }
          // for (var i in list) {
          //   _numberOfRoom += i.houseInfo.numberOfRoom;
          // }
        });
      }
    } catch (error) {
      throw (error);
    }
  }


  @override
  void initState() {
    super.initState();
    getHouseData();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // endDrawer: new Drawer(
        //   child: ListView(
        //     children: [
        //       new UserAccountsDrawerHeader(
        //         accountName: Text(
        //           widget.name,
        //           style: TextStyle(fontSize: 18),
        //         ),
        //         accountEmail:
        //             Text(widget.email, style: TextStyle(fontSize: 16)),
        //         currentAccountPicture: new CircleAvatar(
        //           backgroundImage: AssetImage('assets/images/user.png'),
        //           backgroundColor: Colors.white,
        //         ),
        //       ),
        //       ListTile(
        //         leading: Icon(MyFlutterApp.clipboard),
        //         title: Text(
        //           'Thông tin',
        //           style: TextStyle(fontSize: 18),
        //         ),
        //         onTap: () {
        //           print('About Page');
        //         },
        //       ),
        //       ListTile(
        //         leading: Icon(MyFlutterApp.phone),
        //         title: Text(
        //           'Liên hệ',
        //           style: TextStyle(fontSize: 18),
        //         ),
        //         subtitle: Text(
        //           '0902923542',
        //           style: TextStyle(fontSize: 16),
        //         ),
        //         onTap: () {
        //           print('About Page');
        //         },
        //       ),
        //       ListTile(
        //         leading: Icon(MyFlutterApp.mail),
        //         title: Text(
        //           'Email',
        //           style: TextStyle(fontSize: 18),
        //         ),
        //         subtitle: Text(
        //           'admin@gmail.com',
        //           style: TextStyle(fontSize: 16),
        //         ),
        //         onTap: () {
        //           print('About Page');
        //         },
        //       ),
        //       Divider(
        //         color: Colors.black,
        //         height: 10,
        //       ),
        //       ListTile(
        //         leading: Icon(Icons.star),
        //         title: Text(
        //           'Đánh giá',
        //           style: TextStyle(fontSize: 18),
        //         ),
        //         onTap: () {
        //           print('About Page');
        //         },
        //       ),
        //       ListTile(
        //         leading: Icon(Icons.help),
        //         title: Text(
        //           'Trợ giúp',
        //           style: TextStyle(fontSize: 18),
        //         ),
        //         onTap: () {
        //           print('About Page');
        //         },
        //       ),
        //       Divider(
        //         color: Colors.black,
        //         height: 10,
        //       ),
        //       ListTile(
        //         leading: Icon(Icons.logout),
        //         title: Text(
        //           'Đăng xuất',
        //           style: TextStyle(fontSize: 18),
        //         ),
        //         onTap: () {

        //         },
        //       ),
        //     ],
        //   ),
        // ),
        body: setUserForm(name.toString()),
      ),
    );
  }

  Widget setUserForm(String username) {
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
              height: MediaQuery.of(context).size.height * 0.25,
              child: Card(
                  elevation: 20.0,
                  margin: EdgeInsets.only(left: 25.0, right: 25.0, top: 100.0),
                  child: ListView(
                      padding: EdgeInsets.only(
                          top: 15.0, left: 20.0, right: 20.0, bottom: 5.0),
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
                                    list.length.toString(),
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
                        Row(),
                      ])),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              color: Colors.white,
              height: MediaQuery.of(context).size.height * 0.63,
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
                    username.contains('null') ? '' : username,
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
        child: CircleAvatar(
          radius: 25,
          backgroundImage: AssetImage('assets/images/user.png'),
          backgroundColor: Colors.transparent,
        ),
      )
      // Positioned(
      //   top: 20,
      //   right: 10,
      //   child: Container(
      //     child: TextButton(
      //       child: Text('upload'),
      //       onPressed: selectFile
      //   ),
      //   ),
      // )
    ]);
  }
}


 