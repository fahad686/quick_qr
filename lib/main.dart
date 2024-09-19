import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'view/gen_qr_screen.dart';

void main() {
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme:
          ThemeData(primaryColor: Colors.black54, primarySwatch: Colors.brown),
      home: GenerateQRCode(),
    );
  }
}
