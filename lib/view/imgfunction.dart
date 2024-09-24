import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../common/provider/provider.dart';

class ImgScreen extends ConsumerWidget {
  const ImgScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imgData = ref.watch(imgprovider);
    final imgFunction = ref.read(imgprovider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Image Picker & QR Scanner"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Center(
                child: Container(
                  height: 300,
                  width: 300,
                  color: const Color.fromARGB(255, 95, 94, 94),
                  child: imgData != null
                      ? Image.file(
                          imgData,
                          fit: BoxFit.cover,
                        )
                      : const Center(
                          child: Text(
                            "No Image Selected",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Text(
                imgFunction.scannedData.isNotEmpty
                    ? "Scanning QR Code: ${imgFunction.scannedData}"
                    : "No QR Code Scanned",
                style: const TextStyle(fontSize: 16, color: Colors.black),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () {
                imgFunction.pickQr(context);
              },
              icon: const Icon(Icons.image_search),
              label: const Text("Pick Image & Scan QR"),
            ),
          ],
        ),
      ),
    );
  }
}
