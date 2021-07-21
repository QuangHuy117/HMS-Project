import 'dart:convert';
import 'dart:io';

import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:house_management_project/fonts/my_flutter_app_icons.dart';
import 'package:house_management_project/main.dart';
import 'package:house_management_project/models/House.dart';
import 'package:house_management_project/screens/House/HouseSettingPage.dart';
import 'package:house_management_project/screens/Room/RoomNavigationBar.dart';

class ListHouseNotUsing extends StatefulWidget {
  const ListHouseNotUsing({Key key}) : super(key: key);

  @override
  _ListHouseNotUsingState createState() => _ListHouseNotUsingState();
}

class _ListHouseNotUsingState extends State<ListHouseNotUsing> {
  List<House> listHouse = [];

  getHouseData() async {
    listHouse.clear();
    dynamic token = await FlutterSession().get("token");
    var url = Uri.parse('https://$serverHost/api/houses?Status=false');
    try {
      var response = await http.get(
        url,
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer ${token.toString()}',
        },
      );

      print(response.statusCode);
      if (response.statusCode == 200) {
        var items = jsonDecode(response.body);
        setState(() {
          for (var u in items) {
            // print(u);
            House house = new House.fromJson(u);
            listHouse.add(house);
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
    getHouseData();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Container(
        height: size.height * 0.85,
        width: size.width,
        padding: EdgeInsets.symmetric(vertical: 10),
        child: RefreshIndicator(
          child: ListView.builder(
            itemBuilder: (context, index) {
              return Container(
                height: size.height * 0.2,
                padding: EdgeInsets.symmetric(
                  horizontal: 15,
                ),
                margin: EdgeInsets.only(
                  top: 30,
                ),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RoomNavigationBar(
                                houseId: listHouse[index].id,
                              )),
                    );
                  },
                  child: Slidable(
                    actionPane: SlidableDrawerActionPane(),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 6,
                      shadowColor: Colors.black,
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.only(left: size.width * 0.01),
                            width: size.height * 0.18,
                            height: size.height * 0.18,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                '${listHouse[index].houseInfo.image}',
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.only(top: 10,),
                                width: size.width * 0.53,
                                alignment: Alignment.centerRight,
                                child: Text(
                                  '${listHouse[index].status ? '' : 'Chưa thuê'}',
                                  style: TextStyle(
                                    color: listHouse[index].status
                                        ? PrimaryColor
                                        : Color(0xFF707070),
                                    fontSize: 21,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              SizedBox(height: size.height * 0.01,),
                              Container(
                                width: size.width * 0.5,
                                padding: EdgeInsets.only(left: size.width * 0.03),
                                child: Text(
                                  'Nhà ở ${listHouse[index].houseInfo.name}',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black87
                                  ),
                                ),
                              ),
                              SizedBox(height: size.height * 0.025,),
                              Container(
                                width: size.width * 0.52,
                                padding: EdgeInsets.only(left: 10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(Icons.room, color: PrimaryColor,),
                                    Container(
                                      width: size.width * 0.44,
                                      padding: EdgeInsets.only(
                                        right: size.width * 0.01,
                                      ),
                                      child: Text(
                                        '${listHouse[index].houseInfo.address}',
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.blueGrey,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          // Container(
                          //   width: size.height * 0.17,
                          //   height: size.height * 0.18,
                          //   decoration: BoxDecoration(
                          //     borderRadius: BorderRadius.circular(20),
                          //     color: Colors.grey
                          //   ),
                          //   child: (
                          //     Image.network('${listHouse[index].houseInfo.image}',
                          //     fit: BoxFit.contain,)
                          //   ),
                          // ),
                        ],
                      ),
                      // Stack(
                      //   children: [
                      //     Positioned(
                      //       top: 30,
                      //       left: 5,
                      //       child: Icon(
                      //         MyFlutterApp.home,
                      //         color: PrimaryColor,
                      //         size: 60,
                      //       ),
                      //     ),
                      //     Positioned(
                      //       top: 28,
                      //       left: 70,
                      //       child: Container(
                      //         width: size.width * 0.6,
                      //         padding: EdgeInsets.only(
                      //           right: 10,
                      //         ),
                      //         child: Column(
                      //           crossAxisAlignment: CrossAxisAlignment.start,
                      //           children: [
                      //             Text(
                      //               'Nhà ở ${listHouse[index].houseInfo.name}',
                      //               style: TextStyle(
                      //                 fontSize: 20,
                      //                 fontWeight: FontWeight.w700,
                      //               ),
                      //             ),
                      //             SizedBox(
                      //               height: 5,
                      //             ),
                      //             Text(
                      //               '${listHouse[index].houseInfo.address}',
                      //               style: TextStyle(
                      //                 fontSize: 16,
                      //               ),
                      //             ),
                      //           ],
                      //         ),
                      //       ),
                      //     ),
                      //     Positioned(
                      //       top: 15,
                      //       right: 10,
                      //       child: Text(
                      //         '${listHouse[index].status ? 'Đang thuê' : ''}',
                      //         style: TextStyle(
                      //           color: listHouse[index].status
                      //               ? PrimaryColor
                      //               : Color(0xFF707070),
                      //           fontSize: 20,
                      //           fontWeight: FontWeight.w700,
                      //         ),
                      //       ),
                      //     ),
                      //     Positioned(
                      //       bottom: 10,
                      //       right: 10,
                      //       child: GestureDetector(
                      //         onTap: () {
                      //           Navigator.push(
                      //             context,
                      //             MaterialPageRoute(
                      //                 builder: (context) => HouseSettingPage(
                      //                     houseId: listHouse[index].id)),
                      //           );
                      //         },
                      //         child: Icon(
                      //           MyFlutterApp.cog,
                      //           color: PrimaryColor,
                      //           size: 28,
                      //         ),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                    ),
                    secondaryActions: [
                      ClipRRect(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                        child: IconSlideAction(
                          caption: 'Delete',
                          color: Colors.red,
                          icon: Icons.delete,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            itemCount: listHouse.length,
          ),
          onRefresh: () => getHouseData(),
        ),
      ),
    );
  }
}
