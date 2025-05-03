import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:london_crime/service/crime_service.dart';

class CrimeMapPage extends StatefulWidget {
  const CrimeMapPage({super.key});

  @override
  State<CrimeMapPage> createState() => _CrimeMapPageState();
}

class _CrimeMapPageState extends State<CrimeMapPage> {
  GoogleMapController? _controller;
  Set<Marker> _markers = {};
  bool _loading = true;
  Set<String> selectedCategories = {};
  Set<String> availableCategories = {};

  @override
  void initState() {
    super.initState();
    _loadCrimeData();
  }

  Future<void> _loadCrimeData() async {
    try {
      final crimes = await CrimeService.fetchCrimes(
        lat: 51.5074,
        lng: -0.1278,
        date: '2024-03',
      );

      final Set<Marker> newMarkers = {};
      final Set<String> categorySet = {};

      for (var crime in crimes) {
        if (crime.locationLat == null || crime.locationLng == null) continue;

        categorySet.add(crime.category);

        if (selectedCategories.isEmpty || selectedCategories.contains(crime.category)) {
          newMarkers.add(
            Marker(
              markerId: MarkerId(crime.hashCode.toString()),
              position: LatLng(crime.locationLat!, crime.locationLng!),
              infoWindow: InfoWindow(
                title: crime.category,
                snippet: crime.location,
              ),
              icon: BitmapDescriptor.defaultMarkerWithHue(_getHueForCategory(crime.category)),
            ),
          );
        }
      }

      setState(() {
        _markers = newMarkers;
        availableCategories = categorySet;
        _loading = false;
      });
    } catch (e, stackTrace) {
      print('Error loading crime data: $e');
      print(stackTrace);
    }
  }


  double _getHueForCategory(String category) {
    final hues = {
      'burglary': BitmapDescriptor.hueRed,
      'vehicle-crime': BitmapDescriptor.hueAzure,
      'drugs': BitmapDescriptor.hueGreen,
      'robbery': BitmapDescriptor.hueOrange,
      'violent-crime': BitmapDescriptor.hueViolet,
      'other-theft': BitmapDescriptor.hueCyan,
    };
    return hues[category] ?? BitmapDescriptor.hueRose;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crime Map - London')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Filter Chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    children: availableCategories.map((category) {
                      final isSelected = selectedCategories.contains(category);
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: FilterChip(
                          label: Text(category),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              if (selected) {
                                selectedCategories.add(category);
                              } else {
                                selectedCategories.remove(category);
                              }
                              _loadCrimeData(); // Reload with filter applied
                            });
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),

                // Expanded Google Map
                Expanded(
                  child: GoogleMap(
                    onMapCreated: (controller) => _controller = controller,
                    initialCameraPosition: const CameraPosition(
                      target: LatLng(51.5074, -0.1278),
                      zoom: 12,
                    ),
                    markers: _markers,
                  ),
                ),
              ],
            ),
    );
  }
}
