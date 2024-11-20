import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  final Map<String, dynamic> response;

  const ResultScreen({super.key, required this.response});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Processing Results'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Summary:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(response['summary'] ?? 'No summary available.'),
              const SizedBox(height: 20),
              const Text(
                'Outline:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(response['outline'] ?? 'No outline available.'),
              const SizedBox(height: 20),
              const Text(
                'Important Questions:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(response['questions'] ?? 'No questions found.'),
            ],
          ),
        ),
      ),
    );
  }
}
