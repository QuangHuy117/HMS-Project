import 'package:flutter/material.dart';
import 'package:house_management_project/screens/SignInPage.dart';

void main() {
  runApp(MyApp());
}

const PrimaryColor = Color(0xFF45BAFE);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: PrimaryColor,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: SignInPage(),
    );
  }
}
