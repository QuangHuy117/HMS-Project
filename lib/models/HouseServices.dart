

class HouseServices{
  int id;
  String name;
  String calculationUnit;
  bool status;
  double price;
  String serviceType;

  HouseServices({
    this.id,
    this.name,
    this.calculationUnit,
    this.status,
    this.price,
    this.serviceType,
  });

  factory HouseServices.fromJson(Map<String, dynamic> json) => HouseServices(
    id: json['id'],
    name: json['name'],
    calculationUnit: json['calculationUnit'],
    status: json['status'],
    price: double.parse(json['price'].toString()),
    serviceType: json['serviceType'],
  );
}