import 'package:flutter/material.dart';
import 'package:house_management_project/components/RoundedButton.dart';
import 'package:house_management_project/components/TextInput.dart';
import 'package:house_management_project/components/TextPasswordInput.dart';
import 'package:house_management_project/fonts/my_flutter_app_icons.dart';
import 'package:house_management_project/main.dart';
import 'package:house_management_project/screens/SignUpPage.dart';
import 'package:house_management_project/screens/HomePage.dart';
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
  String loginErr = "Username and Password can't be blank !!!";
  String showErr = "";

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: size.height,
            width: size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(
                    bottom: 30,
                  ),
                  height: size.height * 0.27,
                  child: Image(
                    image: AssetImage('assets/images/house_icon.png'),
                    fit: BoxFit.fill,
                    width: size.width * 0.54,
                  ),
                ),
                SizedBox(
                  height: 30,
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
                  height: 15,
                ),
                Text(
                  showErr.isEmpty ? '' : showErr,
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
    );
  }

  void onSignInClicked() {
    setState(() {
      if (username.text.isEmpty && password.text.isEmpty) {
        showErr = loginErr;
      } else if (username.text.isEmpty || password.text.isEmpty) {
        showErr = "Username or Password can't be blank !!!";
      } else {
        checkSignIn(username.text, password.text);
        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(builder: (context) => HomePage(username: username.text,)),
        // );
      }
    });
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
      print(jsonData['username']);
      print(jsonData);
      setState(() {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => HomePage(username: username)), (route) => false);
      });
    } else {
      setState(() {
         showErr = "Wrong Username or Password";
      });
     
    }
  }
}
