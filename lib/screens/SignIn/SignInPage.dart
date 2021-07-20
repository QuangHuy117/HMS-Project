import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:house_management_project/components/RoundedButton.dart';
import 'package:house_management_project/components/TextInput.dart';
import 'package:house_management_project/components/TextPasswordInput.dart';
import 'package:house_management_project/fonts/my_flutter_app_icons.dart';
import 'package:house_management_project/main.dart';
import 'package:house_management_project/screens/SignIn/ForgotPasswordPage.dart';
import 'package:house_management_project/screens/House/HomePage.dart';
import 'package:house_management_project/screens/SignUp/SignUpPage.dart';
import 'package:house_management_project/screens/Tenant/TenantHomePage.dart';
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
  bool _isLoading = false;
  final auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 55, horizontal: 40),
            // decoration: BoxDecoration(
            //   image: DecorationImage(
            //     image: AssetImage('assets/images/ImageBackground.jpg'),
            //     fit: BoxFit.cover,
            //   ),
            // ),
            color: Color(0xFFFFF5EE),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              height: size.height * 0.85,
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
                      bottom: 10,
                    ),
                    child: Image(
                      image: AssetImage('assets/images/logo_image.png'),
                      fit: BoxFit.scaleDown,
                      height: size.height * 0.23,
                      width: size.width * 0.4,
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.02,
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
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => ForgotPasswordPage()));
                          },
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
                  // Container(
                  //   margin: EdgeInsets.symmetric(
                  //     vertical: 20,
                  //   ),
                  //   child: RoundedButton(
                  //     text: 'Đăng nhập',
                  //     press: onSignInClicked,
                  //   ),
                  // ),
                  Container(
                    width: size.width * 0.7,
                     margin: EdgeInsets.symmetric(
                      vertical: 20,
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 5,
                            offset: const Offset(0, 5),
                          )
                        ]),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30.0),
                      child: TextButton(
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          backgroundColor: PrimaryColor,
                        ),
                        child: _isLoading ? Container(
                          height: 23,
                          width: 23,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        )
                        : Text(
                          'Đăng nhập',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w700),
                        ),
                        onPressed: () {
                          setState(() {
                            _isLoading = true;
                            onSignInClicked();
                          });
                        },
                      ),
                    ),
                  ),
                  Container(
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
                              color: PrimaryColor, fontWeight: FontWeight.w700),
                        ),
                        Text(
                          '----------------------------',
                          style: TextStyle(color: Color(0xFF707070)),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
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
                        onTap: () => signInWithGoogle()),
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

  Future<void> signInWithGoogle() async {
    GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    // print(googleSignInAuthentication.idToken);

    AuthCredential authCredential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken);

    // ignore: unused_local_variable
    UserCredential authResult = await auth.signInWithCredential(authCredential);
    // ignore: unused_local_variable
    User user = auth.currentUser;

    print(authResult.user.getIdToken().then((value) => print("-----" + value)));

    // print(user.providerData.first.providerId);
  }

  _signIn(String email, String password) async {
    try {
      UserCredential user = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      var idToken = await user.user.getIdToken();
      print(idToken);
      var jsonData = null;
      var url = Uri.parse('https://$serverHost/api/accounts/authenticate');
      print(url);
      var response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          "idToken": idToken,
          // 'email': email,
          // 'password': password,
        }),
      );
      if (response.statusCode == 200) {
        jsonData = jsonDecode(response.body);
        var session = FlutterSession();
        await session.set("name", jsonData['name']);
        await session.set("username", jsonData['userId']);
        await session.set("phone", jsonData['phone']);
        await session.set("email", jsonData['email']);
        await session.set("image", jsonData['image']);
        await session.set("role", jsonData['role']);
        await session.set("token", jsonData['token']);

        _isLoading = false;
        if (jsonData['role'] == 'Chủ trọ') {
          Navigator.pushAndRemoveUntil(context,
              MaterialPageRoute(builder: (_) => HomePage()), (route) => false);
        } else {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => TenantHomePage()), (route) => false);
        }
      }
    } on FirebaseAuthException catch (e) {
      print(e.code);
      setState(() {
        if (e.code == 'invalid-email') {
          showErr = 'Tên đăng nhập phải là Email !!!';
        } else if (e.code == 'user-not-found') {
          showErr = 'Email không tồn tại !!!';
        } else if (e.code == 'wrong-password') {
          showErr = 'Sai mật khẩu !!!';
        } else if (e.code == 'too-many-requests') {
          showErr = 'Đăng nhập sai nhiều lần vui lòng thử lại sau !!!';
        }
      });
    }
  }

  void checkSignIn(String username, String password) async {
    var jsonData = null;
    var url = Uri.parse('https://$serverHost/api/accounts/authenticate');
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
      var session = FlutterSession();
      await session.set("name", jsonData['response']['name']);
      await session.set("username", jsonData['response']['username']);
      await session.set("phone", jsonData['response']['phone']);
      await session.set("email", jsonData['response']['email']);
      await session.set("role", jsonData['response']['role']);
      await session.set("token", jsonData['response']['token']);
      setState(() {
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (_) => HomePage()), (route) => false);
      });
    } else {
      setState(() {
        showErr = "Sai tên đăng nhập hoặc tài khoản";
      });
    }
  }
}
