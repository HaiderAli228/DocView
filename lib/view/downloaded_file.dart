import 'package:docsview/view/result_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:open_file/open_file.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/app_colors.dart'; // Import custom app colors for consistency

class DownloadedFilesScreen extends StatefulWidget {
  const DownloadedFilesScreen({super.key});

  @override
  _DownloadedFilesScreenState createState() => _DownloadedFilesScreenState();
}

class _DownloadedFilesScreenState extends State<DownloadedFilesScreen> {
  // Fetch the list of downloaded files from SharedPreferences
  Future<List<String>> _getDownloadedFiles() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> files = prefs.getStringList('downloaded_files') ?? [];
    files = files.reversed
        .toList(); // Reverse the list to show the last downloaded file first
    return files;
  }

  // Delete a specific file from SharedPreferences and update UI
  Future<void> _deleteFile(String fileMetadata) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> files = prefs.getStringList('downloaded_files') ?? [];
    files.remove(fileMetadata); // Remove the file from the list
    await prefs.setStringList(
        'downloaded_files', files); // Save the updated list back to prefs
    setState(() {}); // Trigger UI update
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.98), // Slight opacity for background
      appBar: AppBar(
        backgroundColor: AppColors.themeColor, // Custom app theme color
        foregroundColor: Colors.white,
        title: const Text('Downloaded Files',
          style:  TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        titleSpacing: 0,
      ),
      body: FutureBuilder<List<String>>(
        future: _getDownloadedFiles(), // Fetch the downloaded files list
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator()); // Show loading indicator
          }
          if (snapshot.hasError) {
            return Center(
                child: _buildErrorScreen()); // Show error screen on failure
          }

          final downloadedFiles = snapshot.data ?? [];
          if (downloadedFiles.isEmpty) {
            return Center(
                child: _buildNoFilesScreen()); // Show 'No files' screen
          }

          return LayoutBuilder(
            builder: (context, constraints) {
              double screenWidth = constraints.maxWidth;

              // Calculate the number of grid items per row based on screen width
              int crossAxisCount = (screenWidth ~/ 180)
                  .clamp(2, 4); // Min 2, max 4 items per row

              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  childAspectRatio:
                      0.92, // Adjust aspect ratio for a clean look
                ),
                itemCount: downloadedFiles.length,
                itemBuilder: (context, index) {
                  final fileMetadata = downloadedFiles[index];
                  final fileParts = fileMetadata
                      .split(':'); // Split metadata for file details
                  final fileName = fileParts[0];
                  final filePath = fileParts[1];

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      color: Colors.white,
                      elevation: 5, // Card shadow for depth
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            10), // Rounded corners for card
                      ),
                      child: Stack(
                        children: [
                          InkWell(
                            onTap: () {
                              OpenFile.open(filePath); // Open file on tap
                            },
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.book, // Icon for file preview
                                    color: AppColors.themeColor,
                                    size: screenWidth *
                                        0.08, // Adjust size dynamically
                                  ),
                                  SizedBox(height: screenWidth * 0.02),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5),
                                    child: Text(
                                      fileName,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: screenWidth *
                                            0.035, // Dynamic text size
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // Popup menu for file actions (e.g., delete)
                          Positioned(
                            top: 8,
                            right: 8,
                            child: PopupMenuButton<String>(
                              color: Colors.white,
                              elevation: 5,
                              shadowColor: Colors.grey,
                              menuPadding: const EdgeInsets.all(5),
                              onSelected: (value) {
                                if (value == 'delete') {
                                  _confirmDelete(context,
                                      fileMetadata); // Confirm before deleting
                                }
                              },
                              itemBuilder: (context) => [
                                const PopupMenuItem<String>(
                                  value: 'delete',
                                  child: Text(
                                    'Delete',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              ],
                              icon: const Icon(
                                Icons.more_vert,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ],
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

  // Confirm deletion with a dialog
  void _confirmDelete(BuildContext context, String fileMetadata) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete File'),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        shadowColor: Colors.grey,
        content: const Text('Are you sure you want to delete this file?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: ResultScreenState.buttonText("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              _deleteFile(fileMetadata); // Perform deletion
            },
            style: ElevatedButton.styleFrom(
              backgroundColor:
              AppColors.themeColor, // Set background color to purple
              foregroundColor: Colors.white, // Set text color to white
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  // Widget for 'No files' message
  Widget _buildNoFilesScreen() {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset("assets/images/noData.json"),
            const Text(
              'No files downloaded',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }

  // Widget for error message in case of failure
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
