import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../common/provider/provider.dart';
import 'gen_qr_screen.dart';

class CameraScanScreen extends ConsumerWidget {
  const CameraScanScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final qrState = ref.watch(qrProvider);

    // Method to handle scanned data like email, phone number, or URL
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Scanned complete!",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            qrState.when(
              data: (qrData) {
                if (qrData != null) {
                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Text(
                              qrData,
                              style: const TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(width: 15),
                          GestureDetector(
                            onTap: () {
                              Clipboard.setData(ClipboardData(text: qrData));
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
                      const SizedBox(height: 20),

                      // Button to handle the scanned data
                      ElevatedButton(
                        onPressed: () {
                          handleScannedData(qrData);
                        },
                        child: const Text('Open Scanned Data'),
                      ),
                    ],
                  );
                } else {
                  return const Center(child: Text("No QR code scanned"));
                }
              },
              loading: () => const CircularProgressIndicator(),
              error: (error, _) => Text("Error: $error"),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
