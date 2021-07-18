

class HouseInfo {
  
    int id;
    String name;
    String address;
    String houseId;
    String image;
    int paidDeadline;
    int billDate;
    int beforeNotiDate;

    
    HouseInfo({
        this.id,
        this.name,
        this.address,
        this.houseId,
        this.image,
        this.paidDeadline,
        this.billDate,
        this.beforeNotiDate,
    });


    factory HouseInfo.fromJson(Map<String, dynamic> json) => HouseInfo(
        id: json['id'],
        name: json['name'],
        address: json['address'],
        houseId: json['houseId'],
        image: json['image'] == null ? null : json['image'],
        paidDeadline: json['paidDeadline'] == null ? null : json['paidDeadline'],
        billDate: json['billDate'] == null ? null : json['billDate'],
        beforeNotiDate: json['beforeNotiDate'] == null ? null : json['beforeNotiDate'],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "address": address,
        "houseId": houseId,
        "image": image,
        "paidDeadline": paidDeadline,
        "billDate": billDate,
        "beforeNotiDate": beforeNotiDate,
    };
}
