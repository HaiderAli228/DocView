import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

c // Replace with your root folder ID

class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key});

  @override
  ResultScreenState createState() => ResultScreenState();
}

class ResultScreenState extends State<ResultScreen> {
  String currentFolderId = rootFolderId; // Start at the root folder
  String currentFolderName = "Root Folder"; // Display folder name
  List<dynamic> folderContents = [];
  bool isLoading = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    print("initState: Starting to fetch folder contents");
    fetchFolderContents(currentFolderId);
  }

  // Recursive function to fetch folder contents
  Future<void> fetchFolderContents(String folderId) async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    final String url =
        "https://www.googleapis.com/drive/v3/files?q='$folderId'+in+parents+and+trashed=false&key=$apiKey&fields=files(id,name,mimeType)";
    print("fetchFolderContents: URL is $url");

    try {
      final response = await http.get(Uri.parse(url));
      print("fetchFolderContents: Response status is ${response.statusCode}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print("fetchFolderContents: Response data is $data");

        setState(() {
          folderContents = data['files'] ?? [];
          isLoading = false;
        });
        print("fetchFolderContents: Successfully fetched folder contents");
      } else {
        print("fetchFolderContents: Error - ${response.statusCode} ${response.reasonPhrase}");
        setState(() {
          errorMessage = "Error: ${response.statusCode} ${response.reasonPhrase}";
          isLoading = false;
        });
      }
    } catch (e) {
      print("fetchFolderContents: Exception caught - $e");
      setState(() {
        errorMessage = "An error occurred: $e";
        isLoading = false;
      });
    }
  }

  void navigateToFolder(String folderId, String folderName) {
    print("navigateToFolder: Navigating to folder $folderName with ID $folderId");
    setState(() {
      currentFolderId = folderId;
      currentFolderName = folderName;
    });
    fetchFolderContents(folderId);
  }

  // Beautiful card layout for folder and file
  Widget buildFolderItem(dynamic item) {
    bool isFolder = item['mimeType'] == 'application/vnd.google-apps.folder';

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 5,
      child: InkWell(
        onTap: () {
          if (isFolder) {
            navigateToFolder(item['id'], item['name']);
          } else {
            // Handle file click (e.g., show details or download)
            print("File clicked: ${item['name']}");
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(
                isFolder ? Icons.folder : Icons.insert_drive_file,
                color: isFolder ? Colors.blue : Colors.grey,
                size: 40,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  item['name'],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
// ================================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(currentFolderName),
        leading: currentFolderId != rootFolderId
            ? IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            setState(() {
              currentFolderId = rootFolderId;
              currentFolderName = "Root Folder";
            });
            fetchFolderContents(rootFolderId);
          },
        )
            : null,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
          ? Center(child: Text(errorMessage!))
          : folderContents.isEmpty
          ? const Center(child: Text("No files or folders found."))
          : ListView.builder(
        itemCount: folderContents.length,
        itemBuilder: (context, index) {
          final item = folderContents[index];
          return buildFolderItem(item);
        },
      ),
    );
  }
}
