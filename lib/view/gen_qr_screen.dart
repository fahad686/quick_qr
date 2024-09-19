import 'package:flutter/material.dart';
import '../view_model/saveimage.dart';
import 'qr_image_screen.dart';

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
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Icon(
              Icons.qr_code_scanner,
              color: Colors.blue,
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
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Select Type of QR code',
                ),
                value: selectedValue,
                items: <String>['Gmail', 'Phone number', 'Web URL', 'Address']
                    .map((String value) {
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
                    if (!RegExp(r'^[\w-]+@([\w-]+\.)+[\w-]{2,4}$')
                        .hasMatch(value)) {
                      return 'Please enter a valid Gmail address';
                    }
                  } else if (selectedValue == 'Phone number') {
                    if (!RegExp(r'^\+[1-9]\d{1,14}$').hasMatch(value)) {
                      return 'Please enter a valid international phone number';
                    }
                  } else if (selectedValue == 'Web URL') {
                    if (!Uri.tryParse(value)!.isAbsolute) {
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return QRImageScreen(controller);
                        },
                      ),
                    );
                  }
                },
                child: const Text('Generate QR Code'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
