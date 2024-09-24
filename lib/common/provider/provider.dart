import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../view_model/qr_image_scan_gallery.dart';
import '../../view_model/qr_scanner.dart';
import '../../view_model/share_save_qr.dart';

// Define a provider for QRCodeNotifier
final shareSaveqr = StateNotifierProvider<QRCodeNotifier, void>((ref) {
  return QRCodeNotifier();
});

/////////////////////////////////////////////////////

final qrProvider =
    StateNotifierProvider.autoDispose<QrScanner, AsyncValue<String?>>(
  (ref) => QrScanner(),
);

final imgprovider = StateNotifierProvider.autoDispose<Imgfunction, File?>(
    (ref) => Imgfunction());
