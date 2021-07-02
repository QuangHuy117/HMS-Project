import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:house_management_project/components/TextInput.dart';
import 'package:house_management_project/main.dart';
import 'package:house_management_project/models/House.dart';
import 'package:house_management_project/screens/House/ListHouseNotUsing.dart';
import 'package:house_management_project/screens/House/ListHouseUsing.dart';
import 'package:http/http.dart' as http;

class ListHouseView extends StatefulWidget {
  final String username;
  ListHouseView({Key key, @required this.username}) : super(key: key);

  @override
  _ListHouseViewState createState() => _ListHouseViewState();
}

class _ListHouseViewState extends State<ListHouseView> {
  TextEditingController name = new TextEditingController();
  TextEditingController address = new TextEditingController();
  String showErr = "";
  List<House> listHouseUsing = [];
  List<House> listHouseNotUsing = [];
  List<House> list = [];

  getHouseData() async {
    var url = Uri.parse(
        'https://localhost:44322/api/houses?username=${widget.username}');
    try {
      var response = await http.get(url);
      print(response.statusCode);
      if (response.statusCode == 200) {
        var items = jsonDecode(response.body);
        setState(() {
          // print(items);
          for (var u in items) {
            // print(u);
            House house = new House.fromJson(u);
            list.add(house);
          }
          getListHouseSeperate(list);
        });
      }
    } catch (error) {
      throw (error);
    }
  }


  getListHouseSeperate(List<House> listHouse) {
    print(list);
    for (var u in listHouse) {
      if(u.status == true) {
        listHouseUsing.add(u);
      } else {
        listHouseNotUsing.add(u);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getHouseData();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Color(0xFFF5F5F5),
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.only(
                      topLeft: Radius.circular(5),
                      topRight: Radius.circular(5),
                    ),
                  ),
                  builder: (context) => Padding(
                        padding: EdgeInsets.symmetric(vertical: 15),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Tạo nhà mới',
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w500),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            TextInput(
                              text: 'Nhập tên nhà',
                              hidePass: false,
                              controller: name,
                            ),
                            Container(
                              width: size.width * 0.7,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 5,
                                      offset: const Offset(0, 5),
                                    )
                                  ]),
                              child: TextField(
                                controller: address,
                                // maxLines: 2,
                                textInputAction: TextInputAction.done,
                                decoration: InputDecoration(
                                  hintText: 'Nhập địa chỉ nhà',
                                  hintStyle: TextStyle(
                                      color: Color(0xFF707070),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15)),
                                  fillColor: Colors.white,
                                  filled: true,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(showErr.isEmpty ? '' : showErr),
                            SizedBox(
                              height: 10,
                            ),
                            TextButton(
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 20),
                                backgroundColor: PrimaryColor,
                              ),
                              child: Text(
                                'Xác nhận',
                                style:
                                    TextStyle(color: Colors.white, fontSize: 16),
                              ),
                              onPressed: () {
                                setState(() {
                                  if (name.text.isEmpty || address.text.isEmpty) {
                                    showErr = 'Thông tin không được trống !!!';
                                  } else {}
                                });
                              },
                            ),
                            Padding(
                                padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom,
                            )),
                          ],
                        ),
                      ));
            },
            backgroundColor: PrimaryColor,
            child: Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
          appBar: AppBar(
            elevation: 0,
            title: Text(
              'Danh Sách Nhà',
              style: TextStyle(
                  color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700),
            ),
            centerTitle: true,
            backgroundColor: PrimaryColor,
            bottom: TabBar(
              indicator: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10)),
                color: Colors.white,
              ),
              labelColor: PrimaryColor,
              labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              unselectedLabelColor: Colors.white70,
              tabs: [
                Tab(
                  child: Container(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text('Nhà đang thuê', style: TextStyle(
                        fontSize: 20,
                      ),),
                    ),
                  ),
                ),
                Tab(
                  child: Container(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text('Nhà chưa thuê', style: TextStyle(
                        fontSize: 20,
                      ),),
                    ),
                  ),
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              ListHouseUsing(list: listHouseUsing),
              ListHouseNotUsing(list: listHouseNotUsing),
            ],
            )
        ),
      ),
    );
  }
}
