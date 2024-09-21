import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quick_qr/view/gallery_image_scan.dart';

class QrImageFromGallery extends StatefulWidget {
  QrImageFromGallery({super.key});

  @override
  State<QrImageFromGallery> createState() => _QrImageFromGalleryState();
}

class _QrImageFromGalleryState extends State<QrImageFromGallery> {
  bool text = false;

  ///picimage function
  File? _image;
  final ImagePicker _picker = ImagePicker();
  Future<void> pickQr() async {
    final PickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (PickedFile != null) {
      setState(() {
        _image = File(PickedFile.path);
      });

      scanQrImage(File(PickedFile.path));
    }
  }

  ///Scan Qr image Function
  String scannedData = "";
  Future<void> scanQrImage(File image) async {
    final inputimage = InputImage.fromFile(image);
    final barcodeScan = BarcodeScanner();
    try {
      final List<Barcode> barcode = await barcodeScan.processImage(inputimage);
      if (barcode.isEmpty) {
        print("No QR code found.");
        setState(() {
          scannedData = "Please Select a QR Code Image.";
        });
      } else {
        for (Barcode barcode in barcode) {
          final String qrCodeData = barcode.displayValue ?? "";

          print("Scanned QR Code: $qrCodeData");

          setState(() {
            scannedData = qrCodeData;
          });

          Future.delayed(Duration(seconds: 2), () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        GalleryImageScan(newdata: qrCodeData)));
          });
        }
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Gallery"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 30),
          Center(
            child: text == true
                ? Text("QR Code Scanning....")
                : Text("Select Image from gallery"),
          ),
          SizedBox(height: 30),
          if (_image != null)
            Center(
              child: Container(
                height: 500,
                child: Image.file(_image!),
              ),
            ),
          Text(
            scannedData,
            style: TextStyle(color: Colors.red),
          ),
          Center(
            child: TextButton(
                onPressed: () {
                  pickQr();
                  text = true;
                },
                child: Text("Open Gallery")),
          ),
        ],
      ),
    );
  }
}
