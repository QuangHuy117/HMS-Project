import 'dart:convert';
import 'package:flutter/material.dart';
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
  TextEditingController custName;
  TextEditingController elecNum;
  TextEditingController waterNum;
  Room detail = new Room();
  Contract contract = new Contract();
  bool _isEdit = false;
  bool _isLoading = true;

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
          _isLoading = false;
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
                Container(
                  width: size.width,
                  child: _isEdit
                      ? Container(
                          margin: EdgeInsets.only(bottom: 10),
                          width: size.width * 0.68,
                          child: TextField(
                            textAlign: TextAlign.center,
                            controller: name,
                            style: TextStyle(color: Colors.blue, fontSize: 20),
                            decoration: InputDecoration(
                              hintText: 'Tên phòng',
                              hintStyle: TextStyle(fontSize: 20),
                            ),
                            onSubmitted: (value) {
                              setState(() {
                                _isEdit = false;
                              });
                              print(value);
                            },
                          ),
                        )
                      : Container(
                          width: size.width * 0.68,
                          height: size.height * 0.061,
                          alignment: Alignment.center,
                          padding: EdgeInsets.only(bottom: 10),
                          child: GestureDetector(
                            child: Text(
                              detail.name == null ? '' : detail.name,
                              style: TextStyle(
                                  fontSize: 20,
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
                SizedBox(
                  height: 10,
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
                Text(
                  'Hợp đồng',
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Colors.blue),
                ),
                SizedBox(height: 20,),
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
                                            Navigator.push(context, 
                                            MaterialPageRoute(builder: (_) => CreateContractPage(houseId: widget.houseId, roomName: detail.name, roomId: widget.roomId,)));
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
