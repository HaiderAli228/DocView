import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:http_parser/http_parser.dart';
import '../utils/app_links.dart'; // Import the constants class

Future<Map<String, String>> generateContentFromFile(
    File file, String prompt) async {
  final String mimeType = _getMimeType(file.path);

  var request =
      http.MultipartRequest('POST', Uri.parse(ApiConstants.geminiApiEndpoint));

  // Attach the file to the request
  request.files.add(await http.MultipartFile.fromPath(
    'file',
    file.path,
    contentType: MediaType(mimeType.split('/')[0], mimeType.split('/')[1]),
  ));

  // Add prompt and API Key
  request.headers['Authorization'] = 'Bearer ${ApiConstants.apiKey}';
  request.fields['prompt'] = prompt;

  var response = await request.send();

  if (response.statusCode == 200) {
    var responseBody = await response.stream.bytesToString();
    var data = jsonDecode(responseBody);

    // Return summary and outlines
    return {
      "summary": data['summary'] ?? "No summary available.",
      "outlines": data['outlines'] ?? "No outlines available."
    };
  } else {
    throw Exception(
        'Failed to process file. Status Code: ${response.statusCode}, Error: ${response.reasonPhrase}');
  }
}

// Helper function to get MIME type
String _getMimeType(String filePath) {
  final extension = filePath.split('.').last;
  switch (extension) {
    case 'pdf':
      return 'application/pdf';
    case 'js':
      return 'application/x-javascript';
    case 'py':
      return 'application/x-python';
    case 'txt':
      return 'text/plain';
    case 'html':
      return 'text/html';
    case 'css':
      return 'text/css';
    case 'md':
      return 'text/md';
    case 'csv':
      return 'text/csv';
    case 'xml':
      return 'text/xml';
    case 'rtf':
      return 'text/rtf';
    default:
      return 'application/octet-stream';
  }
}
