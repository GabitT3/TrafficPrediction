import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'map.dart'; // Import the LocationPage

class GetTrafficPredictionPage extends StatefulWidget {
  final String originLat;
  final String originLon;
  final String destLat;
  final String destLon;
  final DateTime dateTime;
  final String trafficConsideration;

  const GetTrafficPredictionPage({
    Key? key,
    required this.originLat,
    required this.originLon,
    required this.destLat,
    required this.destLon,
    required this.dateTime,
    required this.trafficConsideration,
  }) : super(key: key);

  @override
  _GetTrafficPredictionPageState createState() =>
      _GetTrafficPredictionPageState();
}

class _GetTrafficPredictionPageState extends State<GetTrafficPredictionPage> {
  String predictionResult = '';
  String predictionCategory = '';
  bool isLoading = false;

  Future<void> makePrediction() async {
    String apiUrl = 'http:///127.0.0.1:8000/predict'; // Replace with your FastAPI server URL
    Map<String, dynamic> requestBody = {
      'origin_lat': double.parse(widget.originLat),
      'origin_lon': double.parse(widget.originLon),
      'dest_lat': double.parse(widget.destLat),
      'dest_lon': double.parse(widget.destLon),
      'datetime': widget.dateTime.toIso8601String(), // Convert to ISO 8601 string
      'traffic_condition': widget.trafficConsideration,
    };

    setState(() {
      isLoading = true;
      predictionResult = '';
      predictionCategory = '';
    });

    try {
      http.Response response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200) {
        // Parse JSON response
        var data = jsonDecode(response.body);

        if (data != null &&
            data.containsKey('prediction') &&
            data.containsKey('category')) {
          setState(() {
            predictionResult =
                data['prediction'][0].toStringAsFixed(2); // Assuming prediction is a list
            predictionCategory = data['category'];
          });
        } else {
          setState(() {
            predictionResult = 'Error: Unexpected response format';
          });
        }
      } else {
        setState(() {
          predictionResult =
          'Failed to get prediction: ${response.statusCode} ${response.reasonPhrase}';
        });
      }
    } catch (e) {
      setState(() {
        predictionResult = 'Error occurred: $e';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Traffic Prediction'),
        backgroundColor: Colors.blueAccent,
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(Icons.arrow_back),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.map),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  LocationPage ()),
              );
            },
          ),
        ],
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
              const Text(
                'Traffic Prediction for:',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              const SizedBox(height: 10.0),
              _buildInfoText('Origin', '${widget.originLat}, ${widget.originLon}'),
              _buildInfoText('Destination', '${widget.destLat}, ${widget.destLon}'),
              _buildInfoText('Date', '${widget.dateTime.day}/${widget.dateTime.month}/${widget.dateTime.year}'),
              _buildInfoText('Traffic Consideration', widget.trafficConsideration),
              const SizedBox(height: 20.0),
              Center(
                child: ElevatedButton(
                  onPressed: makePrediction,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 15.0),
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  child: const Text(
                    'Predict Traffic',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : predictionResult.isNotEmpty
                  ? _buildPredictionResult()
                  : const SizedBox.shrink(), // Hide container if no prediction yet
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoText(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label:',
          style: const TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            color: Colors.blueAccent,
          ),
        ),
        const SizedBox(height: 5.0),
        Text(
          value,
          style: const TextStyle(fontSize: 18.0, color: Colors.white),
        ),
        const SizedBox(height: 10.0),
      ],
    );
  }

  Widget _buildPredictionResult() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Prediction Result:',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: Colors.blueAccent,
          ),
        ),
        const SizedBox(height: 10.0),
        Text(
          'Prediction: $predictionResult',
          style: const TextStyle(fontSize: 18.0, color: Colors.white),
        ),
        const SizedBox(height: 10.0),
        Text(
          'Category: $predictionCategory',
          style: const TextStyle(fontSize: 18.0, color: Colors.white),
        ),
      ],
    );
  }
}
