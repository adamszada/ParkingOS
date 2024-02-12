class ParkingUser {
  String login;
  double balance;
  bool isBlocked = false;
  ParkingUser(
      {required this.login, required this.balance, this.isBlocked = false});
}
