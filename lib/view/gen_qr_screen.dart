import 'package:flutter/material.dart';
import '../common/widget/animation.dart';
import 'save_share_img.dart';
import 'qr_scanner.dart';
import 'imgfunction.dart';
import 'convert_image_text.dart';

class GenerateQRCode extends StatefulWidget {
  const GenerateQRCode({super.key});

  @override
  GenerateQRCodeState createState() => GenerateQRCodeState();
}

class GenerateQRCodeState extends State<GenerateQRCode> {
  TextEditingController controller = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Generate QR"),
        centerTitle: true,
        automaticallyImplyLeading: true,
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
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ImageToText()),
                );
              },
              child: const Icon(
                Icons.file_open_outlined,
                color: Colors.blue,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 50),
                Center(
                  child: Container(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: AnimatedImage(
                      imagePath: 'images/quick_qr.jpeg',
                      size: 200,
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Select Type of QR code',
                  ),
                  value: selectedValue,
                  items: <String>[
                    'Gmail',
                    'Phone number',
                    'Web URL',
                    'YouTube',
                    'Address',
                    'WhatsApp'
                  ].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedValue = value;
                      controller.clear();
                    });
                  },
                  validator: (value) =>
                      value == null ? 'Please select an option' : null,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: controller,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: selectedValue != null
                        ? 'Enter your $selectedValue'
                        : 'Enter value',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }

                    // Validation for each type of input
                    switch (selectedValue) {
                      case 'Gmail':
                        if (!RegExp(r'^[\w\.\-]+@[a-zA-Z\d\-]+\.[a-zA-Z]{2,}$')
                            .hasMatch(value)) {
                          return 'Please enter a valid Gmail address';
                        }
                        break;
                      case 'Phone number':
                        if (!RegExp(r'^\+?[1-9]\d{1,14}$').hasMatch(value)) {
                          return 'Please enter a valid phone number';
                        }
                        break;
                      case 'Web URL':
                      case 'YouTube':
                        final Uri? parsedUrl = Uri.tryParse(value);
                        if (parsedUrl == null || !parsedUrl.isAbsolute) {
                          return 'Please enter a valid URL';
                        }
                        break;
                      case 'WhatsApp':
                        if (!RegExp(
                                r'^whatsapp://send\?phone=\+?[1-9]\d{1,14}$')
                            .hasMatch(value)) {
                          return 'Please enter a valid WhatsApp number';
                        }
                        break;
                      case 'Address':
                        if (value.isEmpty) {
                          return 'Please enter a valid address';
                        }
                        break;
                      default:
                        return 'Invalid selection';
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // QR code data handling
                      String qrData = controller.text;

                      switch (selectedValue) {
                        case 'Gmail':
                          qrData = 'mailto:${controller.text}';
                          break;
                        case 'Phone number':
                          qrData = controller.text;
                          break;
                        case 'Web URL':
                        case 'YouTube':
                          qrData = controller.text;
                          break;
                        case 'WhatsApp':
                          qrData = 'https://wa.me/${controller.text}';
                          break;
                        case 'Address':
                          qrData = controller.text;
                          break;
                      }

                      // Navigate to Save QR screen
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return SaveImage(
                              TextEditingController(text: qrData),
                            );
                          },
                        ),
                      );
                    }
                  },
                  child: const Text('Generate QR Code'),
                ),
                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Dialog to choose between Gallery and Camera for scanning
  void _showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Choose QR Scanning Method'),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    const Icon(Icons.photo),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ImgScreen(),
                          ),
                        );
                      },
                      child: const Text("Gallery"),
                    ),
                  ],
                ),
                Column(
                  children: [
                    const Icon(Icons.camera_alt),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => QrScannerScreen(),
                          ),
                        );
                      },
                      child: const Text("Camera"),
                    ),
                  ],
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
