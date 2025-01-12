import 'package:docsview/utils/shimmer_widget.dart';
import 'package:docsview/view/downloaded_file.dart';
import 'package:docsview/view/profile.dart';
import 'package:docsview/view/result_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart'; // Import Lottie
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
                                  "",
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
    double screenWidth = MediaQuery.of(context).size.width;

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
              height: screenWidth * 0.12,
              width: screenWidth * 0.12,
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
                height: screenWidth * 0.12,
                width: screenWidth * 0.12,
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
      // Show Lottie animation only for BS Programs (Other)
      if (filter == "Other") {
        return _buildEmptyState();
      } else {
        return Center(
            child: Text(emptyMessage)); // Show empty message for MBBS section
      }
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
          return Container(
            margin: const EdgeInsets.only(right: 10),
            child: GestureDetector(
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
                elevation: 8,
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
                      const SizedBox(height: 10),
                      Expanded(
                        child: Text(
                          item['name'],
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
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

  Widget _buildGridView(List<dynamic> items) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.85,
        mainAxisSpacing: 20,
        crossAxisSpacing: 20,
      ),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
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
            elevation: 8,
            color: Colors.white,
            shadowColor: Colors.grey.withOpacity(0.4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Expanded(
                  flex: 3,
                  child: Image.asset(
                    departmentIcon(item),
                    fit: BoxFit.contain,
                  ),
                ),
                Expanded(
                  child: Text(
                    item['name'],
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Column(
      children: [
        Lottie.asset(
            "assets/images/error.json"), // Lottie animation for BS Programs
        const SizedBox(height: 10),
        const Text(
          "Something went wrong",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  String departmentIcon(dynamic item) {
    return item['name'].toString().toUpperCase().startsWith("MBBS")
        ? 'assets/icons/mbbs_icon.png'
        : 'assets/icons/other_icon.png';
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
