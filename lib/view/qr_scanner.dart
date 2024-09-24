import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../common/provider/provider.dart';

class QrScannerScreen extends ConsumerWidget {
  QrScannerScreen({Key? key}) : super(key: key);

  final TextEditingController qrTextController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(qrProvider);
    final provider = ref.read(qrProvider.notifier);

    provider.requestCameraPermission();

    return Scaffold(
      appBar: AppBar(
        title: const Text("QR Scanner"),
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
            Text("Object Scanning...."),
            const SizedBox(height: 40),
            Center(
              child: Container(
                height: 300,
                width: 250,
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.blue)),
                child: MobileScanner(
                  controller: provider.scannerController,
                  onDetect: (capture) {
                    final barcode = capture.barcodes.first;
                    provider.scanQrCode(barcode, context);
                  },
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
