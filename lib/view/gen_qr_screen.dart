import 'package:flutter/material.dart';
import 'package:quick_qr/view/convert_image_text.dart';
import 'imgfunction.dart';
import 'qr_save.dart';
import 'qr_scanner.dart';

class GenerateQRCode extends StatefulWidget {
  const GenerateQRCode({super.key});

  @override
  GenerateQRCodeState createState() => GenerateQRCodeState();
}

class GenerateQRCodeState extends State<GenerateQRCode> {
  TextEditingController controller = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Quick QR"),
        centerTitle: true,
        automaticallyImplyLeading: true,
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  height: 300,
                  width: 800,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.black, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        offset: Offset(2, 2),
                        blurRadius: 5,
                      ),
                    ],
                    image: DecorationImage(
                      image: AssetImage('images/quick_qr.jpeg'),
                      // fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
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
                  'Address'
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

                  // Custom validation based on the selected dropdown value
                  if (selectedValue == 'Gmail') {
                    // Validate for Gmail format
                    if (!RegExp(r'^[\w\.\-]+@gmail\.com$').hasMatch(value)) {
                      return 'Please enter a valid Gmail address';
                    }
                  } else if (selectedValue == 'Phone number') {
                    // Validate for Phone number format
                    if (!RegExp(r'^\+?[1-9]\d{1,14}$').hasMatch(value)) {
                      return 'Please enter a valid international phone number';
                    }
                  } else if (selectedValue == 'Web URL') {
                    // URL validation for general websites
                    final Uri? parsedUrl = Uri.tryParse(value);
                    if (parsedUrl == null || !parsedUrl.isAbsolute) {
                      return 'Please enter a valid URL';
                    }
                  }

                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Prepare data to generate the QR code
                    String qrData = controller.text;

                    if (selectedValue == 'Gmail') {
                      qrData =
                          'mailto:${controller.text}'; // For Gmail, add mailto:
                    } else if (selectedValue == 'Phone number') {
                      qrData =
                          'tel:${controller.text}'; // For phone numbers, add tel:
                    }

                    // Navigate to the SaveImage screen with the formatted qrData
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return SaveImage(TextEditingController(text: qrData));
                        },
                      ),
                    );
                  }
                },
                child: const Text('Generate QR Code'),
              ),
              SizedBox(
                height: 50,
              ),
            ],
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
                            builder: (context) => ImgScreen(),
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
                )
              ],
            )
          ],
        );
      },
    );
  }
}
