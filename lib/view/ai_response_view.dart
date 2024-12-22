import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:docsview/utils/app_colors.dart';
import 'package:flutter/material.dart';

class ResultScreenOfAI extends StatefulWidget {
  final Map<String, dynamic> response;

  const ResultScreenOfAI({super.key, required this.response});

  @override
  _ResultScreenOfAIState createState() => _ResultScreenOfAIState();
}

class _ResultScreenOfAIState extends State<ResultScreenOfAI> {
  bool showSummary = false;
  bool showOutlines = false;
  bool showQuestions = false;

  int currentOutlineIndex = 0;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        showSummary = true;
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _showNextOutline() {
    if (currentOutlineIndex < outlines.length - 1) {
      setState(() {
        currentOutlineIndex++;
      });
      _scrollToBottom();
    } else {
      setState(() {
        showQuestions = true; // Move to questions after all outlines
      });
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOut,
      );
    });
  }

  late final List<String> outlines;
  late final String summary;
  late final String questions;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    outlines = widget.response['outlines'] is String
        ? (widget.response['outlines'] as String).split('\n')
        : (widget.response['outlines'] as List<dynamic>? ?? []).cast<String>();
    summary = widget.response['summary'] ?? 'No summary available.';
    questions = widget.response['questions'] ?? 'No questions found.';
  }

  String _formatOutline(String outline) {
    return outline.replaceAll('*', '').trim();
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
          controller: _scrollController,
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
                    _scrollToBottom();
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (int i = 0; i <= currentOutlineIndex; i++)
                        AnimatedTextKit(
                          animatedTexts: [
                            TypewriterAnimatedText(
                              _formatOutline(outlines[i]),
                              textStyle: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                                color: Colors.black,
                              ),
                              speed: const Duration(milliseconds: 20),
                            ),
                          ],
                          isRepeatingAnimation: false,
                          onFinished: i == currentOutlineIndex
                              ? _showNextOutline
                              : null,
                        ),
                    ],
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
                      _scrollToBottom();
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
                  onFinished: _scrollToBottom,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
