// import 'package:docsview/routes/routes.dart';
// import 'package:docsview/routes/routes_name.dart';
// import 'package:docsview/utils/app_colors.dart';
// import 'package:flutter/material.dart';
//
// import 'model/api_services.dart';
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//
//   // Initialize authentication
//   await ApiService.initializeAuthentication();
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//           primaryColor: AppColors.themeColor, primarySwatch: Colors.blue),
//       initialRoute: RoutesName.homeScreenView,
//       onGenerateRoute: Routes.generatedRoutes,
//     );
//   }
// }
import 'package:docsview/view/home_view.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Document Processor',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomeView(),
    );
  }
}
