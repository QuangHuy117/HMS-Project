

class HouseInfo {
  
    int id;
    String name;
    String address;
    String houseId;
    String image;

    
    HouseInfo({
        this.id,
        this.name,
        this.address,
        this.houseId,
        this.image,
    });


    factory HouseInfo.fromJson(Map<String, dynamic> json) => HouseInfo(
        id: json['id'],
        name: json['name'],
        address: json['address'],
        houseId: json['houseId'],
        image: json['image'] == null ? null : json['image'],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "address": address,
        "houseId": houseId,
        "image": image
    };
}
