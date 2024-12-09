import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/custom_card.dart';

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
                  children: _buildCards(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildCards(BuildContext context) {
    return [
      _buildOptionCard(context, Icons.book, "Semester Books", () {}),
      _buildOptionCard(context, Icons.description_outlined, "Book Outlines", () {}),
      _buildOptionCard(context, Icons.assignment_outlined, "Mid Past Papers", () {}),
      _buildOptionCard(context, Icons.library_books_outlined, "Final Past Papers", () {}),
      _buildOptionCard(context, Icons.task, "Time Table", () {}),
      _buildOptionCard(context, Icons.note, "Lecture Notes", () {}),
      _buildOptionCard(context, Icons.quiz_outlined, "Imp Questions", () {}),
    ];
  }

  Widget _buildOptionCard(BuildContext context, IconData icon, String label, VoidCallback onTap) {
    return CustomCard(
      icon: icon,
      label: label,
      onTap: onTap,
    );
  }
}
