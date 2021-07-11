
import 'dart:convert';

Account accountFromJson(String str) => Account.fromJson(json.decode(str));

String accountToJson(Account data) => json.encode(data.toJson());

class Account {
    Account({
        this.name,
        this.userId,
        this.phone,
        this.email,
        this.image,
        this.role,
        this.token,
    });

    String name;
    String userId;
    String phone;
    String email;
    String image;
    String role;
    String token;

    factory Account.fromJson(Map<String, dynamic> json) => Account(
        name: json["name"],
        userId: json["userId"],
        phone: json["phone"],
        email: json["email"],
        image: json["image"] == null ? null : json['image'],
        role: json["role"],
        token: json["token"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "userId": userId,
        "phone": phone,
        "email": email,
        "image": image,
        "role": role,
        "token": token,
    };
}
