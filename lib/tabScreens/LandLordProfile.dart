import 'package:flutter/material.dart';

class LandLordProfile extends StatelessWidget {
  const LandLordProfile({ Key key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text('Profile', 
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),),
            centerTitle: true,
          ),
        ),
    );
  }
}