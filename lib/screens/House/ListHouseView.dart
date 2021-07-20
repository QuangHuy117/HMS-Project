
import 'package:flutter/material.dart';
import 'package:house_management_project/main.dart';
import 'package:house_management_project/screens/House/ListHouseNotUsing.dart';
import 'package:house_management_project/screens/House/ListHouseUsing.dart';

class ListHouseView extends StatefulWidget {
  ListHouseView({
    Key key,
  }) : super(key: key);

  @override
  _ListHouseViewState createState() => _ListHouseViewState();
}

class _ListHouseViewState extends State<ListHouseView> {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: AppBar(
              elevation: 0,
              title: Text(
                'Danh Sách Nhà',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w700),
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
                labelStyle:
                    TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                unselectedLabelColor: Colors.white70,
                tabs: [
                  Tab(
                    child: Container(
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Nhà đang thuê',
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Tab(
                    child: Container(
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Nhà chưa thuê',
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                ListHouseUsing(),
                ListHouseNotUsing(),
              ],
            )),
      ),
    );
  }
}
