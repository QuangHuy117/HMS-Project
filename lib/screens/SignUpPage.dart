import 'package:flutter/material.dart';
import 'package:house_management_project/components/RoundedButton.dart';
import 'package:house_management_project/components/TextInput.dart';
import 'package:house_management_project/components/TextPasswordInput.dart';
import 'package:house_management_project/fonts/my_flutter_app_icons.dart';
import 'package:house_management_project/main.dart';
import 'package:house_management_project/screens/SignInPage.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController username = new TextEditingController();
  TextEditingController password = new TextEditingController();
  TextEditingController rePassword = new TextEditingController();
  TextEditingController email = new TextEditingController();
  bool showPass = false;
  bool showRePass = false;
  String showErr = "";
  String valueChoose;
  List listItem = ["Chủ trọ", "Người thuê"];
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 50, horizontal: 40),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/ImageBackground.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Align(
              alignment: Alignment.center,
              child: Container(
                height: size.height * 0.93,
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
                        bottom: 20,
                      ),
                      height: size.height * 0.19,
                      child: Image(
                        image: AssetImage('assets/images/logo_image.png'),
                        fit: BoxFit.fill,
                        width: size.width * 0.38,
                      ),
                    ),
                    Container(
                      child: Column(
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
                          TextPasswordInput(
                            text: 'Xác nhận mật khẩu',
                            icon: Icon(
                              Icons.lock,
                              color: Colors.black,
                            ),
                            backIcon: GestureDetector(
                              child: Icon(
                                showRePass
                                    ? MyFlutterApp.eye
                                    : MyFlutterApp.eye_slash,
                                size: 20,
                              ),
                              onTap: () {
                                setState(() {
                                  showRePass = !showRePass;
                                });
                              },
                            ),
                            hidePass: !showRePass,
                            controller: rePassword,
                          ),
                          TextInput(
                            text: 'Email',
                            icon: Icon(
                              MyFlutterApp.mail,
                              color: Colors.black,
                            ),
                            hidePass: false,
                            controller: email,
                          ),
                          Container(
                            width: size.width * 0.4,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 15,
                              ),
                              child: DropdownButton(
                                icon: Icon(Icons.arrow_drop_down),
                                iconSize: 35,
                                hint: Text('Chọn vai trò'),
                                isExpanded: true,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                                value: valueChoose,
                                onChanged: (newValue) {
                                  setState(() {
                                    valueChoose = newValue;
                                  });
                                },
                                items: listItem.map((valueItem) {
                                  return DropdownMenuItem(
                                    value: valueItem,
                                    child: Text(valueItem),
                                  );
                                }).toList(),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.02,
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
                      margin: EdgeInsets.only(
                        top: 10,
                      ),
                      child: RoundedButton(
                        text: 'Đăng ký',
                        press: onSignUpClicked,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        top: 20,
                      ),
                      width: size.width * 0.7,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Bạn đã có tài khoản ?\t\t\t\t',
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFFACACAC),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          GestureDetector(
                            child: Text(
                              'Đăng nhập',
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
                                    builder: (context) => SignInPage()),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(
                        vertical: 15,
                      ),
                      width: size.width * 0.7,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            '----------------------------',
                            style: TextStyle(color: Color(0xFF707070)),
                          ),
                          Text(
                            'HOẶC',
                            style: TextStyle(
                                color: PrimaryColor,
                                fontWeight: FontWeight.w700),
                          ),
                          Text(
                            '----------------------------',
                            style: TextStyle(color: Color(0xFF707070)),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(),
                      ),
                      child: GestureDetector(
                        child: Icon(
                          MyFlutterApp.gplus,
                          color: PrimaryColor,
                        ),
                        onTap: () {
                          print("Google");
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void onSignUpClicked() {
    setState(() {
      if (username.text.isEmpty &&
          password.text.isEmpty &&
          rePassword.text.isEmpty &&
          email.text.isEmpty) {
        showErr =
            "Thông tin không được để trống !!!";
      } else if (username.text.isEmpty ||
          password.text.isEmpty ||
          rePassword.text.isEmpty ||
          email.text.isEmpty) {
        showErr =
            "Tên đăng nhập hoặc mật khẩu hoặc Email không được trống !!!";
      } else if (rePassword.text != password.text) {
        showErr = "Xác nhận mật khẩu phải trùng với mật khẩu";
      } else if (valueChoose == null) {
        showErr = "Vui lòng chọn vai trò";
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SignInPage()),
        );
      }
    });
  }
}
