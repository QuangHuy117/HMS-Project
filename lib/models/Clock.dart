
import 'package:house_management_project/models/ClockValue.dart';

class Clock {
  String id;
  int roomId;
  String clockCategoryId;
  bool status;
  String clockCategory;
  List<ClockValue> clockValues;

  Clock({
    this.id,
    this.roomId,
    this.clockCategoryId,
    this.status,
    this.clockCategory,
    this.clockValues,
  });

  factory Clock.fromJson(Map<String, dynamic> json) => Clock(
    id: json['id'],
    roomId: json['roomId'],
    clockCategoryId: json['clockCategoryId'],
    status: json['status'],
    clockCategory: json['clockCategory'],
    clockValues: List<ClockValue>.from(json['clockValues'].map((x) => ClockValue.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "roomId": roomId,
    "clockCategoryId": clockCategoryId,
    "status": status,
    "clockCategory": clockCategory,
    "clockValues": List<dynamic>.from(clockValues.map((x) => x.toJson())),
  };
}