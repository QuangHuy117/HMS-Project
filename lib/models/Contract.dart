import 'package:house_management_project/models/ServiceContracts.dart';
import 'package:house_management_project/models/TenantUsernameNavigation.dart';

class Contract {
  int id;
  String ownerUsername;
  String tenantUsername;
  int roomId;
  DateTime startDate;
  DateTime endDate;
  bool status;
  String image;
  TenantUsernameNavigation tenant;
  List<ServiceContracts> serviceContracts;

  Contract({
    this.id,
    this.ownerUsername,
    this.tenantUsername,
    this.roomId,
    this.startDate,
    this.endDate,
    this.status,
    this.image,
    this.tenant,
    this.serviceContracts,
  });

  factory Contract.fromJson(Map<String, dynamic> json) => Contract(
        id: json['id'],
        ownerUsername: json['ownerUsername'],
        tenantUsername: json['tenantUsername'],
        roomId: json['roomId'],
        startDate: DateTime.parse(json['startDate']),
        endDate: DateTime.parse(json['endDate']),
        status: json['status'],
        image: json['image'] == null ? null : json['image'],
        tenant: TenantUsernameNavigation.fromJson(json['tenantUsernameNavigation']),
        serviceContracts: json['serviceContracts'] == null ? null : List<ServiceContracts>.from(json["serviceContracts"].map((x) => ServiceContracts.fromJson(x)))
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "ownerUsername": ownerUsername,
    "tenantUsername": tenantUsername,
    "roomId": roomId,
    "startDate": startDate,
    "endDate": endDate,
    "status": status,
    "image": image,
    "tenant": tenant,
    "serviceContracts": List<dynamic>.from(serviceContracts.map((x) => x.toJson())),
  };
}
