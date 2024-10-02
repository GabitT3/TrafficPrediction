import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ReportIncidentPage extends StatefulWidget {
  const ReportIncidentPage({Key? key}) : super(key: key);

  @override
  _ReportIncidentPageState createState() => _ReportIncidentPageState();
}

class _ReportIncidentPageState extends State<ReportIncidentPage> {
  String selectedIncidentType = "Accident"; // Initial selection
  String location = "48.8249,2.2708";
  String description = "";
  bool isLoading = false;

  final List<Map<String, dynamic>> incidentTypes = [
    {"type": "Accident", "icon": Icons.car_crash},
    {"type": "Traffic", "icon": Icons.traffic},
    {"type": "Construction", "icon": Icons.construction},
    {"type": "Road Closure", "icon": Icons.block},
    {"type": "Other", "icon": Icons.report_problem},
  ];

  TextEditingController locationController = TextEditingController();

  Future<void> submit() async {
    setState(() {
      isLoading = true;
    });

    final Uri url = Uri.parse('http://127.0.0.1:8000/report-incident');
    final headers = {'Content-Type': 'application/json'};

    try {
      // Split location into latitude and longitude
      final locationSplit = location.split(',');
      if (locationSplit.length != 2) {
        throw FormatException('Invalid location format');
      }

      final latitude = double.parse(locationSplit[0].trim());
      final longitude = double.parse(locationSplit[1].trim());

      final jsonData = {
        "incident_type": selectedIncidentType,
        "location_lat": latitude,
        "location_lon": longitude,
        "description": description,
      };

      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(jsonData),
      );

      setState(() {
        isLoading = false;
      });

      if (response.statusCode == 200) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Incident Reported'),
              content: Text('Incident reported successfully! Thank you for your support.'),
              actions: <Widget>[
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                    Navigator.pop(context); // Close the report incident page
                  },
                ),
              ],
            );
          },
        );
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('Error submitting incident: ${response.statusCode}'),
              actions: <Widget>[
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Error submitting incident: $e'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report Incident'),
        backgroundColor: Colors.red, // Set app bar color (optional)
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search bar
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: TextField(
                controller: locationController,
                decoration: InputDecoration(
                  hintText: 'Search location',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    location = value;
                  });
                },
              ),
            ),
            const SizedBox(height: 20.0),
            const Text(
              'Select Incident Type',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10.0),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: incidentTypes.length,
              itemBuilder: (context, index) {
                final incident = incidentTypes[index];
                return ListTile(
                  leading: Icon(incident['icon']),
                  title: Text(incident['type']),
                  selected: selectedIncidentType == incident['type'],
                  selectedTileColor: Colors.grey[200],
                  onTap: () {
                    setState(() {
                      selectedIncidentType = incident['type'];
                    });
                  },
                );
              },
            ),
            const SizedBox(height: 16.0),
            // Description text field
            TextField(
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Describe the Incident (Optional)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0), // Rounded corners for text field
                ),
              ),
              onChanged: (value) => setState(() => description = value),
            ),
            const SizedBox(height: 16.0),
            // Submit button
            Center(
              child: ElevatedButton(
                onPressed: isLoading ? null : submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red, // Set button color
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0), // Rounded corners for button
                  ),
                ),
                child: isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : const Text(
                  'Submit Report',
                  style: TextStyle(fontSize: 18.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
