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

  // Pick a PDF file from the device
  Future<void> pickPdf() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      setState(() {
        _pdfFile = File(result.files.single.path!);
        ToastHelper.showToast("PDF file selected.");
      });
    } else {
      ToastHelper.showToast("No file selected.");
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
        ToastHelper.showToast("Error processing PDF: $e");
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      ToastHelper.showToast("No PDF file selected!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            children: [
              Column(
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
                      margin: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 10),
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
                    padding: const EdgeInsets.symmetric(horizontal: 15),
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
                    onTap: _isLoading ? null : processPdf,
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
              if (_isLoading)
                Center(
                  child: Lottie.asset(
                    "assets/images/loading.json",
                    alignment: Alignment.center,
                    repeat: true,
                    fit: BoxFit.cover,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
