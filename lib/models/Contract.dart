import 'package:house_management_project/models/ServiceContracts.dart';
import 'package:house_management_project/models/TenantUsernameNavigation.dart';

class Contract {
  int id;
  String ownerUserId;
  String tenantUserId;
  int roomId;
  DateTime startDate;
  DateTime endDate;
  bool status;
  TenantUsernameNavigation tenant;
  List<ServiceContracts> serviceContracts;

  Contract({
    this.id,
    this.ownerUserId,
    this.tenantUserId,
    this.roomId,
    this.startDate,
    this.endDate,
    this.status,
    this.tenant,
    this.serviceContracts,
  });

  factory Contract.fromJson(Map<String, dynamic> json) => Contract(
        id: json['id'],
        ownerUserId: json['owneruserId'],
        tenantUserId: json['tenantuserId'],
        roomId: json['roomId'],
        startDate: DateTime.parse(json['startDate']),
        endDate: DateTime.parse(json['endDate']),
        status: json['status'],
        tenant: json['tenantUser'] == null ? null : TenantUsernameNavigation.fromJson(json['tenantUser']),
        serviceContracts: json['serviceContracts'] == null ? null : List<ServiceContracts>.from(json["serviceContracts"].map((x) => ServiceContracts.fromJson(x)))
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "owneruserId": ownerUserId,
    "tenantuserId": tenantUserId,
    "roomId": roomId,
    "startDate": startDate,
    "endDate": endDate,
    "status": status,
    "tenantUser": tenant,
    "serviceContracts": List<dynamic>.from(serviceContracts.map((x) => x.toJson())),
  };
}
