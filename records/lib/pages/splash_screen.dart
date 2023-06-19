import 'dart:async';
import 'package:flutter/material.dart';
import 'login_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  // ignore: library_private_types_in_public_api
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 6000), () {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginPage()),
          (route) => false);
    });
    Timer(const Duration(milliseconds: 10), () {
      setState(() {
        _isVisible = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: AnimatedOpacity(
          opacity: _isVisible ? 1.0 : 0,
          duration: const Duration(milliseconds: 6000),
          child: Container(
            alignment: Alignment.bottomCenter,
            margin: const EdgeInsets.only(bottom: 15),
            child: Image.asset(
              'assets/images/splash.png',
              height: 100,
              width: 200,
            ),
          ),
        ),
      ),
    );
  }
}
