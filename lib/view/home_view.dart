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
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          title: _buildHeader(context),
        ),
        backgroundColor: Colors.white,
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
                        const SizedBox(height: 10),
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
                        const SizedBox(height: 20),
                        _buildSection(
                          title: "Medical Science",
                          viewModel: viewModel,
                          filter: "MBBS",
                          emptyMessage: "",
                        ),
                        const SizedBox(height: 20),
                        _buildSection(
                          title: "BS Programs",
                          viewModel: viewModel,
                          filter: "Other",
                          emptyMessage:
                              "\n\n\n Something went wrong, check your internet connection",
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
    );
  }

  // Builds the header with icons for Contact Us and Downloaded Files
  Widget _buildHeader(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          buildIconButton(
            context,
            screenWidth,
            "assets/images/icon.png",
            () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const ContactUsScreen())),
          ),
          buildIconButton(
            context,
            screenWidth,
            FontAwesomeIcons.arrowDown,
            () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const DownloadedFilesScreen())),
          ),
        ],
      ),
    );
  }

  // Builds an icon button with proper styling
  static Widget buildIconButton(BuildContext context, double screenWidth,
      dynamic icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        height: screenWidth * 0.125,
        width: screenWidth * 0.125,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.themeColor.withOpacity(0.13),
          borderRadius: BorderRadius.circular(10),
        ),
        child: icon is String
            ? Image.asset(icon, fit: BoxFit.cover)
            : Icon(icon, color: AppColors.themeColor),
      ),
    );
  }

  // Builds a content section with a title and either a horizontal list or grid view
  Widget _buildSection({
    required String title,
    required HomeViewModel viewModel,
    required String filter,
    required String emptyMessage,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        SizedBox(
          height: 5,
        ),
        viewModel.isLoading
            ? Padding(
                padding: const EdgeInsets.only(top: 10),
                child: ShimmerEffect.shimmerEffect(),
              )
            : _buildFilteredSection(
                viewModel.folderContents, filter, emptyMessage),
      ],
    );
  }

  // Filters and builds content based on a category
  Widget _buildFilteredSection(
      List<dynamic> folderContents, String filter, String emptyMessage) {
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

  // Builds a horizontal list for MBBS items
  Widget _buildHorizontalList(List<dynamic> items) {
    return SizedBox(
      height: 240,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(vertical: 10),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return GestureDetector(
            onTap: () => _navigateToResultScreen(context, item),
            child: Container(
              padding: const EdgeInsets.only(right: 10),
              child: Card(
                elevation: 8,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
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
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // Builds a grid view for non-MBBS items
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

  // Displays a message if the content is empty
  Widget _buildEmptyState(String? errorMessage) {
    return Text(
      errorMessage ?? 'No files or folders found',
      style: const TextStyle(fontSize: 16),
      textAlign: TextAlign.center,
    );
  }

  // Builds a grid item
  Widget _buildFolderItem(dynamic item, BuildContext context) {
    return Card(
      elevation: 8,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        onTap: () => _navigateToResultScreen(context, item),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              departmentIcon(item),
              width: 50,
              height: 50,
            ),
            const SizedBox(height: 14),
            Text(
              item['name'] ?? 'Unknown',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Handles navigation to the result screen
  void _navigateToResultScreen(BuildContext context, dynamic item) {
    if (item['mimeType'] == 'application/vnd.google-apps.folder') {
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
  }

  // Retrieves the appropriate icon for a department
  String departmentIcon(dynamic item) {
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
