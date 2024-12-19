import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SemesterBookOutlinesDetail extends StatelessWidget {
  const SemesterBookOutlinesDetail({super.key});

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
              .collection('departments')
              .doc("ComputerScience")
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              print("Error: ${snapshot.error}");
              return const Center(child: Text('Error loading outline'));
            }
            if (!snapshot.hasData || !snapshot.data!.exists) {
              print("No data found for the document.");
              return const Center(child: Text('No outline available'));
            }

            // Parse document data
            final data = snapshot.data!.data() as Map<String, dynamic>;
            final downloadUrl = data['url'];
            final title = data['title'] ?? 'Untitled';

            if (downloadUrl == null) {
              print("Missing 'url' in document data.");
              return const Center(child: Text('No valid URL available'));
            }

            return ListView(
              children: [
                ListTile(
                  leading: const Icon(Icons.book, color: Colors.blue),
                  title: Text(title),
                  subtitle: const Text('Tap to view or download'),
                  onTap: () {
                    _openDownloadUrl(context, downloadUrl);
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
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      debugPrint('Error launching URL: $e');
    }
  }
}
