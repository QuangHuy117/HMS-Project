import 'package:flutter/material.dart';
import 'package:house_management_project/fonts/my_flutter_app_icons.dart';

class UserInfoPage extends StatefulWidget {
  const UserInfoPage({ Key key }) : super(key: key);

  @override
  _UserInfoPageState createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Thông tin', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: Colors.white),),
          centerTitle: true,
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(MyFlutterApp.left,
            color: Colors.white,
            size: 27,),
          ),
          automaticallyImplyLeading: false,
        ),
      )
      );
  }
}