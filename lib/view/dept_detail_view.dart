import 'package:flutter/material.dart';

import '../routes/routes_name.dart';
import '../utils/app_colors.dart';

class DeptDetailView extends StatelessWidget {
  final String departmentName;
  final String departmentIcon;

  DeptDetailView({
    super.key,
    required this.departmentName,
    required this.departmentIcon,
  });

  final semesterDetails = [
    {'icon': Icons.looks_one, 'name': "Semester"},
    {'icon': Icons.looks_two, 'name': "Semester"},
    {'icon': Icons.looks_3, 'name': "Semester"},
    {'icon': Icons.looks_4, 'name': "Semester"},
    {'icon': Icons.looks_5, 'name': "Semester"},
    {'icon': Icons.looks_6, 'name': "Semester"},
    {'icon': Icons.auto_graph, 'name': "Research \nSemester"},
    {'icon': Icons.workspace_premium, 'name': "    Final \nSemester"},
  ];

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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
        
                ],
              ),
              const SizedBox(height: 20),
              RichText(
                text: TextSpan(
                  style: const TextStyle(fontSize: 22),
                  children: [
                    const TextSpan(
                      text: "Welcome to the department of ",
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
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: semesterDetails.length, // Use semesterDetails count
                  itemBuilder: (context, index) {
                    final semester = semesterDetails[index];
                    return Card(
                      elevation: 6,
                      color: Colors.white,
                      margin: const EdgeInsets.all(8),
                      shadowColor: Colors.grey.withOpacity(0.4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: InkWell(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            RoutesName.semesterDetailView,
                            arguments: {
                              'name': departmentName,
                              'icon': departmentIcon,
                            },
                          );
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              semester['icon'] as IconData,
                              size: 40,
                              color: AppColors.themeColor,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              semester['name'] as String,
                              style: const TextStyle(
                                fontSize: 18,
                                fontFamily: "Poppins",
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
