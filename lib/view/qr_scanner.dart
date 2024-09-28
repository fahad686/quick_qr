import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../common/provider/provider.dart';

class QrScannerScreen extends ConsumerWidget {
  QrScannerScreen({super.key});

  final TextEditingController qrTextController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(qrProvider);
    final provider = ref.read(qrProvider.notifier);

    provider.requestCameraPermission();

    return Scaffold(
      appBar: AppBar(
        title: const Text("QR Scanner"),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.purpleAccent, Colors.deepPurple],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.flip_camera_ios),
            onPressed: () => provider.switchCamera(),
          ),
          IconButton(
            icon: const Icon(Icons.flash_on),
            onPressed: () => provider.toggleTorch(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text("Object Scanning...."),
            const SizedBox(height: 40),
            Center(
              child: SizedBox(
                height: 350,
                width: 300,
                child: Stack(
                  children: [
                    Positioned(
                      left: 25,
                      child: Container(
                        height: 300,
                        width: 250,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.blue)),
                        child: MobileScanner(
                          controller: provider.scannerController,
                          onDetect: (capture) {
                            final barcode = capture.barcodes.first;
                            provider.scanQrCode(barcode, context);
                          },
                        ),
                      ),
                    ),
                    Positioned(
                      right: 85,
                      bottom: 30,
                      child: SizedBox(
                        height: 370,
                        width: 250,
                        child: LottieBuilder.asset(
                          'lottie/qr_scanner.json',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
