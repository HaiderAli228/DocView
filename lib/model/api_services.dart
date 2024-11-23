// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/services.dart';
// import 'package:googleapis_auth/auth_io.dart';
// import 'package:http/http.dart' as http;
//
// class ApiService {
//   static String apiKey =
//       "AIzaSyDJMHlDV3WXUg8a7B5DJL1ifgbe_9BDdak"; // Replace with your API key
//   static const String fileUploadEndpoint =
//       "https://language.googleapis.com/v1beta1/projects/flutter-428311/locations/global/media";
//   static const String contentGenerationEndpoint =
//       "https://language.googleapis.com/v1beta1/projects/YOUR_PROJECT_ID/locations/global/models:generateContent";
//
//   static late AutoRefreshingAuthClient client;
//
//   /// Initializes authentication using the service account.
//   static Future<void> initializeAuthentication() async {
//     try {
//       // Read service account credentials from a secure location (e.g., assets)
//       final serviceAccountJson =
//       await rootBundle.loadString('assets/service_account.json');
//       final credentials = ServiceAccountCredentials.fromJson(
//         jsonDecode(serviceAccountJson),
//       );
//
//       // Authenticate using clientViaServiceAccount
//       client = await clientViaServiceAccount(
//         credentials,
//         ['https://www.googleapis.com/auth/cloud-platform'], // Scopes for Google Cloud APIs
//       );
//
//       print("Authentication initialized successfully.");
//     } catch (e) {
//       print("Error during authentication initialization: $e");
//     }
//   }
//
//   /// Uploads a file to the server and returns the file ID.
//   static Future<String?> uploadDocument(File file) async {
//     try {
//       var request =
//       http.MultipartRequest('POST', Uri.parse(fileUploadEndpoint));
//       request.headers['Authorization'] = 'Bearer ${client.credentials.accessToken.data}';
//       request.files.add(await http.MultipartFile.fromPath('file', file.path));
//
//       var response = await request.send();
//       if (response.statusCode == 200) {
//         var responseData = await response.stream.bytesToString();
//         var jsonResponse = jsonDecode(responseData);
//         return jsonResponse[
//         'file_id']; // Replace with the actual key for file ID
//       } else {
//         print(
//             "Upload failed: ${response.statusCode} - ${response.reasonPhrase}");
//       }
//     } catch (e) {
//       print("Error during file upload: $e");
//     }
//     return null;
//   }
//
//   /// Generates content for the uploaded file using the provided prompt.
//   static Future<Map<String, String>?> generateDocumentContent(
//       String fileId, String prompt) async {
//     try {
//       final response = await client.post(
//         Uri.parse(contentGenerationEndpoint),
//         headers: {
//           'Authorization': 'Bearer ${client.credentials.accessToken.data}',
//           'Content-Type': 'application/json',
//         },
//         body: jsonEncode({
//           'file_id': fileId,
//           'prompt': prompt,
//           'model_name':
//           'gemini-1.5-flash', // Replace with your specific model name
//         }),
//       );
//
//       if (response.statusCode == 200) {
//         var jsonResponse = jsonDecode(response.body);
//         return {
//           "summary": jsonResponse['summary'] ?? "No summary available.",
//           "outlines": jsonResponse['outlines'] ?? "No outlines available.",
//         };
//       } else {
//         print(
//             "Content generation failed: ${response.statusCode} - ${response.reasonPhrase}");
//       }
//     } catch (e) {
//       print("Error during content generation: $e");
//     }
//     return null;
//   }
// }
import 'package:google_generative_ai/google_generative_ai.dart';

import '../utils/app_links.dart';

class GeminiService {

  Future<Map<String, dynamic>> processDocument(String fileContent) async {
    final model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: ApiConstants.apiKey
    );

    try {
      // Generate content using the extracted file content
      final response = await model.generateContent([
        Content.text('Summarize this text:'),
        Content.text(fileContent),
      ]);

      return {
        'summary': response.text ?? 'No summary generated.',
      };
    } catch (e) {
      throw Exception('Error generating content: $e');
    }
  }
}
