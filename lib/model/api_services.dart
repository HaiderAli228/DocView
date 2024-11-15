import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:http_parser/http_parser.dart';

const String geminiApiEndpoint = "YOUR_GEMINI_API_ENDPOINT"; // Update this
const String apiKey = "YOUR_API_KEY"; // Replace with actual API Key

Future<String> generateContentFromPdf(File pdfFile, String prompt) async {
  var request = http.MultipartRequest('POST', Uri.parse(geminiApiEndpoint));

  // Attach the PDF file to the request
  request.files.add(await http.MultipartFile.fromPath(
    'file',
    pdfFile.path,
    contentType: MediaType('application', 'pdf'),
  ));

  // Add prompt and API Key
  request.headers['Authorization'] = 'Bearer $apiKey';
  request.fields['prompt'] = prompt;

  var response = await request.send();

  if (response.statusCode == 200) {
    var responseBody = await response.stream.bytesToString();
    var data = jsonDecode(responseBody);
    return data['text'] ?? "No response text found."; // Handling empty text
  } else {
    throw Exception(
        'Failed to process PDF. Status Code: ${response.statusCode}, Error: ${response.reasonPhrase}');
  }
}
