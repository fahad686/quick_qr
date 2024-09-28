import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_qr/view/home/home_screen.dart';
import 'package:quick_qr/view/auth/login_screen.dart';
import '../../common/provider/provider.dart'; // This should import your authProvider

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller1;
  late AnimationController _controller2;
  late Animation<double> _animation1;
  late Animation<double> _animation2;

  @override
  void initState() {
    super.initState();


    _controller1 = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _animation1 = Tween<double>(begin: 0.0, end: 1.0).animate(_controller1)
      ..addListener(() {
        setState(() {});
      });


    _controller2 = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _animation2 = Tween<double>(begin: 0.0, end: 1.0).animate(_controller2)
      ..addListener(() {
        setState(() {});
      });


    _controller1.forward();


    Future.delayed(const Duration(seconds: 2), () {
      _controller2.forward();
    });

  
    Future.delayed(const Duration(seconds: 5), () {
      _checkAuthState();
    });
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    super.dispose();
  }

  // Check if the user is logged in or not
  void _checkAuthState() {
    final authState = ref.read(authProvider.notifier);
    authState.checkUserLoggedIn().then((_) {
      final user = ref.read(authProvider).value;
      if (user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LogInScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
           
            Opacity(
              opacity: _animation1.value,
              child: Image.asset(
                'images/qr-code-scan.png',
                width: 150,
                height: 150,
              ),
            ),
            const SizedBox(height: 20),
       
            Opacity(
              
              opacity: _animation2.value,
              child: Image.asset(
                'images/quick_qr.jpeg',
                width: 150,
                height: 150,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
