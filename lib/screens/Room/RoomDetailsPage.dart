import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:house_management_project/main.dart';
import 'package:house_management_project/models/Contract.dart';
import 'package:house_management_project/models/Room.dart';
import 'package:house_management_project/screens/Contract/ContractDetailPage.dart';
import 'package:house_management_project/screens/Contract/CreateContractPage.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class RoomDetailsPage extends StatefulWidget {
  final int roomId;
  final String houseId;
  const RoomDetailsPage(
      {Key key, @required this.roomId, @required this.houseId})
      : super(key: key);

  @override
  _RoomDetailsPageState createState() => _RoomDetailsPageState();
}

class _RoomDetailsPageState extends State<RoomDetailsPage> {
  TextEditingController startDatePicked;
  TextEditingController endDatePicked;
  TextEditingController name = new TextEditingController();
  TextEditingController custName = new TextEditingController();
  TextEditingController roomSquare = new TextEditingController();
  TextEditingController roomPrice = new TextEditingController();
  Room detail = new Room();
  Contract contract = new Contract();
  bool _isEdit = false;
  bool _isLoading = true;
  String responseMsg = '';

  getRoomDetailFromRoomId() async {
    var url = Uri.parse('https://$serverHost/api/rooms/${widget.roomId}');
    try {
      var response = await http.get(url);
      print(response.statusCode);
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        setState(() {
          detail = Room.fromJson(jsonData);
          name = new TextEditingController(text: detail.name);
          roomPrice = new TextEditingController(text: detail.defaultPrice.toString());
          roomSquare = new TextEditingController(text: detail.roomSquare.toString());
          _isLoading = false;
        });
      }
    } catch (error) {
      throw (error);
    }
  }

  updateDetailRoom(String roomSquare, String price, String name) async {
    dynamic token = await FlutterSession().get("token");
    var url = Uri.parse('https://$serverHost/api/rooms');
    try {
      var response = await http.put(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: 'Bearer ${token.toString()}'
        },
        body: jsonEncode({
          "id": detail.id,
          "roomSquare": int.parse(roomSquare),
          "defaultPrice": int.parse(price),
          "name": name,
        }),
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        setState(() {
          responseMsg = 'Cập nhật phòng thành công';
          _isEdit = false;
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
              responseMsg,
              style: TextStyle(fontSize: 20),
            ),
          ));
        });
      }
    } catch (error) {
      throw (error);
    }
  }

  @override
  void initState() {
    super.initState();
    getRoomDetailFromRoomId();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Container(
        color: Colors.white,
        width: size.width,
        height: size.height * 0.9,
        padding: EdgeInsets.all(20),
        child: Align(
          alignment: Alignment.topCenter,
          child: Container(
            height: size.height * 0.81,
            padding: EdgeInsets.only(
              top: 20,
              right: 10,
              left: 10,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 5,
                  spreadRadius: 3,
                  offset: const Offset(0, 3),
                )
              ],
              border: Border.all(
                width: 1,
                color: Color(0xFFFEAF45),
                style: BorderStyle.solid,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Phòng',
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Colors.blue),
                ),
                Divider(
                  indent: 60,
                  endIndent: 60,
                  thickness: 2,
                  color: Colors.blue,
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      Icon(
                        Icons.meeting_room_outlined,
                        color: Colors.black54,
                        size: 30,
                      ),
                      Container(
                        width: size.width * 0.68,
                        child: _isEdit
                            ? Container(
                                margin: EdgeInsets.only(bottom: 10, left: 10),
                                width: size.width * 0.68,
                                child: TextField(
                                  controller: name,
                                  style: TextStyle(
                                      color: Colors.blue, fontSize: 22),
                                  decoration: InputDecoration(
                                    hintText: 'Tên phòng',
                                    hintStyle: TextStyle(fontSize: 20),
                                  ),
                                ),
                              )
                            : Container(
                                width: size.width * 0.68,
                                height: size.height * 0.061,
                                alignment: Alignment.centerLeft,
                                margin: EdgeInsets.only(left: 10),
                                child: GestureDetector(
                                  child: Text(
                                    detail.name == null ? 'N/A' : detail.name,
                                    style: TextStyle(
                                        fontSize: 22,
                                        color: PrimaryColor,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  onTap: () {
                                    setState(() {
                                      _isEdit = true;
                                    });
                                  },
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      Icon(
                        Icons.crop_square,
                        color: Colors.black54,
                        size: 30,
                      ),
                      Container(
                        width: size.width * 0.68,
                        child: _isEdit
                            ? Container(
                                margin: EdgeInsets.only(bottom: 10, left: 10),
                                width: size.width * 0.68,
                                child: TextField(
                                  controller: roomSquare,
                                  style: TextStyle(
                                      color: Colors.blue, fontSize: 22),
                                  decoration: InputDecoration(
                                    hintText: 'Diện tích',
                                    hintStyle: TextStyle(fontSize: 20),
                                  ),
                                ),
                              )
                            : Container(
                                width: size.width * 0.68,
                                height: size.height * 0.061,
                                alignment: Alignment.centerLeft,
                                margin: EdgeInsets.only(left: 10),
                                child: GestureDetector(
                                  child: Text(
                                    detail.roomSquare == null
                                        ? 'N/A'
                                        : detail.roomSquare.toString(),
                                    style: TextStyle(
                                        fontSize: 22,
                                        color: PrimaryColor,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  onTap: () {
                                    setState(() {
                                      _isEdit = true;
                                    });
                                  },
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      Icon(
                        Icons.attach_money_outlined,
                        color: Colors.black54,
                        size: 30,
                      ),
                      Container(
                        width: size.width * 0.68,
                        child: _isEdit
                            ? Container(
                                margin: EdgeInsets.only(bottom: 10, left: 10),
                                width: size.width * 0.68,
                                child: TextField(
                                  controller: roomPrice,
                                  style: TextStyle(
                                      color: Colors.blue, fontSize: 22),
                                  decoration: InputDecoration(
                                    hintText: 'Giá mặc định',
                                    hintStyle: TextStyle(fontSize: 20),
                                  ),
                                ),
                              )
                            : Container(
                                width: size.width * 0.68,
                                height: size.height * 0.061,
                                alignment: Alignment.centerLeft,
                                margin: EdgeInsets.only(left: 10),
                                child: GestureDetector(
                                  child: Text(
                                    detail.defaultPrice == null
                                        ? 'N/A'
                                        : detail.defaultPrice.toString(),
                                    style: TextStyle(
                                        fontSize: 22,
                                        color: PrimaryColor,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  onTap: () {
                                    setState(() {
                                      _isEdit = true;
                                    });
                                  },
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: size.width * 0.2,
                  height: size.height * 0.045,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: PrimaryColor,
                      ),
                      child: Text(
                        'Cập nhật',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w700),
                      ),
                      onPressed: () {
                        updateDetailRoom(
                            roomSquare.text, roomPrice.text, name.text);
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Hợp đồng',
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Colors.blue),
                ),
                Divider(
                  indent: 60,
                  endIndent: 60,
                  thickness: 2,
                  color: Colors.blue,
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  child: _isLoading
                      ? Center(
                          child: SizedBox(
                              width: 30,
                              height: 30,
                              child: CircularProgressIndicator()))
                      : Container(
                          child: detail.contract == null
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                        child: Text(
                                      'Chưa tồn tại hợp đồng !!!',
                                      style: TextStyle(
                                          fontSize: 23,
                                          fontWeight: FontWeight.w600),
                                    )),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Container(
                                      width: size.width * 0.2,
                                      height: size.height * 0.045,
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        child: TextButton(
                                          style: TextButton.styleFrom(
                                            backgroundColor: PrimaryColor,
                                          ),
                                          child: Text(
                                            'Tạo',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                                fontWeight: FontWeight.w700),
                                          ),
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (_) =>
                                                        CreateContractPage(
                                                          houseId:
                                                              widget.houseId,
                                                          roomName: detail.name,
                                                          roomId: widget.roomId,
                                                        )));
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => ContractDetailPage(
                                                  contractId:
                                                      detail.contract.id,
                                                  houseId: widget.houseId,
                                                )));
                                  },
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(20),
                                          bottomLeft: Radius.circular(20),
                                          topRight: Radius.circular(20),
                                          bottomRight: Radius.circular(20)),
                                    ),
                                    elevation: 5,
                                    shadowColor: Colors.black,
                                    child: Container(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 20),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(20),
                                            bottomLeft: Radius.circular(20),
                                            topRight: Radius.circular(20),
                                            bottomRight: Radius.circular(20)),
                                      ),
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            'Hợp đồng khách hàng: ${detail.contract == null ? '' : detail.contract.tenant.name}',
                                            style: TextStyle(
                                                fontSize: 19,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Divider(
                                            indent: 30,
                                            endIndent: 30,
                                            thickness: 1,
                                            color: Colors.grey,
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 20),
                                            child: Row(
                                              children: [
                                                Text(
                                                  'Ngày bắt đầu: ',
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                                SizedBox(
                                                  width: 20,
                                                ),
                                                Text(
                                                  detail.contract == null
                                                      ? ''
                                                      : DateFormat('dd/MM/yyyy')
                                                          .format(detail
                                                              .contract
                                                              .startDate),
                                                  style:
                                                      TextStyle(fontSize: 18),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 20),
                                            child: Row(
                                              children: [
                                                Text(
                                                  'Ngày kết thúc: ',
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                                SizedBox(
                                                  width: 20,
                                                ),
                                                Text(
                                                  detail.contract == null
                                                      ? ''
                                                      : DateFormat('dd/MM/yyyy')
                                                          .format(detail
                                                              .contract
                                                              .endDate),
                                                  style:
                                                      TextStyle(fontSize: 18),
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
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
