import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';

// Fetch API key and root folder ID from environment variables
final String apiKey = dotenv.env['API_KEY'] ?? '';
final String rootFolderId = dotenv.env['ROOT_FOLDER_ID'] ?? '';

class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key});

  @override
  ResultScreenState createState() => ResultScreenState();
}

class ResultScreenState extends State<ResultScreen> {
  static List<Map<String, String>> departments = [
    {"name": "Computer", "icon": "assets/images/computer.png"},
    {"name": "Physics", "icon": "assets/images/physics.png"},
    {"name": "Chemistry", "icon": "assets/images/chemistry.png"},
    {"name": "Botany", "icon": "assets/images/botany.png"},
    {"name": "Zoology", "icon": "assets/images/zoology.png"},
    {"name": "Math", "icon": "assets/images/math.png"},
    {"name": "Islamiyat", "icon": "assets/images/islam.png"},
    {"name": "English", "icon": "assets/images/english.png"},
    {"name": "Economy", "icon": "assets/images/bba.png"},
  ];

  String currentFolderId = rootFolderId;
  String currentFolderName = "Root Folder";
  List<dynamic> folderContents = [];
  bool isLoading = false;
  String? errorMessage;
  final List<Map<String, String>> navigationStack = [];

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
        "https://www.googleapis.com/drive/v3/files?q='$folderId'+in+parents+and+trashed=false&key=$apiKey&fields=files(id,name,mimeType)";
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<dynamic> files = data['files'] ?? [];

        files.sort((a, b) => a['name']?.toLowerCase()?.compareTo(b['name']?.toLowerCase() ?? '') ?? 0);

        setState(() {
          folderContents = files;
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
    navigationStack.add({
      "id": currentFolderId,
      "name": currentFolderName,
    });

    setState(() {
      currentFolderId = folderId;
      currentFolderName = folderName;
    });
    fetchFolderContents(folderId);
  }

  void navigateBack() {
    if (navigationStack.isNotEmpty) {
      final previousFolder = navigationStack.removeLast();
      setState(() {
        currentFolderId = previousFolder["id"]!;
        currentFolderName = previousFolder["name"]!;
      });
      fetchFolderContents(currentFolderId);
    }
  }
  String getDepartmentIcon(String folderName) {
    // Check if folder name matches any department
    final department = departments.firstWhere(
          (department) => folderName.toLowerCase().contains(department['name']!.toLowerCase()),
      orElse: () => {"icon": "assets/images/defaultIcon.png"},
    );
    return department['icon'] ?? "assets/images/defaultIcon.png";
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
            navigateToFolder(item['id'] ?? '', item['name'] ?? 'Unknown Folder');
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

  Widget buildShimmerEffect(int count) {
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 3 / 2,
      ),
      itemCount: count,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Card(
            elevation: 6,
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
                  Container(
                    width: 50,
                    height: 50,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: 60,
                    height: 16,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(currentFolderName),
        leading: navigationStack.isNotEmpty
            ? IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: navigateBack,
        )
            : null,
      ),
      body: isLoading
          ? buildShimmerEffect(folderContents.isNotEmpty ? folderContents.length : 6)
          : errorMessage != null
          ? Center(child: Text(errorMessage!))
          : folderContents.isEmpty
          ? const Center(child: Text("No files or folders found."))
          : GridView.builder(
        padding: const EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 3 / 2,
        ),
        itemCount: folderContents.length,
        itemBuilder: (context, index) {
          final item = folderContents[index];
          return buildFolderItem(item);
        },
      ),
    );
  }
}
