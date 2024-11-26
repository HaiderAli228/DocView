import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:docsview/utils/app_colors.dart';
import 'package:flutter/material.dart';

class ResultScreen extends StatefulWidget {
  final Map<String, dynamic> response;

  const ResultScreen({super.key, required this.response});

  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  bool showSummary = false;
  bool showOutlines = false;
  bool showQuestions = false;

  @override
  void initState() {
    super.initState();
    // Start by showing the summary animation
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        showSummary = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // Parse outlines as a list of items
    final List<String> outlines = widget.response['outlines'] is String
        ? (widget.response['outlines'] as String).split('\n') // Assume newline-separated list
        : (widget.response['outlines'] as List<dynamic>? ?? []).cast<String>();

    final String summary = widget.response['summary'] ?? 'No summary available.';
    final String questions = widget.response['questions'] ?? 'No questions found.';

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
              if (showSummary)
                AnimatedTextKit(
                  animatedTexts: [
                    TypewriterAnimatedText(
                      summary,
                      textStyle: const TextStyle(fontSize: 16),
                      speed: const Duration(milliseconds: 10),
                    ),
                  ],
                  isRepeatingAnimation: false,
                  onFinished: () {
                    setState(() {
                      showOutlines = true;
                    });
                  },
                ),
              if (showOutlines) ...[
                const SizedBox(height: 20),
                const Text(
                  'Outline:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                outlines.isNotEmpty
                    ? Column(
                  children: outlines.map((outline) {
                    return AnimatedTextKit(
                      animatedTexts: [
                        TypewriterAnimatedText(
                          '\u2022 $outline',
                          textStyle: const TextStyle(fontSize: 16),
                          speed: const Duration(milliseconds: 10),
                        ),
                      ],
                      isRepeatingAnimation: false,
                      onFinished: () {
                        if (outline == outlines.last) {
                          setState(() {
                            showQuestions = true;
                          });
                        }
                      },
                    );
                  }).toList(),
                )
                    : AnimatedTextKit(
                  animatedTexts: [
                    TypewriterAnimatedText(
                      'No outline available.',
                      textStyle: const TextStyle(fontSize: 16),
                      speed: const Duration(milliseconds: 10),
                    ),
                  ],
                  isRepeatingAnimation: false,
                  onFinished: () {
                    setState(() {
                      showQuestions = true;
                    });
                  },
                ),
              ],
              if (showQuestions) ...[
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
                      speed: const Duration(milliseconds: 10),
                    ),
                  ],
                  isRepeatingAnimation: false,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
