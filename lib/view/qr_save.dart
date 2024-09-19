import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:quick_qr/common/provider/provider.dart';

class SaveImage extends ConsumerWidget {
  SaveImage(this.controller, {super.key});

  final TextEditingController controller;
  final GlobalKey _globalKey = GlobalKey();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final qrCodeNotifier = ref.read(saveImageProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Quick QR"),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RepaintBoundary(
                key: _globalKey,
                child: Container(
                  // width: 800,
                  // height: 400,
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
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
