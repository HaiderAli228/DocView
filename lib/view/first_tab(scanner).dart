import 'package:docsview/view/response_screen.dart';
import 'package:flutter/material.dart';
import 'package:docx_to_text/docx_to_text.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import '../model/api_services.dart';
import '../utils/app_colors.dart';
import '../utils/toast_msg.dart';

class FirstTabScanner extends StatefulWidget {
  const FirstTabScanner({super.key});

  @override
  State<FirstTabScanner> createState() => _FirstTabScannerState();
}

class _FirstTabScannerState extends State<FirstTabScanner> {
  File? selectedFile;
  bool isLoading = false;

  Future<void> pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['txt', 'docx', 'pdf'], // Supported formats
      );

      if (result != null && result.files.isNotEmpty) {
        setState(() {
          selectedFile = File(result.files.single.path!);
        });
        ToastHelper.showToast('File selected successfully.');
      } else {
        setState(() {
          selectedFile = null;
        });
        ToastHelper.showToast('No file selected.');
      }
    } catch (e) {
      ToastHelper.showToast('Error picking file: $e');
    }
  }

  Future<void> processFile() async {
    if (selectedFile == null) {
      ToastHelper.showToast('Please select a file to process.');
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      String fileContent = '';

      // Check the file extension and read it accordingly
      if (selectedFile!.path.endsWith('.txt')) {
        fileContent = await selectedFile!.readAsString();
      } else if (selectedFile!.path.endsWith('.docx')) {
        final bytes = await selectedFile!.readAsBytes();
        fileContent = docxToText(bytes);
      } else if (selectedFile!.path.endsWith('.pdf')) {
        final pdfBytes = await selectedFile!.readAsBytes();
        final pdfDocument = PdfDocument(inputBytes: pdfBytes);
        fileContent = PdfTextExtractor(pdfDocument).extractText();
      } else {
        throw Exception('Unsupported file format.');
      }

      // Process the file content using GeminiService
      final geminiService = GeminiService();
      final response = await geminiService.processDocument(fileContent);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(response: response),
        ),
      );
    } catch (e) {
      ToastHelper.showToast('Error processing file: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    RichText(
                      text: const TextSpan(
                        style: TextStyle(fontSize: 25),
                        children: [
                          TextSpan(
                              text: "Upload and scan your document with ",
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
                    ),
                    Center(
                      child: Lottie.asset("assets/images/4.json",
                          height: 200, fit: BoxFit.cover),
                    ),
                    InkWell(
                      onTap: pickFile,
                      child: Container(
                        height: 170,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(5),
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: Colors.grey.shade200,
                              style: BorderStyle.solid),
                        ),
                        child: selectedFile == null
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
                                    ),
                                  ),
                                ],
                              )
                            : Text(
                                'File Selected: ${selectedFile!.path.split('/').last}',
                                style: const TextStyle(
                                  fontFamily: "Poppins",
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    InkWell(
                      onTap: isLoading ? null : processFile,
                      child: Container(
                        height: 50,
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: AppColors.themeColor,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          "Process File",
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
              if (isLoading)
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Lottie.asset(
                          "assets/images/loading.json",
                          repeat: true,
                          fit: BoxFit.cover,
                        ),
                        const Text(
                          "Please wait while the file is processed",
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontFamily: "Poppins"),
                        ),
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
