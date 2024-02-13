// ignore_for_file: unnecessary_string_interpolations

import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:parkingos/parking/util/parking_summary_item.dart';
import 'package:parkingos/util/parking_cost.dart';
import 'package:parkingos/util/parking_lot.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:http/http.dart' as http;

class ParkingSummaryPage extends StatefulWidget {
  final ParkingLot parking;
  const ParkingSummaryPage({super.key, required this.parking});

  @override
  ParkingSummaryPageState createState() =>
      ParkingSummaryPageState(parking: this.parking);
}

class ParkingSummaryPageState extends State<ParkingSummaryPage> {
  final ParkingLot parking;
  ParkingSummaryPageState({required this.parking});

  List<ParkingSummaryItem> temp = [];

  Future<void> fetchParkingStatistics() async {
    final apiUrl = "http://127.0.0.1:5000/parking_summary/${parking.id}";
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        temp = (data['summaries'] as List)
            .map((json) => ParkingSummaryItem.fromJson(json))
            .toList();
      });
    } else {
      throw Exception('Failed to load parking costs');
    }
  }


  @override
  void initState() {
    super.initState();
    fetchParkingStatistics();
  }


  // List<ParkingSummaryItem> temp = [
  //   ParkingSummaryItem(month: "maj", year: "2023", costs: 1050, earning: 19500),
  //   ParkingSummaryItem(
  //       month: "czerwiec", year: "2023", costs: 1060, earning: 14000),
  //   ParkingSummaryItem(
  //       month: "lipiec", year: "2023", costs: 1070, earning: 19300),
  //   ParkingSummaryItem(
  //       month: "sierpień", year: "2023", costs: 1080, earning: 19200),
  //   ParkingSummaryItem(
  //       month: "wrzesień", year: "2023", costs: 1090, earning: 19100),
  //   ParkingSummaryItem(
  //       month: "październik", year: "2023", costs: 1100, earning: 19000),
  //   ParkingSummaryItem(
  //       month: "listopad", year: "2023", costs: 1110, earning: 18900),
  //   ParkingSummaryItem(
  //       month: "grudzień", year: "2023", costs: 1120, earning: 18800),
  //   ParkingSummaryItem(
  //       month: "styczeń", year: "2024", costs: 1010, earning: 19900),
  //   ParkingSummaryItem(
  //       month: "luty", year: "2024", costs: 1020, earning: 19800),
  // ];

  List<BarChartGroupData> getBarGroups(List<ParkingSummaryItem> data) {
    return List.generate(data.length, (index) {
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
              y: data[index].earning - data[index].costs, // Przykładowe dane
              colors: [Colors.lightBlueAccent, Colors.greenAccent],
              borderRadius: BorderRadius.circular(25),
              width: (MediaQuery.of(context).size.width / 6) / data.length),
        ],
      );
    });
  }

  String startDate = "";
  String endDate = "";
  @override
  Widget build(BuildContext context) {
    List<String> dates = [];
    for (int i = 0; i < temp.length; i++) {
      dates.add("${temp[i].month} ${temp[i].year}");
    }
    startDate = startDate == "" ? dates.first : startDate;

    List<String> dates2 = [];
    bool canWrite = false;
    String tempName = "";
    bool overRide = true;
    for (int i = 0; i < dates.length; i++) {
      if (dates[i] == startDate) {
        canWrite = true;
        tempName = startDate;
      }
      if (canWrite) {
        if (dates[i] == endDate) overRide = false;
        dates2.add(dates[i]);
      }
    }
    if (overRide) endDate = tempName;
    endDate = endDate == "" ? dates2.first : endDate;

    double costs = 0;
    double earning = 0;
    List<ParkingSummaryItem> dataToShow = [];
    canWrite = false;
    for (int i = 0; i < temp.length; i++) {
      if ("${temp[i].month} ${temp[i].year}" == startDate) canWrite = true;
      if (canWrite) {
        costs += temp[i].costs;
        earning += temp[i].earning;
        dataToShow.add(temp[i]);
      }
      if ("${temp[i].month} ${temp[i].year}" == endDate) break;
    }

    return SafeArea(
      child: Expanded(
        child: SizedBox(
            child: Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: BarChart(
                      BarChartData(
                        backgroundColor: Colors.white,
                        // alignment: BarChartAlignment.spaceAround,
                        maxY: dataToShow
                                .reduce((ParkingSummaryItem a,
                                        ParkingSummaryItem b) =>
                                    a.earning > b.earning ? a : b)
                                .earning *
                            1.05,
                        minY: dataToShow
                                .reduce((ParkingSummaryItem a,
                                        ParkingSummaryItem b) =>
                                    a.earning < b.earning ? a : b)
                                .costs *
                            0.95,

                        barTouchData: BarTouchData(
                          enabled: true,
                        ),
                        titlesData: FlTitlesData(
                          show: true,
                          rightTitles: SideTitles(showTitles: false),
                          topTitles: SideTitles(showTitles: false),
                          bottomTitles: SideTitles(
                            showTitles: true,
                            getTextStyles: (context, value) => const TextStyle(
                                color: Colors.white, fontSize: 14),
                            margin: 16,
                            getTitles: (double value) {
                              return "${dataToShow[value.toInt()].month}\n${dataToShow[value.toInt()].year}";
                            },
                          ),
                          leftTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 50,
                            getTextStyles: (context, value) => const TextStyle(
                                color: Colors.white, fontSize: 14),
                            margin: 10,
                          ),
                        ),
                        gridData: FlGridData(
                          show: true,
                          checkToShowHorizontalLine: (value) => value % 5 == 0,
                          getDrawingHorizontalLine: (value) => FlLine(
                            color: Colors.black12,
                            strokeWidth: 1,
                          ),
                        ),
                        borderData: FlBorderData(
                          show: true,
                        ),
                        barGroups: getBarGroups(dataToShow),
                      ),
                    ),
                  )),
                ],
              ),
            ),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width / 4,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Od:",
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.height <
                                    MediaQuery.of(context).size.width
                                ? MediaQuery.of(context).size.height / 20
                                : MediaQuery.of(context).size.width / 20,
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontFamily: 'Jaldi',
                            decorationThickness: 3.0,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(25)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 25),
                            child: DropdownButton<String>(
                              value: startDate,
                              borderRadius: BorderRadius.circular(25),
                              underline: Container(),
                              isExpanded: true,
                              menuMaxHeight:
                                  (MediaQuery.of(context).size.height ~/ 3)
                                      .toDouble(),
                              style: TextStyle(
                                fontSize: MediaQuery.of(context).size.height <
                                        MediaQuery.of(context).size.width
                                    ? MediaQuery.of(context).size.height / 40
                                    : MediaQuery.of(context).size.width / 40,
                                color: Colors.black,
                                fontWeight: FontWeight.w100,
                                fontFamily: 'Jaldi',
                                decorationThickness: 3.0,
                              ),
                              onChanged: (String? newValue) {
                                setState(() {
                                  startDate = newValue!;
                                });
                              },
                              items: dates.map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                        Text(
                          "Do:",
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.height <
                                    MediaQuery.of(context).size.width
                                ? MediaQuery.of(context).size.height / 20
                                : MediaQuery.of(context).size.width / 20,
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontFamily: 'Jaldi',
                            decorationThickness: 3.0,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(25)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 25),
                            child: DropdownButton<String>(
                              value: endDate,
                              borderRadius: BorderRadius.circular(25),
                              underline: Container(),
                              isExpanded: true,
                              menuMaxHeight:
                                  (MediaQuery.of(context).size.height ~/ 3)
                                      .toDouble(),
                              style: TextStyle(
                                fontSize: MediaQuery.of(context).size.height <
                                        MediaQuery.of(context).size.width
                                    ? MediaQuery.of(context).size.height / 40
                                    : MediaQuery.of(context).size.width / 40,
                                color: Colors.black,
                                fontWeight: FontWeight.w100,
                                fontFamily: 'Jaldi',
                                decorationThickness: 3.0,
                              ),
                              onChanged: (String? newValue) {
                                setState(() {
                                  endDate = newValue!;
                                });
                              },
                              items: dates2.map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(25),
                          child: Container(),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(25)),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Podsumowanie:",
                                          textAlign: TextAlign.end,
                                          style: TextStyle(
                                            fontSize: MediaQuery.of(context)
                                                        .size
                                                        .height <
                                                    MediaQuery.of(context)
                                                        .size
                                                        .width
                                                ? MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    30
                                                : MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    30,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w900,
                                            fontFamily: 'Jaldi',
                                            decorationThickness: 3.0,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5),
                                          child: Container(
                                            color: Colors.black,
                                            height: 3,
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "zysk:",
                                              textAlign: TextAlign.end,
                                              style: TextStyle(
                                                fontSize: MediaQuery.of(context)
                                                            .size
                                                            .height <
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width
                                                    ? MediaQuery.of(context)
                                                            .size
                                                            .height /
                                                        30
                                                    : MediaQuery.of(context)
                                                            .size
                                                            .width /
                                                        30,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w900,
                                                fontFamily: 'Jaldi',
                                                decorationThickness: 3.0,
                                              ),
                                            ),
                                            Text(
                                              "${earning} zł",
                                              textAlign: TextAlign.end,
                                              style: TextStyle(
                                                fontSize: MediaQuery.of(context)
                                                            .size
                                                            .height <
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width
                                                    ? MediaQuery.of(context)
                                                            .size
                                                            .height /
                                                        30
                                                    : MediaQuery.of(context)
                                                            .size
                                                            .width /
                                                        30,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w900,
                                                fontFamily: 'Jaldi',
                                                decorationThickness: 3.0,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "koszty:",
                                              textAlign: TextAlign.end,
                                              style: TextStyle(
                                                fontSize: MediaQuery.of(context)
                                                            .size
                                                            .height <
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width
                                                    ? MediaQuery.of(context)
                                                            .size
                                                            .height /
                                                        30
                                                    : MediaQuery.of(context)
                                                            .size
                                                            .width /
                                                        30,
                                                color: Colors.red,
                                                fontWeight: FontWeight.w900,
                                                fontFamily: 'Jaldi',
                                                decorationThickness: 3.0,
                                              ),
                                            ),
                                            Text(
                                              "-${costs} zł",
                                              textAlign: TextAlign.end,
                                              style: TextStyle(
                                                fontSize: MediaQuery.of(context)
                                                            .size
                                                            .height <
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width
                                                    ? MediaQuery.of(context)
                                                            .size
                                                            .height /
                                                        30
                                                    : MediaQuery.of(context)
                                                            .size
                                                            .width /
                                                        30,
                                                color: Colors.red,
                                                fontWeight: FontWeight.w900,
                                                fontFamily: 'Jaldi',
                                                decorationThickness: 3.0,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5),
                                          child: Container(
                                            color: Colors.black,
                                            height: 3,
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "bilans:",
                                              textAlign: TextAlign.end,
                                              style: TextStyle(
                                                fontSize: MediaQuery.of(context)
                                                            .size
                                                            .height <
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width
                                                    ? MediaQuery.of(context)
                                                            .size
                                                            .height /
                                                        25
                                                    : MediaQuery.of(context)
                                                            .size
                                                            .width /
                                                        25,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w900,
                                                fontFamily: 'Jaldi',
                                                decorationThickness: 3.0,
                                              ),
                                            ),
                                            Text(
                                              "${earning - costs} zł",
                                              textAlign: TextAlign.end,
                                              style: TextStyle(
                                                fontSize: MediaQuery.of(context)
                                                            .size
                                                            .height <
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width
                                                    ? MediaQuery.of(context)
                                                            .size
                                                            .height /
                                                        25
                                                    : MediaQuery.of(context)
                                                            .size
                                                            .width /
                                                        25,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w900,
                                                fontFamily: 'Jaldi',
                                                decorationThickness: 3.0,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ]),
                                ),
                              ),
                            ),
                          ],
                        )
                      ]),
                ))
          ],
        )),
      ),
    );
  }
}
