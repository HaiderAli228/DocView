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

  // List of pages to display based on the selected index
  final List<Widget> _pages = [
    const FirstTabScanner(),
    const SecondTabPaper(),
    const ThirdTabProfile(),
  ];

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
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:syncfusion_flutter_pdf/pdf.dart';
// import 'package:docx_to_text/docx_to_text.dart';
// import '../model/api_services.dart';
// import '../view/r_screen.dart';
//
// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});
//
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   File? selectedFile;
//   bool isLoading = false;
//
//   // Method to pick a file
//   Future<void> pickFile() async {
//     final result = await FilePicker.platform.pickFiles(
//       type: FileType.custom,
//       allowedExtensions: ['txt', 'docx', 'pdf'], // Support multiple formats
//     );
//
//     if (result != null && result.files.isNotEmpty) {
//       setState(() {
//         selectedFile = File(result.files.single.path!); // Set the selected file
//       });
//     } else {
//       setState(() {
//         selectedFile = null; // No file selected
//       });
//     }
//   }
//   Future<void> processFile() async {
//     if (selectedFile == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please select a file to process.')),
//       );
//       return;
//     }
//
//     setState(() {
//       isLoading = true;
//     });
//
//     try {
//       String fileContent = '';
//
//       // Check the file extension and read it accordingly
//       if (selectedFile!.path.endsWith('.txt')) {
//         // Read text file
//         fileContent = await selectedFile!.readAsString();
//       } else if (selectedFile!.path.endsWith('.docx')) {
//         // Use docx_to_text to extract content
//         final bytes = await selectedFile!.readAsBytes(); // Read the file as bytes
//         fileContent = docxToText(bytes); // Extract text from .docx file
//       } else if (selectedFile!.path.endsWith('.pdf')) {
//         // Use syncfusion_flutter_pdf to extract content
//         final pdfBytes = await selectedFile!.readAsBytes();
//         final pdfDocument = PdfDocument(inputBytes: pdfBytes);
//         fileContent = PdfTextExtractor(pdfDocument).extractText();
//       } else {
//         throw Exception('Unsupported file format');
//       }
//
//       // Process the file content using GeminiService
//       final geminiService = GeminiService();
//       final response = await geminiService.processDocument(fileContent);
//
//       // Navigate to the result screen with the response
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => ResultScreen(response: response),
//         ),
//       );
//     } catch (e) {
//       // Handle errors
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error processing file: $e')),
//       );
//     } finally {
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Document Processor'),
//       ),
//       body: Center(
//         child: isLoading
//             ? const CircularProgressIndicator() // Show loading indicator while processing
//             : Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             if (selectedFile != null)
//               Text(
//                 'Selected File: ${selectedFile!.path.split('/').last}', // Display selected file name
//                 textAlign: TextAlign.center,
//               ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: pickFile, // Trigger file picker on button press
//               child: const Text('Select File'),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: processFile, // Process file on button press
//               child: const Text('Process File'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
//
