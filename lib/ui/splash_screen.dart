import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import package baru
import 'package:lottie/lottie.dart';
import 'produk_page.dart';
import 'login_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthAndNavigate();
  }

  void _checkAuthAndNavigate() async {
    const minimumSplashDuration = Duration(seconds: 3);
    final startTime = DateTime.now();

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    final endTime = DateTime.now();
    final durationPassed = endTime.difference(startTime);
    if (durationPassed < minimumSplashDuration) {
      await Future.delayed(minimumSplashDuration - durationPassed);
    }

    if (mounted) {
      if (token != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ProdukPage()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFD4A3),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/lottie/book.json',
              width: 350,
              height: 350,
            ),
            const SizedBox(height: 20),
            const Text(
              'Loading...',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}