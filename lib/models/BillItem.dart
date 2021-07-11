import 'package:house_management_project/models/ClockValueInBillItem.dart';
import 'package:house_management_project/models/ServiceContracts.dart';

class BillItem {
  int id;
  int serviceContractId;
  int billId;
  int totalPrice;
  int startValue;
  int endValue;
  bool status;
  ServiceContracts serviceContract;
  ClockValueInBillItem clockValueInBillItem;

  BillItem({
    this.id,
    this.serviceContractId,
    this.billId,
    this.totalPrice,
    this.startValue,
    this.endValue,
    this.status,
    this.serviceContract,
    this.clockValueInBillItem,
  });

  factory BillItem.fromJson(Map<String, dynamic> json) => BillItem(
        id: json["id"],
        serviceContractId: json["serviceContractId"] == null ? null : json['serviceContractId'],
        billId: json["billId"],
        totalPrice: json["totalPrice"] == null ? null : json['totalPrice'],
        startValue: json["startValue"] == null ? null : json["startValue"],
        endValue: json["endValue"] == null ? null : json["endValue"],
        status: json["status"],
        serviceContract: json["serviceContract"] == null ? null : ServiceContracts.fromJson(json["serviceContract"]),
        clockValueInBillItem: json['clockValueInBillItem'] == null ? null : ClockValueInBillItem.fromJson(json["clockValueInBillItem"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "serviceContractId": serviceContractId,
        "billId": billId,
        "totalPrice": totalPrice,
        "startValue": startValue == null ? null : startValue,
        "endValue": endValue == null ? null : endValue,
        "status": status,
        "serviceContract": serviceContract.toJson(),
        "clockValueInBillItem": clockValueInBillItem.toJson(),
    };
}
