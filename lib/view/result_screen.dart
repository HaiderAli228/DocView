import 'dart:async';

import 'package:docsview/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:lottie/lottie.dart';

class ResultScreen extends StatefulWidget {
  final String folderId;
  final String folderName;

  const ResultScreen({
    super.key,
    required this.folderId,
    required this.folderName,
  });

  @override
  ResultScreenState createState() => ResultScreenState();
}

class ResultScreenState extends State<ResultScreen> {
  List<dynamic> folderContents = [];
  bool isLoading = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchFolderContents(widget.folderId);
  }

  Future<void> fetchFolderContents(String folderId) async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    final String apiKey = dotenv.env['API_KEY'] ?? '';
    final String url =
        "https://www.googleapis.com/drive/v3/files?q='$folderId'+in+parents+and+trashed=false&key=$apiKey&fields=files(id,name,mimeType)";

    try {
      final response = await http
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 10)); // Timeout after 10 seconds

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<dynamic> files = data['files'] ?? [];

        files.sort((a, b) =>
        a['name']?.toLowerCase()?.compareTo(b['name']?.toLowerCase() ?? '') ??
            0);

        setState(() {
          folderContents = files;
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = "Server Error: ${response.statusCode}";
          isLoading = false;
        });
      }
    } on http.ClientException {
      setState(() {
        errorMessage = "Unable to connect to the server. Check your connection.";
        isLoading = false;
      });
    } on TimeoutException {
      setState(() {
        errorMessage = "Request timed out. Please try again.";
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = "An unexpected error occurred.";
        isLoading = false;
      });
    }
  }

  void navigateToFolder(String folderId, String folderName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResultScreen(
          folderId: folderId,
          folderName: folderName,
        ),
      ),
    );
  }

  String getDepartmentIcon(String name) {
    if (name.toLowerCase().contains('folder')) {
      return 'assets/images/folder.png'; // Replace with your folder icon asset
    } else {
      return 'assets/images/file.png'; // Replace with your file icon asset
    }
  }

  Widget buildFolderItem(dynamic item) {
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
            navigateToFolder(
                item['id'] ?? '', item['name'] ?? 'Unknown Folder');
          } else {
            print("File clicked: ${item['name']}");
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                getDepartmentIcon(item['name'] ?? 'Unknown'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.themeColor,
        foregroundColor: Colors.white,
        title: Text(
          widget.folderName,
          style: const TextStyle(fontFamily: "Poppins"),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : folderContents.isNotEmpty
          ? GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: folderContents.length,
        itemBuilder: (context, index) {
          return buildFolderItem(folderContents[index]);
        },
      )
          : Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (errorMessage == null)
              Lottie.asset(
                'assets/images/noData.json',
                height: 300,
                fit: BoxFit.contain,
              )
            else
              Lottie.asset(
                'assets/images/internetError.json',
                height: 300,
                fit: BoxFit.contain,
              ),
            const SizedBox(height: 16),
            Text(
              errorMessage ?? 'No files or folders found.',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
