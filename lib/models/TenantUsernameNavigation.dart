
class TenantUsernameNavigation{
  String name;
  String userId;
  String phone;
  String email;
  String image;
  String role;

  TenantUsernameNavigation({
    this.name,
    this.userId,
    this.phone,
    this.email,
    this.image,
    this.role
  });

  factory TenantUsernameNavigation.fromJson(Map<String, dynamic> json) => TenantUsernameNavigation(
    name: json['name'],
    userId: json['userId'],
    phone: json['phone'],
    email: json['email'],
    image: json['image'] == null ? null : json['image'],
    role: json['role'],
  );
}