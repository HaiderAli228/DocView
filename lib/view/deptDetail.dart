import 'package:flutter/material.dart';

class DeptDetailView extends StatelessWidget {
  final String departmentName;

  const DeptDetailView({super.key, required this.departmentName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          departmentName,
          style: const TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.teal, // Change as needed
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: 8, // 8 Semesters
          itemBuilder: (context, index) {
            return Card(
              elevation: 4,
              shadowColor: Colors.grey.withOpacity(0.4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: InkWell(
                onTap: () {
                  // Handle semester-specific navigation or actions
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Semester ${index + 1} clicked!'),
                    ),
                  );
                },
                child: Center(
                  child: Text(
                    'Semester ${index + 1}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
