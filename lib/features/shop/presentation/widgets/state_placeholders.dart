import 'package:ecom_template/core/constants.dart';
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
