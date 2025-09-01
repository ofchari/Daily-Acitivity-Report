import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';

class RouteMapPage extends StatefulWidget {
  const RouteMapPage({super.key});

  @override
  _RouteMapPageState createState() => _RouteMapPageState();
}

class _RouteMapPageState extends State<RouteMapPage> {
  List<LatLng> routePoints = [];

  @override
  void initState() {
    super.initState();
    _addDummyLocations();
    _loadTodayRoute();
  }

        /// Live Location for Store the Hive Data from Today Date ///
  Future<void> _loadTodayRoute() async {
    final box = await Hive.openBox<List<String>>('location_history');
    final today = DateFormat(
      'dd-MM-yyyy',
    ).format(DateTime.now()); // CHANGE THIS LINE
    List<String> locations = box.get(today, defaultValue: [])!;

    setState(() {
      routePoints = locations.map((loc) {
        final parts = loc.split(',');
        return LatLng(double.parse(parts[0]), double.parse(parts[1]));
      }).toList();
    });
  }

      /// Dummy function to add some locations for today //
  Future<void> _addDummyLocations() async {
    final box = await Hive.openBox<List<String>>('location_history');
    final today = DateFormat('dd-MM-yyyy').format(DateTime.now());

    // Dummy coordinates (you can change these to your preferred locations)
    List<String> dummyLocations = [
      '11.0168,76.9558', // Coimbatore Railway Station
      '11.0183,76.9725', // Brookefields Mall
      '11.0072,76.9647', // Gandhipuram
      '10.9931,76.9610', // RS Puram
    ];

    await box.put(today, dummyLocations);

    // Reload the route
    _loadTodayRoute();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text('Today\'s Route',style: GoogleFonts.dmSans(textStyle: TextStyle(fontSize: 16.sp,fontWeight: FontWeight.w500,color: Colors.white)),),
        backgroundColor: const Color(0xFF2563EB),
        foregroundColor: Colors.white,
      ),

      body: routePoints.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.location_off, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No route data for today',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  Text(
                    'Visit locations to see your route',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            )
          : FlutterMap(
              options: MapOptions(
                initialCenter: routePoints.first,
                initialZoom: 13.0,
                minZoom: 5.0,
                maxZoom: 18.0,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.your_app_name',
                ),
                if (routePoints.length > 1)
                  PolylineLayer(
                    polylines: [
                      Polyline(
                        points: routePoints,
                        strokeWidth: 4.0,
                        color: Colors.blue,
                      ),
                    ],
                  ),
                MarkerLayer(
                  markers: routePoints.asMap().entries.map((entry) {
                    return Marker(
                      point: entry.value,
                      width: 40,
                      height: 40,
                      child: Container(
                        decoration: BoxDecoration(
                          color: entry.key == 0
                              ? Colors.green
                              : entry.key == routePoints.length - 1
                              ? Colors.red
                              : Colors.blue,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: Icon(
                          entry.key == 0
                              ? Icons.play_arrow
                              : entry.key == routePoints.length - 1
                              ? Icons.stop
                              : Icons.circle,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),

      // floatingActionButton: routePoints.isNotEmpty
      //     ? FloatingActionButton(
      //         onPressed: () {
      //           // Center map on all points
      //           setState(() {});
      //         },
      //         backgroundColor: const Color(0xFF2563EB),
      //         child: const Icon(Icons.my_location, color: Colors.white),
      //       )
      //     : null,
    );
  }
}
