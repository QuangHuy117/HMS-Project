
class Service{
  int id;
  String name;
  String calculationUnit;
  bool status;
  int price;
  String serviceType;

  Service({
    this.id,
    this.name,
    this.calculationUnit,
    this.status,
    this.price,
    this.serviceType,
  });

  factory Service.fromJson(Map<String, dynamic> json) => Service(
    id: json['id'],
    name: json['name'],
    calculationUnit: json['calculationUnit'],
    status: json['status'],
    price: int.parse(json['price'].toString()),
    serviceType: json['serviceType'],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "calculationUnit": calculationUnit,
    "status": status,
    "price": price,
    "serviceType": serviceType,
  };
}