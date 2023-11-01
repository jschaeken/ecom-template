import 'package:ecom_template/core/constants.dart';
import 'package:ecom_template/core/presentation/widgets/icon_components.dart';
import 'package:ecom_template/core/presentation/widgets/text_components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class LoadingStateWidget extends StatelessWidget {
  final double height;
  final double width;

  const LoadingStateWidget({
    super.key,
    this.height = 200,
    this.width = double.infinity,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
            height: height,
            width: width,
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: Constants.borderRadius,
            ))
        .animate(
          onComplete: (controller) => controller.repeat(),
        )
        .shimmer(
          angle: 0,
          duration: 1500.ms,
        );
  }
}

class InitialStateWidget extends StatelessWidget {
  const InitialStateWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const SizedBox();
  }
}

class IconTextError extends StatelessWidget {
  const IconTextError({
    super.key,
    required this.icon,
    required this.text,
  });

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(width: double.infinity),
        CustomIcon(icon),
        TextBody(text: text)
      ],
    );
  }
}
