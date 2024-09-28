import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:quick_qr/view/data_camera_scan_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class QrScanner extends StateNotifier<AsyncValue<String?>> {
  MobileScannerController scannerController = MobileScannerController();

  QrScanner() : super(const AsyncValue.data(null));

  void scanQrCode(Barcode barcode, BuildContext context) {
    final scannedValue = barcode.rawValue;
    state = AsyncValue.data(scannedValue);

    if (scannedValue != null) {
      // Show a message to notify the user
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Scanned complete!")),
      );

      scannerController.stop();

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const CameraScanScreen(),
        ),
      );

      if (_isValidURL(scannedValue)) {
        _launchURL(scannedValue);
      }
    }
  }

  void toggleTorch() {
    try {
      scannerController.toggleTorch();
    } catch (e) {
      log('Torch toggle error: $e');
    }
  }

  ////////
  Future<void> requestCameraPermission() async {
    var status = await Permission.camera.status;
    if (!status.isGranted) {
      await Permission.camera.request();
    }
  }

  void switchCamera() {
    try {
      scannerController.switchCamera();
    } catch (e) {
      log('Camera switch error: $e');
    }
  }

  void resetData() {
    state = const AsyncValue.data(null);

    // scannerController.start();
  }

  // Function to launch a URL
  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(Uri.encodeFull(url));
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      log('Could not launch $url');
    }
  }

  // Helper function to validate URL
  bool _isValidURL(String url) {
    return Uri.tryParse(url)?.hasAbsolutePath ?? false;
  }
}
