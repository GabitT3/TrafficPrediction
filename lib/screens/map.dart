import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'app_constants.dart';

class LocationPage extends StatefulWidget {
  const LocationPage({Key? key}) : super(key: key);

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  final TextEditingController _searchController = TextEditingController();
  final MapController _mapController = MapController();
  LatLng _currentLocation = LatLng(0, 0);
  LatLng _destinationLocation = LatLng(0, 0);
  List<Map<String, dynamic>> _nearbyPlaces = [];
  List<Polyline> _trafficPolylines = [];
  double _distanceInMeters = 0;
  double _estimatedTravelTimeInMinutes = 0;

  @override
  void initState() {
    super.initState();
    _getUserLocation(); // Fetch user's location on initialization
  }

  Future<void> _getUserLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
        _mapController.move(_currentLocation, 15.0);
      });
      await fetchNearbyPlaces(position.latitude, position.longitude);
      await fetchTrafficData(position.latitude, position.longitude);
    } catch (e) {
      print('Error getting user location: $e');
      // Handle errors fetching location
    }
  }

  Future<void> fetchNearbyPlaces(double lat, double lng) async {
    final response = await http.get(Uri.parse(
        'https://discover.search.hereapi.com/v1/discover?at=$lat,$lng&limit=10&q=petrol%20station&apiKey=_XvEO_n6hIVWiVQxbCdA80WfArf9siGOcz6kXNrkyj0'));
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      setState(() {
        _nearbyPlaces = List<Map<String, dynamic>>.from(jsonData['items']);
      });
    } else {
      print('Error: ${response.statusCode}');
    }
  }

  Future<void> fetchTrafficData(double lat, double lng) async {
    final response = await http.get(Uri.parse(
        'https://traffic.ls.hereapi.com/traffic/6.2/flow.json?prox=$lat,$lng,5000&apiKey=_XvEO_n6hIVWiVQxbCdA80WfArf9siGOcz6kXNrkyj0'));
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      print('Traffic Data: $jsonData'); // Debugging: Print raw traffic data

      List<Polyline> polylines = [];
      for (var flowItem in jsonData['RWS'][0]['RW']) {
        for (var fis in flowItem['FIS']) {
          for (var fi in fis['FI']) {
            var coordinates = fi['SHP'][0]['value'].map<LatLng>((point) {
              var latLng = point.split(',');
              return LatLng(
                double.parse(latLng[0]),
                double.parse(latLng[1]),
              );
            }).toList();

            polylines.add(
              Polyline(
                points: coordinates,
                strokeWidth: 4.0,
                color: Colors.red,
              ),
            );
          }
        }
      }
      setState(() {
        _trafficPolylines = polylines;
        print('Polylines: $_trafficPolylines'); // Debugging: Print polylines data
      });
    } else {
      print('Error: ${response.statusCode}');
    }
  }

  Future<void> geocode(String query) async {
    final response = await http.get(Uri.parse(
        'https://geocode.search.hereapi.com/v1/geocode?q=$query&apiKey=_XvEO_n6hIVWiVQxbCdA80WfArf9siGOcz6kXNrkyj0'));
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      if (jsonData['items'].isNotEmpty) {
        final location = jsonData['items'][0]['position'];
        final lat = location['lat'];
        final lng = location['lng'];
        setState(() {
          _destinationLocation = LatLng(lat, lng);
          _mapController.move(_destinationLocation, 15.0);
        });
        await fetchNearbyPlaces(lat, lng);
        await fetchTrafficData(lat, lng);

        // Calculate distance and estimated travel time
        _calculateDistanceAndTravelTime();
      } else {
        print('No results found');
      }
    } else {
      print('Error: ${response.statusCode}');
    }
  }

  void _calculateDistanceAndTravelTime() async {
    double distanceInMeters = await Geolocator.distanceBetween(
      _currentLocation.latitude,
      _currentLocation.longitude,
      _destinationLocation.latitude,
      _destinationLocation.longitude,
    );

    double estimatedTravelTimeInMinutes = distanceInMeters / 80.0; // Assuming average speed of 80 km/h

    setState(() {
      _distanceInMeters = distanceInMeters;
      _estimatedTravelTimeInMinutes = estimatedTravelTimeInMinutes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Map'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search or enter an address',
                prefixIcon: Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () => _searchController.clear(),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onSubmitted: (value) async {
                setState(() {
                  _nearbyPlaces = [];
                });
                await geocode(value.trim());
              },
            ),
          ),
          Expanded(
            flex: 2, // Map takes two-thirds of the available space
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                center: _currentLocation,
                zoom: 15.0,
                interactiveFlags: InteractiveFlag.all, // Enable zoom and pan
              ),
              children: [
                TileLayer(
                  urlTemplate:
                  'https://api.mapbox.com/styles/v1/${AppConstants.mapBoxStyleId}/tiles/{z}/{x}/{y}?access_token=${AppConstants.mapBoxAccessToken}',
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      width: 40,
                      height: 40,
                      point: _currentLocation,
                      builder: (ctx) => Icon(
                        Icons.control_point,
                        color: Colors.red,
                        size: 40,
                      ),
                    ),
                    Marker(
                      width: 40,
                      height: 40,
                      point: _destinationLocation,
                      builder: (ctx) => Icon(
                        Icons.place,
                        color: Colors.blue,
                        size: 40,
                      ),
                    ),
                  ],
                ),
                PolylineLayer(
                  polylines: _trafficPolylines,
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1, // List takes one-third of the available space
            child: ListView.builder(
              itemCount: _nearbyPlaces.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_nearbyPlaces[index]['title']),
                  subtitle: Text(_nearbyPlaces[index]['address']['label']),
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.all(16.0),
            color: Colors.grey[200],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Distance: ${(_distanceInMeters / 1000).toStringAsFixed(1)} km',
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Estimated Travel Time: ${_estimatedTravelTimeInMinutes.ceil()} minutes',
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
