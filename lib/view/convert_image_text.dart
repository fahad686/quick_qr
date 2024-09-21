import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'dart:io';

class ImageToText extends StatefulWidget {
  @override
  _ImageToTextState createState() => _ImageToTextState();
}

class _ImageToTextState extends State<ImageToText> {
  File? _image;
  final picker = ImagePicker();
  String scannedData = "";

  Future<void> pickImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      scanImage(File(pickedFile.path));
    }
  }

  Future<void> scanImage(File image) async {
    final inputImage = InputImage.fromFile(image);
    final textRecognizer = TextRecognizer();

    // Debugging statement to ensure scanning starts
    print("Scanning image...");

    try {
      final RecognizedText recognizedText =
          await textRecognizer.processImage(inputImage);

      // Check if text is recognized
      String scannedText = recognizedText.text;
      print("Scanned Text: $scannedText"); // Debugging the scanned text

      setState(() {
        scannedData = scannedText;
      });

      textRecognizer.close();

      // Show dialog with the scanned data
      handleScannedData(scannedText);
    } catch (e) {
      print("Error during scanning: $e");
    }
  }

  void handleScannedData(String scannedText) {
    if (scannedText.isEmpty) {
      // If no text is scanned
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('No Text Found'),
            content: Text(
              'No text could be scanned from the image.',
              style: TextStyle(color: Colors.red),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      // Display scanned text in dialog
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Scanned Text'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                    scannedText,
                    style: TextStyle(color: Colors.amber),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Scanner'),
      ),
      body: Column(
        children: [
          if (_image != null)
            Image.file(
              _image!,
              height: 300,
            ),
          SizedBox(height: 20),
          //Text(scannedData),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => pickImage(ImageSource.camera),
                child: Text('Pick from Camera'),
              ),
              SizedBox(width: 20),
              ElevatedButton(
                onPressed: () => pickImage(ImageSource.gallery),
                child: Text('Pick from Gallery'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
