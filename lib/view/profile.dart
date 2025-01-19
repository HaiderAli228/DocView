import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../utils/app_colors.dart';

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({super.key});

  // Function to open the email client
  Future<void> _launchEmail() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'flutter2830@gmail.com',
      query: 'subject=Feedback&body=Hello, I would like to provide feedback...',
    );

    if (await canLaunchUrl(emailLaunchUri)) {
      await launchUrl(emailLaunchUri);
    } else {
      throw 'Could not launch $emailLaunchUri';
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.98),
      appBar: AppBar(
        backgroundColor: AppColors.themeColor,
        foregroundColor: Colors.white,
        title: const Text(
          "Library",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        titleSpacing: 0,
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
                "Library is your one-step solution for academic excellence. Initially designed for GCUF students, it now serves a broader audience, including MBBS aspirants, offering invaluable resources for every learner.",
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
              const SizedBox(height: 10),

              // feedback section
              Container(
                padding: EdgeInsets.all(screenWidth * 0.04),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Found Incorrect Information?",
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Poppins",
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "If you notice any errors in the provided resources, please let us know.",
                      style: TextStyle(fontSize: 15, fontFamily: "Poppins"),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: () {
                        _launchEmail();
                      },
                      icon: const Icon(
                        Icons.mail,
                        color: Colors.white,
                      ),
                      label: const Text(
                        "flutter2830@gmail.com",
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.themeColor,
                      ),
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
                        alignment: Alignment.bottomLeft,
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Text(
                            "\"No matter what you have, where you are, rise above the crowd & build legacy that will never be overlooked.\" — Haider Ali",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontFamily: "Poppins",
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Motivational and Achievement Section
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
                      "TechSquad Journey",
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Poppins",
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "The Library app is a testament to what leadership, creativity, and dedication can achieve. Lead and developed by Haider Ali, with the support of TechSquad, this app reflects the hard work and passion of every individual involved. Every feature and design element is crafted with the aim of providing an exceptional experience for users. We hope our journey inspires you to pursue your dreams and make a positive impact.",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        fontFamily: "Poppins",
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "TechSquad Message",
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Poppins",
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "No matter where you come from, your determination and efforts can lead to incredible achievements. Life will always present challenges, but remember, with hard work, focus, and persistence, you can overcome anything and achieve your goals. Believe in yourself, take every opportunity to learn, and never stop striving for greatness.",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        fontFamily: "Poppins",
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Services Section
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
                      "TechSquad Services",
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Poppins",
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "• Mobile App Development (Flutter, iOS, Native).",
                      style: TextStyle(fontSize: 15, fontFamily: "Poppins"),
                    ),
                    Text(
                      "• Full Stack Web Development and React Apps.",
                      style: TextStyle(fontSize: 15, fontFamily: "Poppins"),
                    ),
                    Text(
                      "• SEO Solutions and Content Editing.",
                      style: TextStyle(fontSize: 15, fontFamily: "Poppins"),
                    ),
                    Text(
                      "• Research, Mentorship, and Academic Resources.",
                      style: TextStyle(fontSize: 15, fontFamily: "Poppins"),
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
