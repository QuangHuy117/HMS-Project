import 'package:flutter/material.dart';
import 'package:house_management_project/fonts/my_flutter_app_icons.dart';
import 'package:house_management_project/screens/DisplayBillPage.dart';
import 'package:house_management_project/screens/ListContractPage.dart';
import 'package:house_management_project/screens/NotificationPage.dart';
import 'package:house_management_project/tabScreens/LandLordProfile.dart';
import 'package:house_management_project/tabScreens/ListHouseView.dart';
import 'package:flutter/foundation.dart';

class HomePage extends StatefulWidget {
  final String username;

  HomePage({Key key, @required this.username}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final tabs = [
      ListHouseView(username: widget.username,),
      DisplayBillPage(),
      ListContractPage(),
      NotificationPage(),
      LandLordProfile(),
    ];

    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                blurRadius: 5,
                spreadRadius: 1,
              )
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
            ),
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              iconSize: 25,
              unselectedFontSize: 12,
              selectedFontSize: 12,
              backgroundColor: Colors.lightBlue,
              selectedItemColor: Colors.black,
              unselectedItemColor: Colors.white,
              currentIndex: _currentIndex,
              items: [
                BottomNavigationBarItem(
                    icon: Icon(
                      MyFlutterApp.home,
                      size: 28,
                    ),
                    label: 'Trang chủ'),
                    BottomNavigationBarItem(
                    icon: Icon(
                      MyFlutterApp.clipboard,
                    ),
                    label: 'Hóa đơn'),
                BottomNavigationBarItem(
                    icon: Icon(
                      MyFlutterApp.file_contract,
                    ),
                    label: 'Hợp đồng'),
                BottomNavigationBarItem(
                    icon: Icon(
                      MyFlutterApp.bell,
                    ),
                    label: 'Thông báo'),
                
                BottomNavigationBarItem(
                    icon: Icon(
                      MyFlutterApp.user,
                    ),
                    label: 'Hồ sơ'),
              ],
              onTap: (value) {
                setState(() {
                  _currentIndex = value;
                });
              },
            ),
          ),
        ),
        body: tabs[_currentIndex],
      ),
    );
  }
}
