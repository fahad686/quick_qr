import 'package:flutter/material.dart';
import 'package:quick_qr/view/home/drawar.dart';

import '../gen_qr_screen.dart';
import '../imgfunction.dart';
import '../qr_scanner.dart';
import 'curser_slider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(
        title: Text("Quick Qr"),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Icon(Icons.more_vert_outlined),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          QrCarouselSlider(),
          SizedBox(
            height: 60,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => GenerateQRCode()));
                },
                child: Column(
                  children: [
                    Container(
                      height: 100,
                      width: 100,
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
                    Text(
                      "Genrate Qr",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    )
                  ],
                ),
              ),
              Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      _showAlertDialog(context);
                    },
                    child: Container(
                      height: 100,
                      width: 100,
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
                          image: AssetImage('images/qr-code-scan.png'),
                          // fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Text(
                    "Scan Qr",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  )
                ],
              ),
            ],
          ),
          SizedBox(
            height: 110,
          ),
        ],
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
