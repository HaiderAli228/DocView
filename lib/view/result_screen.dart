import 'package:docsview/utils/app_colors.dart';
import 'package:docsview/view/pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';

import '../view-model/provider.dart';

class ResultScreen extends StatelessWidget {
  final String folderId;
  final String folderName;

  const ResultScreen({
    super.key,
    required this.folderId,
    required this.folderName,
  });

  @override
  Widget build(BuildContext context) {
    // Fetch the folder contents through the provider
    Future.delayed(Duration.zero, () {
      Provider.of<FolderProvider>(context, listen: false).fetchFolderContents(folderId);
    });

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.themeColor,
        foregroundColor: Colors.white,
        title: Text(
          folderName,
          style: const TextStyle(fontFamily: "Poppins"),
        ),
      ),
      body: Consumer<FolderProvider>(
        builder: (context, folderProvider, child) {
          if (folderProvider.isLoading) {
            return const Center(child: CircularProgressIndicator(color: AppColors.themeColor));
          }

          if (folderProvider.errorMessage != null) {
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
                    folderProvider.errorMessage ?? 'An error occurred.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 18),
                  ),
                ],
              ),
            );
          }

          if (folderProvider.folderContents.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset(
                    'assets/images/progress.json',
                    height: 300,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Working on it, available soon",
                    textAlign: TextAlign.center,
                    style:  TextStyle(fontSize: 18),
                  ),
                ],
              ),
            );
          }

          return LayoutBuilder(
            builder: (context, constraints) {
              // Decide on the number of columns based on screen width
              int crossAxisCount = 2;
              if (constraints.maxWidth > 600) {
                crossAxisCount = 3; // Use 3 columns for larger screens
              } else if (constraints.maxWidth > 1000) {
                crossAxisCount = 4; // Use 4 columns for extra large screens
              }

              return GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: folderProvider.folderContents.length,
                itemBuilder: (context, index) {
                  return buildFolderItem(folderProvider.folderContents[index], context);
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget buildFolderItem(dynamic item, BuildContext context) {
    bool isFolder = item['mimeType'] == 'application/vnd.google-apps.folder';

    return Card(
      elevation: 6,
      color: Colors.white,
      shadowColor: Colors.grey.withOpacity(0.4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        onTap: () {
          if (isFolder) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ResultScreen(
                  folderId: item['id'] ?? '',
                  folderName: item['name'] ?? 'Unknown Folder',
                ),
              ),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PDFViewerScreen(pdfUrl: item['webContentLink'] ?? ''),
              ),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                getDepartmentIcon(item['mimeType'] ?? ''),
                width: 50,
                height: 50,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 8),
              Text(
                item['name'] ?? 'Unknown',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String getDepartmentIcon(String mimeType) {
    if (mimeType == 'application/vnd.google-apps.folder') {
      return 'assets/images/defaultIcon.png'; // Folder icon
    } else {
      return 'assets/images/file.png'; // File icon
    }
  }
}
