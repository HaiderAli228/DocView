import 'package:flutter/material.dart';

import '../utils/app_colors.dart';

class SemesterDetailView extends StatelessWidget {
  final String departmentName;
  final String departmentIcon;

  const SemesterDetailView({
    super.key,
    required this.departmentName,
    required this.departmentIcon,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: AppColors.themeColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.arrow_back,
                    color: AppColors.themeColor,
                    size: 30,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              RichText(
                text: TextSpan(
                  style: const TextStyle(fontSize: 22),
                  children: [
                    const TextSpan(
                      text: "Explore your passion with your own department of ",
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: "Poppins",
                      ),
                    ),
                    TextSpan(
                      text: departmentName,
                      style: const TextStyle(
                        color: AppColors.themeColor,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Poppins",
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: GridView(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  children: [
                    _buildOptionCard(
                      context,
                      icon: Icons.assignment_outlined,
                      label: "MIS Past Papers",
                      onTap: () {
                        // Navigate to MIS Past Papers
                      },
                    ),
                    _buildOptionCard(
                      context,
                      icon: Icons.library_books_outlined,
                      label: "Final Past Papers",
                      onTap: () {
                        // Navigate to Final Past Papers
                      },
                    ),
                    _buildOptionCard(
                      context,
                      icon: Icons.book,
                      label: "Books of Semester",
                      onTap: () {
                        // Navigate to Books of Semester
                      },
                    ),
                    _buildOptionCard(
                      context,
                      icon: Icons.description_outlined,
                      label: "Book Outlines",
                      onTap: () {
                        // Navigate to Book Outlines
                      },
                    ),
                    _buildOptionCard(
                      context,
                      icon: Icons.task,
                      label: "Assignments",
                      onTap: () {
                        // Navigate to Assignments
                      },
                    ),
                    _buildOptionCard(
                      context,
                      icon: Icons.note,
                      label: "Lecture Notes",
                      onTap: () {
                        // Navigate to Lecture Notes
                      },
                    ),
                    _buildOptionCard(
                      context,
                      icon: Icons.quiz_outlined,
                      label: "Practice Questions",
                      onTap: () {
                        // Navigate to Practice Questions
                      },
                    ),
                    _buildOptionCard(
                      context,
                      icon: Icons.more_horiz,
                      label: "More Options",
                      onTap: () {
                        // Navigate to More Options
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionCard(BuildContext context,
      {required IconData icon, required String label, required VoidCallback onTap}) {
    return Card(
      elevation: 6,
      color: Colors.white,
      shadowColor: Colors.grey.withOpacity(0.4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 40,
              color: AppColors.themeColor,
            ),
            const SizedBox(height: 10),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontFamily: "Poppins",
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}