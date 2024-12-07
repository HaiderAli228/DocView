import 'package:carousel_slider/carousel_slider.dart';
import 'package:docsview/routes/routes_name.dart';
import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/drawer_tile.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final List<String> imagePaths = [
    'assets/images/1.jpg',
    'assets/images/2.jpg',
    'assets/images/3.jpg',
  ];

  final List<Map<String, String>> departments = [
    {"name": "Computer", "icon": "assets/images/computer.png"},
    {"name": "Physics", "icon": "assets/images/physics.png"},
    {"name": "Chemistry", "icon": "assets/images/chemistry.png"},
    {"name": "Botany", "icon": "assets/images/botany.png"},
    {"name": "Zoology", "icon": "assets/images/zoology.png"},
    {"name": "Mathematics", "icon": "assets/images/math.png"},
    {"name": "Islamist", "icon": "assets/images/islam.png"},
    {"name": "English", "icon": "assets/images/english.png"},
    {"name": "Economics", "icon": "assets/images/bba.png"},
  ];

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final int crossAxisCount = screenWidth < 600 ? 2 : 4;

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
                                    color: AppColors.themeColor.withOpacity(0.1),
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
                        style: TextStyle(fontSize: 25),
                        children: [
                          TextSpan(
                              text: "Upload and scan your document with ",
                              style: TextStyle(
                                  color: Colors.black, fontFamily: "Poppins")),
                          TextSpan(
                              text: "DocView",
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
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 5.0,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: Image.asset(
                                  imagePath,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 1.1, // Adjust height-to-width ratio
                      ),
                      itemCount: departments.length,
                      itemBuilder: (context, index) {
                        final department = departments[index];
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                department['icon']!,
                                height: 50,
                                width: 50,
                                fit: BoxFit.contain,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                department['name']!,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: AppColors.themeColor,
          onPressed: () {
            Navigator.pushNamed(context, RoutesName.aiScreenView);
          },
          child: const Icon(
            Icons.add,
            color: Colors.white,
            size: 40,
          ),
        ),
      ),
    );
  }
}