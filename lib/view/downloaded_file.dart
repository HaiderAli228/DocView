import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/app_colors.dart';

class DownloadedFilesScreen extends StatelessWidget {
  const DownloadedFilesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.themeColor, // Custom theme color
        foregroundColor: Colors.white,
        title: const Text('Downloaded Files'),

      ),
      body: FutureBuilder<List<String>>(
        future: _getDownloadedFiles(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
                child:
                    _buildErrorScreen()); // Error state with Lottie animation
          }

          final downloadedFiles = snapshot.data ?? [];
          if (downloadedFiles.isEmpty) {
            return Center(
                child:
                    _buildNoFilesScreen()); // No files state with Lottie animation
          }

          return LayoutBuilder(
            builder: (context, constraints) {
              // Ensure 2 items per row
              int crossAxisCount = 2;

              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount:
                      crossAxisCount, // Set to 2 for two items per row
                  childAspectRatio: 1.0, // Aspect ratio for each grid item
                ),
                itemCount: downloadedFiles.length,
                itemBuilder: (context, index) {
                  final fileMetadata = downloadedFiles[index];
                  final fileParts = fileMetadata.split(':');
                  final fileName = fileParts[0];
                  final filePath = fileParts[1];

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      color: Colors.white,
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: InkWell(
                        onTap: () {
                          OpenFile.open(filePath);
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.book, // Book icon
                              color: AppColors.themeColor, // Custom color
                              size: 40,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              fileName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Future<List<String>> _getDownloadedFiles() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('downloaded_files') ?? [];
  }

  // Show Lottie animation when there are no downloaded files
  Widget _buildNoFilesScreen() {
    return const SingleChildScrollView(
      // Wrapping with SingleChildScrollView to allow scrolling
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'No files downloaded',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }

  // Show Lottie animation for error state
  Widget _buildErrorScreen() {
    return const SingleChildScrollView(
      // Wrapping with SingleChildScrollView to allow scrolling
      child: Center(
        child: Text(
          'Something went wrong, try again later',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
