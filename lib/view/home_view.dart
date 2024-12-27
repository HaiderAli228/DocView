import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';
import '../utils/app_colors.dart';
import '../utils/drawer_tile.dart';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import 'result_screen.dart';

// Fetch API key and root folder ID from environment variables
final String apiKey = dotenv.env['API_KEY'] ?? '';
final String rootFolderId = dotenv.env['ROOT_FOLDER_ID'] ?? '';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => HomeViewState();
}

class HomeViewState extends State<HomeView> {
  final List<String> imagePaths = [
    'assets/images/1.jpg',
    'assets/images/2.jpg',
    'assets/images/3.jpg',
  ];

  String currentFolderId = rootFolderId;
  String currentFolderName = "Root Folder";
  List<dynamic> folderContents = [];
  bool isLoading = false;
  String? errorMessage;
  final List<Map<String, String>> navigationStack = [];

  // Define your department icons
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
      final response = await http
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 30));

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
          errorMessage = "Failed to fetch data. Try again later.";
          isLoading = false;
        });
      }
    } on http.ClientException catch (_) {
      setState(() {
        errorMessage = "Failed to connect. Check your internet connection.";
        isLoading = false;
      });
    } on TimeoutException {
      setState(() {
        errorMessage = "Request timed out. Please try again.";
        isLoading = false;
      });
    } on FormatException {
      setState(() {
        errorMessage = "Invalid response format. Please try again later.";
        isLoading = false;
      });
    } catch (_) {
      setState(() {
        errorMessage = "An unexpected error occurred.";
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

  Widget buildFolderItem(dynamic item) {
    bool isFolder = item['mimeType'] == 'application/vnd.google-apps.folder';

    // Check if the department exists for the folder name
    String departmentIcon = 'assets/images/defaultIcon.png'; // Default icon
    for (var department in departments) {
      if (item['name'] == department['name']) {
        departmentIcon = department['icon'] ?? departmentIcon;
        break;
      }
    }
    return Card(
      elevation: 8,
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
            print("File clicked: ${item['name']}");
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                departmentIcon,
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

  Widget buildLoadingIndicator() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Two blocks in one row
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: 6, // Adjust count for shimmer placeholders
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            height: 100, // Adjust height as needed
            width: double.infinity,
            color: Colors.white, // Placeholder color
            margin: const EdgeInsets.all(4.0), // Optional margin
          ),
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        drawer: Drawer(
          backgroundColor: AppColors.backgroundBodyColor,
          child: Column(
            children: [
              const UserAccountsDrawerHeader(
                decoration: BoxDecoration(color: AppColors.themeColor),
                accountName: Text(
                  "Haider Ali",
                  style: TextStyle(
                      fontFamily: "Poppins", fontWeight: FontWeight.bold),
                ),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Text(
                    "PIC",
                    style: TextStyle(
                        color: AppColors.themeColor,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.bold),
                  ),
                ),
                accountEmail: Text(
                  "example@gmail.com",
                  style: TextStyle(
                    fontFamily: "Poppins",
                  ),
                ),
              ),
              DrawerTile(
                iconIs: const Icon(
                  Icons.account_box,
                  color: AppColors.themeColor,
                ),
                name: "Profile",
                function: () {},
              ),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 20,
                        bottom: 15,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Builder(
                            builder: (context) {
                              return GestureDetector(
                                onTap: () {
                                  Scaffold.of(context).openDrawer();
                                },
                                child: Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                    color:
                                    AppColors.themeColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: const EdgeInsets.all(10),
                                  child: const Icon(
                                    Icons.menu,
                                    color: AppColors.themeColor,
                                  ),
                                ),
                              );
                            },
                          ),
                          GestureDetector(
                            onTap: () {},
                            child: Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                color: AppColors.themeColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.all(8),
                              child: const Icon(Icons.notifications_active,
                                  color: AppColors.themeColor),
                            ),
                          ),
                        ],
                      ),
                    ),
                    RichText(
                      text: const TextSpan(
                        style: TextStyle(fontSize: 20),
                        children: [
                          TextSpan(
                              text: "Code your path to success with ",
                              style: TextStyle(
                                  color: Colors.black, fontFamily: "Poppins")),
                          TextSpan(
                              text: "CS Department",
                              style: TextStyle(
                                  color: AppColors.themeColor,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "Poppins")),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CarouselSlider(
                      options: CarouselOptions(
                        height: 320.0,
                        autoPlay: true,
                        enlargeCenterPage: true,
                      ),
                      items: imagePaths.map((imagePath) {
                        return Builder(
                          builder: (BuildContext context) {
                            return Container(
                              margin: const EdgeInsets.symmetric(horizontal: 5.0),
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(imagePath),
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius: BorderRadius.circular(15)),
                            );
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),
                    isLoading
                        ? buildLoadingIndicator() // Shimmer effect instead of circular progress indicator
                        : folderContents.isNotEmpty
                        ? GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
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
                          Text(
                            errorMessage ?? 'No files or folders found',
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 18),
                          ),
                          Lottie.asset("assets/images/internetError.json"),

                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
