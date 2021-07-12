import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:house_management_project/main.dart';
import 'package:house_management_project/models/Room.dart';
import 'package:house_management_project/screens/Room/ListRoomNotUsing.dart';
import 'package:house_management_project/screens/Room/ListRoomUsing.dart';
import 'package:http/http.dart' as http;
import 'package:house_management_project/fonts/my_flutter_app_icons.dart';

class RoomPage extends StatefulWidget {
  final String houseId;
  RoomPage({Key key, 
  @required this.houseId,})
      : super(key: key);

  @override
  _RoomPageState createState() => _RoomPageState();
}

class _RoomPageState extends State<RoomPage> {
  List<Room> listRoom = [];
  List<Room> listRoomUsing = [];
  List<Room> listRoomNotUsing = [];


  // getListRoomSeparate(List<Room> listRoomSeparate) {
  //   for (var u in listRoomSeparate) {
  //     if (u.status == true) {
  //       listRoomUsing.add(u);
  //     } else {
  //       listRoomNotUsing.add(u);
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    // Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: AppBar(
              elevation: 0,
              title: Text(
                'Danh Sách Phòng',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w700),
              ),
              centerTitle: true,
              automaticallyImplyLeading: false,
              leading: GestureDetector(
                  onTap: () {
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                  child: Icon(
                    MyFlutterApp.home,
                    color: Colors.white,
                    size: 30,
                  )),
              bottom: TabBar(
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)),
                  color: Colors.white,
                ),
                labelColor: PrimaryColor,
                labelStyle:
                    TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                unselectedLabelColor: Colors.white70,
                tabs: [
                  Tab(
                    child: Container(
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Phòng đang thuê',
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Tab(
                    child: Container(
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Phòng chưa thuê',
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                ListRoomUsing(
                  houseId: widget.houseId,
                ),
                ListRoomNotUsing(
                  houseId: widget.houseId,
                ),
              ],
            )),
      ),
    );
  }
}
