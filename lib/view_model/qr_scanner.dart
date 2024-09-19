import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:url_launcher/url_launcher.dart';

class QrViewModel extends StateNotifier<AsyncValue<String?>> {
  MobileScannerController scannerController = MobileScannerController();

  QrViewModel() : super(const AsyncValue.data(null));

  // Function to scan QR Code
  void scanQrCode(Barcode barcode) {
    final scannedValue = barcode.rawValue;
    state = AsyncValue.data(scannedValue);

    // Automatically launch URL if it's a valid one
    if (scannedValue != null && _isValidURL(scannedValue)) {
      _launchURL(scannedValue);
    }
  }

  // Function to toggle torch
  void toggleTorch() {
    try {
      scannerController.toggleTorch();
    } catch (e) {
      log('Torch toggle error: $e');
    }
  }

  // Function to switch camera
  void switchCamera() {
    try {
      scannerController.switchCamera();
    } catch (e) {
      log('Camera switch error: $e');
    }
  }

  // Reset the QR data after scanning
  void resetData() {
    state = const AsyncValue.data(null);
  }

  // Function to launch a URL
  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(Uri.encodeFull(url)); // Properly encode the URL
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
