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
              double screenWidth = constraints.maxWidth;

              // Determine the number of items per row dynamically based on screen size
              int crossAxisCount = (screenWidth ~/ 180)
                  .clamp(2, 4); // Minimum 2 items, maximum 4 items per row

              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  childAspectRatio: 0.8, // Adjust the ratio for a better look
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
                            Icon(
                              Icons.book, // Book icon
                              color: AppColors.themeColor, // Custom color
                              size: screenWidth * 0.08, // Responsive icon size
                            ),
                            SizedBox(height: screenWidth * 0.02),
                            Text(
                              fileName,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize:
                                    screenWidth * 0.035, // Responsive font
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

  Widget _buildNoFilesScreen() {
    return const SingleChildScrollView(
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

  Widget _buildErrorScreen() {
    return const SingleChildScrollView(
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
