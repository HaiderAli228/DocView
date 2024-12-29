// lib/widgets/shimmer_widget.dart

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerWidget extends StatelessWidget {
  final int itemCount;
  final double height;
  final int crossAxisCount;

  const ShimmerWidget({
    Key? key,
    this.itemCount = 6,  // Default shimmer item count
    this.height = 150,   // Default shimmer height
    this.crossAxisCount = 2, // Default grid items per row
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: itemCount,
        itemBuilder: (context, index) {
          return Container(
            height: height,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
          );
        },
      ),
    );
  }
}
