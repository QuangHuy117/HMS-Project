

class Response {
    Response({
        this.name,
        this.username,
        this.phone,
        this.email,
        this.role,
        this.token,
    });

    String name;
    String username;
    String phone;
    String email;
    String role;
    String token;

    factory Response.fromJson(Map<String, dynamic> json) => Response(
        name: json["name"],
        username: json["username"],
        phone: json["phone"],
        email: json["email"],
        role: json["role"],
        token: json["token"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "username": username,
        "phone": phone,
        "email": email,
        "role": role,
        "token": token,
    };
}
