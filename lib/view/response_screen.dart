import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  final Map<String, dynamic> response;

  const ResultScreen({super.key, required this.response});

  @override
  Widget build(BuildContext context) {
    // Parse outlines as a list of items (if possible)
    final List<String> outlines = response['outlines'] is String
        ? (response['outlines'] as String).split('\n') // Assume newline-separated list
        : (response['outlines'] as List<dynamic>? ?? []).cast<String>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Processing Results',style: TextStyle(
          fontWeight: FontWeight.bold,
          fontFamily: "Poppins",
        ),),
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
              const SizedBox(height: 8),
              Text(
                response['summary'] ?? 'No summary available.',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              const Text(
                'Outline:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              outlines.isNotEmpty
                  ? ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: outlines.length,
                separatorBuilder: (_, __) => const SizedBox(height: 4),
                itemBuilder: (context, index) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '\u2022 ', // Bullet point
                        style: TextStyle(fontSize: 16),
                      ),
                      Expanded(
                        child: Text(
                          outlines[index],
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  );
                },
              )
                  : const Text('No outline available.'),
              const SizedBox(height: 20),
              const Text(
                'Important Questions:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                response['questions'] ?? 'No questions found.',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
