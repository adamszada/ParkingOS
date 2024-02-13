class ParkingUser {
  late String id;
  String login;
  double balance;
  bool isBlocked = false;
  ParkingUser(
      {this.id = "0",
      required this.login,
      required this.balance,
      this.isBlocked = false});
  factory ParkingUser.fromJson(Map<String, dynamic> json) {
    return ParkingUser(
      id: json['uid'],
      login: json['email'],
      balance: json['saldo'],
      isBlocked: json['has_ban'],
    );
  }
}
