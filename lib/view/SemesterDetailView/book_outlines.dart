import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SemesterBookOutlinesDetail extends StatelessWidget {
  const SemesterBookOutlinesDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Book Outlines'),
          backgroundColor: Colors.blue,
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('outlines').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: Text('Error loading outlines'));
            } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text('No outlines available'));
            }

            final outlines = snapshot.data!.docs;

            return ListView.builder(
              itemCount: outlines.length,
              itemBuilder: (context, index) {
                final outline = outlines[index];
                final title = outline['title'] ?? 'Untitled';
                final description = outline['description'] ?? 'No description';
                final icon = outline['icon'] ?? Icons.book.codePoint;

                return ListTile(
                  leading: Icon(IconData(icon, fontFamily: 'MaterialIcons')),
                  title: Text(title),
                  subtitle: Text(description),
                  onTap: () {
                    // Handle navigation or further actions
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
