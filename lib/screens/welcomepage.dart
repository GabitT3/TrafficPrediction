import 'package:flutter/material.dart';
import 'package:traffic_prediction/screens/reportincidentpage.dart';
import 'package:traffic_prediction/screens/routeselectionpage.dart';
import 'package:video_player/video_player.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  late VideoPlayerController _controller;
  bool _isVideoPlaying = false;
// Variable to store selected vehicle type

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/welcome.mp4')
      ..initialize().then((_) {
        setState(() {
          _isVideoPlaying = true;
          _controller.play();
          _controller.setLooping(true);
          _controller.setVolume(0.0); // Mute the video
        });
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _saveSelectedVehicle(String vehicleType) {
    setState(() {
// Save selected vehicle type
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          if (_isVideoPlaying)
            Positioned.fill(
              child: AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              ),
            ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Are You Driving a BIKE, CAR or TRUCK?",
                    style: TextStyle(
                      fontSize: 28.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  const Text(
                    "Choose Your Vehicle",
                    style: TextStyle(fontSize: 20.0, color: Colors.white70),
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      buildVehicleButton(context, 'assets/bike.png', 'Bike', 'bike'),
                      const SizedBox(width: 16.0),
                      buildVehicleButton(context, 'assets/car.png', 'Car', 'car'),
                      const SizedBox(width: 16.0),
                      buildVehicleButton(context, 'assets/truck.png', 'Truck', 'truck'),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RouteSelectionPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: const Color(0xFF2962FF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    child: const Text(
                      'Next',
                      style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ReportIncidentPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    child: const Text(
                      'Report Incident',
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildVehicleButton(BuildContext context, String imagePath, String text, String vehicleType) {
    return ElevatedButton(
      onPressed: () {
        // Handle button press for specific vehicle
        _saveSelectedVehicle(vehicleType); // Save the selected vehicle type
        // Example: Navigate to different pages based on vehicle type
      },
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            imagePath,
            width: 50.0,
            height: 50.0,
          ),
          const SizedBox(height: 5.0),
          Text(
            text,
            style: const TextStyle(fontSize: 14.0),
          ),
        ],
      ),
    );
  }
}
