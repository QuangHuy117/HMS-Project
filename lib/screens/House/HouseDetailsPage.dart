import 'package:flutter/material.dart';

class HouseDetailsPage extends StatefulWidget {
  const HouseDetailsPage({Key key}) : super(key: key);

  @override
  _HouseDetailsPageState createState() => _HouseDetailsPageState();
}

class _HouseDetailsPageState extends State<HouseDetailsPage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Container(
        color: Color(0xFFF5F5F5),
        width: size.width,
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(
                bottom: 10,
              ),
              child: Text(
                'Chi tiết nhà',
                style: TextStyle(
                  color: Colors.blueGrey,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 20),
              height: size.height * 0.8,
              width: size.width * 0.87,
              decoration: BoxDecoration(
                color: Colors.white,
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
                    margin: EdgeInsets.only(bottom: 20),
                    width: size.width * 0.68,
                    child: TextField(
                      decoration: InputDecoration(
                        icon: Icon(Icons.house_outlined, size: 35,),
                        hintText: 'Tên nhà',
                        hintStyle: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 10),
                    width: size.width * 0.68,
                    child: TextField(
                      decoration: InputDecoration(
                        icon: Icon(Icons.room_outlined, size: 35,),
                        hintText: 'Địa chỉ',
                        hintStyle: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
