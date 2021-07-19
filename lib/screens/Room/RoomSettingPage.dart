import 'package:flutter/material.dart';
import 'package:house_management_project/fonts/my_flutter_app_icons.dart';
import 'package:house_management_project/screens/Room/RoomDetailsPage.dart';
import 'package:house_management_project/screens/Room/RoomServicesPage.dart';

class RoomSettingPage extends StatefulWidget {
  final int roomId;
  final String houseId;
  const RoomSettingPage({ Key key, 
  @required this.roomId,
  @required this.houseId, }) : super(key: key);

  @override
  _RoomSettingPageState createState() => _RoomSettingPageState();
}

class _RoomSettingPageState extends State<RoomSettingPage> {
  @override
  Widget build(BuildContext context) {
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
                'Quản Lý Phòng',
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
                  color: Colors.white,
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
                        child: Text('Tạo hóa đơn'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          body: TabBarView(
              children: [
                RoomDetailsPage(roomId: widget.roomId,
                houseId: widget.houseId),
                RoomServicesPage(roomId: widget.roomId,
                houseId: widget.houseId,),
              ],
            ),
        ),
      ),
    );
  }
}