import 'package:flutter/material.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';

import '../model/api_services.dart';
import '../utils/app_colors.dart';
import 'second_tab(paper).dart';

class FirstTabScanner extends StatefulWidget {
  const FirstTabScanner({super.key});

  @override
  State<FirstTabScanner> createState() => _FirstTabScannerState();
}

class _FirstTabScannerState extends State<FirstTabScanner> {
  File? _pdfFile;
  bool _isLoading = false;

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
      setState(() {
        _isLoading = true;
      });

      try {
        String result = await generateContentFromPdf(_pdfFile!, prompt);

        // Navigate to SecondTabPaper with the summary
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SecondTabPaper(summary: result),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error processing PDF: $e")),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No PDF file selected!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              RichText(
                text: const TextSpan(
                  style: TextStyle(fontSize: 27), // Responsive font size
                  children: [
                    TextSpan(
                        text: "Upload and scan your PDF with ",
                        style: TextStyle(
                            color: Colors.black, fontFamily: "Poppins")),
                    TextSpan(
                        text: "DocView",
                        style: TextStyle(
                            color: AppColors.themeColor,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Poppins")),
                  ],
                ),
                textAlign: TextAlign.left, // Align text to left
              ),
              InkWell(
                onTap: pickPdf,
                child: Container(
                  height: 200,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(5),
                  margin:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      border: Border.all(
                          color: Colors.grey.shade200,
                          style: BorderStyle.solid)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.cloud_upload_outlined,
                        color: Colors.grey.shade400,
                        size: 50,
                      ),
                      Text(
                        "Click to upload",
                        style: TextStyle(
                          color: Colors.grey.shade400,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          overflow: TextOverflow.fade,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              _pdfFile == null
                  ? const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 15,
                      ),
                      child: Text(
                        'No PDF selected',
                        style: TextStyle(
                            fontFamily: "Poppins", overflow: TextOverflow.clip),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                      ),
                      child: Text(
                        'Selected PDF: ${_pdfFile!.path}',
                        style: const TextStyle(
                            fontFamily: "Poppins", overflow: TextOverflow.clip),
                      ),
                    ),
              ElevatedButton(
                onPressed: _isLoading ? null : processPdf,
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Process PDF'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
