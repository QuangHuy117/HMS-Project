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
  bool status;
  String note;
  bool isDeleted;
  bool isSent;
  bool isPaidInFull;
  Contract contract;
  List<BillItem> billItems;
  List<Payment> payments;

  Bill ({
    this.id,
    this.contractId,
    this.issueDate,
    this.startDate,
    this.endDate,
    this.status,
    this.note,
    this.isDeleted,
    this.isSent,
    this.isPaidInFull,
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
        status: json['status'],
        note: json['note'] == null ? null : json['note'],
        isDeleted: json['isDeleted'],
        isSent: json['isSent'],
        isPaidInFull: json['isPaidInFull'] == null ? null : json['isPaidInFull'],
        contract: Contract.fromJson(json['contract']),
        billItems: List<BillItem>.from(json['billItems'].map((x) => BillItem.fromJson(x))),
        payments: json['payments'] == null ? null : List<Payment>.from(json['payments'].map((x) => Payment.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "contractId": contractId,
        "issueDate": issueDate.toIso8601String(),
        "startDate": startDate.toIso8601String(),
        "endDate": endDate.toIso8601String(),
        "status": status,
        "note": note,
        "isDeleted": isDeleted,
        "isSent": isSent,
        "isPaidInFull": isPaidInFull,
        "contract": contract.toJson(),
        "billItems": List<dynamic>.from(billItems.map((x) => x.toJson())),
        "payments": List<dynamic>.from(payments.map((x) => x.toJson())),
    };
}
