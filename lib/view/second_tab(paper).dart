import 'package:docsview/utils/app_colors.dart';
import 'package:flutter/material.dart';

class SecondTabPaper extends StatelessWidget {
  final String? summary;
  final String? outlines;

  const SecondTabPaper({super.key, this.summary, this.outlines});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Document Analysis',
          style: TextStyle(fontFamily: "Poppins"),
        ),
        backgroundColor: AppColors.themeColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Summary:",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Poppins",
                ),
              ),
              const SizedBox(height: 8),
              _buildScrollableText(summary ?? 'No summary available.'),
              const Divider(height: 30),
              const Text(
                "Outlines:",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Poppins",
                ),
              ),
              const SizedBox(height: 8),
              _buildScrollableText(outlines ?? 'No outlines available.'),
            ],
          ),
        ),
      ),
    );
  }

  // A method to build scrollable text blocks with appropriate styling
  Widget _buildScrollableText(String content) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Text(
        content,
        style: const TextStyle(
          fontSize: 16,
          fontFamily: "Poppins",
        ),
        textAlign: TextAlign.justify,
      ),
    );
  }
}
