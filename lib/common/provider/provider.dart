import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_qr/view_model/saveimage.dart';

final qrImageProvider =
    StateNotifierProvider<QRImageNotifier, AsyncValue<String>>((ref) {
  return QRImageNotifier();
});
