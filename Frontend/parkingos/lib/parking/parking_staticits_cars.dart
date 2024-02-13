// ignore_for_file: unnecessary_string_interpolations

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:parkingos/parking/util/parking_statistic_item.dart';
import 'package:parkingos/util/parking_lot.dart';
import 'package:parkingos/util/vehicle.dart';
import 'package:http/http.dart' as http;

class ParkingStatisticsCarsPage extends StatefulWidget {
  final ParkingLot parking;
  const ParkingStatisticsCarsPage({super.key, required this.parking});

  @override
  ParkingStatisticsCarsPageState createState() =>
      ParkingStatisticsCarsPageState(parking: this.parking);
}

class ParkingStatisticsCarsPageState extends State<ParkingStatisticsCarsPage> {
  final ParkingLot parking;
  ParkingStatisticsCarsPageState({required this.parking});
  TextEditingController searchBar = TextEditingController();
  String _searchTerm = '';
  String info = '';

  List<ParkingStatisticsItem> parkingStatisticsItems = [];
List<ParkingStatisticsItem> temp = [];

  Future<void> fetchParkingStatistics() async {
    final apiUrl = "http://127.0.0.1:5000/parking_statistics_view/${parking.name}";
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        temp = (data['list'] as List)
            .map((json) => ParkingStatisticsItem.fromJson(json))
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

  void _updateSearchTerm() {
    setState(() {
      _searchTerm = searchBar.text;
    });
    // Tutaj można dodać logikę wyszukiwania, np. zaktualizować listę wyników.
  }

  List<ParkingStatisticsItem> selectItems(List<ParkingStatisticsItem> list) {
    List<ParkingStatisticsItem> new_list = [];
    if (_searchTerm == "") return list;

    for (int i = 0; i < list.length; i++) {
      if (list[i]
          .vehicle
          .registration
          .toUpperCase()
          .contains(_searchTerm.toUpperCase())) new_list.add(list[i]);
    }

    return new_list;
  }

  @override
  Widget build(BuildContext context) {
    parkingStatisticsItems = selectItems(temp);
    info = parkingStatisticsItems.isEmpty
        ? "Nie znaleziono pasującego pojazdu"
        : "";
    return Container(
      decoration: const BoxDecoration(
          color: Color(0xff156BAD),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
              bottomRight: Radius.circular(25))),
      child: Column(children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 5, left: 25, right: 25),
              child: Text(
                "numer rejestracyjny:",
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
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 3,
              child: Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25)),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: TextField(
                        controller: searchBar,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          suffixIcon: IconButton(
                            icon: _searchTerm != ""
                                ? const Icon(Icons.clear)
                                : const Icon(Icons.search),
                            onPressed: () {
                              searchBar.clear();
                              _updateSearchTerm();
                            },
                          ),
                        ),
                        onChanged: (value) {
                          _updateSearchTerm();
                        },
                      ),
                    ),
                  )),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 10, left: 25, right: 25),
          child: Row(
            children: [
              Expanded(child: Container(height: 5, color: Colors.white))
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 10.0, left: 5, right: 5),
            child: Row(children: [
              Expanded(
                child: Stack(
                  children: [
                    Center(
                      child: Text(
                        info,
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
                    ),
                    ListView.builder(
                      itemBuilder: (context, index) {
                        return buildparkingStatisticsItems(index);
                      },
                      itemCount: parkingStatisticsItems.length,
                      scrollDirection: Axis.vertical,
                    ),
                  ],
                ),
              ),
            ]),
          ),
        )
      ]),
    );
  }

  Widget buildparkingStatisticsItems(int index) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(25)),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${parkingStatisticsItems[index].floor} | ${parkingStatisticsItems[index].parkingSpot}",
                        style: TextStyle(
                            fontSize: MediaQuery.of(context).size.height / 40),
                      ),
                      Expanded(
                        child: Text(
                          "${parkingStatisticsItems[index].vehicle.model} | ${parkingStatisticsItems[index].vehicle.brand} | ${parkingStatisticsItems[index].vehicle.registration}",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.height / 40),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          "od: ${parkingStatisticsItems[index].dateStart.toString().substring(0, 16)} do: ${parkingStatisticsItems[index].dateEnd.toString().substring(0, 16)}",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.height / 40),
                        ),
                      ),
                      Text(
                        "${parkingStatisticsItems[index].curEarnings.toStringAsFixed(2)} zł",
                        textAlign: TextAlign.end,
                        style: TextStyle(
                            fontSize: MediaQuery.of(context).size.height / 40),
                      ),
                    ]),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
