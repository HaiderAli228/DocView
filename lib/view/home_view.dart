import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:docsview/utils/app_colors.dart';
import 'package:docsview/view/first_tab(scanner).dart';
import 'package:docsview/view/second_tab(paper).dart';
import 'package:docsview/view/third_tab(profile).dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => HomeViewState();
}

class HomeViewState extends State<HomeView> {
  int _page = 0;
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  // Shared data to store response from FirstTabScanner
  String? summary;
  String? outlines;

  // List of pages to display
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      FirstTabScanner(onFileProcessed: updateResponse), // Pass callback
      SecondTabPaper(summary: summary, outlines: outlines),
      const ThirdTabProfile(),
    ];
  }

  void updateResponse(String newSummary, String newOutlines) {
    setState(() {
      summary = newSummary;
      outlines = newOutlines;
      _page = 1; // Switch to SecondTabPaper
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _pages[_page],
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.white,
        color: AppColors.themeColor,
        key: _bottomNavigationKey,
        animationDuration: const Duration(milliseconds: 300),
        animationCurve: Curves.linear,
        items: const [
          Icon(Icons.screen_search_desktop_rounded,
              color: AppColors.themeIconColor, size: 30),
          Icon(Icons.assignment_rounded,
              color: AppColors.themeIconColor, size: 30),
          Icon(FontAwesomeIcons.solidCircleUser,
              color: AppColors.themeIconColor, size: 30),
        ],
        onTap: (index) {
          setState(() {
            _page = index;
          });
        },
      ),
    );
  }
}
