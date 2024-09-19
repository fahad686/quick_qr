import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRImageNotifier extends StateNotifier<AsyncValue<String>> {
  QRImageNotifier() : super(const AsyncValue.data(''));

  final ScreenshotController _screenshotController = ScreenshotController();

  Future<void> requestStoragePermission() async {
    state = const AsyncValue.loading();
    final status = await Permission.storage.request();
    if (status.isGranted) {
      await saveImage();
    } else {
      state = AsyncValue.error(Error, StackTrace.current);
    }
  }

  Future<void> saveImage() async {
    try {
      final Uint8List? uint8list = await _screenshotController.capture();
      if (uint8list != null) {
        final result = await ImageGallerySaver.saveImage(uint8list);
        if (result["isSuccess"]) {
          state = AsyncValue.data("Image saved to gallery");
        } else {
          state = AsyncValue.error(Error, StackTrace.current);
          //("Image save failed: ${result["error"]}");
        }
      }
    } catch (e) {
      state = AsyncValue.error(Error, StackTrace.current);
    }
  }

  ScreenshotController get screenshotController => _screenshotController;
}

final qrImageProvider =
    StateNotifierProvider<QRImageNotifier, AsyncValue<String>>((ref) {
  return QRImageNotifier();
});

// Update with the correct path

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
