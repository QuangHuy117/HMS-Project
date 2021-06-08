import 'package:flutter/material.dart';
import 'package:house_management_project/fonts/my_flutter_app_icons.dart';
import 'package:house_management_project/tabScreens/LandLordProfile.dart';
import 'package:house_management_project/tabScreens/ListHouseView.dart';

class HomePage extends StatefulWidget {
  const HomePage({ Key key }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final tabs = [
    ListHouseView(),
    LandLordProfile(),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            boxShadow: [ BoxShadow(
            color: Colors.grey,
            blurRadius: 6,
            )],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
            child: BottomNavigationBar(
              currentIndex: _currentIndex,
              items: [
                BottomNavigationBarItem(icon: Icon(Icons.house, size: 35,), label: ''),
                BottomNavigationBarItem(icon: Icon(MyFlutterApp.user, size: 28,), label: ''),
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