import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'gen_qr_screen.dart';

class QrResultScreen extends StatefulWidget {
  final String scannedData;

  const QrResultScreen({Key? key, required this.scannedData}) : super(key: key);

  @override
  State<QrResultScreen> createState() => _QrResultScreenState();
}

class _QrResultScreenState extends State<QrResultScreen> {
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

      if (url.host.contains('youtube.com') || url.host.contains('youtu.be')) {
        // Handle YouTube links

        // For short YouTube URLs like "youtu.be"
        String videoId = url.host.contains('youtu.be')
            ? url.pathSegments.first
            : url.queryParameters['v'] ?? '';

        final Uri youtubeUri = Uri.parse('youtube://watch?v=$videoId');

        if (await canLaunchUrl(youtubeUri)) {
          // Open in the YouTube app if available
          await launchUrl(youtubeUri);
        } else {
          // If YouTube app is not available, open in the browser
          await launchUrl(url);
        }
      } else if (url.host.contains('google.com')) {
        // If it's a Google URL, open in the browser
        await launchUrl(url);
      } else {
        // For other general URLs, open them in the browser
        if (await canLaunchUrl(url)) {
          await launchUrl(url);
        } else {
          // Show alert if unable to launch URL
          _showAlertDialog(scannedText);
        }
      }
    } else {
      // If the scanned text is not an email, phone number, or URL
      _showAlertDialog(scannedText);
    }
  }

  void _showAlertDialog(String scannedText) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton.filledTonal(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const GenerateQRCode(),
              ),
            );
          },
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Scanned QR Code Data:",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  children: [
                    Spacer(),
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
