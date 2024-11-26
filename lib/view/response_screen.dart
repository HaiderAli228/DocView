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

  int currentOutlineIndex = 0;

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

  void _showNextOutline() {
    if (currentOutlineIndex < outlines.length - 1) {
      setState(() {
        currentOutlineIndex++;
      });
    } else {
      setState(() {
        showQuestions = true; // Move to questions after all outlines
      });
    }
  }

  late final List<String> outlines;
  late final String summary;
  late final String questions;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Initialize response data
    outlines = widget.response['outlines'] is String
        ? (widget.response['outlines'] as String).split('\n') // Assume newline-separated list
        : (widget.response['outlines'] as List<dynamic>? ?? []).cast<String>();
    summary = widget.response['summary'] ?? 'No summary available.';
    questions = widget.response['questions'] ?? 'No questions found.';
  }

  @override
  Widget build(BuildContext context) {
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
                      speed: const Duration(milliseconds: 20),
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
                if (outlines.isNotEmpty)
                  Column(
                    children: List.generate(currentOutlineIndex + 1, (index) {
                      return AnimatedTextKit(
                        animatedTexts: [
                          TypewriterAnimatedText(
                            '\u2022 ${outlines[index]}',
                            textStyle: const TextStyle(fontSize: 16),
                            speed: const Duration(milliseconds: 20),
                          ),
                        ],
                        isRepeatingAnimation: false,
                        onFinished: index == currentOutlineIndex
                            ? _showNextOutline
                            : null,
                      );
                    }),
                  )
                else
                  AnimatedTextKit(
                    animatedTexts: [
                      TypewriterAnimatedText(
                        'No outline available.',
                        textStyle: const TextStyle(fontSize: 16),
                        speed: const Duration(milliseconds: 20),
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
                      speed: const Duration(milliseconds: 20),
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
