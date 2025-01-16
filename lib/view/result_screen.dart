import 'dart:io';
import 'package:docsview/view/pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../utils/app_colors.dart';
import '../utils/shimmer_widget.dart';
import '../view-model/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ResultScreen extends StatelessWidget {
  final String folderId;
  final String folderName;

  const ResultScreen({
    super.key,
    required this.folderId,
    required this.folderName,
  });

  // Generate file URL to fetch file from Google Drive API
  String generateFileUrl(String fileId, String apiKey) {
    return "https://www.googleapis.com/drive/v3/files/$fileId?alt=media&key=$apiKey";
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ResultScreenProvider()..initialize(folderId, folderName),
      child: Scaffold(
        backgroundColor: Colors.white.withOpacity(0.98),
        appBar: AppBar(
          backgroundColor: AppColors.themeColor,
          foregroundColor: Colors.white,
          title: Consumer<ResultScreenProvider>(
            builder: (context, provider, _) => Text(provider.currentFolderName),
          ),
          leading: Consumer<ResultScreenProvider>(
            builder: (context, provider, _) => IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                // Navigate back if possible, otherwise pop the screen
                if (provider.navigationStack.isNotEmpty) {
                  provider.navigateBack();
                } else {
                  Navigator.pop(context);
                }
              },
            ),
          ),
        ),
        body: Consumer<ResultScreenProvider>(
          builder: (context, provider, _) {
            // Show shimmer effect if data is loading
            if (provider.isLoading) {
              return Padding(
                padding: const EdgeInsets.all(20),
                child: ShimmerEffect.shimmerEffect(countValue: 6),
              );
            }
            // Show error message if there's an issue
            if (provider.errorMessage != null) {
              return Padding(
                padding: const EdgeInsets.all(12.0),
                child: Center(child: Text(provider.errorMessage!)),
              );
            }
            // Show a progress animation if no folder contents are available
            if (provider.folderContents.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Lottie.asset("assets/images/progress.json"),
                    const Text(
                      'Working on it, available soon',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              );
            }

            // Separate folders and files from the contents
            final folders = provider.folderContents
                .where((item) =>
                    item['mimeType'] == 'application/vnd.google-apps.folder')
                .toList();
            final files = provider.folderContents
                .where((item) =>
                    item['mimeType'] != 'application/vnd.google-apps.folder')
                .toList();

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Display folder grid if available
                  if (folders.isNotEmpty)
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount:
                            MediaQuery.of(context).size.width > 600 ? 4 : 2,
                        crossAxisSpacing: 17,
                        mainAxisSpacing: 17,
                        childAspectRatio: 1,
                      ),
                      itemCount: folders.length,
                      itemBuilder: (context, index) {
                        final folder = folders[index];
                        return GestureDetector(
                          onTap: () => provider.navigateToFolder(
                            folder['id'] ?? '',
                            folder['name'] ?? 'Unknown Folder',
                          ),
                          child: _buildFolderCard(folder),
                        );
                      },
                    ),
                  const SizedBox(height: 16),

                  // Display file list if available
                  if (files.isNotEmpty)
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: files.length,
                      itemBuilder: (context, index) {
                        final file = files[index];
                        final String fileUrl = generateFileUrl(
                          file['id'] ?? '',
                          dotenv.env['API_KEY'] ?? '',
                        );
                        return _buildFileCard(file, fileUrl, context);
                      },
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // Helper function to build folder card widget
  Widget _buildFolderCard(Map folder) {
    return Card(
      elevation: 8,
      color: Colors.white,
      shadowColor: Colors.grey.withOpacity(0.5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              getDepartmentIcon(folder['mimeType'] ?? ''),
              width: 50,
              height: 50,
            ),
            const SizedBox(height: 8),
            Text(
              folder['name'] ?? 'Unknown',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }

  // Helper function to build file card widget
  Widget _buildFileCard(Map file, String fileUrl, BuildContext context) {
    return Card(
      elevation: 5,
      color: Colors.white.withOpacity(0.95),
      shadowColor: Colors.grey.withOpacity(0.5),
      margin: const EdgeInsets.only(bottom: 25),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              'assets/images/file.png',
              width: 55,
              height: 55,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    file['name'] ?? 'Unknown File',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                  ),
                  const SizedBox(height: 8),
                  _buildFileActions(fileUrl, file['name'] ?? '', context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper function to build file action buttons (Download, View)
  Widget _buildFileActions(String fileUrl, String fileName, BuildContext context) {
    // Derive fileType from fileName or MIME type
    String fileType = fileName.split('.').last.toLowerCase(); // Extract extension

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        InkWell(
          onTap: () => downloadFile(fileUrl, fileName, context),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.42, // Make download button wider
            padding: const EdgeInsets.symmetric(vertical: 7),
            margin: const EdgeInsets.symmetric(vertical: 5),
            decoration: BoxDecoration(
              color: Colors.purple,
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: const Text(
              'Download',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8), // Add some space between the buttons
        Container(
          width: MediaQuery.of(context).size.width * 0.2, // Make view button smaller
          padding: const EdgeInsets.symmetric(vertical: 7),
          margin: const EdgeInsets.symmetric(vertical: 5),
          decoration: BoxDecoration(
            color: AppColors.themeColor,
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PDFViewerScreen(fileUrl: fileUrl, fileType: fileType),
                ),
              );
            },
            child: const Text(
              'View',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }


  // Helper function to get appropriate department icon based on mimeType
  String getDepartmentIcon(String mimeType) {
    return mimeType == 'application/vnd.google-apps.folder'
        ? 'assets/images/defaultIcon.png' // Folder icon
        : 'assets/images/file.png'; // File icon
  }

  Future<void> storeFileMetadata(String fileName, String filePath) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> storedFiles = prefs.getStringList('downloaded_files') ?? [];

    // Create a metadata entry (e.g., fileName: filePath)
    String metadata = '$fileName:$filePath';
    storedFiles.add(metadata);

    // Save the list of file metadata back to SharedPreferences
    await prefs.setStringList('downloaded_files', storedFiles);
  }

  Future<void> downloadFile(
      String url, String fileName, BuildContext context) async {
    try {
      Fluttertoast.showToast(
          backgroundColor: AppColors.themeColor,
          gravity: ToastGravity.CENTER,
          toastLength: Toast.LENGTH_LONG,
          textColor: Colors.white,
          msg: "Downloading $fileName...");

      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final directory = await getApplicationDocumentsDirectory();
        final filePath = '${directory.path}/$fileName';

        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);

        // Store file metadata in SharedPreferences
        await storeFileMetadata(fileName, filePath);

        Fluttertoast.showToast(
            msg: "$fileName downloaded successfully.",
            gravity: ToastGravity.BOTTOM,
            toastLength: Toast.LENGTH_SHORT,
            backgroundColor: AppColors.themeColor,
            textColor: Colors.white);
        _showOpenFileDialog(context, filePath, fileName);
      } else {
        Fluttertoast.showToast(
            msg: "Failed to download $fileName",
            gravity: ToastGravity.BOTTOM,
            toastLength: Toast.LENGTH_SHORT,
            backgroundColor: Colors.red,
            textColor: Colors.white);
      }
    } catch (e) {
      Fluttertoast.showToast(
          msg: "Error: $e",
          gravity: ToastGravity.CENTER,
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: AppColors.themeColor,
          textColor: Colors.white);
    }
  }

// Function to show the dialog asking if the user wants to open the file
  // Function to show a dialog prompting the user to open the downloaded file
  void _showOpenFileDialog(
      BuildContext context, String filePath, String fileName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Download Complete'),
          content: Text('$fileName has been downloaded. Do you want to open it?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                OpenFile.open(filePath); // Open the downloaded file
              },
              child: const Text('Open'),
            ),
          ],
        );
      },
    );
  }

}
