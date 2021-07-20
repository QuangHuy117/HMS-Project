
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:house_management_project/main.dart';
import 'package:house_management_project/screens/House/HouseSettingPage.dart';
import 'package:house_management_project/screens/Room/ListRoomNotUsing.dart';
import 'package:house_management_project/screens/Room/ListRoomUsing.dart';
import 'package:house_management_project/fonts/my_flutter_app_icons.dart';

class RoomPage extends StatefulWidget {
  final String houseId;
  RoomPage({
    Key key,
    @required this.houseId,
  }) : super(key: key);

  @override
  _RoomPageState createState() => _RoomPageState();
}

class _RoomPageState extends State<RoomPage> {
  String showErr = "";
  TextEditingController name = new TextEditingController();
  TextEditingController price = new TextEditingController();
  TextEditingController square = new TextEditingController();
  String responseMsg = '';

  

  @override
  Widget build(BuildContext context) {
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
                    MyFlutterApp.left,
                    color: Colors.white,
                    size: 30,
                  )),
              actions: [
                IconButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) =>
                    HouseSettingPage(houseId: widget.houseId,),));
                  }, 
                  icon: Icon(MyFlutterApp.cog, color: Colors.white,),
                  ),
              ],
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
