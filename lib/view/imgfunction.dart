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
        title: const Text("QR Scanner"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.purpleAccent, Colors.deepPurple],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Center(
                  child: Container(
                    height: 300,
                    width: 300,
                    color: const Color.fromARGB(255, 255, 255, 255),
                    child: imgData != null
                        ? Image.file(
                            imgData,
                            fit: BoxFit.cover,
                          )
                        : const Center(
                            child: Text(
                              "No Image Selected",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 24, 24, 24)),
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
                label: const Text("Open Gallery"),
              ),
              SizedBox(
                height: 20,
              ),
              IconButton(
                icon: const Icon(
                  Icons.refresh,
                  color: Colors.deepPurple,
                ),
                onPressed: () {
                  imgFunction.clearData();
                },
              ),
              SizedBox(
                height: 160,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
