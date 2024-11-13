import 'package:flutter/material.dart';

class SecondTabPaper extends StatelessWidget {
  const SecondTabPaper({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'This is the second page ✅✅',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }
}
