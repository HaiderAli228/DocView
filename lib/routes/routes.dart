import 'package:docsview/routes/routes_name.dart';
import 'package:docsview/view/SemesterDetailView/book_outlines.dart';
import 'package:docsview/view/SemesterDetailView/final_past_paper.dart';
import 'package:docsview/view/SemesterDetailView/imp_question.dart';
import 'package:docsview/view/SemesterDetailView/lecture_notes.dart';
import 'package:docsview/view/SemesterDetailView/mid_past_paper.dart';
import 'package:docsview/view/SemesterDetailView/semester_book.dart';
import 'package:docsview/view/SemesterDetailView/time_table.dart';
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
      case RoutesName.homeScreenView:
        return _createRoute(const HomeView());

      case RoutesName.splashScreenView:
        return _createRoute(const SplashScreen());

      case RoutesName.semesterBookDetailView:
        return _createRoute(const SemesterBookDetail());

      case RoutesName.semesterFinalPaperDetailView:
        return _createRoute(const SemesterFinalPaperDetail());

      case RoutesName.semesterMidPaperDetailView:
        return _createRoute(const SemesterMidPaperDetail());

      case RoutesName.semesterTTableDetailView:
        return _createRoute(const SemesterTTableDetail());

      case RoutesName.semesterImpQusDetailView:
        return _createRoute(const SemesterImpQuestionDetail());

      case RoutesName.semesterNotesDetailView:
        return _createRoute(const SemesterNotesDetail());

      case RoutesName.semesterOutlinesDetailView:
        return _createRoute(const SemesterBookOutlinesDetail());

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
