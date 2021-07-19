import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:house_management_project/fonts/my_flutter_app_icons.dart';
import 'package:house_management_project/main.dart';
import 'package:house_management_project/models/House.dart';
import 'package:house_management_project/screens/Tenant/TenantContractPage.dart';
import 'package:house_management_project/screens/Tenant/TenantRoomPage.dart';
import 'package:http/http.dart' as http;
import 'package:titled_navigation_bar/titled_navigation_bar.dart';

import 'TenantProfile.dart';

class TenantHomePage extends StatefulWidget {
  const TenantHomePage({Key key}) : super(key: key);

  @override
  _TenantHomePageState createState() => _TenantHomePageState();
}

class _TenantHomePageState extends State<TenantHomePage> {
  List<House> listHouse = [];
  int _currentIndex = 0;
  

  @override
  Widget build(BuildContext context) {
    final tabs = [
      TenantContractPage(),
      TenantProfile(),
      // ListBillPage(),
      // ListContractPage(),
      // NotificationPage(),
      // LandLordProfile(),
    ];
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: ClipRRect(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
          child: TitledBottomNavigationBar(
              curve: Curves.easeOutBack,
              activeColor: Colors.black,
              inactiveColor: Colors.white,
              reverse: true,
              currentIndex: _currentIndex,
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              items: [
                TitledNavigationBarItem(
                    title: Container(padding: EdgeInsets.only(left: 15) , child: Text('Hợp đồng', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w600))), icon: MyFlutterApp.home, backgroundColor: PrimaryColor),
                // TitledNavigationBarItem(
                //     title: Text('Hóa đơn', style: TextStyle(fontWeight: FontWeight.w600)), icon: MyFlutterApp.clipboard, backgroundColor: PrimaryColor),
                // TitledNavigationBarItem(
                //     title: Text('Hợp đồng', style: TextStyle(fontWeight: FontWeight.w600)), icon: MyFlutterApp.file_contract, backgroundColor: PrimaryColor),
                // TitledNavigationBarItem(
                //     title: Text('Thông báo', style: TextStyle(fontWeight: FontWeight.w600)), icon: MyFlutterApp.bell, backgroundColor: PrimaryColor),
                TitledNavigationBarItem(
                    title: Text('Hồ sơ', style: TextStyle(fontWeight: FontWeight.w600)), icon: MyFlutterApp.user, backgroundColor: PrimaryColor),
              ]),
        ),
        body: tabs[_currentIndex],
      ),
    );
  }
}
        
