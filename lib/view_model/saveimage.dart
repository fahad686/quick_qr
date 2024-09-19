import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';

class QRImageNotifier extends StateNotifier<AsyncValue<String>> {
  QRImageNotifier() : super(const AsyncValue.data(''));

  final ScreenshotController _screenshotController = ScreenshotController();

  Future<void> requestStoragePermission() async {
    state = const AsyncValue.loading();
    try {
      final status = await Permission.storage.request();
      if (status.isGranted) {
        await saveImage();
      } else {
        state =
            AsyncValue.error('Storage permission denied', StackTrace.current);
      }
    } catch (e, st) {
      state = AsyncValue.error('Permission request failed: $e', st);
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
          state = AsyncValue.error('Failed to save image', StackTrace.current);
        }
      } else {
        state =
            AsyncValue.error('Screenshot capture failed', StackTrace.current);
      }
    } catch (e, st) {
      state = AsyncValue.error('Error saving image: $e', st);
    }
  }

  ScreenshotController get screenshotController => _screenshotController;
}
