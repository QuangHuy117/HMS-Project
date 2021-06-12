import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:house_management_project/fonts/my_flutter_app_icons.dart';
import 'package:house_management_project/models/House.dart';
import 'package:house_management_project/tabScreens/LandLordProfile.dart';
import 'package:house_management_project/tabScreens/ListHouseView.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  final String username;

  HomePage({Key key, @required this.username}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  List<House> list = [];

  getHouseData() async {
    var url = Uri.parse(
        'https://localhost:44322/api/houses?username=${widget.username}');
    try {
      var response = await http.get(url);
      print(response.statusCode);
      if (response.statusCode == 200) {
        var items = jsonDecode(response.body);
        setState(() {
          print(items);
          for (var u in items) {
            print(u);
            House house = new House.fromJson(u);
            list.add(house);
          }
        });
      }
    } catch (error) {
      throw (error);
    }
  }

  @override
  void initState() {
    super.initState();
    this.getHouseData();
  }

  @override
  Widget build(BuildContext context) {
    final tabs = [
      ListHouseView(list: list, username: widget.username,),
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
              currentIndex: _currentIndex,
              items: [
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.house,
                      size: 35,
                    ),
                    label: ''),
                BottomNavigationBarItem(
                    icon: Icon(
                      MyFlutterApp.user,
                      size: 28,
                    ),
                    label: ''),
              ],
              onTap: (value) {
                setState(() {
                  _currentIndex = value;
                  
                });
                
              },
            ),
          ),
        ),
        body:
            tabs[_currentIndex],
      ),
    );
  }
}
