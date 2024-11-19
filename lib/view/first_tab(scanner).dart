import 'package:docsview/view/second_tab(paper).dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:lottie/lottie.dart';
import '../model/api_services.dart';
import '../utils/app_colors.dart';
import '../utils/toast_msg.dart'; // Import ToastHelper

class FirstTabScanner extends StatefulWidget {
  const FirstTabScanner({super.key});

  @override
  State<FirstTabScanner> createState() => _FirstTabScannerState();
}

class _FirstTabScannerState extends State<FirstTabScanner> {
  File? _pdfFile;
  bool _isLoading = false;

  // Pick a PDF or other allowed file
  Future<void> pickFile() async {
    try {
      // Allow picking files with specified extensions
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: [
          'pdf',
          'js',
          'py',
          'txt',
          'html',
          'css',
          'md',
          'csv',
          'xml',
          'rtf',
        ],
      );

      if (result != null) {
        // Update the state with the selected file
        setState(() {
          _pdfFile = File(result.files.single.path!);
        });

        // Show a toast confirming the selection
        ToastHelper.showToast("File selected: ${result.files.single.name}");
      } else {
        // Handle the case where no file is selected
        ToastHelper.showToast("No file selected.");
      }
    } catch (e) {
      // Catch any unexpected errors during file picking
      ToastHelper.showToast("Error picking file: $e");
    }
  }

// Process the selected file
  Future<void> processFile() async {
    if (_pdfFile != null) {
      // Validate file extension
      final validExtensions = [
        'pdf',
        'js',
        'py',
        'txt',
        'html',
        'css',
        'md',
        'csv',
        'xml',
        'rtf',
      ];
      final fileExtension = _pdfFile!.path.split('.').last.toLowerCase();

      if (!validExtensions.contains(fileExtension)) {
        ToastHelper.showToast("Invalid file type. Please select a valid file.");
        return;
      }

      // Define the prompt for processing
      String prompt = "Provide a summary and outlines for this document.";

      // Show loading state
      setState(() {
        _isLoading = true;
      });

      try {
        // Step 1: Upload the document to get the file ID
        final fileId = await ApiService.uploadDocument(_pdfFile!);
        if (fileId == null) {
          ToastHelper.showToast("File upload failed. Please try again.");
          return;
        }

        // Step 2: Use the file ID to generate content
        final result = await ApiService.generateDocumentContent(fileId, prompt);
        if (result == null) {
          ToastHelper.showToast(
              "Failed to process the file. Please try again.");
          return;
        }

        // Step 3: Navigate to the result screen with summary and outlines
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SecondTabPaper(
              summary: result['summary']!,
              outlines: result['outlines']!,
            ),
          ),
        );
      } on SocketException {
        ToastHelper.showToast("Network error. Please check your connection.");
      } on HttpException {
        ToastHelper.showToast("Server error. Unable to process the file.");
      } on FormatException {
        ToastHelper.showToast("Invalid response format from the server.");
      } catch (e) {
        ToastHelper.showToast("An unexpected error occurred: $e");
      } finally {
        // Hide loading state
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      ToastHelper.showToast("No file selected!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: _isLoading
            ? const EdgeInsets.all(0)
            : const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
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
                    Container(
                      alignment: Alignment.center,
                      child: Lottie.asset("assets/images/4.json",
                          height: 200, fit: BoxFit.cover),
                    ),
                    InkWell(
                      onTap: pickFile,
                      child: Container(
                        height: 200,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(5),
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(10),
                          ),
                          border: Border.all(
                              color: Colors.grey.shade200,
                              style: BorderStyle.solid),
                        ),
                        child: _pdfFile == null
                            ? Column(
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
                                  ),
                                ],
                              )
                            : const Text(
                                'PDF Selected',
                                style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 13, right: 13, top: 20),
                      child: Text(
                        _pdfFile == null
                            ? 'No PDF selected'
                            : 'Selected PDF: ${_pdfFile!.path.split('/').last}',
                        style: const TextStyle(
                            fontFamily: "Poppins",
                            overflow: TextOverflow.clip,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    InkWell(
                      onTap: _isLoading ? null : processFile,
                      child: Container(
                        height: 50,
                        padding: const EdgeInsets.all(5),
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 20),
                        decoration: const BoxDecoration(
                          color: AppColors.themeColor,
                          borderRadius: BorderRadius.all(Radius.circular(6)),
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          "Process PDF",
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: "Poppins",
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (_isLoading)
                Center(
                  child: Container(
                    decoration: const BoxDecoration(
                        borderRadius:
                            BorderRadius.all(Radius.circular(10)),
                        color: Colors.white),
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          color: Colors.white
                              .withOpacity(0.8), // Semi-transparent overlay
                          alignment: Alignment.center,
                          child: Lottie.asset(
                            "assets/images/loading.json",
                            repeat: true,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const Text(
                          "Please wait until PDF process",
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontFamily: "Poppins"),
                        )
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
