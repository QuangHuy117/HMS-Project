import 'package:flutter/material.dart';
import 'package:house_management_project/fonts/my_flutter_app_icons.dart';
import 'package:house_management_project/main.dart';
import 'package:house_management_project/models/Room.dart';
import 'package:house_management_project/screens/Bill/BillHistoryPage.dart';
import 'package:house_management_project/screens/Room/RoomSettingPage.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class ListRoomUsing extends StatefulWidget {
  final String houseId;
  const ListRoomUsing({ Key key,
  @required this.houseId,}) : super(key: key);

  @override
  _ListRoomUsingState createState() => _ListRoomUsingState();
}

class _ListRoomUsingState extends State<ListRoomUsing> {

  List<Room> listRoom = [];

  getRoomsByHouseId() async {
    var url = Uri.parse(
        'https://localhost:44322/api/rooms?HouseId=${widget.houseId}&Status=true');
    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        setState(() {
          listRoom = roomFromJson(response.body);
        });
      }
    } catch (error) {
      throw (error);
    }
  }

  @override
  void initState() {
    super.initState();
    getRoomsByHouseId();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Container(
        height: size.height * 0.8,
        width: size.width,
        padding: EdgeInsets.symmetric(vertical: 10),
        child: ListView.builder(
          itemBuilder: (context, index) {
            return Container(
              height: size.height * 0.2,
              padding: EdgeInsets.symmetric(
                horizontal: 20,
              ),
              margin: EdgeInsets.only(
                top: 30,
              ),
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
                      top: 40,
                      left: 5,
                      child: Icon(
                        MyFlutterApp.home,
                        color: PrimaryColor,
                        size: 60,
                      ),
                    ),
                    Positioned(
                      top: 20,
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
                                  '${listRoom[index].name}',
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
                                  '${listRoom[index].contract == null ? 'Trống' : listRoom[index].contract.tenant.name}',
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
                                  '${listRoom[index].contract == null ? 'Trống' : DateFormat('dd/MM/yyyy').format(listRoom[index].contract.startDate)}',
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
                                  '${listRoom[index].contract == null ? 'Trống' : DateFormat('dd/MM/yyyy').format(listRoom[index].contract.endDate)}',
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
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(right: 20, left: 25),
                                  width: size.width * 0.2,
                                  height: size.height * 0.045,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10.0),
                                    child: TextButton(
                                      style: TextButton.styleFrom(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 5),
                                        backgroundColor: PrimaryColor,
                                      ),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Icon(
                                            MyFlutterApp.cog,
                                            color: Colors.black87,
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            'Quản lý',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ],
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    RoomSettingPage(
                                                      roomId: listRoom[index].id,
                                                      houseId: widget.houseId,
                                                    )));
                                      },
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 10),
                                  width: size.width * 0.21,
                                  height: size.height * 0.045,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10.0),
                                    child: TextButton(
                                      style: TextButton.styleFrom(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 5),
                                        backgroundColor: PrimaryColor,
                                      ),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Icon(
                                            MyFlutterApp.clipboard,
                                            color: Colors.black87,
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            'Hóa đơn',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ],
                                      ),
                                      onPressed: () {
                                        Navigator.push(context, MaterialPageRoute(builder: (_) => BillHistoryPage(contractId: listRoom[index].contract.id,)));
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: 10,
                      right: 10,
                      child: Text(
                        '${listRoom[index].status ? 'Đang thuê' : ''}',
                        style: TextStyle(
                          color: listRoom[index].status
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
            );
          },
          itemCount: listRoom.length,
        ),
      ),
    );
  }
}