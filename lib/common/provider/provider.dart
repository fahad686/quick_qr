import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_qr/view_model/saveimage.dart';
import '../../view_model/qr_scanner.dart';

final qrImageProvider =
    StateNotifierProvider<QRImageNotifier, AsyncValue<String>>((ref) {
  return QRImageNotifier();
});

/////////////////////////////////////////////////////

final qrProvider = StateNotifierProvider<QrViewModel, AsyncValue<String?>>(
  (ref) => QrViewModel(),
);
