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
          drawer: _buildHeader(context),
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
                          _buildSectionTitle("Medical Science"),
                          const SizedBox(height: 10),
                          viewModel.isLoading
                              ? ShimmerEffect.shimmerEffect()
                              : _buildFilteredSection(
                                  viewModel.folderContents,
                                  "MBBS",
                                  "No MBBS folders found",
                                ),
                          const SizedBox(height: 20),
                          _buildSectionTitle("BS Programs"),
                          const SizedBox(height: 10),
                          viewModel.isLoading
                              ? ShimmerEffect.shimmerEffect()
                              : _buildFilteredSection(
                                  viewModel.folderContents,
                                  "Other",
                                  "No other department folders found",
                                ),
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
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DownloadedFilesScreen(),
                  ));
            },
            child: Container(
                alignment: Alignment.center,
                height: 50,
                width: 50,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.themeColor.withOpacity(0.13),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  FontAwesomeIcons.arrowDown,
                  color: AppColors.themeColor,
                )),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
          fontWeight: FontWeight.w500, fontSize: 20, color: Colors.black),
    );
  }

  Widget _buildFilteredSection(
    List<dynamic> folderContents,
    String filter,
    String emptyMessage,
  ) {
    final filteredItems = folderContents.where((item) {
      if (filter == "MBBS") {
        return item['name'].toString().toUpperCase().startsWith("MBBS");
      } else {
        return !item['name'].toString().toUpperCase().startsWith("MBBS");
      }
    }).toList();

    if (filteredItems.isEmpty) {
      return Center(child: _buildEmptyState(emptyMessage));
    }

    return filter == "MBBS"
        ? _buildHorizontalList(filteredItems)
        : _buildGridView(filteredItems);
  }

  Widget _buildHorizontalList(List<dynamic> items) {
    return SizedBox(
      height: 240,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(
          top: 10,
          bottom: 10,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ResultScreen(
                    folderId: item['id'],
                    folderName: item['name'],
                  ),
                ),
              );
            },
            child: Card(
              elevation: 4,
              color: Colors.white,
              shadowColor: Colors.grey.withOpacity(0.4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Image.asset(
                        departmentIcon(item),
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(height: 14),
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
        },
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
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                departmentIcon(item),
                width: 50,
                height: 50,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 14),
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

  String departmentIcon(dynamic item) {
    // Update this function to handle MBBS items and their respective images
    if (item['name'].contains('MBBS')) {
      return departments.firstWhere(
        (dept) => dept['name'] == item['name'],
        orElse: () => {'icon': 'assets/images/defaultIcon.png'},
      )['icon']!;
    }
    return departments.firstWhere(
      (dept) => dept['name'] == item['name'],
      orElse: () => {'icon': 'assets/images/defaultIcon.png'},
    )['icon']!;
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
  {"name": "MBBS 1st Year", "icon": "assets/images/6.jpg"},
  {"name": "MBBS 2nd Year", "icon": "assets/images/7.jpg"},
  {"name": "MBBS 3rd Year", "icon": "assets/images/8.jpg"},
  {"name": "MBBS 4th Year", "icon": "assets/images/9.jpg"},
  {"name": "MBBS Last Year", "icon": "assets/images/10.jpg"},
];
