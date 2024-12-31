import 'package:docsview/utils/shimmer_widget.dart';
import 'package:docsview/view/result_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../utils/app_colors.dart';
import '../utils/drawer_tile.dart';
import '../view-model/provider.dart';
import 'downloaded_file.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  void navigateToDownload(BuildContext context) {
    // Close the drawer before navigating
    Navigator.pop(context);

    // Navigate to the DownloadedFilesScreen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const DownloadedFilesScreen(),
      ),
    );
  }

  Future<void> _onRefresh(BuildContext context) async {
    // Trigger data refresh in your view model or backend call
    final viewModel = Provider.of<HomeViewModel>(context, listen: false);
    await viewModel.refreshData();  // Assuming you have a refreshData method in your ViewModel
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeViewModel(),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          drawer: _buildDrawer(context), // Pass context here
          body: Consumer<HomeViewModel>(
            builder: (context, viewModel, child) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Stack(
                  children: [
                    RefreshIndicator(
                      onRefresh: () => _onRefresh(context),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
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
                            const SizedBox(height: 20),
                            viewModel.isLoading
                                ? ShimmerEffect.shimmerEffect()
                                : viewModel.folderContents.isNotEmpty
                                ? _buildGridView(viewModel.folderContents)
                                : _buildEmptyState(viewModel.errorMessage),
                            const SizedBox(height: 30),
                          ],
                        ),
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

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.backgroundBodyColor,
      child: ListView(
        children: [
          const SizedBox(
            height: 20,
          ),
          DrawerTile(
            iconIs: const Icon(
              Icons.arrow_downward_outlined,
            ),
            name: "Download",
            function: () {
              navigateToDownload(context); // Corrected here
            },
          ),
          DrawerTile(
            iconIs: const Icon(
              Icons.email_outlined,
            ),
            name: "Contact us",
            function: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildIconButton(
            context,
            icon: Icons.menu,
            onTap: () => Scaffold.of(context).openDrawer(),
          ),
          _buildIconButton(
            context,
            icon: FontAwesomeIcons.arrowDown,
            onTap: () {
              navigateToDownload(context); // Corrected here
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
          color: AppColors.themeColor.withOpacity(0.1),
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
          Lottie.asset("assets/images/internetError.json"),
          Text(
            errorMessage ?? 'No files or folders found',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18),
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
];
