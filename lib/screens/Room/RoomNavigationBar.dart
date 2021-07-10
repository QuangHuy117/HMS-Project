import 'package:flutter/material.dart';
import 'package:house_management_project/fonts/my_flutter_app_icons.dart';
import 'package:house_management_project/screens/Bill/ListBillPage.dart';
import 'package:house_management_project/screens/Contract/ListContractPage.dart';
import 'package:house_management_project/screens/NotificationPage.dart';
import 'package:house_management_project/screens/Room/RoomPage.dart';
import 'package:house_management_project/screens/Profile/LandLordProfile.dart';

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
  

  @override
  Widget build(BuildContext context) {
    final tabs = [
      RoomPage(
        houseId: widget.houseId,
      ),
      ListBillPage(),
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
                blurRadius: 6,
              )
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
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
                      Icons.meeting_room,
                      size: 28,
                    ),
                    label: 'Danh sách phòng'),
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
                print(value);
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
