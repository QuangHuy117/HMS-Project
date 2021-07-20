import 'dart:convert';

import 'package:house_management_project/models/ServiceContracts.dart';
import 'package:house_management_project/models/TenantUsernameNavigation.dart';

List<Contract> contractFromJson(String str) => List<Contract>.from(json.decode(str).map((x) => Contract.fromJson(x)));

String contractToJson(List<Contract> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Contract {
  int id;
  String ownerUserId;
  String tenantUserId;
  int roomId;
  int roomPrice;
  String note;
  DateTime startDate;
  DateTime endDate;
  bool status;
  bool isDeleted;
  String houseName;
  String roomName;
  String ownerName;
  TenantUsernameNavigation tenant;
  List<ServiceContracts> serviceContracts;

  Contract({
    this.id,
    this.ownerUserId,
    this.tenantUserId,
    this.roomId,
    this.roomPrice,
    this.note,
    this.startDate,
    this.endDate,
    this.status,
    this.isDeleted,
    this.houseName,
    this.roomName,
    this.ownerName,
    this.tenant,
    this.serviceContracts,
  });

  factory Contract.fromJson(Map<String, dynamic> json) => Contract(
        id: json['id'],
        ownerUserId: json['owneruserId'],
        tenantUserId: json['tenantuserId'],
        roomId: json['roomId'],
        roomPrice: json['roomPrice'],
        note: json['note'] == null ? null : json['note'] ,
        startDate: DateTime.parse(json['startDate']),
        endDate: DateTime.parse(json['endDate']),
        status: json['status'],
        isDeleted: json['isDeleted'] == null ? null : json['isDeleted'],
        houseName: json['houseName'] == null ? null : json['houseName'],
        roomName: json['roomName'] == null ? null : json['roomName'],
        ownerName: json['ownerName'] == null ? null : json['ownerName'],
        tenant: json['tenantUser'] == null ? null : TenantUsernameNavigation.fromJson(json['tenantUser']),
        serviceContracts: json['serviceContracts'] == null ? null : List<ServiceContracts>.from(json["serviceContracts"].map((x) => ServiceContracts.fromJson(x)))
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "owneruserId": ownerUserId,
    "tenantuserId": tenantUserId,
    "roomId": roomId,
    "roomPrice": roomPrice,
    "note": note,
    "startDate": startDate,
    "endDate": endDate,
    "status": status,
    "isDeleted": isDeleted,
    "houseName": houseName,
    "roomName": roomName,
    "ownerName": ownerName,
    "tenantUser": tenant,
    "serviceContracts": List<dynamic>.from(serviceContracts.map((x) => x.toJson())),
  };
}
