import 'package:docsview/utils/app_colors.dart';
import 'package:flutter/material.dart';

class DrawerTile extends StatelessWidget {
  const DrawerTile({this.name,  this.function, super.key, this.iconIs});
  final String? name;
  final VoidCallback? function;
  final Icon? iconIs;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      child: InkWell(
        onTap: function,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 5),
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.05),
            borderRadius: BorderRadius.circular(8), // Rounded corners
          ),
          child: ListTile(
            leading: iconIs,
            iconColor: AppColors.themeColor,
            title: Text(
              name ?? "Nothing",
              style: const TextStyle(
                fontFamily: "Poppins",
              ),
            ),
          ),
        ),
      ),
    );
  }
}
