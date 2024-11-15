import 'package:flutter/material.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';

import '../model/api-services.dart';

class FirstTabScanner extends StatefulWidget {
  const FirstTabScanner({super.key});

  @override
  State<FirstTabScanner> createState() => _FirstTabScannerState();
}

class _FirstTabScannerState extends State<FirstTabScanner> {
  File? _pdfFile;

  // Pick a PDF file from the device
  Future<void> pickPdf() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      setState(() {
        _pdfFile = File(result.files.single.path!);
      });
    }
  }

  // Call the API to process PDF
  Future<void> processPdf() async {
    if (_pdfFile != null) {
      String prompt = "Give me a summary of this PDF file.";
      try {
        String result = await generateContentFromPdf(_pdfFile!, prompt);
        print(result); // For now, print the result
        // You can navigate to another screen or display the result
      } catch (e) {
        print("Error processing PDF: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('PDF Scanner')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _pdfFile == null
                ? const Text('No PDF selected')
                : Text('Selected PDF: ${_pdfFile!.path}'),
            ElevatedButton(
              onPressed: pickPdf,
              child: const Text('Pick PDF'),
            ),
            ElevatedButton(
              onPressed: processPdf,
              child: const Text('Process PDF'),
            ),
          ],
        ),
      ),
    );
  }
}
