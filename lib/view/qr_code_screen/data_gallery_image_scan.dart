import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class QrResultScreen extends StatefulWidget {
  final String scannedData;

  const QrResultScreen({super.key, required this.scannedData});

  @override
  State<QrResultScreen> createState() => _QrResultScreenState();
}

class _QrResultScreenState extends State<QrResultScreen> {
  void handleScannedData(String scannedText) async {
    if (RegExp(r'^[\w\.\-]+@[a-zA-Z\d\-]+\.[a-zA-Z]{2,}$')
        .hasMatch(scannedText)) {
      // If it's an email
      final Uri emailLaunchUri = Uri(
        scheme: 'mailto',
        path: scannedText,
      );
      launchUrl(emailLaunchUri);
    } else if (RegExp(r'^\+?[1-9]\d{1,14}$').hasMatch(scannedText)) {
      // If it's a phone number
      final Uri phoneUri = Uri(
        scheme: 'tel',
        path: scannedText,
      );
      launchUrl(phoneUri);
    } else if (RegExp(r'^whatsapp://send\?phone=\+?[1-9]\d{1,14}$')
        .hasMatch(scannedText)) {
      // If it's a WhatsApp message
      final Uri whatsappUri = Uri.parse(scannedText);
      launchUrl(whatsappUri);
    } else if (RegExp(
            r'^https?://(?:m\.|www\.)?youtube\.com/watch\?v=[\w-]{11}$')
        .hasMatch(scannedText)) {
      // If it's a YouTube video URL
      final Uri youtubeUri = Uri.parse(scannedText);
      launchUrl(youtubeUri);
    } else if (RegExp(r'^https?://(?:m\.|www\.)?google\.com/search\?q=.*$')
        .hasMatch(scannedText)) {
      // If it's a Google Web URL
      final Uri googleUri = Uri.parse(scannedText);
      launchUrl(googleUri);
    } else if (Uri.parse(scannedText).isAbsolute) {
      // If it's a URL
      final Uri url = Uri.parse(scannedText);
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      }
    } else {
      // Show if none matched
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
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Scanned QR Code Data:",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  children: [
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        Clipboard.setData(
                            ClipboardData(text: widget.scannedData));
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
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Text(
                  widget.scannedData,
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  handleScannedData(widget.scannedData);
                },
                child: const Text("Open"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
