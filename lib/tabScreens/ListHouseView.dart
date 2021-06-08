import 'package:flutter/material.dart';
import 'package:house_management_project/components/TextInput.dart';
import 'package:house_management_project/fonts/my_flutter_app_icons.dart';
import 'package:house_management_project/main.dart';
import 'package:house_management_project/models/House.dart';
import 'package:house_management_project/screens/HouseSetting.dart';

class ListHouseView extends StatefulWidget {
  @override
  _ListHouseViewState createState() => _ListHouseViewState();
}

class _ListHouseViewState extends State<ListHouseView> {
  final List<House> list = [
    House(
      id: 'House 1',
      name: 'Nguyễn Thị A',
      address: '120/31/12, Nguyễn Kiệm, Phường 9, Quận Gò Vấp, TP Hồ Chí Minh',
    ),
    House(
      id: 'House 2',
      name: 'Trần Thị B',
      address: '12/12, Trần Duy Hưng, phường 69, Quận 9, TP Hồ Chí Minh',
    ),
    House(
      id: 'House 3',
      name: 'Hoàng Thị C',
      address: '382/10, Lý Thường Kiệt, phường 6, Quận 11, TP Hồ Chí Minh',
    ),
  ];
  TextEditingController name = new TextEditingController();
  TextEditingController address = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                builder: (context) => Container(
                      padding: MediaQuery.of(context).viewInsets,
                      height: size.height * 0.6,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Create New House',
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.w500),
                          ),
                          TextInput(
                            text: "Enter a Name",
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
                              maxLines: 2,
                              textInputAction: TextInputAction.done,
                              decoration: InputDecoration(
                                hintText: 'Enter An Address',
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
                          TextButton(
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 20),
                              backgroundColor: PrimaryColor,
                            ),
                            child: Text(
                              'Submit',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                            onPressed: () {
                              setState(() {
                                if (name.text.isEmpty || address.text.isEmpty) {
                                  Navigator.pop(context);
                                }
                              });
                            },
                          ),
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
          title: Text(
            'House\'s List',
            style: TextStyle(
                color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700),
          ),
          centerTitle: true,
          backgroundColor: PrimaryColor,
        ),
        body: ListView.builder(
          itemBuilder: (context, index) {
            return Container(
              height: size.height * 0.14,
              padding: EdgeInsets.symmetric(
                horizontal: 25,
              ),
              margin: EdgeInsets.only(
                top: 30,
              ),
              child: GestureDetector(
                onTap: () {
                  // Navigator.push(context,
                  // MaterialPageRoute(builder: (context) => ListRoomPage()),
                  // );
                  print('Hello');
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 5,
                  shadowColor: Colors.black,
                  child: Stack(
                    children: [
                      Positioned(
                        top: 30,
                        left: 5,
                        child: Icon(
                          MyFlutterApp.home,
                          color: PrimaryColor,
                          size: 60,
                        ),
                      ),
                      Positioned(
                        top: 25,
                        left: 65,
                        child: Container(
                          width: size.width * 0.6,
                          padding: EdgeInsets.only(
                            right: 10,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${list[index].name}',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                '${list[index].address}',
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: 15,
                        right: 10,
                        child: Text(
                          'Rented',
                          style: TextStyle(
                            color: PrimaryColor,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 15,
                        right: 10,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HouseSetting()),
                            );
                          },
                          child: Icon(
                            MyFlutterApp.cog,
                            color: PrimaryColor,
                            size: 28,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
          itemCount: list.length,
        ),
      ),
    );
  }
}
