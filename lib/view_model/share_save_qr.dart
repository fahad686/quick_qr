import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:saver_gallery/saver_gallery.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui' as ui;

class QRCodeNotifier extends StateNotifier<void> {
  QRCodeNotifier() : super(null);

  Future<bool> requestPermission() async {
    bool statuses;
    try {
      if (Platform.isAndroid) {
        final deviceInfoPlugin = DeviceInfoPlugin();
        final deviceInfo = await deviceInfoPlugin.androidInfo;
        final sdkInt = deviceInfo.version.sdkInt;
        statuses =
            sdkInt < 29 ? await Permission.storage.request().isGranted : true;
      } else {
        statuses = await Permission.photosAddOnly.request().isGranted;
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Permission error: $e');
      return false;
    }
    Fluttertoast.showToast(msg: 'Permission granted: $statuses');
    return statuses;
  }

  // Function to save the QR code image to the gallery
  Future<void> saveQRCodeImage(GlobalKey globalKey) async {
    try {
      RenderRepaintBoundary boundary =
          globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage();
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);

      if (byteData != null) {
        String picturesPath = "${DateTime.now().millisecondsSinceEpoch}.jpg";
        final result = await SaverGallery.saveImage(
            byteData.buffer.asUint8List(),
            name: picturesPath,
            androidExistNotSave: false);
        Fluttertoast.showToast(msg: 'Saved: $result');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error saving image: $e');
    }
  }

  // Method to share the QR code image
  Future<void> shareQRCodeImage(GlobalKey globalKey) async {
    try {
      // Convert the widget to an image
      RenderRepaintBoundary boundary =
          globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      final image = await boundary.toImage();
      final byteData = await image.toByteData(format: ImageByteFormat.png);
      final Uint8List pngBytes = byteData!.buffer.asUint8List();

      // Save the image temporarily
      final tempDir = await getTemporaryDirectory();
      final file = await File('${tempDir.path}/qr_code.png').create();
      await file.writeAsBytes(pngBytes);

      // Use share_plus to share the image
      await Share.shareXFiles([XFile(file.path)], text: 'Here is my QR code!');
    } catch (e) {
      Fluttertoast.showToast(msg: "Error sharing QR code: $e");
    }
  }
}
