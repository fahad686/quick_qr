import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: must_be_immutable
class GalleryImageScan extends StatefulWidget {
  String newdata;
  GalleryImageScan({super.key, required this.newdata});

  @override
  State<GalleryImageScan> createState() => _GalleryImageScanState();
}

class _GalleryImageScanState extends State<GalleryImageScan> {
  Future<void> handleScannedData(String scannedText) async {
    if (RegExp(r'^[\w\.\-]+@[a-zA-Z\d\-]+\.[a-zA-Z]{2,}$')
        .hasMatch(scannedText)) {
      // If it's an email
      final Uri emailLaunchUri = Uri(
        scheme: 'mailto',
        path: scannedText,
      );
      await launchUrl(emailLaunchUri);
    } else if (RegExp(r'^\+?[1-9]\d{1,14}$').hasMatch(scannedText)) {
      // If it's a phone number
      final Uri phoneUri = Uri(
        scheme: 'tel',
        path: scannedText,
      );
      await launchUrl(phoneUri);
    } else if (Uri.parse(scannedText).isAbsolute) {
      // If it's a URL
      final Uri url = Uri.parse(scannedText);
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      }
    } else {
      // Show alert dialog if none matched
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Scanned Text'),
            content: Text(scannedText),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("NewData"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () {
                  Clipboard.setData(ClipboardData(text: widget.newdata));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("QR Code copied to clipboard"),
                    ),
                  );
                },
                child: const Icon(
                  Icons.copy,
                  size: 15,
                  color: Colors.blue,
                ),
              ),
              SizedBox(
                width: 50,
              ),
            ],
          ),
          Center(child: Text(widget.newdata)),
          TextButton(
              onPressed: () {
                handleScannedData(widget.newdata);
              },
              child: Text('Open')),
        ],
      ),
    );
  }
}
