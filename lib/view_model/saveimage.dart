import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:saver_gallery/saver_gallery.dart';

// StateNotifier class to handle QR code saving logic
class QRCodeNotifier extends StateNotifier<bool> {
  QRCodeNotifier() : super(false);

  // Function to request permission based on the platform
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
}
