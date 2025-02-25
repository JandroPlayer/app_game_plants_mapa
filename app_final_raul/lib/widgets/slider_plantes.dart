import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class ImageSlider extends StatelessWidget {
  final List<String> imagePaths = [
    for (int i = 1; i <= 28; i++) 'assets/galeriaPlantes/$i.png'
  ];

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        height: 70,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 3),
        enlargeCenterPage: true,
        viewportFraction: 0.4, // Ajuste para tamaño reducido
      ),
      items: imagePaths.map((path) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset(
            path,
            fit: BoxFit.cover,
          ),
        );
      }).toList(),
    );
  }
}
