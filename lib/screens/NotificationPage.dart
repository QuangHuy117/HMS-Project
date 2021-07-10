import 'package:flutter/material.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key key}) : super(key: key);

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // body: userDetail(account.name),
      ),
    );
  }
  // Widget userDetail(String username) {
  //   return Stack(
  //     children: <Widget>[
  //   // Background with gradient
  //     Container(
  //         decoration: BoxDecoration(
  //             // gradient: LinearGradient(
  //             //     begin: Alignment.centerLeft,
  //             //     end: Alignment.bottomCenter,
  //             //     colors: [Colors.red[900], Colors.blue[700]])
  //             color: PrimaryColor,
  //                 ),
  //         height: MediaQuery.of(context).size.height * 0.25
  //       ),
  //   //Above card
  //     Container(
  //       height: MediaQuery.of(context).size.height * 0.3,
  //       child: Card(
  //           elevation: 20.0,
  //           margin: EdgeInsets.only(left: 15.0, right: 15.0, top: 100.0),
  //           child: ListView(
  //               padding:
  //               EdgeInsets.only(top: 20.0, left: 20.0, right: 18.0, bottom: 5.0),
  //               children: <Widget>[
  //                 TextField(),
  //                 TextField()
  //               ]

  //         )),
  //     ),
  //     // Positioned to take only AppBar size 
  //     Positioned( 
  //       top: 15.0,
  //       left: 5.0,
  //       right: 0.0,
  //       child: AppBar(        // Add AppBar here only
  //         backgroundColor: Colors.transparent,
  //         elevation: 0.0,
  //         title: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Text('Xin chào,', style: TextStyle(fontSize: 18, color: Colors.white),),
  //             Text(username, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white),),
  //           ],
  //           ),
  //       ),
  //     ),

  //   ]);
  // }
}
