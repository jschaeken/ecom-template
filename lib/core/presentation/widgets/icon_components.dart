import 'package:flutter/material.dart';

class CustomIcon extends StatelessWidget {
  const CustomIcon(this.iconData, {this.color, this.size, super.key});

  final IconData iconData;
  final double? size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Icon(
      iconData,
      size: size ?? 24,
      color: color ?? Theme.of(context).primaryColor,
    );
  }
}
