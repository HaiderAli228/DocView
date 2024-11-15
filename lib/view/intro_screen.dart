
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

import '../routes/routes_name.dart';
import '../utils/app_colors.dart';
import '../utils/intro_image.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          IntroductionScreen(
            pages: [
              PageViewModel(
                titleWidget: buildTitle(
                  "AI-Powered Study Companion ",
                  "DocView ",
                  "",
                  size,
                ),
                bodyWidget: buildBody(
                    'DocView is designed to simplify studying and research. With advanced AI tools, you can transform lengthy documents into concise summaries and generate tailored questions for exam prep. Unlock efficient, focused learning',
                    size),
                image: buildImage('assets/images/first.json', size),
                decoration: getPageDecoration(size),
              ),
              PageViewModel(
                titleWidget: buildTitle(
                  "Document Scanning with",
                  " DocView",
                  "",
                  size,
                ),
                bodyWidget: buildBody(
                    'Easily scan and upload documents of any format—DocView’s AI analyzes content to produce clear outlines and extract key insights. Save time and focus on what is essential ',
                    size),
                image: buildImage('assets/images/scanning.json', size),
                decoration: getPageDecoration(size),
              ),
              PageViewModel(
                titleWidget: buildTitle(
                  "Quick Access to Past Papers in ",
                  "DocView",
                  "",
                  size,
                ),
                bodyWidget: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    buildBody(
                        'With DocView, you can quickly search and access relevant documents, making exam prep easier than ever',
                        size),
                    SizedBox(height: size.height * 0.05),
                    // Get Started button with navigation
                    buildButton(
                      text: "Get Started",
                      onTap: () {
                        Navigator.of(context)
                            .pushReplacementNamed(RoutesName.homeScreenView);
                      },
                    ),
                  ],
                ),
                image: buildImage('assets/images/search.json', size),
                decoration: getPageDecoration(size),
              ),
            ],
            onDone: () {
              Navigator.of(context)
                  .pushReplacementNamed(RoutesName.homeScreenView);
            },
            onSkip: () {
              Navigator.of(context)
                  .pushReplacementNamed(RoutesName.homeScreenView);
            },
            showSkipButton: false,
            next: buildButton(icon: Icons.arrow_forward),
            done: const SizedBox.shrink(), // Hide 'done' button
            dotsDecorator: getDotsDecorator(size),
          ),
          // Skip button at top-right corner
          Positioned(
            top: size.height * 0.05,
            right: size.width * 0.05,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context)
                    .pushReplacementNamed(RoutesName.homeScreenView);
              },
              child: const Text(
                "Skip",
                style: TextStyle(
                    color: AppColors.themeColor,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTitle(String title1, title2, title3, Size size) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: size.width * 0.05), // Responsive padding
      child: RichText(
        text: TextSpan(
          style:
              TextStyle(fontSize: size.height * 0.035), // Responsive font size
          children: [
            TextSpan(
                text: title1,
                style: const TextStyle(
                    color: Colors.black, fontFamily: "Poppins")),
            TextSpan(
                text: title2,
                style: const TextStyle(
                    color: AppColors.themeColor,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Poppins")),
            TextSpan(
                text: title3,
                style: const TextStyle(
                    color: Colors.black, fontFamily: "Poppins")),
          ],
        ),
        textAlign: TextAlign.left, // Align text to left
      ),
    );
  }

  Widget buildBody(String body, Size size) {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: size.height * 0.005), // Responsive padding
      child: Text(
        body,
        style: TextStyle(
          fontSize: size.height * 0.022, // Responsive font size
          fontFamily: "Poppins",
          color: Colors.grey.shade600,
          height: 1.5,
        ),
        textAlign: TextAlign.left,
      ),
    );
  }

  PageDecoration getPageDecoration(Size size) {
    return PageDecoration(
      imagePadding: EdgeInsets.all(size.height * 0.02), // Responsive padding
      titlePadding: EdgeInsets.only(
          left: 0,
          bottom: size.height * 0.01,
          right: size.width * 0.04,
          top: size.height * 0.02),
      bodyPadding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
      pageColor: AppColors.backgroundBodyColor,
    );
  }

  DotsDecorator getDotsDecorator(Size size) {
    return DotsDecorator(
      color: Colors.green.shade100,
      activeColor: AppColors.themeColor,
      size: Size(size.width * 0.02, size.height * 0.02), // Responsive dot size
      activeSize: Size(
          size.width * 0.1, size.height * 0.01), // Responsive active dot size
      activeShape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(25.0)),
      ),
    );
  }

  Widget buildButton({String? text, IconData? icon, VoidCallback? onTap}) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: onTap, // Added onTap for button actions
      child: Container(
        height: size.height * 0.067,
        width: text != null
            ? size.width * 0.9
            : size.width * 0.18, // Responsive button size
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: size.height * 0.02),
        decoration: BoxDecoration(
          color: AppColors.themeColor,
          borderRadius: BorderRadius.circular(size.height * 0.015),
        ),
        child: text != null
            ? Text(
                text,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontFamily: "Poppins",
                  fontSize: size.height * 0.02, // Responsive font size
                ),
              )
            : Icon(
                icon,
                color: Colors.white,
                size: size.height * 0.03, // Responsive icon size
              ),
      ),
    );
  }
}
