import 'package:flutter/material.dart';
import 'gettarfficpredictionpage.dart';

void main() {
  runApp(const MaterialApp(
    home: RouteSelectionPage(),
  ));
}

class RouteSelectionPage extends StatefulWidget {
  const RouteSelectionPage({Key? key}) : super(key: key);

  @override
  _RouteSelectionPageState createState() => _RouteSelectionPageState();
}

class _RouteSelectionPageState extends State<RouteSelectionPage> {
  String originLat = '48.8566';
  String originLon = '2.3522';
  String destLat = '48.8249';
  String destLon = '2.2708';
  String trafficConsideration = "Fastest Route"; // Initial value
  DateTime selectedDateTime = DateTime.now();

  void navigateToTrafficPrediction() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GetTrafficPredictionPage(
          originLat: originLat,
          originLon: originLon,
          destLat: destLat,
          destLon: destLon,
          dateTime: selectedDateTime.toUtc(), // Convert to UTC
          trafficConsideration: trafficConsideration,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Route Selection'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.png'), // Replace with your image path
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.dstATop),
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.0),
              _buildLabel('Origin Latitude'),
              _buildTextField(
                hintText: 'Enter origin latitude',
                initialValue: originLat,
                onChanged: (value) {
                  setState(() {
                    originLat = value;
                  });
                },
              ),
              SizedBox(height: 16.0),
              _buildLabel('Origin Longitude'),
              _buildTextField(
                hintText: 'Enter origin longitude',
                initialValue: originLon,
                onChanged: (value) {
                  setState(() {
                    originLon = value;
                  });
                },
              ),
              SizedBox(height: 16.0),
              _buildLabel('Destination Latitude'),
              _buildTextField(
                hintText: 'Enter destination latitude',
                initialValue: destLat,
                onChanged: (value) {
                  setState(() {
                    destLat = value;
                  });
                },
              ),
              SizedBox(height: 16.0),
              _buildLabel('Destination Longitude'),
              _buildTextField(
                hintText: 'Enter destination longitude',
                initialValue: destLon,
                onChanged: (value) {
                  setState(() {
                    destLon = value;
                  });
                },
              ),
              SizedBox(height: 16.0),
              _buildLabel('Date Selection'),
              ElevatedButton.icon(
                onPressed: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: selectedDateTime,
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null && picked != selectedDateTime) {
                    setState(() {
                      selectedDateTime = picked;
                    });
                  }
                },
                icon: Icon(Icons.calendar_today),
                label: Text(
                  'Select Date',
                  style: TextStyle(fontSize: 16.0),
                ),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              _buildLabel('Traffic Consideration'),
              Container(
                width: MediaQuery.of(context).size.width / 2,
                child: DropdownButtonFormField<String>(
                  value: trafficConsideration,
                  onChanged: (String? value) {
                    setState(() {
                      trafficConsideration = value!;
                    });
                  },
                  items: <String>[
                    "Fastest Route",
                    "Least Congested Route",
                    "Balanced",
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              Center(
                child: ElevatedButton(
                  onPressed: navigateToTrafficPrediction,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  child: Text(
                    'Get Traffic Prediction',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.0),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 16.0,
        color: Colors.blueAccent,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildTextField({
    required String hintText,
    required String initialValue,
    required ValueChanged<String> onChanged,
  }) {
    return Container(
      width: MediaQuery.of(context).size.width / 2,
      child: TextFormField(
        initialValue: initialValue,
        onChanged: onChanged,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          hintText: hintText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        ),
      ),
    );
  }
}
