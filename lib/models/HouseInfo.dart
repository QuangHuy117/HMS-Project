

class HouseInfo {
  
    int id;
    String name;
    String address;
    bool status;
    String houseId;
    int numberOfRoom;

    
    HouseInfo({
        this.id,
        this.name,
        this.address,
        this.status,
        this.houseId,
        this.numberOfRoom,
    });


    factory HouseInfo.fromJson(Map<String, dynamic> json) => HouseInfo(
        id: json["id"],
        name: json["name"],
        address: json["address"],
        status: json["status"],
        houseId: json["houseId"],
        numberOfRoom: json["numberOfRoom"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "address": address,
        "status": status,
        "houseId": houseId,
        "numberOfRoom": numberOfRoom,
    };
}
