import 'dart:convert';

import 'package:house_management_project/models/BillItem.dart';
import 'package:house_management_project/models/Contract.dart';
import 'package:house_management_project/models/Payment.dart';

List<Bill> billFromJson(String str) => List<Bill>.from(json.decode(str).map((x) => Bill.fromJson(x)));

String billToJson(List<Bill> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Bill {
  int id;
  int contractId;
  DateTime issueDate;
  DateTime startDate;
  DateTime endDate;
  int totalPrice;
  bool status;
  String note;
  bool isDeleted;
  bool isSent;
  bool isWaiting;
  Contract contract;
  List<BillItem> billItems;
  List<Payment> payments;

  Bill ({
    this.id,
    this.contractId,
    this.issueDate,
    this.startDate,
    this.endDate,
    this.totalPrice,
    this.status,
    this.note,
    this.isDeleted,
    this.isSent,
    this.isWaiting,
    this.contract,
    this.billItems,
    this.payments,
  });

  factory Bill.fromJson(Map<String, dynamic> json) => Bill(
        id: json['id'],
        contractId: json['contractId'],
        issueDate: DateTime.parse(json['issueDate']),
        startDate: DateTime.parse(json['startDate']),
        endDate: DateTime.parse(json['endDate']),
        totalPrice: json['totalPrice'] == null ? null : json['totalPrice'],
        status: json['status'],
        note: json['note'] == null ? null : json['note'],
        isDeleted: json['isDeleted'],
        isSent: json['isSent'],
        isWaiting: json['isWaiting'] == null ? null : json['isWaiting'],
        contract: Contract.fromJson(json['contract']),
        billItems: json['billItems'] == null ? null : List<BillItem>.from(json['billItems'].map((x) => BillItem.fromJson(x))),
        payments: json['payments'] == null ? null : List<Payment>.from(json['payments'].map((x) => Payment.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "contractId": contractId,
        "issueDate": issueDate.toIso8601String(),
        "startDate": startDate.toIso8601String(),
        "endDate": endDate.toIso8601String(),
        "totalPrice": totalPrice,
        "status": status,
        "note": note,
        "isDeleted": isDeleted,
        "isSent": isSent,
        "isWaiting": isWaiting,
        "contract": contract.toJson(),
        "billItems": List<dynamic>.from(billItems.map((x) => x.toJson())),
        "payments": List<dynamic>.from(payments.map((x) => x.toJson())),
    };
}
