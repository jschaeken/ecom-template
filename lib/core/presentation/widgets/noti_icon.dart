import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:ecom_template/core/constants.dart';
import 'package:ecom_template/core/presentation/widgets/text_components.dart';

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
    return (visible && isUnder)
        ? Column(
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: visible && isUnder ? 3 : 0),
                child: Icon(
                  icon,
                ),
              ),
              Container(
                margin: EdgeInsets.zero,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  shape: BoxShape.circle,
                ),
                constraints: const BoxConstraints(
                  minWidth: 9,
                  minHeight: 9,
                ),
              ).animate().scaleXY(
                    curve: Curves.bounceOut,
                  ),
            ],
          )
        : Stack(
            children: [
              Icon(
                icon,
              ),
              if (visible && !isUnder)
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    margin: EdgeInsets.zero,
                    padding: Constants.innerPadding,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Center(
                      child: TextBody(
                        text: text ?? ' ',
                        color: Theme.of(context).canvasColor,
                      ),
                    ),
                  ).animate().scaleXY(
                        curve: Curves.bounceOut,
                      ),
                ),
              if (visible && isUnder)
                Container(
                  margin: EdgeInsets.zero,
                  padding: Constants.innerPadding,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: Center(
                    child: TextBody(
                      text: text ?? ' ',
                      color: Theme.of(context).canvasColor,
                    ),
                  ),
                ).animate().scaleXY(
                      curve: Curves.bounceOut,
                    ),
            ],
          );
  }
}
