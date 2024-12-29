import 'package:docsview/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:lottie/lottie.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

class PDFViewerScreen extends StatefulWidget {
  final String pdfUrl;

  const PDFViewerScreen({super.key, required this.pdfUrl});

  @override
  PDFViewerScreenState createState() => PDFViewerScreenState();
}

class PDFViewerScreenState extends State<PDFViewerScreen> {
  String? localPath;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    downloadPDF();
  }

  Future<void> downloadPDF() async {
    try {
      final response = await http
          .get(Uri.parse(widget.pdfUrl))
          .timeout(const Duration(seconds: 10)); // Add timeout

      if (response.statusCode == 200) {
        final directory = await getApplicationDocumentsDirectory();
        final filePath = "${directory.path}/temp.pdf";

        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);

        setState(() {
          localPath = filePath;
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = "Unable to download the file.";
          isLoading = false;
        });
      }
    } on TimeoutException {
      setState(() {
        errorMessage = "The request timed out. Please try again.";
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = "Something went wrong, try again later.";
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("PDF Viewer"),
        backgroundColor: AppColors.themeColor,
        foregroundColor: Colors.white,
      ),
      body: isLoading
          ? const Center(
        child: CircularProgressIndicator(
          color: AppColors.themeColor,
        ),
      )
          : errorMessage != null
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/images/internetError.json',
              height: 300,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 16),
            Text(
              errorMessage!,
              textAlign: TextAlign.center,
              style:
              const TextStyle(fontSize: 16, color: Colors.red),
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: () {
                setState(() {
                  isLoading = true;
                  errorMessage = null;
                });
                downloadPDF();
              },
              child: Container(
                height: 50,
                width: 200,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                    color: AppColors.themeColor,
                    borderRadius:
                    BorderRadius.all(Radius.circular(8))),
                child: const Text(
                  "Retry",
                  style: TextStyle(
                      color: Colors.white, fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      )
          : localPath != null
          ? PDFView(
        filePath: localPath!,
        enableSwipe: true,
        swipeHorizontal: true,
        autoSpacing: true,
        pageFling: true,
        onError: (error) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text(
                    "Error loading the PDF. Please try again.")),
          );
        },
        onPageError: (page, error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
                    "Error on page $page. Please try again.")),
          );
        },
      )
          : const Center(
        child: Text(
          "Unable to display PDF.",
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
