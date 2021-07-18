class ClockValue {
  int id;
  DateTime createDate;
  int clockId;
  int indexValue;
  DateTime recordDate;
  bool status;

  ClockValue(
      {this.id,
      this.createDate,
      this.clockId,
      this.indexValue,
      this.recordDate,
      this.status});

  factory ClockValue.fromJson(Map<String, dynamic> json) => ClockValue(
        id: json['id'],
        createDate: DateTime.parse(json['createDate']),
        clockId: json['clockId'],
        indexValue: json['indexValue'],
        recordDate: json['recordDate'] == null ? null : DateTime.parse(json['recordDate']),
        status: json['status'],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "createDate": createDate.toIso8601String(),
        "clockId": clockId,
        "indexValue": indexValue,
        "recordDate": recordDate.toIso8601String(),
        "status": status,
      };
}
