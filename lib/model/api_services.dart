import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ApiService {
  static const String apiKey = "YOUR_GEMINI_API_KEY"; // Replace with your API key
  static const String fileUploadEndpoint = "https://api.gemini.com/v1/files/upload";
  static const String contentGenerationEndpoint = "https://api.gemini.com/v1/models/generateContent";

  /// Uploads a file to the server and returns the file ID.
  static Future<String?> uploadDocument(File file) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse(fileUploadEndpoint));
      request.headers['Authorization'] = 'Bearer $apiKey';
      request.files.add(await http.MultipartFile.fromPath('file', file.path));

      var response = await request.send();
      if (response.statusCode == 200) {
        var responseData = await response.stream.bytesToString();
        var jsonResponse = jsonDecode(responseData);
        return jsonResponse['file_id']; // Replace with the actual key for file ID
      } else {
        print("Upload failed: ${response.statusCode} - ${response.reasonPhrase}");
      }
    } catch (e) {
      print("Error during file upload: $e");
    }
    return null;
  }

  /// Generates content for the uploaded file using the provided prompt.
  static Future<Map<String, String>?> generateDocumentContent(String fileId, String prompt) async {
    try {
      final response = await http.post(
        Uri.parse(contentGenerationEndpoint),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'file_id': fileId,
          'prompt': prompt,
          'model_name': 'gemini-1.5-flash', // Replace with your specific model name
        }),
      );

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        return {
          "summary": jsonResponse['summary'] ?? "No summary available.",
          "outlines": jsonResponse['outlines'] ?? "No outlines available.",
        };
      } else {
        print("Content generation failed: ${response.statusCode} - ${response.reasonPhrase}");
      }
    } catch (e) {
      print("Error during content generation: $e");
    }
    return null;
  }
}
