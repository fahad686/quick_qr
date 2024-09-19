// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:image_gallery_saver/image_gallery_saver.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:qr_flutter/qr_flutter.dart';
// import 'package:screenshot/screenshot.dart';

// class QRImage extends StatefulWidget {
//   QRImage(this.controller, {super.key});

//   final TextEditingController controller;

//   @override
//   State<QRImage> createState() => _QRImageState();
// }

// class _QRImageState extends State<QRImage> {
//   ScreenshotController screenshot = ScreenshotController();

//   Future<void> requestStoragePermission() async {
//     final status = await Permission.storage.request();
//     if (status.isGranted) {
//       // Permission is granted
//       await saveImage();
//     } else {
//       // Permission is denied, handle accordingly
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Storage permission denied")),
//       );
//     }
//   }

//   Future<void> saveImage() async {
//     final Uint8List? uint8list = await screenshot.capture();
//     if (uint8list != null) {
//       final result = await ImageGallerySaver.saveImage(uint8list);
//       if (result["isSuccess"]) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Image saved to gallery")),
//         );
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Image save failed: ${result["error"]}")),
//         );
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Quick QR"),
//         centerTitle: true,
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Screenshot(
//               controller: screenshot,
//               child: QrImageView(
//                 data: widget.controller.text,
//                 size: 280,
//               ),
//             ),
//             SizedBox(height: 90),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Column(
//                   children: [
//                     GestureDetector(
//                       onTap: () async {
//                         await requestStoragePermission();
//                       },
//                       child: Icon(Icons.save, size: 34),
//                     ),
//                     Text("Save Gallery")
//                   ],
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
