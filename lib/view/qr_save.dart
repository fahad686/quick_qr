import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../common/provider/provider.dart';
import 'gen_qr_screen.dart';

class SaveImage extends ConsumerWidget {
  SaveImage(this.controller, {super.key});

  final TextEditingController controller;
  final GlobalKey _globalKey = GlobalKey();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final qrCodeNotifier = ref.read(shareSaveqr.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Quick QR"),
        centerTitle: true,
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
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RepaintBoundary(
                key: _globalKey,
                child: Container(
                  color: Colors.white,
                  child: QrImageView(
                    data: controller.text,
                    size: 280,
                  ),
                ),
              ),
              SizedBox(height: 90),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () async {
                      // Request permission and save the QR code if granted
                      bool permissionGranted =
                          await qrCodeNotifier.requestPermission();
                      if (permissionGranted) {
                        await qrCodeNotifier.saveQRCodeImage(_globalKey);
                      } else {
                        Fluttertoast.showToast(msg: "Permission denied.");
                      }
                    },
                    child: Column(
                      children: [
                        Icon(Icons.save, size: 34),
                        Text("Save Gallery")
                      ],
                    ),
                  ),
                  SizedBox(width: 40),
                  GestureDetector(
                    onTap: () async {
                      await qrCodeNotifier.shareQRCodeImage(_globalKey);
                    },
                    child: Column(
                      children: [Icon(Icons.share, size: 34), Text("Share QR")],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
