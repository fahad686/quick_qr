import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';

import '../common/provider/provider.dart';

class QRImageScreen extends ConsumerWidget {
  QRImageScreen(this.controller, {super.key});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final qrImageState = ref.watch(qrImageProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Quick QR"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Screenshot(
              controller:
                  ref.read(qrImageProvider.notifier).screenshotController,
              child: QrImageView(
                data: controller.text,
                size: 280,
              ),
            ),
            SizedBox(height: 90),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        await ref
                            .read(qrImageProvider.notifier)
                            .requestStoragePermission();
                      },
                      child: Icon(Icons.save, size: 34),
                    ),
                    Text("Save Gallery")
                  ],
                ),
              ],
            ),
            qrImageState.when(
              data: (message) => Text(
                message,
                style: TextStyle(color: Colors.green),
              ),
              loading: () => CircularProgressIndicator(),
              error: (error, stack) => Text(
                error.toString(),
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
