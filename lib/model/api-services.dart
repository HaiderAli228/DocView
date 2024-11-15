import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:http_parser/http_parser.dart';

Future<String> generateContentFromPdf(File pdfFile, String prompt) async {
  var request = http.MultipartRequest(
      'POST',
      Uri.parse('YOUR_GEMINI_API_ENDPOINT') // Replace with actual endpoint
  );

  // Attach the PDF file to the request
  request.files.add(await http.MultipartFile.fromPath(
      'file',
      pdfFile.path,
      contentType: MediaType('application', 'pdf')
  ));

  // Add prompt to the fields
  request.fields['prompt'] = prompt;

  var response = await request.send();

  if (response.statusCode == 200) {
    var responseBody = await response.stream.bytesToString();
    var data = jsonDecode(responseBody);
    return data['text']; // Assuming 'text' contains the output from the API
  } else {
    throw Exception('Failed to process PDF');
  }
}
