import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:docsview/utils/app_colors.dart';

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
  bool isDisposed = false;
  int totalPages = 0;
  int currentPage = 0;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadLastPage();
    _downloadPDF();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
    isDisposed = true;
  }

  Future<void> _downloadPDF() async {
    try {
      print("Starting download for: ${widget.pdfUrl}");
      final response = await _getHttpResponse(widget.pdfUrl);

      if (response != null && response.statusCode == 200) {
        print("Download successful, saving file...");
        final filePath = await _saveFileLocally(response.bodyBytes);
        print("File saved locally at: $filePath");
        if (!isDisposed) {
          setState(() {
            localPath = filePath;
            isLoading = false;
          });
        }
      } else {
        _handleError("Unable to download the file.");
        print("Download failed. HTTP status code: ${response?.statusCode}");
      }
    } on TimeoutException {
      _handleError("The request timed out. Please try again.");
      print("Timeout occurred while downloading the PDF.");
    } catch (e) {
      _handleError("Something went wrong. Please try again later.");
      print("Error during download: $e");
    }
  }

  Future<http.Response?> _getHttpResponse(String url) async {
    try {
      return await http
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 80));
    } catch (e) {
      print("Error in HTTP request: $e");
      return null;
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

  Future<void> _loadLastPage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      currentPage = prefs.getInt('lastPage') ?? 0;
    });
  }

  Future<void> _saveLastPage(int page) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('lastPage', page);
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: AppColors.themeColor,
                  ),
                  SizedBox(
                    height: 22,
                  ),
                  Text("Large file take time, please wait while loading"),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Recommended :  ",
                        style: TextStyle(
                            color: AppColors.themeColor,
                            fontWeight: FontWeight.bold),
                      ),
                      Text("First download, then see"),
                    ],
                  )
                ],
              ),
            )
          : errorMessage != null
              ? _buildErrorUI()
              : localPath != null
                  ? Column(
                      children: [
                        Expanded(
                          child: PDFView(
                            filePath: localPath!,
                            enableSwipe: true,
                            swipeHorizontal: false,
                            autoSpacing: true,
                            pageFling: true,
                            defaultPage: currentPage,
                            onError: (error) {
                              _showErrorSnackBar(
                                  "Error loading the PDF. Please try again.");
                              print("PDFView Error: $error");
                            },
                            onPageError: (page, error) {
                              _showErrorSnackBar(
                                  "Error on page $page. Please try again.");
                              print("Error on page $page: $error");
                            },
                            onPageChanged: (page, total) {
                              if (!isDisposed) {
                                setState(() {
                                  currentPage = page!;
                                  totalPages = total!;
                                });
                                _saveLastPage(currentPage);
                              }
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Page ${currentPage + 1} of $totalPages",
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
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
