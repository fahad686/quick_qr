import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/services.dart';
import '../common/provider/provider.dart';

class QrScannerScreen extends ConsumerWidget {
  QrScannerScreen({Key? key}) : super(key: key);

  final TextEditingController qrTextController = TextEditingController();

  Future<void> requestCameraPermission() async {
    var status = await Permission.camera.status;
    if (!status.isGranted) {
      await Permission.camera.request();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final qrState = ref.watch(qrProvider);
    final qrViewModel = ref.read(qrProvider.notifier);

    requestCameraPermission();

    return Scaffold(
      appBar: AppBar(
        title: const Text("QR Scanner"),
        actions: [
          IconButton(
            icon: const Icon(Icons.flip_camera_ios),
            onPressed: () => qrViewModel.switchCamera(),
          ),
          IconButton(
            icon: const Icon(Icons.flash_on),
            onPressed: () => qrViewModel.toggleTorch(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              // QR Scanner
              Container(
                height: 300,
                width: 250,
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.blue)),
                child: MobileScanner(
                  controller: qrViewModel.scannerController,
                  onDetect: (capture) {
                    final barcode = capture.barcodes.first;
                    qrViewModel.scanQrCode(barcode);
                  },
                ),
              ),
              const SizedBox(height: 20),

              // Show scanned QR code data with Copy & Open URL buttons
              qrState.when(
                data: (qrData) {
                  if (qrData != null) {
                    return Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              qrData,
                              style: const TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            GestureDetector(
                                onTap: () {
                                  Clipboard.setData(
                                      ClipboardData(text: qrData));
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            "QR Code copied to clipboard")),
                                  );
                                },
                                child: Icon(
                                  Icons.copy,
                                  size: 15,
                                  color: Colors.blue,
                                ))
                          ],
                        ),
                      ],
                    );
                  } else {
                    return Center(child: const Text("No QR code scanned"));
                  }
                },
                loading: () => const CircularProgressIndicator(),
                error: (error, _) => Text("Error: $error"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
