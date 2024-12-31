import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:lottie/lottie.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

import 'package:docsview/utils/app_colors.dart';

class PDFViewerScreen extends StatefulWidget {
  final String pdfUrl;

  const PDFViewerScreen({super.key, required this.pdfUrl});

  @override
  _PDFViewerScreenState createState() => _PDFViewerScreenState();
}

class _PDFViewerScreenState extends State<PDFViewerScreen> {
  String? localPath;
  bool isLoading = true;
  String? errorMessage;
  bool isDisposed = false;

  @override
  void initState() {
    super.initState();
    _downloadPDF();
  }

  @override
  void dispose() {
    super.dispose();
    isDisposed = true;
  }

  Future<void> _downloadPDF() async {
    try {
      final response = await _getHttpResponse(widget.pdfUrl);

      if (response != null && response.statusCode == 200) {
        final filePath = await _saveFileLocally(response.bodyBytes);
        if (!isDisposed) {
          setState(() {
            localPath = filePath;
            isLoading = false;
          });
        }
      } else {
        _handleError("Unable to download the file.");
      }
    } on TimeoutException {
      _handleError("The request timed out. Please try again.");
    } catch (e) {
      _handleError("Something went wrong. Please try again later.");
    }
  }

  Future<http.Response?> _getHttpResponse(String url) async {
    try {
      final response = await http.get(Uri.parse(url)).timeout(const Duration(seconds: 10));
      return response;
    } catch (_) {
      return null; // Return null in case of any error (e.g., no internet)
    }
  }

  Future<String> _saveFileLocally(List<int> bytes) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File("${directory.path}/temp.pdf");
    await file.writeAsBytes(bytes);
    return file.path;
  }

  void _handleError(String message) {
    if (!isDisposed) {
      setState(() {
        errorMessage = message;
        isLoading = false;
      });
    }
  }

  void _retryDownload() {
    if (!isDisposed) {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });
    }
    _downloadPDF();
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
          ? _buildErrorUI()
          : localPath != null
          ? PDFView(
        filePath: localPath!,
        enableSwipe: true,
        swipeHorizontal: true,
        autoSpacing: true,
        pageFling: true,
        onError: (error) =>
            _showErrorSnackBar("Error loading the PDF. Please try again."),
        onPageError: (page, error) =>
            _showErrorSnackBar("Error on page $page. Please try again."),
      )
          : const Center(
        child: Text(
          "Unable to display PDF.",
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildErrorUI() {
    return Center(
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
            style: const TextStyle(fontSize: 16, color: Colors.red),
          ),
          const SizedBox(height: 16),
          InkWell(
            onTap: _retryDownload,
            child: Container(
              height: 50,
              width: 200,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                  color: AppColors.themeColor,
                  borderRadius: BorderRadius.all(Radius.circular(8))),
              child: const Text(
                "Retry",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
