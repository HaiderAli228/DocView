import 'dart:async';
import 'dart:io';

import 'package:google_generative_ai/google_generative_ai.dart';

import '../utils/app_links.dart';

class GeminiService {
  Future<Map<String, dynamic>> processDocument(String fileContent) async {
    final model = GenerativeModel(
      model: 'gemini-1.5-flash', // Replace with your actual model name
      apiKey: ApiConstants.apiKey, // Your API key
    );

    try {
      // Set timeout for the API call to avoid long waits
      final summaryResponse = await model.generateContent([
        Content.text('Summarize this text:'),
        Content.text(fileContent),
      ]).timeout(const Duration(seconds: 30)); // 30 seconds timeout

      final outlineResponse = await model.generateContent([
        Content.text('Provide an outline of this text:'),
        Content.text(fileContent),
      ]).timeout(const Duration(seconds: 30)); // 30 seconds timeout

      return {
        'summary': summaryResponse.text ?? 'No summary generated.',
        'outlines': outlineResponse.text ?? 'No outlines generated.',
      };
    } catch (e) {
      // Handle network and timeout exceptions
      if (e is TimeoutException) {
        throw Exception('Request timed out. Please try again later.');
      } else if (e is SocketException) {
        throw Exception('Network error. Please check your internet connection.');
      } else {
        throw Exception('Error generating content: $e');
      }
    }
  }
}
