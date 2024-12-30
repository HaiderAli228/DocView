import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../utils/app_colors.dart';
import '../utils/shimmer_widget.dart';
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
    return ChangeNotifierProvider(
      create: (_) => ResultScreenProvider()..initialize(folderId, folderName),
      child: Scaffold(
        backgroundColor: Colors.white,
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
            if (provider.isLoading) {
              return Padding(
                padding: const EdgeInsets.all(20),
                child: ShimmerEffect.shimmerEffect(countValue: 6),
              );
            }
            if (provider.errorMessage != null) {
              return Center(child: Text(provider.errorMessage!));
            }
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
                  // Folder Grid
                  if (folders.isNotEmpty)
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount:
                            MediaQuery.of(context).size.width > 600 ? 4 : 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
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
                          child: Card(
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
                                    width: 60,
                                    height: 60,
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
                          ),
                        );
                      },
                    ),
                  const SizedBox(height: 16),
                  // File List
                  if (files.isNotEmpty)
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: files.length,
                      itemBuilder: (context, index) {
                        final file = files[index];
                        return Card(
                          elevation: 5,
                          color: Colors.white,
                          shadowColor: Colors.grey.withOpacity(0.5),
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
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.contain,
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        file['name'] ?? 'Unknown File',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          // Download Button
                                          GestureDetector(
                                            onTap: () {
                                              // Implement file download logic here
                                            },
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.37, // 60% of screen width
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8),
                                              decoration: BoxDecoration(
                                                color: Colors
                                                    .purple, // Background color
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              alignment: Alignment.center,
                                              child: const Text(
                                                'Download',
                                                style: TextStyle(
                                                  color: Colors
                                                      .white, // Text color
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                              width:
                                                  6), // Space between the buttons
                                          // View Button
                                          GestureDetector(
                                            onTap: () {
                                              // Implement file view logic here
                                            },
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.17, // 30% of screen width
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8),
                                              decoration: BoxDecoration(
                                                color: Colors
                                                    .purple, // Background color
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              alignment: Alignment.center,
                                              child: const Text(
                                                'View',
                                                style: TextStyle(
                                                  color: Colors
                                                      .white, // Text color
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
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

  String getDepartmentIcon(String mimeType) {
    return mimeType == 'application/vnd.google-apps.folder'
        ? 'assets/images/defaultIcon.png'
        : 'assets/images/file.png';
  }
}
