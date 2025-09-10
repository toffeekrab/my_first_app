import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_first_app/model/response/trip_get_res.dart';
import 'package:my_first_app/pages/profile.dart';
import 'package:my_first_app/pages/trip.dart';

class ShowTripPage extends StatefulWidget {
  // const ShowTripPage({super.key});
  int cid = 0;
  int idx = 0;
  ShowTripPage({super.key, required this.cid});

  @override
  State<ShowTripPage> createState() => _ShowTripPageState();
}

class _ShowTripPageState extends State<ShowTripPage> {
  final String uri = "http://172.18.1.32:3000";

  List<TripRes> allTrips = [];
  List<TripRes> filteredTrips = [];
  List<String> regions = ["ทั้งหมด"];
  String selectedRegion = "ทั้งหมด";

  @override
  void initState() {
    super.initState();
    loadDataAsync();
  }

  Future<void> loadDataAsync() async {
    final res = await http.get(Uri.parse("$uri/trips"));
    log("Body: ${res.body}");

    final trips = tripGetResponseFromJson(res.body);

    final zoneNames = trips
        .map((t) => destinationZoneValues.reverse[t.destinationZone] ?? "")
        .where((name) => name.isNotEmpty)
        .toSet()
        .toList();

    setState(() {
      allTrips = trips;
      filteredTrips = trips;
      regions = ["ทั้งหมด", ...zoneNames];
    });
  }

  void filterByRegion(String regionName) {
    setState(() {
      selectedRegion = regionName;
      if (regionName == "ทั้งหมด") {
        filteredTrips = allTrips;
      } else {
        filteredTrips = allTrips
            .where(
              (trip) =>
                  destinationZoneValues.reverse[trip.destinationZone] ==
                  regionName,
            )
            .toList();
      }
    });
  }

  void gotoTrip(int id) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TripPage(idx: id)),
    );
  }

  Widget _buildCategoryButton(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: FilledButton(
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        onPressed: () => filterByRegion(text),
        child: Text(text, style: const TextStyle(color: Colors.white)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('รายการทริป'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              log(value);
              if (value == 'profile') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfilePage(idx: widget.cid),
                  ),
                );
              } else if (value == 'logout') {
                Navigator.of(context).popUntil((route) => route.isFirst);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem<String>(
                value: 'profile',
                child: Text('ข้อมูลส่วนตัว'),
              ),
              const PopupMenuItem<String>(
                value: 'logout',
                child: Text('ออกจากระบบ'),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: regions
                  .map((region) => _buildCategoryButton(region))
                  .toList(),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: filteredTrips.isEmpty
                ? const Center(child: Text("ไม่พบทริป"))
                : ListView.builder(
                    itemCount: filteredTrips.length,
                    itemBuilder: (context, index) {
                      final trip = filteredTrips[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 3,
                          child: Row(
                            children: [
                              // รูปภาพ
                              ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(12),
                                  bottomLeft: Radius.circular(12),
                                ),
                                child: Image.network(
                                  trip.coverimage,
                                  width: 120,
                                  height: 120,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      width: 120,
                                      height: 120,
                                      color: Colors.grey,
                                      child: const Icon(
                                        Icons.image_not_supported,
                                        color: Colors.white,
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(width: 12),

                              // ข้อมูลทริป
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8,
                                    horizontal: 4,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        trip.name,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text("ประเทศ ${trip.country}"),
                                      Text("ระยะเวลา ${trip.duration} วัน"),
                                      Text(
                                        "ราคา ${trip.price} บาท",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: FilledButton(
                                          onPressed: () => gotoTrip(trip.idx),
                                          child: const Text(
                                            "รายละเอียดเพิ่มเติม",
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
