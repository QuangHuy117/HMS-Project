
import 'package:house_management_project/models/Clock.dart';
import 'package:house_management_project/models/Service.dart';

class ServiceContracts{
  int id;
  int contractId;
  int serviceId;
  int unitPrice;
  bool status;
  String clockId;
  Service service;
  Clock clock;

  ServiceContracts({
    this.id,
    this.contractId,
    this.serviceId,
    this.unitPrice,
    this.status,
    this.clockId,
    this.service,
    this.clock,
  });

  factory ServiceContracts.fromJson(Map<String, dynamic> json) => ServiceContracts(
    id: json['id'],
    contractId: json['contractId'],
    serviceId: json['serviceId'],
    unitPrice: json['unitPrice'],
    status: json['status'] == null ? null : json['status'],
    clockId: json['clockId'] == null ? null : json['clockId'],
    service: Service.fromJson(json['service']),
    clock: json['clock'] == null ? null : Clock.fromJson(json['clock']),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "contractId": contractId,
    "serviceId": serviceId,
    "unitPrice": unitPrice,
    "status": status,
    "clockId": clockId,
    "service": service.toJson(),
    "clock": clock == null ? null : clock.toJson(),
  };
}