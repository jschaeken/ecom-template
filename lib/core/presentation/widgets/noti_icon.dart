import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class NotiIcon extends StatelessWidget {
  final IconData icon;
  final bool visible;
  final bool isUnder;
  final String? text;

  const NotiIcon({
    required this.icon,
    this.isUnder = false,
    this.text,
    required this.visible,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: visible && isUnder ? 3 : 0),
          child: Icon(
            icon,
          ),
        ),
        visible
            ? Container(
                margin: EdgeInsets.zero,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  shape: BoxShape.circle,
                ),
                constraints: const BoxConstraints(
                  minWidth: 5,
                  minHeight: 5,
                ),
              ).animate().scaleXY(
                  curve: Curves.bounceOut,
                )
            : const SizedBox(),
      ],
    );
  }
}
