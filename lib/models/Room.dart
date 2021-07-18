import 'package:house_management_project/models/Clock.dart';
import 'package:house_management_project/models/Contract.dart';
import 'dart:convert';

List<Room> roomFromJson(String str) => List<Room>.from(json.decode(str).map((x) => Room.fromJson(x)));

class Room {
  int id;
  String name;
  String houseId;
  bool status;
  bool isDeleted;
  Contract contract;
  List<Clock> clocks;

  Room({
    this.id,
    this.name,
    this.houseId,
    this.status,
    this.isDeleted,
    this.contract,
    this.clocks,
  });

  factory Room.fromJson(Map<String, dynamic> json) => Room(
        id: json["id"],
        name: json["name"],
        houseId: json['houseId'],
        status: json["status"],
        isDeleted: json["isDeleted"],
        contract: json['contract'] == null ? null : Contract.fromJson(json['contract']),
        clocks: json['clocks'] == null ? null : List<Clock>.from(json["clocks"].map((x) => Clock.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "houseId": houseId,
        "status": status,
        "isDeleted": isDeleted,
        "contract": contract,
        "clocks": List<dynamic>.from(clocks.map((x) => x.toJson())),
      };
}
