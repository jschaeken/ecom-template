import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SafeImage extends StatelessWidget {
  const SafeImage({
    super.key,
    required this.imageUrl,
    this.assetUrl,
    this.width,
  });

  final String? imageUrl;
  final double? width;
  final String? assetUrl;

  @override
  Widget build(BuildContext context) {
    return assetUrl != null && imageUrl == null
        ? Image.asset(
            assetUrl ?? '',
            fit: BoxFit.cover,
            alignment: Alignment.center,
            width: width,
          ).animate().fadeIn()
        : Image.network(imageUrl ?? '', fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
            return Image.asset(
              'assets/images/placeholder-image.png',
              fit: BoxFit.contain,
              alignment: Alignment.center,
              width: width,
            );
          }).animate().fadeIn();
  }
}
