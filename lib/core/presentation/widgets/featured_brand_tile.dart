import 'package:ecom_template/core/constants.dart';
import 'package:ecom_template/core/presentation/widgets/safe_image.dart';
import 'package:ecom_template/core/presentation/widgets/text_components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class FeaturedBrandTile extends StatelessWidget {
  const FeaturedBrandTile({
    super.key,
    required this.brand,
  });

  final List<String> brand;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        ClipRRect(
          borderRadius: Constants.borderRadius,
          child: SafeImage(imageUrl: brand[1]),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: Constants.borderRadius,
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                Colors.black.withOpacity(.8),
                Colors.black.withOpacity(0.2),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 10,
          left: 10,
          child: TextBody(
            text: brand[0],
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
