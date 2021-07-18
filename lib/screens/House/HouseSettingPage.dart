import 'package:flutter/material.dart';
import 'package:house_management_project/fonts/my_flutter_app_icons.dart';
import 'package:house_management_project/screens/House/HouseDetailsPage.dart';
import 'package:house_management_project/screens/House/HouseServicesPage.dart';

class HouseSettingPage extends StatefulWidget {
  final String houseId;
  const HouseSettingPage({Key key, this.houseId}) : super(key: key);

  @override
  _HouseSettingPageState createState() => _HouseSettingPageState();
}

class _HouseSettingPageState extends State<HouseSettingPage> {
  @override
  Widget build(BuildContext context) {
    // Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            automaticallyImplyLeading: false,
            leading: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  MyFlutterApp.left,
                  color: Colors.white,
                  size: 27,
                )),
            centerTitle: true,
            title: Text(
              'Quản Lý Nhà',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w700),
            ),
            bottom: TabBar(
              indicator: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10)),
                color: Color(0xFFF5F5F5),
              ),
              labelColor: Colors.blueGrey,
              labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              unselectedLabelColor: Colors.white70,
              tabs: [
                Tab(
                  child: Container(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text('Thông tin'),
                    ),
                  ),
                ),
                Tab(
                  child: Container(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text('Dịch vụ'),
                    ),
                  ),
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              HouseDetailsPage(houseId: widget.houseId,),
              HouseServicesPage(houseId: widget.houseId,),
            ],
          ),
        ),
      ),
    );
  }
}
