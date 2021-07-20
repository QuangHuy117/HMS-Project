
class Service{
  int id;
  String name;
  String calculationUnit;
  bool status;
  String houseId;
  int price;
  String serviceType;

  Service({
    this.id,
    this.name,
    this.calculationUnit,
    this.status,
    this.houseId,
    this.price,
    this.serviceType,
  });

  factory Service.fromJson(Map<String, dynamic> json) => Service(
    id: json['id'],
    name: json['name'],
    calculationUnit: json['calculationUnit'],
    status: json['status'],
    houseId: json['houseId'],
    price: int.parse(json['price'].toString()),
    serviceType: json['serviceType'],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "calculationUnit": calculationUnit,
    "status": status,
    "houseId": houseId,
    "price": price,
    "serviceType": serviceType,
  };
}