import 'package:docsview/routes/routes_name.dart';
import 'package:docsview/view/ai_view.dart';
import 'package:docsview/view/intro_view.dart';
import 'package:flutter/material.dart';
import '../view/dept_detail_view.dart';
import '../view/home_view.dart';
import '../view/semester_detail_view.dart';
import '../view/splash_screen.dart';

class Routes {
  static Route<dynamic> generatedRoutes(RouteSettings settings) {
    switch (settings.name) {
      case RoutesName.homeScreenView:
        return _createRoute(const HomeView());

      case RoutesName.deptDetailView:
        if (settings.arguments is Map<String, String>) {
          final department = settings.arguments as Map<String, String>;
          return _createRoute(DeptDetailView(
            departmentName: department['name']!,
            departmentIcon: department['icon']!,
          ));
        } else {
          return _errorRoute("Invalid department data");
        }
        case RoutesName.semesterDetailView:
        if (settings.arguments is Map<String, String>) {
          final department = settings.arguments as Map<String, String>;
          return _createRoute(SemesterDetailView(
            departmentName: department['name']!,
            departmentIcon: department['icon']!,
          ));
        } else {
          return _errorRoute("Invalid department data");
        }

      case RoutesName.splashScreenView:
        return _createRoute(const SplashScreen());

      case RoutesName.aiScreenView:
        return _createRoute(const AiView());

      case RoutesName.introScreenView:
        return _createRoute(const IntroScreen());

      default:
        return _errorRoute("Route Not Found");
    }
  }

  // Helper function to create a smooth animated route
  static PageRouteBuilder _createRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const curve = Curves.easeInOut; // Smooth curve for both entry and exit

        var slideAnimation = Tween<Offset>(
          begin: const Offset(0.0, 1.0), // Slide from bottom to top
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: animation,
          curve: curve,
        ));

        var fadeAnimation = Tween<double>(
          begin: 0.0, // Fade from transparent
          end: 1.0, // To fully visible
        ).animate(CurvedAnimation(
          parent: animation,
          curve: curve,
        ));

        return FadeTransition(
          opacity: fadeAnimation,
          child: SlideTransition(
            position: slideAnimation,
            child: child,
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 500), // Smooth speed
      reverseTransitionDuration:
      const Duration(milliseconds: 500), // Smooth for pop too
    );
  }

  // Helper function to handle errors
  static Route<dynamic> _errorRoute(String message) {
    return MaterialPageRoute(
      builder: (context) => Scaffold(
        body: Center(child: Text(message)),
      ),
    );
  }
}
