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
  bool showPass = false;
  bool showRePass = false;
  String showErr = "";
  String valueChoose;
  List listItem = ["Landlord", "Tenant"];
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: size.height,
            width: size.width,
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
                Container(
                  child: Column(
                    children: [
                      TextInput(
                        text: 'Username',
                        icon: Icon(
                          MyFlutterApp.user,
                          color: Colors.black,
                        ),
                        hidePass: false,
                        controller: username,
                      ),
                      TextPasswordInput(
                        text: 'Password',
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
                        text: 'Re-Password',
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
                            horizontal: 10,
                          ),
                          child: DropdownButton(
                            icon: Icon(Icons.arrow_drop_down),
                            iconSize: 35,
                            hint: Text('Select a Role'),
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
                  height: 20,
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
                  margin: EdgeInsets.only(
                    top: 10,
                  ),
                  child: RoundedButton(
                    text: 'SIGN UP',
                    press: onSignUpClicked,
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
                        'Already have an Account ?\t\t\t\t',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFFACACAC),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      GestureDetector(
                        child: Text(
                          'Sign In',
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
                        'OR',
                        style: TextStyle(
                            color: PrimaryColor, fontWeight: FontWeight.w700),
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
    );
  }

  void onSignUpClicked() {
    setState(() {
      if (username.text.isEmpty && password.text.isEmpty && rePassword.text.isEmpty && valueChoose == null) {
        showErr = "Username, Password, RePassword, Role can't be blank !!!";
      } else if (username.text.isEmpty || password.text.isEmpty || rePassword.text.isEmpty || valueChoose == null) {
        showErr = "Username or Password or Re-Password or Role can't be empty";
      } else if (rePassword.text != password.text) {
        showErr = "Re-Password must match Password";
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SignInPage()),
        );
      }
    });
  }
}
