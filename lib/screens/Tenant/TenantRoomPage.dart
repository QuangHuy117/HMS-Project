import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:house_management_project/fonts/my_flutter_app_icons.dart';
import 'package:house_management_project/main.dart';
import 'package:house_management_project/models/Room.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class TenantRoomPage extends StatefulWidget {
  final int roomId;
  const TenantRoomPage({Key key, @required this.roomId}) : super(key: key);

  @override
  _TenantRoomPageState createState() => _TenantRoomPageState();
}

class _TenantRoomPageState extends State<TenantRoomPage> {
  Room room = new Room();

  getRoomData() async {
    print(widget.roomId);
    var url = Uri.parse('https://$serverHost/api/rooms/${widget.roomId}');
    try {
      var response = await http.get(url);
      print(response.statusCode);
      if (response.statusCode == 200) {
        var items = jsonDecode(response.body);
        setState(() {
          room = Room.fromJson(items);
          print(room);
        });
      }
    } catch (error) {
      throw (error);
    }
  }

  @override
  void initState() {
    super.initState();
    getRoomData();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text(
            'Phòng của tôi',
            style: TextStyle(
                color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700),
          ),
          centerTitle: true,
          backgroundColor: PrimaryColor,
          leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                MyFlutterApp.left,
                color: Colors.white,
                size: 30,
              )),
        ),
        body: SingleChildScrollView(
          child: Container(
            height: size.height * 0.8,
            width: size.width,
            padding: EdgeInsets.symmetric(vertical: 10),
            child: RefreshIndicator(
              child: Container(
                height: size.height * 0.18,
                padding: EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                margin: EdgeInsets.only(
                  top: 30,
                ),
                child: GestureDetector(
                  onTap: () {
                    //  else {
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (_) => BillHistoryPage(
                    //               contractId:
                    //                   listRoom[index].contract.id,
                    //             )));
                    // }
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40),
                          bottomLeft: Radius.circular(40),
                          topRight: Radius.circular(5),
                          bottomRight: Radius.circular(5)),
                    ),
                    elevation: 5,
                    shadowColor: Colors.black,
                    child: Stack(
                      children: [
                        Positioned(
                          top: 50,
                          left: 5,
                          child: Icon(
                            Icons.meeting_room,
                            color: PrimaryColor,
                            size: 60,
                          ),
                        ),
                        Positioned(
                          top: 30,
                          left: 65,
                          child: Container(
                            width: size.width * 0.6,
                            padding: EdgeInsets.only(
                              right: 10,
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Tên phòng : ',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    Text(
                                      '${room.name}',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'Tên khách : ',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    Text(
                                      '${room.contract == null ? 'Trống' : room.contract.tenant.name}',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'Ngày thuê : ',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    Text(
                                      '${room.contract == null ? 'Trống' : DateFormat('dd/MM/yyyy').format(room.contract.startDate)}',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'Ngày hết hạn : ',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    Text(
                                      '${room.contract == null ? 'Trống' : DateFormat('dd/MM/yyyy').format(room.contract.endDate)}',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Positioned(
                        //   bottom: 10,
                        //   right: 10,
                        //   child: GestureDetector(
                        //     child: Icon(
                        //       MyFlutterApp.cog,
                        //       color: PrimaryColor,
                        //     ),
                        //     onTap: () {
                        //       Navigator.push(
                        //           context,
                        //           MaterialPageRoute(
                        //               builder: (context) =>
                        //                   RoomSettingPage(
                        //                     roomId:
                        //                         listRoom[index].id,
                        //                     houseId: widget.houseId,
                        //                   )));
                        //     },
                        //   ),
                        // ),
                        Positioned(
                          top: 10,
                          right: 10,
                          child: Text(
                            '${room.status ? 'Đang thuê' : ''}',
                            style: TextStyle(
                              color: room.status
                                  ? PrimaryColor
                                  : Color(0xFF707070),
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              onRefresh: () => getRoomData(),
            ),
          ),
        ),
      ),
    );
  }
}
