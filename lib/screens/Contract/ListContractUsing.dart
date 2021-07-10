import 'package:flutter/material.dart';
import 'package:house_management_project/models/Contract.dart';
import 'package:intl/intl.dart';

class ListContractUsing extends StatefulWidget {
  final List<Contract> list;
  const ListContractUsing({ Key key, @required this.list }) : super(key: key);

  @override
  _ListContractUsingState createState() => _ListContractUsingState();
}

class _ListContractUsingState extends State<ListContractUsing> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
          child: Container(
            height: size.height * 0.867,
            width: size.width,
            child: ListView.builder(
              itemBuilder: (context, index) {
                return Container(
                  height: size.height * 0.25,
                  padding: EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  margin: EdgeInsets.only(
                    top: 30,
                  ),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(80),
                          bottomLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                          bottomRight: Radius.circular(80)),
                    ),
                    elevation: 5,
                    shadowColor: Colors.black,
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.only(right: 10, top: 10),
                          alignment: Alignment.topRight,
                          child: Text('${widget.list[index].status == true ? 'Còn hiệu lực' : ''}', style: TextStyle(fontSize: 21, fontWeight: FontWeight.w600, color: Colors.blue),),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text('Hợp đồng khách hàng: ${widget.list[index].tenant.name}', style: TextStyle(fontSize: 19, fontWeight: FontWeight.w600),),
                        SizedBox(
                          height: 5,
                        ),
                        Divider(
                          indent: 30,
                          endIndent: 30,
                          thickness: 1,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 10,),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            children: [
                              Text('Tên khách: ', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),),
                              SizedBox(width: 20,),
                              Text('${widget.list[index].tenant.name}', style: TextStyle(fontSize: 18),),
                            ],
                          ),
                        ),
                        SizedBox(height: 10,),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            children: [
                              Text('Số điện thoại: ', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),),
                              SizedBox(width: 20,),
                              Text('${widget.list[index].tenant.phone}', style: TextStyle(fontSize: 18),),
                            ],
                          ),
                        ),
                        SizedBox(height: 5,),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            children: [
                              Text('Email: ', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),),
                              SizedBox(width: 20,),
                              Text('${widget.list[index].tenant.email}', style: TextStyle(fontSize: 18),),
                            ],
                          ),
                        ),
                        SizedBox(height: 5,),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            children: [
                              Text('Ngày bắt đầu: ', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),),
                              SizedBox(width: 20,),
                              Text(DateFormat('dd/MM/yyyy').format(widget.list[index].startDate), style: TextStyle(fontSize: 18),),
                            ],
                          ),
                        ),
                        SizedBox(height: 5,),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            children: [
                              Text('Ngày kết thúc: ', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),),
                              SizedBox(width: 20,),
                              Text(DateFormat('dd/MM/yyyy').format(widget.list[index].endDate), style: TextStyle(fontSize: 18),),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              itemCount: widget.list.length,
            ),
          ),
        );
  }
}