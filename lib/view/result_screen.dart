import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const String apiKey = "AIzaSyCFozPWxi82_xGm011yJsQ5eZocFNLrKzU"; // Replace with your API key
const String rootFolderId = "1CqXi8YcJCufzyldxkQqx72tFEyWfYBbj"; // Replace with your App Data folder ID

class DriveExplorer extends StatefulWidget {
  const DriveExplorer({super.key});

  @override
  DriveExplorerState createState() => DriveExplorerState();
}

class DriveExplorerState extends State<DriveExplorer> {
  String currentFolderId = rootFolderId; // Start at the root folder
  String currentFolderName = "App Data"; // Display folder name
  List<dynamic> folderContents = [];
  bool isLoading = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchFolderContents(currentFolderId);
  }

  Future<void> fetchFolderContents(String folderId) async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    final String url =
        "https://www.googleapis.com/drive/v3/files?q='$folderId'+in+parents&key=$apiKey&fields=files(id,name,mimeType)";

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          folderContents = data['files'] ?? [];
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = "Error: ${response.statusCode} ${response.reasonPhrase}";
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = "An error occurred: $e";
        isLoading = false;
      });
    }
  }

  void navigateToFolder(String folderId, String folderName) {
    setState(() {
      currentFolderId = folderId;
      currentFolderName = folderName;
    });
    fetchFolderContents(folderId);
  }

  Widget buildFolderItem(dynamic item) {
    if (item['mimeType'] == 'application/vnd.google-apps.folder') {
      // Folder
      return ListTile(
        leading: const Icon(Icons.folder, color: Colors.blue),
        title: Text(item['name']),
        onTap: () => navigateToFolder(item['id'], item['name']),
      );
    } else {
      // File
      return Card(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: ListTile(
          leading: const Icon(Icons.insert_drive_file, color: Colors.grey),
          title: Text(item['name']),
          subtitle: Text("Type: ${item['mimeType']}"),
          onTap: () {
            // Handle file click (e.g., show details or download)
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(currentFolderName),
        leading: currentFolderId != rootFolderId
            ? IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Handle navigation back to parent folder (optional)
            // In this example, user navigates using folder tree.
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
