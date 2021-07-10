
class TenantUsernameNavigation{
  String name;
  String username;
  String phone;
  String email;
  String role;

  TenantUsernameNavigation({
    this.name,
    this.username,
    this.phone,
    this.email,
    this.role
  });

  factory TenantUsernameNavigation.fromJson(Map<String, dynamic> json) => TenantUsernameNavigation(
    name: json['name'],
    username: json['username'],
    phone: json['phone'],
    email: json['email'],
    role: json['role'],
  );
}