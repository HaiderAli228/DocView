import 'package:carousel_slider/carousel_slider.dart';
import 'package:docsview/routes/routes_name.dart';
import 'package:docsview/view/ai_response_screen.dart';
import 'package:flutter/material.dart';
import 'package:docx_to_text/docx_to_text.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import '../model/api_services.dart';
import '../utils/app_colors.dart';
import '../utils/drawer_tile.dart';
import '../utils/toast_msg.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {


  final List<String> imagePaths = [
    'assets/images/1.jpg', // Replace with your actual image paths
    'assets/images/2.jpg',
    'assets/images/3.jpg',
  ];
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
                          // Drawer icon
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
                                    color: AppColors.themeColor.withOpacity(
                                        0.1), // Light shade of themeColor
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
                          // Notification icon
                          GestureDetector(
                            onTap: () {},
                            child: Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                color: AppColors.themeColor.withOpacity(
                                    0.1), // Light shade of themeColor
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
                        autoPlay: true, // Enables auto-scrolling
                        enlargeCenterPage: true, // Enlarges the current slide
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
                                  fit: BoxFit
                                      .cover, // Ensures the image fits properly
                                ),
                              ),
                            );
                          },
                        );
                      }).toList(),
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
            Navigator.pushNamed(context, RoutesName.aiScreenView) ;
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
