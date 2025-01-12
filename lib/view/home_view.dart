import 'package:docsview/utils/shimmer_widget.dart';
import 'package:docsview/view/downloaded_file.dart';
import 'package:docsview/view/profile.dart';
import 'package:docsview/view/result_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../utils/app_colors.dart';
import '../view-model/provider.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeViewModel(),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          drawer: _buildHeader(context), // Pass context here
          body: Consumer<HomeViewModel>(
            builder: (context, viewModel, child) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Stack(
                  children: [
                    SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          _buildHeader(context),
                          RichText(
                            text: const TextSpan(
                              style: TextStyle(fontSize: 20),
                              children: [
                                TextSpan(
                                  text:
                                      "Explore, learn, and expand your mind with the power of ",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: "Poppins",
                                  ),
                                ),
                                TextSpan(
                                  text: "Library",
                                  style: TextStyle(
                                    color: AppColors.themeColor,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Poppins",
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            "Medical Science",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 20,
                                color: Colors.black),
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            height:
                                220, // Total height for each item (image + text)
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: 5, // Replace with your list length
                              itemBuilder: (context, index) {
                                double cardWidth =
                                    MediaQuery.of(context).size.width *
                                        0.45; // 40% of screen width
                                return Container(
                                  width: cardWidth,
                                  margin: const EdgeInsets.only(right: 15),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Column(
                                    children: [
                                      Expanded(
                                        flex:
                                            3, // Image takes 3/4 of the card height
                                        child: ClipRRect(
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            topRight: Radius.circular(10),
                                          ),
                                          child: Image.asset(
                                            "assets/images/botany.png", // Replace with your image path
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex:
                                            1, // Text takes 1/4 of the card height
                                        child: Container(
                                          decoration: const BoxDecoration(
                                            color: AppColors.themeColor,
                                            borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(10),
                                              bottomRight: Radius.circular(10),
                                            ),
                                          ),
                                          alignment: Alignment.center,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5),
                                          child: const Text(
                                            "First Year", // Replace with your data
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Text(
                            "BS Programs",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: Colors.black),
                          ),
                          viewModel.isLoading
                              ? ShimmerEffect.shimmerEffect()
                              : viewModel.folderContents.isNotEmpty
                                  ? _buildGridView(viewModel.folderContents)
                                  : Center(
                                      child: _buildEmptyState(
                                          viewModel.errorMessage)),
                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ContactUsScreen(),
                  ));
            },
            child: Container(
              alignment: Alignment.center,
              height: 52,
              width: 52,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.themeColor.withOpacity(0.13),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Image(
                image: AssetImage("assets/images/icon.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          _buildIconButton(
            context,
            icon: FontAwesomeIcons.arrowDown,
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DownloadedFilesScreen(),
                  ));
            },
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton(BuildContext context,
      {required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          color: AppColors.themeColor.withOpacity(0.11),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          color: AppColors.themeColor,
        ),
      ),
    );
  }

  Widget _buildGridView(List<dynamic> folderContents) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = constraints.maxWidth > 600 ? 3 : 2;
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: folderContents.length,
          itemBuilder: (context, index) {
            return _buildFolderItem(folderContents[index], context);
          },
        );
      },
    );
  }

  Widget _buildEmptyState(String? errorMessage) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            errorMessage ?? 'No files or folders found',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildFolderItem(dynamic item, BuildContext context) {
    bool isFolder = item['mimeType'] == 'application/vnd.google-apps.folder';
    String departmentIcon = departments.firstWhere(
      (dept) => dept['name'] == item['name'],
      orElse: () => {'icon': 'assets/images/defaultIcon.png'},
    )['icon']!;

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
                  fontSize: 14,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

const List<Map<String, String>> departments = [
  {"name": "Computer", "icon": "assets/images/computer.png"},
  {"name": "Physics", "icon": "assets/images/physics.png"},
  {"name": "Chemistry", "icon": "assets/images/chemistry.png"},
  {"name": "Botany", "icon": "assets/images/botany.png"},
  {"name": "Zoology", "icon": "assets/images/zoology.png"},
  {"name": "Math", "icon": "assets/images/math.png"},
  {"name": "Islamiyat", "icon": "assets/images/islam.png"},
  {"name": "English", "icon": "assets/images/english.png"},
  {"name": "Economy", "icon": "assets/images/bba.png"},
  {"name": "Medical Data", "icon": "assets/images/mbbs.png"},
];
