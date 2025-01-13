import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.98),
      appBar: AppBar(
        backgroundColor: AppColors.themeColor,
        foregroundColor: Colors.white,
        title: const Text("About Us"),
      ),
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Section
              const Row(
                children: [
                  Text(
                    "Welcome to Library",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Poppins",
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(width: 10),
                  Icon(Icons.school, color: AppColors.themeColor, size: 26),
                ],
              ),
              const SizedBox(height: 10),
              const Text(
                "Library is your one-stop solution for academic excellence. Initially designed for GCUF students, it now serves a broader audience, including MBBS aspirants, offering invaluable resources for every learner.",
                style: TextStyle(
                  fontSize: 15,
                  fontFamily: "Poppins",
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),

              // Features Section
              Container(
                padding: EdgeInsets.all(screenWidth * 0.04),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Our Features:",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Poppins",
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "• Access to books, notes, and course outlines.",
                      style: TextStyle(fontSize: 15, fontFamily: "Poppins"),
                    ),
                    Text(
                      "• Past papers and exam strategies for all fields.",
                      style: TextStyle(fontSize: 15, fontFamily: "Poppins"),
                    ),
                    Text(
                      "• MBBS-specific books and essential knowledge.",
                      style: TextStyle(fontSize: 15, fontFamily: "Poppins"),
                    ),
                    Text(
                      "• Research ideas and FYP guidance.",
                      style: TextStyle(fontSize: 15, fontFamily: "Poppins"),
                    ),
                    Text(
                      "• Personalized resources for university and professional studies.",
                      style: TextStyle(fontSize: 15, fontFamily: "Poppins"),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Picture and Quote Section
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.asset(
                      "assets/images/profile.jpg", // Replace with your picture
                      width: double.infinity,
                      height: 300,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        gradient: LinearGradient(
                          colors: [
                            Colors.black.withOpacity(0.7),
                            Colors.transparent,
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      ),
                      child: const Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Text(
                            "\"Empower your future by embracing knowledge. Excellence is not a destination but a journey.\" — Haider Ali",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontFamily: "Poppins",
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Services Section
              Container(
                padding: EdgeInsets.all(screenWidth * 0.04),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Our Services",
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Poppins",
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "• Comprehensive academic resources.",
                      style: TextStyle(fontSize: 15, fontFamily: "Poppins"),
                    ),
                    Text(
                      "• Innovative app and web development.",
                      style: TextStyle(fontSize: 15, fontFamily: "Poppins"),
                    ),
                    Text(
                      "• Research and mentorship programs.",
                      style: TextStyle(fontSize: 15, fontFamily: "Poppins"),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Contact Information Section
              Container(
                padding: EdgeInsets.all(screenWidth * 0.04),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Contact Information",
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Poppins",
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Icon(Icons.alternate_email,
                            color: AppColors.themeColor),
                        SizedBox(width: 10),
                        Text(
                          "flutter2830@gmail.com",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            fontFamily: "Poppins",
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(Icons.phone, color: AppColors.themeColor),
                        SizedBox(width: 10),
                        Text(
                          "0349-6292972",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            fontFamily: "Poppins",
                          ),
                        ),
                      ],
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
