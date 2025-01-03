import 'package:docsview/utils/app_colors.dart';
import 'package:docsview/view-model/provider.dart';
import 'package:docsview/view/home_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env"); // Load environment variables
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => HomeViewModel()),
        ChangeNotifierProvider(create: (context) => ResultScreenProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: "Poppins",
          primaryColor: AppColors.themeColor,
          primarySwatch: Colors.blue,
        ),
        home: const HomeView(),
      ),
    );
  }
}
