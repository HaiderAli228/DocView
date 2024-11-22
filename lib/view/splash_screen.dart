import 'package:docsview/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedTextKit(
              animatedTexts: [
                TypewriterAnimatedText(
                  textAlign: TextAlign.center,
                  'DocView',
                  textStyle: const TextStyle(
                    fontSize: 32.0,
                    fontWeight: FontWeight.bold,
                    color: AppColors.themeColor
                  ),
                  speed: const Duration(milliseconds: 100),
                ),
              ],
              repeatForever: true,
              pause: const Duration(milliseconds: 1000),
              displayFullTextOnTap: true,
              stopPauseOnTap: true,
            )
          ],
        ),
      ),
    );
  }
}
