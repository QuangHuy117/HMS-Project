import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:house_management_project/components/RoundedButton.dart';
import 'package:house_management_project/components/TextInput.dart';
import 'package:house_management_project/components/TextPasswordInput.dart';
import 'package:house_management_project/fonts/my_flutter_app_icons.dart';
import 'package:house_management_project/main.dart';
import 'package:house_management_project/screens/HomePage.dart';
import 'package:house_management_project/screens/SignUp/SignUpPage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  TextEditingController username = new TextEditingController();
  TextEditingController password = new TextEditingController();
  bool showPass = false;
  String showErr = "";
  final auth = FirebaseAuth.instance;


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 100, horizontal: 40),
            // decoration: BoxDecoration(
            //   image: DecorationImage(
            //     image: AssetImage('assets/images/ImageBackground.jpg'),
            //     fit: BoxFit.cover,
            //   ),
            // ),
            color: Color(0xFFFFF5EE),
            child: Container(
              height: size.height * 0.78,
              width: size.width * 0.9,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.brown, width: 2),
                borderRadius: BorderRadius.circular(25),
                color: Colors.white38,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(
                      bottom: 30,
                    ),
                    child: Image(
                      image: AssetImage('assets/images/logo_image.png'),
                      fit: BoxFit.scaleDown,
                      height: size.height * 0.23,
                      width: size.width * 0.4,
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.04,
                  ),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        TextInput(
                          text: 'Tên đăng nhập',
                          icon: Icon(
                            MyFlutterApp.user,
                            color: Colors.black,
                          ),
                          hidePass: false,
                          controller: username,
                        ),
                        TextPasswordInput(
                          text: 'Mật khẩu',
                          icon: Icon(
                            Icons.lock,
                            color: Colors.black,
                          ),
                          backIcon: GestureDetector(
                            child: Icon(
                              showPass
                                  ? MyFlutterApp.eye
                                  : MyFlutterApp.eye_slash,
                              size: 20,
                            ),
                            onTap: () {
                              setState(() {
                                showPass = !showPass;
                              });
                            },
                          ),
                          hidePass: !showPass,
                          controller: password,
                        ),
                        GestureDetector(
                          child: Text(
                            'Quên mật khẩu ?',
                            style: TextStyle(
                              color: PrimaryColor,
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.015,
                  ),
                  Text(
                    showErr.isEmpty ? '' : showErr,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(
                      vertical: 20,
                    ),
                    child: RoundedButton(
                      text: 'Đăng nhập',
                      press: onSignInClicked,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      top: 30,
                    ),
                    width: size.width * 0.7,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Chưa có tài khoản ?\t\t\t\t\t',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFFACACAC),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        GestureDetector(
                          child: Text(
                            'Đăng ký',
                            style: TextStyle(
                              color: PrimaryColor,
                              fontWeight: FontWeight.w700,
                              fontSize: 18,
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignUpPage()),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void onSignInClicked() {
    setState(() {
      if (username.text.isEmpty && password.text.isEmpty) {
        showErr = "Tên đăng nhập và mật khẩu không được trống !!!";
      } else if (username.text.isEmpty || password.text.isEmpty) {
        showErr = "Tên đăng nhập hoặc mật khẩu không được trống !!!";
      } else {
          _signIn(username.text, password.text);
          // checkSignIn(username.text, password.text);
        }
    });
  }

  _signIn(String email, String password) async {
    try {
      UserCredential user = await auth.signInWithEmailAndPassword(
          email: email, password: password);
    var jsonData = null;
    var url = Uri.parse(
        'https://localhost:44322/api/accounts/authenticate-firebase');
    var response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
         'userId': user.user.uid,
      }),
    );
    if (response.statusCode == 200) {
      jsonData = jsonDecode(response.body);
      var session = FlutterSession();
      await session.set("name", jsonData['name']);
      await session.set("username", jsonData['userId']);
      await session.set("phone", jsonData['phone']);
      await session.set("email", jsonData['email']);
      await session.set("role", jsonData['role']);
      await session.set("token", jsonData['token']);

      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => HomePage()), (route) => false);
    
    }
    } on FirebaseAuthException catch (e) {
      setState(() {
        if (e.code == 'email-already-in-use') {
          showErr = 'Email đã tồn tại !!!';
        } else if (e.code == 'weak-password') {
          showErr = 'Mật khẩu có ít nhất 6 kí tự !!!';
        } else if (e.code == 'invalid-email') {
          showErr = 'Tên đăng nhập phải là email !!!';
        }
      });
    }
  }



  void checkSignIn(String username, String password) async {
    var jsonData = null;
    var url = Uri.parse(
        'https://localhost:44322/api/accounts/authenticate');
    var response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    );
    if (response.statusCode == 200) {
      jsonData = jsonDecode(response.body);
      // print(jsonData['username']);
      // print(jsonData);
      // print(jsonData['response']['token']);
      var session = FlutterSession();
      await session.set("name", jsonData['response']['name']);
      await session.set("username", jsonData['response']['username']);
      await session.set("phone", jsonData['response']['phone']);
      await session.set("email", jsonData['response']['email']);
      await session.set("role", jsonData['response']['role']);
      await session.set("token", jsonData['response']['token']);
      setState(() {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => HomePage()), (route) => false);
        //  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => AccountProvider(account: jsonData,)), (route) => false);
      });
    } else {
      setState(() {
         showErr = "Sai tên đăng nhập hoặc tài khoản";
      });
     
    }
  }
}
