import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_qr/view_model/saveimage.dart';
import '../../view_model/qr_scanner.dart';

final saveImageProvider =
    StateNotifierProvider.autoDispose<QRCodeNotifier, bool>(
  (ref) => QRCodeNotifier(),
);
/////////////////////////////////////////////////////

final qrProvider =
    StateNotifierProvider.autoDispose<QrScanner, AsyncValue<String?>>(
  (ref) => QrScanner(),
);
