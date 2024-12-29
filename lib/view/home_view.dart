import 'package:docsview/utils/shimmer_widget.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../utils/app_colors.dart';
import '../utils/drawer_tile.dart';
import '../view-model/provider.dart';
import '../routes/routes_name.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeViewModel(),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          drawer: Drawer(
            backgroundColor: AppColors.backgroundBodyColor,
            child: Column(
              children: [
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
          body: Consumer<HomeViewModel>(
            builder: (context, viewModel, child) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Stack(
                  children: [
                    SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 20, bottom: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
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
                                ),
                                GestureDetector(
                                  onTap: () {},
                                  child: Container(
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                      color:
                                          AppColors.themeColor.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    padding: const EdgeInsets.all(8),
                                    child: const Icon(
                                        Icons.notifications_active,
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
                                    text:
                                        "Explore, learn, and expand your mind with the power of ",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: "Poppins")),
                                TextSpan(
                                    text: "Library",
                                    style: TextStyle(
                                        color: AppColors.themeColor,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: "Poppins")),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          viewModel.isLoading
                              ? ShimmerEffect.shimmerEffect()
                              : viewModel.folderContents.isNotEmpty
                                  ? LayoutBuilder(
                                      builder: (context, constraints) {
                                        int crossAxisCount = constraints
                                                    .maxWidth >
                                                600
                                            ? 3
                                            : 2; // 3 columns for wide screens
                                        return GridView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          gridDelegate:
                                              SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: crossAxisCount,
                                            crossAxisSpacing: 8,
                                            mainAxisSpacing: 8,
                                          ),
                                          itemCount:
                                              viewModel.folderContents.length,
                                          itemBuilder: (context, index) {
                                            return buildFolderItem(
                                                viewModel.folderContents[index],
                                                context);
                                          },
                                        );
                                      },
                                    )
                                  : Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Lottie.asset(
                                              "assets/images/internetError.json"),
                                          Text(
                                            viewModel.errorMessage ??
                                                'No files or folders found',
                                            textAlign: TextAlign.center,
                                            style:
                                                const TextStyle(fontSize: 18),
                                          ),
                                        ],
                                      ),
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

  Widget buildFolderItem(dynamic item, BuildContext context) {
    bool isFolder = item['mimeType'] == 'application/vnd.google-apps.folder';
    String departmentIcon = 'assets/images/defaultIcon.png';

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
            Navigator.pushNamed(
              context,
              RoutesName.resultView,
              arguments: {
                'folderId': item['id'] ?? '',
                'folderName': item['name'] ?? 'Unknown Folder',
              },
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

List<Map<String, String>> departments = [
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
