import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:docsview/utils/app_colors.dart';
import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  final Map<String, dynamic> response;

  const ResultScreen({super.key, required this.response});

  @override
  Widget build(BuildContext context) {
    // Parse outlines as a list of items
    final List<String> outlines = response['outlines'] is String
        ? (response['outlines'] as String).split('\n') // Assume newline-separated list
        : (response['outlines'] as List<dynamic>? ?? []).cast<String>();

    final String summary = response['summary'] ?? 'No summary available.';
    final String questions = response['questions'] ?? 'No questions found.';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.themeColor,
        title: const Text(
          'Processing Results',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: "Poppins",
            color: Colors.white,
          ),
        ),
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
              AnimatedTextKit(
                animatedTexts: [
                  TypewriterAnimatedText(
                    summary,
                    textStyle: const TextStyle(fontSize: 16),
                    speed: const Duration(milliseconds: 50),
                  ),
                ],
                isRepeatingAnimation: false,
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
                        child: AnimatedTextKit(
                          animatedTexts: [
                            TypewriterAnimatedText(
                              outlines[index],
                              textStyle: const TextStyle(fontSize: 16),
                              speed: const Duration(milliseconds: 50),
                            ),
                          ],
                          isRepeatingAnimation: false,
                        ),
                      ),
                    ],
                  );
                },
              )
                  : AnimatedTextKit(
                animatedTexts: [
                  TypewriterAnimatedText(
                    'No outline available.',
                    textStyle: const TextStyle(fontSize: 16),
                    speed: const Duration(milliseconds: 50),
                  ),
                ],
                isRepeatingAnimation: false,
              ),
              const SizedBox(height: 20),
              const Text(
                'Important Questions:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              AnimatedTextKit(
                animatedTexts: [
                  TypewriterAnimatedText(
                    questions,
                    textStyle: const TextStyle(fontSize: 16),
                    speed: const Duration(milliseconds: 50),
                  ),
                ],
                isRepeatingAnimation: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
