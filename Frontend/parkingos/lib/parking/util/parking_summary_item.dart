class ParkingSummaryItem {
  late String month = "";
  late String year = "";
  late double costs;
  late double earning;
  ParkingSummaryItem({
    required this.month,
    required this.year,
    required this.costs,
    required this.earning,
  });

  factory ParkingSummaryItem.fromJson(Map<String, dynamic> json) {
    return ParkingSummaryItem(
      month: json['month'].toString().toLowerCase(),
      year: json['year'].toString(),
      costs: double.parse(json['total_costs']),
      earning: double.parse(json['total_revenue']),
    );
  }

}
