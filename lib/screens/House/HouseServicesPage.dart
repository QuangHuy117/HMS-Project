import 'package:flutter/material.dart';
import 'package:house_management_project/main.dart';
import 'package:house_management_project/models/HouseServices.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HouseServicesPage extends StatefulWidget {
  final String houseId;
  const HouseServicesPage({Key key, this.houseId}) : super(key: key);

  @override
  _HouseServicesPageState createState() => _HouseServicesPageState();
}

class _HouseServicesPageState extends State<HouseServicesPage> {
  List<HouseServices> listService = [];

  getServicesByHouseId() async {
    var url = Uri.parse('https://$serverHost/api/houses/${widget.houseId}');
    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        setState(() {
          for (var u in jsonData['services']) {
            HouseServices houseServices = new HouseServices.fromJson(u);
            listService.add(houseServices);
          }
        });
      }
    } catch (error) {
      throw (error);
    }
  }

  @override
  void initState() {
    super.initState();
    getServicesByHouseId();
  }

  @override
  Widget build(BuildContext context) {
    // TextEditingController serviceName = new TextEditingController();
    // TextEditingController unitPrice = new TextEditingController();
    // TextEditingController serviceUnit = new TextEditingController();

    // bool expandCheck = false;
    // String valueChoose;
    // List listServices = ["Chênh lệch", "Cố định"];

    Size size = MediaQuery.of(context).size;
    return Scaffold(
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     showModalBottomSheet(
      //       context: context,
      //       isScrollControlled: true,
      //       backgroundColor: Color(0xFFF5F5F5),
      //       shape: RoundedRectangleBorder(
      //         borderRadius: new BorderRadius.only(
      //           topLeft: Radius.circular(5),
      //           topRight: Radius.circular(5),
      //         ),
      //       ),
      //       builder: (context) => StatefulBuilder(
      //         builder: (BuildContext context, StateSetter setModal) {
      //           return Padding(
      //             padding: EdgeInsets.symmetric(vertical: 15),
      //             child: Column(
      //               mainAxisAlignment: MainAxisAlignment.start,
      //               mainAxisSize: MainAxisSize.min,
      //               children: [
      //                 Text(
      //                   'Thêm dịch vụ',
      //                   style: TextStyle(
      //                       color: Colors.blue,
      //                       fontSize: 22,
      //                       fontWeight: FontWeight.w500),
      //                 ),
      //                 SizedBox(
      //                   height: 20,
      //                 ),
      //                 Container(
      //                   width: size.width * 0.7,
      //                   decoration: BoxDecoration(
      //                       borderRadius: BorderRadius.circular(20),
      //                       boxShadow: [
      //                         BoxShadow(
      //                           color: Colors.black12,
      //                           blurRadius: 5,
      //                           offset: const Offset(0, 5),
      //                         )
      //                       ]),
      //                   child: TextField(
      //                     controller: serviceName,
      //                     textInputAction: TextInputAction.done,
      //                     decoration: InputDecoration(
      //                       hintText: 'Nhập tên dịch vụ',
      //                       hintStyle: TextStyle(
      //                           color: Color(0xFF707070),
      //                           fontWeight: FontWeight.bold,
      //                           fontSize: 18),
      //                       border: OutlineInputBorder(
      //                           borderRadius: BorderRadius.circular(15)),
      //                       fillColor: Colors.white,
      //                       filled: true,
      //                     ),
      //                   ),
      //                 ),
      //                 SizedBox(
      //                   height: 20,
      //                 ),
      //                 Container(
      //                   width: size.width * 0.7,
      //                   decoration: BoxDecoration(
      //                       borderRadius: BorderRadius.circular(20),
      //                       boxShadow: [
      //                         BoxShadow(
      //                           color: Colors.black12,
      //                           blurRadius: 5,
      //                           offset: const Offset(0, 5),
      //                         )
      //                       ]),
      //                   child: TextField(
      //                     controller: unitPrice,
      //                     textInputAction: TextInputAction.done,
      //                     decoration: InputDecoration(
      //                       hintText: 'Nhập đơn giá',
      //                       hintStyle: TextStyle(
      //                           color: Color(0xFF707070),
      //                           fontWeight: FontWeight.bold,
      //                           fontSize: 18),
      //                       border: OutlineInputBorder(
      //                           borderRadius: BorderRadius.circular(15)),
      //                       fillColor: Colors.white,
      //                       filled: true,
      //                     ),
      //                   ),
      //                 ),
      //                 SizedBox(
      //                   height: 20,
      //                 ),
      //                 Container(
      //                   padding: EdgeInsets.only(left: 70, right: 20),
      //                   child: Row(
      //                     mainAxisAlignment: MainAxisAlignment.start,
      //                     children: [
      //                       Container(
      //                         margin: EdgeInsets.only(right: 10),
      //                         width: size.width * 0.4,
      //                         decoration: BoxDecoration(
      //                           border: Border.all(
      //                             color: Colors.black,
      //                             width: 1,
      //                           ),
      //                           borderRadius: BorderRadius.circular(10),
      //                         ),
      //                         child: Padding(
      //                           padding: EdgeInsets.symmetric(
      //                             horizontal: 15,
      //                           ),
      //                           child: DropdownButton(
      //                             icon: Icon(Icons.arrow_drop_down),
      //                             iconSize: 35,
      //                             hint: Text('Chọn loại dịch vụ'),
      //                             isExpanded: true,
      //                             style: TextStyle(
      //                               color: Colors.black,
      //                               fontSize: 18,
      //                               fontWeight: FontWeight.w600,
      //                             ),
      //                             value: valueChoose,
      //                             onChanged: (newValue) {
      //                               setModal(() {
      //                                 if (newValue == 'Chênh lệch') {
      //                                   expandCheck = true;
      //                                   valueChoose = newValue;
      //                                 } else {
      //                                   expandCheck = false;
      //                                   valueChoose = newValue;
      //                                 }
      //                               });
      //                             },
      //                             items: listServices.map((valueItem) {
      //                               return DropdownMenuItem(
      //                                 value: valueItem,
      //                                 child: Text(valueItem),
      //                               );
      //                             }).toList(),
      //                           ),
      //                         ),
      //                       ),
      //                       // ExpandUnitText(expandCheck),
      //                       Container(
      //                         height: size.height * 0.05,
      //                         child: expandCheck
      //                             ? Container(
      //                                 width: size.width * 0.3,
      //                                 decoration: BoxDecoration(
      //                                     borderRadius: BorderRadius.circular(10),
      //                                     boxShadow: [
      //                                       BoxShadow(
      //                                         color: Colors.black12,
      //                                         blurRadius: 5,
      //                                         offset: const Offset(0, 5),
      //                                       )
      //                                     ]),
      //                                 child: TextField(
      //                                   textAlign: TextAlign.center,
      //                                   controller: serviceUnit,
      //                                   textInputAction: TextInputAction.done,
      //                                   decoration: InputDecoration(
      //                                     labelText: "Nhập đơn vị đo",
      //                                     labelStyle: TextStyle(
      //                                         color: Color(0xFF707070),
      //                                         fontWeight: FontWeight.bold,
      //                                         fontSize: 15),
      //                                     border: OutlineInputBorder(
      //                                         borderRadius:
      //                                             BorderRadius.circular(15)),
      //                                     fillColor: Colors.white,
      //                                     filled: true,
      //                                   ),
      //                                 ),
      //                               )
      //                             : Container(),
      //                       ),
      //                     ],
      //                   ),
      //                 ),
      //                 SizedBox(
      //                   height: 10,
      //                 ),
      //                 // Text(showErr.isEmpty ? '' : showErr),
      //                 SizedBox(
      //                   height: 10,
      //                 ),
      //                 TextButton(
      //                   style: TextButton.styleFrom(
      //                     padding: EdgeInsets.symmetric(
      //                         vertical: 15, horizontal: 20),
      //                     backgroundColor: PrimaryColor,
      //                   ),
      //                   child: Text(
      //                     'Xác nhận',
      //                     style: TextStyle(color: Colors.white, fontSize: 16),
      //                   ),
      //                   onPressed: () {
      //                     // setState(() {
      //                     //   if (name.text.isEmpty || address.text.isEmpty) {
      //                     //     showErr = 'Thông tin không được trống !!!';
      //                     //   } else {}
      //                     // });
      //                   },
      //                 ),
      //                 Padding(
      //                     padding: EdgeInsets.only(
      //                   bottom: MediaQuery.of(context).viewInsets.bottom,
      //                 )),
      //               ],
      //             ),
      //           );
      //         },
      //       ),
      //     );
      //   },
      //   child: Icon(Icons.add),
      //   tooltip: 'Create Service',
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: SingleChildScrollView(
        child: Container(
          color: Color(0xFFF5F5F5),
          width: size.width,
          padding: EdgeInsets.all(15),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(
                  bottom: 10,
                ),
                child: Text(
                  'Đơn giá dịch vụ',
                  style: TextStyle(
                    color: Colors.blueGrey,
                    fontSize: 21,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(20),
                height: size.height * 0.8,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    width: 2,
                    color: Color(0xFF707070),
                    style: BorderStyle.solid,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                            bottom: 15,
                          ),
                          child: Card(
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                              side:
                                  BorderSide(color: Color(0xFF707070), width: 2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Container(
                              height: size.height * 0.07,
                              width: size.width * 0.8,
                              padding: EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              child: Stack(
                                children: [
                                  Positioned(
                                      top: 25,
                                      left: 5,
                                    child: Text(
                                      '${listService[index].name}',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 25,
                                    left: 100,
                                    child: Text(
                                      '${listService[index].serviceType}',
                                      style: TextStyle(
                                        color: listService[index].serviceType == "Chênh lệch" ? Colors.red : Colors.blue,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 25,
                                    right: 5,
                                    child: Text(
                                      '${listService[index].price}đ/${listService[index].calculationUnit}',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                  itemCount: listService.length,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  // ExpandUnitText(bool value) {
  //   if (value == true) {
  //     return Container(
  //       child: Text('Expand'),
  //     );
  //   } else {
  //     return Container();
  //   }
  // }
}
