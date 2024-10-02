import 'package:flutter/material.dart';
import 'package:traffic_prediction/screens/welcomepage.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: SplashPage(duration: 3, goToPage: WelcomePage()),
  ));
}

class LogoScreen extends StatelessWidget {
  const LogoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Logo Screen'),
      ),
    );
  }
}

class SplashPage extends StatelessWidget {
  final int duration;
  final Widget goToPage;

  const SplashPage({Key? key, required this.goToPage, required this.duration});

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: duration), () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => goToPage),
      );
    });
    return Scaffold(
      body: Container(
        color: const Color(0x89A2A6A2),
        alignment: Alignment.center,
        child: Image.asset('assets/logo.jpg'),
      ),
    );
  }
}




