import 'package:house_management_project/main.dart';
import 'package:house_management_project/screens/Bill/ListBillNotUsing.dart';
import 'package:house_management_project/screens/Bill/ListBillUsing.dart';
import 'package:flutter/material.dart';

class ListBillPage extends StatefulWidget {
  const ListBillPage({Key key}) : super(key: key);

  @override
  _ListBillPageState createState() => _ListBillPageState();
}

class _ListBillPageState extends State<ListBillPage> {
  // List<Bill> listBill = [];
  // List<Bill> listBillUsing = [];
  // List<Bill> listBillNotUsing = [];

  // getListBill() async {
  //   var url = Uri.parse(
  //       'https://localhost:44322/api/bills?username=${widget.username}');
  //   try {
  //     var response = await http.get(url);
  //     if (response.statusCode == 200) {
  //       // var items = jsonDecode(response.body);
  //       setState(() {
  //         listBill = billFromJson(response.body);
          
  //       });
  //     }
  //   } catch (error) {
  //     throw (error);
  //   }
  // }

//  getBillSeperate(List<Bill> list) {
//     for (var i in list) {
//       if (i.status == true) {
//         print(i);
//         listBillUsing.add(i);
//       }
//     }
//   }

  // @override
  // void initState() {
  //   super.initState();
  //   getListBill();
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            title: Text(
              'Danh Sách Hóa Đơn',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w700),
            ),
            centerTitle: true,
            automaticallyImplyLeading: false,
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
                      child: Text(
                        'Đã thanh toán',
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
                        'Chưa thanh toán',
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
              ListBillUsing(
                // username: widget.username,
                // list: listBillUsing,
              ),
              ListBillNotUsing(
                // username: widget.username,
                // list: listBillNotUsing,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
