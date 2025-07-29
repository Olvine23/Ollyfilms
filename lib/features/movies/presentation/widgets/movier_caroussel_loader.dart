import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
 

class MovieCarouselShimmer extends StatelessWidget {
  const MovieCarouselShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Shimmer.fromColors(
        baseColor: Colors.grey[800]!,
        highlightColor: Colors.greenAccent,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          itemCount: 6,
          itemBuilder: (_, __) {
            return Column(
              children: [
                Container(
                  width: 120,
                  height: 160,
                  decoration: BoxDecoration(
                    color: Colors.lightGreenAccent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                const SizedBox(height: 8),
                // Container(
                //   width: 100,
                //   height: 12,
                //   color: Colors.grey[900],
                // ),
              ],
            );
          },
          separatorBuilder: (_, __) => const SizedBox(width: 12),
        ),
      ),
    );
  }
}
