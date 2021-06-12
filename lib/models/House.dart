import 'package:house_management_project/models/HouseInfo.dart';
import 'dart:convert';
class House {
  String id;
  String ownerUsername;
  bool isDeleted;
  bool status;
  HouseInfo houseInfo;

  House({
    this.id,
    this.ownerUsername,
    this.isDeleted,
    this.status,
    this.houseInfo,
  });

  factory House.fromJson(Map<String, dynamic> json) => House(
    id: json['id'],
    ownerUsername: json['ownerUsername'],
    isDeleted: json['isDeleted'],
    status: json['status'],
    houseInfo: HouseInfo.fromJson(json['houseInfo']),
  );
}



// List<House> houseFromJson(String str) => List<House>.from(json.decode(str).map((x) => House.fromJson(x)));

// String houseToJson(List<House> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

// class House {
//     House({
//         this.id,
//         this.ownerUsername,
//         this.isDeleted,
//         this.status,
//         this.houseInfos,
//     });

//     String id;
//     String ownerUsername;
//     bool isDeleted;
//     bool status;
//     List<HouseInfo> houseInfos;

//     factory House.fromJson(Map<String, dynamic> json) => House(
//         id: json["id"],
//         ownerUsername: json["ownerUsername"],
//         isDeleted: json["isDeleted"],
//         status: json["status"],
//         houseInfos: List<HouseInfo>.from(json["houseInfos"].map((x) => HouseInfo.fromJson(x))),
//     );

//     Map<String, dynamic> toJson() => {
//         "id": id,
//         "ownerUsername": ownerUsername,
//         "isDeleted": isDeleted,
//         "status": status,
//         "houseInfos": List<dynamic>.from(houseInfos.map((x) => x.toJson())),
//     };
// }