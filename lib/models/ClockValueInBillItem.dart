import 'package:house_management_project/models/ClockValue.dart';

class ClockValueInBillItem {
  int id;
  int billItemId;
  int startValueId;
  int endValueId;
  bool status;
  ClockValue endValue;
  ClockValue startValue;

  ClockValueInBillItem({
    this.id,
    this.billItemId,
    this.startValueId,
    this.endValueId,
    this.status,
    this.endValue,
    this.startValue,
  });

  factory ClockValueInBillItem.fromJson(Map<String, dynamic> json) =>
      ClockValueInBillItem(
        id: json["id"],
        billItemId: json["billItemId"],
        startValueId: json["startValueId"],
        endValueId: json["endValueId"],
        status: json["status"],
        endValue: ClockValue.fromJson(json["endValue"]),
        startValue: ClockValue.fromJson(json["startValue"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "billItemId": billItemId,
        "startValueId": startValueId,
        "endValueId": endValueId,
        "status": status,
        "endValue": endValue.toJson(),
        "startValue": startValue.toJson(),
      };
}
