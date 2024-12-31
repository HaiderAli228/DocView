import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.themeColor,
        foregroundColor: Colors.white,
        title: const Text("Contact Us"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Poppins",
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(width: 10),
                  Icon(Icons.library_books,
                      color: AppColors.themeColor, size: 26),
                ],
              ),
              const SizedBox(height: 10),
              const Text(
                "This app is your ultimate educational companion. Designed to help students excel, it offers:",
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: "Poppins",
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),

              // Features Section
              Container(
                padding: const EdgeInsets.all(16),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "• Access to books and handy notes.",
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: "Poppins",
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      "• Midterm and final past papers.",
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: "Poppins",
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      "• Detailed course outlines.",
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: "Poppins",
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      "• Important topics and questions.",
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: "Poppins",
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      "• Final year project ideas.",
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: "Poppins",
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      "• Department-wise study material.",
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: "Poppins",
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      "• Semester-wise study guides and exam strategies.",
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: "Poppins",
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      "• Research topics and ideas for academic exploration.",
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: "Poppins",
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Divider(
                color: Colors.grey,
              ),
              const SizedBox(
                height: 20,
              ),

              // Vision Section
              const Text(
                "Our Vision",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Poppins",
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              Stack(
                children: [
                  // Full width image with increased height and rounded corners
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      "assets/images/profile.jpg",
                      width: double.infinity, // Image takes full width
                      height: 300, // Increased height of image
                      fit: BoxFit.cover,
                    ),
                  ),
                  // Gradient overlay with opacity and quote text
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20), // Ensure the gradient overlay follows the image's rounded corners
                        gradient: LinearGradient(
                          colors: [
                            Colors.black.withOpacity(0.6),
                            Colors.transparent,
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topRight,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                      child: const Align(
                        alignment: Alignment.bottomCenter,
                        child: Text(
                          "\" Even in a place where potential is overlooked, I chose to rise above and leave my mark .\" ",
                          style: TextStyle(
                            fontSize: 16,

                            fontWeight: FontWeight.bold,
                            fontFamily: "Poppins",
                            color: Colors.white, // White text on dark background
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Services Section
              Container(
                padding: const EdgeInsets.all(16),
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
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Poppins",
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "• Website Development",
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: "Poppins",
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      "• Personalized project mentorship.",
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: "Poppins",
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      "• Cutting-edge app development solutions.",
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: "Poppins",
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Contact Information Section
              Container(
                padding: const EdgeInsets.all(16),
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
                        fontSize: 20,
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
                            fontSize: 16,
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
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            fontFamily: "Poppins",
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),


            ],
          ),
        ),
      ),
    );
  }
}