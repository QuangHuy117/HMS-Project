import 'package:flutter/material.dart';
import 'package:house_management_project/fonts/my_flutter_app_icons.dart';

class HouseSetting extends StatefulWidget {
  const HouseSetting({ Key key }) : super(key: key);

  @override
  _HouseSettingState createState() => _HouseSettingState();
}

class _HouseSettingState extends State<HouseSetting> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(MyFlutterApp.left, color: Colors.white, size: 27,)),
          centerTitle: true,
          title: Text(
            'House\'s Settings', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700),
          ),
        ),
        body: Container(
          width: size.width,
          padding: EdgeInsets.all(15),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(
                    bottom: 10,
                  ),
                  child: Text('Unit Price', style: TextStyle(
                    color: Colors.blueGrey,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),),
                ),
                Container(
                  padding: EdgeInsets.all(20),
                  height: size.height * 0.82,
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 2,
                      color: Color(0xFF707070),
                      style: BorderStyle.solid,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                          bottom: 15,
                        ),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(color: Color(0xFF707070), width: 2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Container(
                            height: size.height * 0.07,
                            width: size.width * 0.8,
                            padding: EdgeInsets.symmetric(
                              horizontal: 10,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Tiền Điện', style: TextStyle(
                                  color: Color(0xFF707070),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),),
                                Text('Chênh Lệch', style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),),
                                Text('200,000đ', style: TextStyle(
                                  color: Color(0xFF707070),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                          bottom: 10,
                        ),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(color: Color(0xFF707070), width: 2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Container(
                            height: size.height * 0.07,
                            width: size.width * 0.8,
                            padding: EdgeInsets.symmetric(
                              horizontal: 10,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Tiền Điện', style: TextStyle(
                                  color: Color(0xFF707070),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),),
                                Text('Cố Định', style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),),
                                Text('200,000đ', style: TextStyle(
                                  color: Color(0xFF707070),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
        ),
      ),
    );
  }
}