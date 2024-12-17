import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SemesterBookOutlinesDetail extends StatelessWidget {
  final String department; // Example: "ComputerScience"
  final String semester; // Example: "Semester1"

  const SemesterBookOutlinesDetail({
    required this.department,
    required this.semester,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Books Outline'),
          backgroundColor: Colors.blue,
        ),
        body: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('Departments')
              .doc(department)
              .collection('semester')
              .doc(semester)
              .collection('resources')
              .doc('outline') // Access the specific document named "outline"
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return const Center(child: Text('Error loading outline'));
            }
            if (!snapshot.hasData || !snapshot.data!.exists) {
              return const Center(child: Text('No outline available'));
            }

            final data = snapshot.data!.data() as Map<String, dynamic>;
            final title = data['title'] ?? 'Untitled';
            final downloadUrl = data['download_url'];

            return ListView(
              children: [
                ListTile(
                  leading: const Icon(Icons.book, color: Colors.blue),
                  title: Text(title),
                  subtitle: const Text('Tap to view or download'),
                  onTap: () {
                    if (downloadUrl != null) {
                      _openDownloadUrl(context, downloadUrl);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('No download URL available')),
                      );
                    }
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _openDownloadUrl(BuildContext context, String url) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Open Book'),
        content: const Text('Do you want to open the book?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _launchURL(url);
            },
            child: const Text('Open'),
          ),
        ],
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      debugPrint('Error launching URL: $e');
    }
  }
}
