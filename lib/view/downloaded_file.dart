import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/app_colors.dart';

class DownloadedFilesScreen extends StatefulWidget {
  const DownloadedFilesScreen({super.key});

  @override
  _DownloadedFilesScreenState createState() => _DownloadedFilesScreenState();
}

class _DownloadedFilesScreenState extends State<DownloadedFilesScreen> {
  Future<List<String>> _getDownloadedFiles() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('downloaded_files') ?? [];
  }

  Future<void> _deleteFile(String fileMetadata) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> files = prefs.getStringList('downloaded_files') ?? [];
    files.remove(fileMetadata);
    await prefs.setStringList('downloaded_files', files);
    setState(() {}); // Update the UI
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.98),
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
            return Center(child: _buildErrorScreen());
          }

          final downloadedFiles = snapshot.data ?? [];
          if (downloadedFiles.isEmpty) {
            return Center(child: _buildNoFilesScreen());
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
                  childAspectRatio: 0.92, // Adjust the ratio for a better look
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
                      child: Stack(
                        children: [
                          InkWell(
                            onTap: () {
                              OpenFile.open(filePath);
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.book,
                                  color: AppColors.themeColor,
                                  size: screenWidth * 0.08,
                                ),
                                SizedBox(height: screenWidth * 0.02),
                                Text(
                                  fileName,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: screenWidth * 0.035,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
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
                                  _confirmDelete(context, fileMetadata);
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

  void _confirmDelete(BuildContext context, String fileMetadata) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete File'),
        content: const Text('Are you sure you want to delete this file?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              _deleteFile(fileMetadata);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
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
