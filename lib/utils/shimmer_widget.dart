import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerEffect {
  static shimmerEffect() {

      return SizedBox(
        height: 800,
        child: Center(
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Display two containers per row
                crossAxisSpacing: 16, // Space between items
                mainAxisSpacing: 16, // Space between items
              ),
              itemCount: 8, // Display 6 shimmer containers
              itemBuilder: (context, index) {
                return Container(
                  height: 150, // Adjust the height as needed
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(
                        12), // Rounded corners for the shimmer container
                  ),
                );
              },
            ),
          ),
        ),
      );
    }

}
