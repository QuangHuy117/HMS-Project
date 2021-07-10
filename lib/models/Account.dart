
// class Account{
//   String name;
//   String username;
//   String phone;
//   String email;
//   String role;
//   String token;

//   Account({
//     this.name,
//     this.username,
//     this.phone,
//     this.email,
//     this.role,
//     this.token,
//   });

//   factory Account.fromJson(Map<String, dynamic> json) => Account(
//       name: json['name'],
//       username: json['username'],
//       phone: json['phone'],
//       email: json['email'],
//       role: json['role'],
//       token: json['token'],
//   );

  
// }

import 'dart:convert';

import 'package:house_management_project/models/Response.dart';

Account accountFromJson(String str) => Account.fromJson(json.decode(str));

String accountToJson(Account data) => json.encode(data.toJson());

class Account {
    Account({
        this.response,
        this.expiration,
    });

    Response response;
    DateTime expiration;

    factory Account.fromJson(Map<String, dynamic> json) => Account(
        response: Response.fromJson(json["response"]),
        expiration: DateTime.parse(json["expiration"]),
    );

    Map<String, dynamic> toJson() => {
        "response": response.toJson(),
        "expiration": expiration.toIso8601String(),
    };
}