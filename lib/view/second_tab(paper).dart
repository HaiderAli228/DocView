import 'package:flutter/material.dart';
class SecondTabPaper extends StatelessWidget {
  final String? summary;
  final String? outlines;

  const SecondTabPaper({super.key, this.summary, this.outlines});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Document Analysis')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Summary:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              _buildScrollableText(context, summary ?? 'No summary available.'),
              const Divider(height: 30),
              const Text(
                "Outlines:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              _buildScrollableText(context, outlines ?? 'No outlines available.'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScrollableText(BuildContext context, String text) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8.0),
      ),
      height: MediaQuery.of(context).size.height * 0.4, // Adjust height
      child: SingleChildScrollView(
        child: Text(
          text,
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
