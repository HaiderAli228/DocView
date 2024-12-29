import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/app_colors.dart';
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
              return const Center(child: CircularProgressIndicator());
            }
            if (provider.errorMessage != null) {
              return Center(child: Text(provider.errorMessage!));
            }
            if (provider.folderContents.isEmpty) {
              return const Center(child: Text("No files or folders found."));
            }
            return GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: MediaQuery.of(context).size.width > 600 ? 4 : 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1,
              ),
              itemCount: provider.folderContents.length,
              itemBuilder: (context, index) {
                final item = provider.folderContents[index];
                final isFolder =
                    item['mimeType'] == 'application/vnd.google-apps.folder';
                return GestureDetector(
                  onTap: isFolder
                      ? () => provider.navigateToFolder(
                            item['id'] ?? '',
                            item['name'] ?? 'Unknown Folder',
                          )
                      : null,
                  child: Card(
                    elevation: 8,
                    color: Colors.white,
                    shadowColor: Colors.grey.withOpacity(0.4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            getDepartmentIcon(item['mimeType'] ?? ''),
                            width: 48,
                            height: 48,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            item['name'] ?? 'Unknown',
                            style: const TextStyle(
                              fontSize: 14,
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
