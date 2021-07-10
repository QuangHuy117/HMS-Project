import 'package:flutter/material.dart';
import 'package:house_management_project/fonts/my_flutter_app_icons.dart';
import 'package:house_management_project/main.dart';
import 'package:house_management_project/models/House.dart';
import 'package:house_management_project/screens/House/HouseSettingPage.dart';
import 'package:house_management_project/screens/Room/RoomNavigationBar.dart';

class ListHouseNotUsing extends StatefulWidget {
  final List<House> list;
  const ListHouseNotUsing({ Key key , @required this.list}) : super(key: key);

  @override
  _ListHouseNotUsingState createState() => _ListHouseNotUsingState();
}

class _ListHouseNotUsingState extends State<ListHouseNotUsing> {
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
                height: size.height * 0.14,
                padding: EdgeInsets.symmetric(
                  horizontal: 25,
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
                              houseId: widget.list[index].id,
                              )),
                    );
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 6,
                    shadowColor: Colors.black,
                    child: Stack(
                      children: [
                        Positioned(
                          top: 30,
                          left: 5,
                          child: Icon(
                            MyFlutterApp.home,
                            color: PrimaryColor,
                            size: 60,
                          ),
                        ),
                        Positioned(
                          top: 28,
                          left: 70,
                          child: Container(
                            width: size.width * 0.6,
                            padding: EdgeInsets.only(
                              right: 10,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${widget.list[index].houseInfo.name}',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  '${widget.list[index].houseInfo.address}',
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          top: 15,
                          right: 10,
                          child: Text(
                            '${widget.list[index].status ? '' : 'Chưa thuê'}',
                            style: TextStyle(
                              color: widget.list[index].status
                                  ? PrimaryColor
                                  : Color(0xFF707070),
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 15,
                          right: 10,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HouseSettingPage(
                                        houseId: widget.list[index].id)),
                              );
                            },
                            child: Icon(
                              MyFlutterApp.cog,
                              color: PrimaryColor,
                              size: 28,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
            itemCount: widget.list.length,
          ),
      ),
    );
  }
}