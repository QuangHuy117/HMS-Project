class Payment {
  int id;
  DateTime date;
  int billId;
  int amount;
  String note;
  bool status;

  Payment({
    this.id,
    this.date,
    this.billId,
    this.amount,
    this.note,
    this.status,
  });

  factory Payment.fromJson(Map<String, dynamic> json) => Payment(
        id: json["id"],
        date: DateTime.parse(json["date"]),
        billId: json["billId"],
        amount: json["amount"],
        note: json["note"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "date": date.toIso8601String(),
        "billId": billId,
        "amount": amount,
        "note": note,
        "status": status,
      };
}
