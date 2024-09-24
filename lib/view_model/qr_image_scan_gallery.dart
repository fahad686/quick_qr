import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import '../view/data_gallery_image_scan.dart';

// StateNotifier for managing the image and QR code scanning
class Imgfunction extends StateNotifier<File?> {
  Imgfunction() : super(null);

  File? _image;
  final ImagePicker _picker = ImagePicker();
  String scannedData = ""; // To hold the scanned QR code data

  /// Pick image from gallery and start scanning
  Future<void> pickQr(BuildContext context) async {
    final PickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (PickedFile != null) {
      _image = File(PickedFile.path);
      state = _image;
      scanQrImage(_image!, context);
    }
  }

  /// Scan QR code from the selected image
  Future<void> scanQrImage(File image, BuildContext context) async {
    final inputimage = InputImage.fromFile(image);
    final barcodeScan = BarcodeScanner();
    try {
      final List<Barcode> barcodes = await barcodeScan.processImage(inputimage);
      if (barcodes.isEmpty) {
        scannedData = "No QR code found.Please try one another";
      } else {
        for (Barcode barcode in barcodes) {
          final String qrCodeData = barcode.displayValue ?? "";
          scannedData = qrCodeData;
        }

        // Navigate to the result screen with the scanned QR code data

        Future.delayed(Duration(seconds: 3), () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => QrResultScreen(scannedData: scannedData),
            ),
          );
        });
      }
    } catch (e) {
      scannedData = "Error scanning QR code: $e";
    }
  }
}
