import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SafeImage extends StatelessWidget {
  const SafeImage({
    super.key,
    required this.imageUrl,
    this.width,
  });

  final String? imageUrl;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      imageUrl ?? '',
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Image.asset(
          'assets/images/placeholder-image.png',
          fit: BoxFit.contain,
          alignment: Alignment.center,
          width: width,
        ).animate().fadeIn();
      },
    );
  }
}
