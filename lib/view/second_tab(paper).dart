import 'package:flutter/material.dart';

class SecondTabPaper extends StatelessWidget {
  final String? summary;

  const SecondTabPaper({super.key, this.summary});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Document Summary')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Text(
            summary ?? 'No summary available',
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}
