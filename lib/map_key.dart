//
//
// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
// // import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
// import 'package:latlong2/latlong.dart';
//
// class MapScreen extends StatefulWidget {
//   const MapScreen({super.key});
//
//   @override
//   State<MapScreen> createState() => _MapScreenState();
// }
//
// class _MapScreenState extends State<MapScreen> {
//   final MapController controller = MapController();
//
// // Change as per your need
//   LatLng latLng = LatLng(4.04827, 9.70428);
//
//   @override
//   Widget build(BuildContext context) {
//     return FlutterMap(
//       mapController: controller,
//       options: MapOptions(
//         initialCenter: latLng,
//         initialZoom: 18,
//       ),
//       children: [
//         TileLayer(
//           urlTemplate: 'https://api.mapbox.com/styles/v1/mapbox/streets-v11/tiles/{z}/{x}/{y}?access_token=sk.eyJ1IjoiZ2FiaTAwIiwiYSI6ImNsdzR5amxtYzE1b2MyanFzemZ1Y29rMnEifQ.86bzms-RXiGg-upfhZcSgQ',
//         ),
//
//         MarkerLayer(
//           markers: [
//             Marker(
//               point: latLng,
//               width: 60,
//               height: 60,
//               alignment: Alignment.topCenter,
//               child: Icon(
//                 Icons.location_pin,
//                 color: Colors.red.shade700,
//                 size: 60,
//               ), builder: (BuildContext context) {  },
//             ),
//           ],
//         ),
//
//       ],
//     );
//   }
// }
// String map_key="AIzaSyBoya5-l0ER2Ks6fiKQro9FFgowD_tLTcQ";
// AIzaSyBoya5-l0ER2Ks6fiKQro9FFgowD_tLTcQ
// 'https://discover.search.hereapi.com/v1/discover?at=$lat,$lng&limit=10&q=restaurant&apiKey=_XvEO_n6hIVWiVQxbCdA80WfArf9siGOcz6kXNrkyj0'));