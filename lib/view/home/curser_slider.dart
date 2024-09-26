import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class QrCarouselSlider extends StatefulWidget {
  @override
  _QrCarouselSliderState createState() => _QrCarouselSliderState();
}

class _QrCarouselSliderState extends State<QrCarouselSlider> {
  // Use a list of asset paths instead of network URLs
  final List<String> qrImagePaths = [
    'images/quick_qr.jpeg', // Replace with your actual asset paths
    'images/gen_qr.jpeg',
    'images/bc_img.jpeg',
    'images/qr-code-scan.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CarouselSlider(
        options: CarouselOptions(
          height: 200.0,
          autoPlay: true,
          autoPlayInterval: Duration(seconds: 3),
          autoPlayAnimationDuration: Duration(milliseconds: 800),
          enlargeCenterPage: true,
          aspectRatio: 16 / 9,
          enableInfiniteScroll: true,
        ),
        items: qrImagePaths.map((imagePath) {
          return Builder(
            builder: (BuildContext context) {
              return Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.symmetric(horizontal: 5.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(3, 3),
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Center(child: Text('Image load failed'));
                    },
                  ),
                ),
              );
            },
          );
        }).toList(),
      ),
    );
  }
}
