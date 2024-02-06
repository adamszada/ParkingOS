class ParkingCost {
  String tittle;
  double amount;
  String type;

  ParkingCost({required this.tittle, required this.amount, required this.type});

  factory ParkingCost.fromJson(Map<String, dynamic> json) {
    return ParkingCost(
      tittle: json['title'],
      amount: json['amount'],
      type: json['type'],
    );
  }
}