import 'package:flutter/material.dart';
import 'package:house_management_project/fonts/my_flutter_app_icons.dart';
import 'package:house_management_project/main.dart';
import 'package:house_management_project/screens/Bill/ListBillPage.dart';
import 'package:house_management_project/screens/Contract/ListContractPage.dart';
import 'package:house_management_project/screens/NotificationPage.dart';
import 'package:house_management_project/screens/Room/RoomPage.dart';
import 'package:house_management_project/screens/Profile/LandLordProfile.dart';
import 'package:titled_navigation_bar/titled_navigation_bar.dart';

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
        bottomNavigationBar: 
        ClipRRect(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
          child: TitledBottomNavigationBar(
              curve: Curves.easeOutBack,
              activeColor: Colors.black,
              indicatorColor: Colors.black,
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
                    title: Container(padding: EdgeInsets.only(left: 15) , child: Text('Danh sách phòng', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w600))), icon: Icons.meeting_room, backgroundColor: PrimaryColor),
                TitledNavigationBarItem(
                    title: Text('Hóa đơn', style: TextStyle(fontWeight: FontWeight.w600)), icon: MyFlutterApp.clipboard, backgroundColor: PrimaryColor),
                TitledNavigationBarItem(
                    title: Text('Hợp đồng', style: TextStyle(fontWeight: FontWeight.w600)), icon: MyFlutterApp.file_contract, backgroundColor: PrimaryColor),
                TitledNavigationBarItem(
                    title: Text('Thông báo', style: TextStyle(fontWeight: FontWeight.w600)), icon: MyFlutterApp.bell, backgroundColor: PrimaryColor),
                TitledNavigationBarItem(
                    title: Text('Hồ sơ', style: TextStyle(fontWeight: FontWeight.w600)), icon: MyFlutterApp.user, backgroundColor: PrimaryColor),
              ]),
        ),
        body: tabs[_currentIndex],
      ),
    );
  }
}
