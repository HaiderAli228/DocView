
import 'package:docsview/routes/routes.dart';
import 'package:docsview/routes/routes_name.dart';
import 'package:docsview/utils/app_colors.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.themeColor,
            primarySwatch: Colors.blue
      ),
      initialRoute: RoutesName.homeScreenView,
      onGenerateRoute: Routes.generatedRoutes,
    );
  }
}
