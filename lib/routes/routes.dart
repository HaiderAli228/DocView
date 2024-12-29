import 'package:docsview/routes/routes_name.dart';
import 'package:flutter/material.dart';
import '../view/home_view.dart';
import '../view/result_screen.dart';

class Routes {
  /// Generates routes based on the route name and arguments
  static Route<dynamic> generatedRoutes(RouteSettings settings) {
    switch (settings.name) {
      case RoutesName.homeScreenView:
        return _createRoute(const HomeView());

      case RoutesName.resultView:
        final args = settings.arguments as Map<String, dynamic>?;

        if (args != null &&
            args.containsKey('folderId') &&
            args.containsKey('folderName')) {
          return _createRoute(ResultScreen(
            folderId: args['folderId'],
            folderName: args['folderName'],
          ));
        } else {
          return _errorRoute("Invalid or missing arguments for Result Screen");
        }

      default:
        return _errorRoute("No Route Defined for '${settings.name}'");
    }
  }

  /// Creates a custom route with smooth animations
  static PageRouteBuilder _createRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const curve = Curves.easeInOut;

        final slideAnimation = Tween<Offset>(
          begin: const Offset(0.0, 1.0),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: animation,
          curve: curve,
        ));

        final fadeAnimation = Tween<double>(
          begin: 0.0,
          end: 1.0,
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
      transitionDuration: const Duration(milliseconds: 500),
      reverseTransitionDuration: const Duration(milliseconds: 500),
    );
  }

  /// Handles error routes with a customizable message
  static Route<dynamic> _errorRoute(String message) {
    return MaterialPageRoute(
      builder: (context) => Scaffold(
        body: Center(
          child: Text(
            message,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
