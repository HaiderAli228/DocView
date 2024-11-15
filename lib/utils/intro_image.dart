import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

Widget buildImage(String path, Size size) {
  return Padding(
    padding: EdgeInsets.only(top: size.height * 0.05), // Responsive padding
    child: Center(
      child: Lottie.asset(
        path,
        width: size.width * 0.8,
        fit: BoxFit.cover,
      ),
    ),
  );
}
