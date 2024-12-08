import 'dart:io';

import 'package:docsview/utils/app_colors.dart';
import 'package:docx_to_text/docx_to_text.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

import '../model/api_services.dart';
import '../utils/toast_msg.dart';
import 'ai_response_view.dart';
class AiView extends StatefulWidget {
  const AiView({super.key});

  @override
  State<AiView> createState() => _AiViewState();
}

class _AiViewState extends State<AiView> {
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
        fileContent = docxToText(bytes); // Await the docxToText correctly
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

      // Navigate to ResultScreen with the processed content
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
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: AppColors.themeColor,
        title: const Text("AI Assistant",style: TextStyle(
          color: Colors.white,
          fontFamily: "Poppins",
          fontWeight: FontWeight.bold,
          fontSize: 20
        ),),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
        child: Stack(
          children: [
            Column(
              children: [
                const SizedBox(height: 20),
                InkWell(
                  onTap: pickFile,
                  child: Container(
                    height: 150,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(5),
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
                    height: 55,
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
          ]
        ),
      ),
    );
  }
}
