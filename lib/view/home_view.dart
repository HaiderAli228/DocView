import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:docsview/utils/app_colors.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        // color: Colors.blueAccent,
        child: Center(
          child: Column(
            children: [
              Text(_page.toString(), textScaleFactor: 10.0),
              ElevatedButton(
                child: const Text('Go To Page of index 1'),
                onPressed: () {
                  final CurvedNavigationBarState? navBarState =
                      _bottomNavigationKey.currentState;
                  navBarState?.setPage(1);
                },
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.white,
        color: AppColors.themeColor,
        key: _bottomNavigationKey,
        animationCurve: Curves.linear,
        items: const [
          Icon(FontAwesomeIcons.houseChimneyUser,
              color: AppColors.themeIconColor, size: 30),
          Icon(FontAwesomeIcons.solidClipboard,
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
