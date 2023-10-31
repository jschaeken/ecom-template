import 'package:ecom_template/core/constants.dart';
import 'package:ecom_template/core/presentation/widgets/icon_components.dart';
import 'package:ecom_template/core/presentation/widgets/text_components.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class CategoryImageBox extends StatelessWidget {
  const CategoryImageBox({
    required this.imageUrl,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.height = 400,
    super.key,
  });

  final String imageUrl;
  final String title;
  final String subtitle;
  final Function onTap;
  final double height;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        height: height,
        decoration: BoxDecoration(
          borderRadius: Constants.borderRadius,
          image: DecorationImage(
            fit: BoxFit.cover,
            image: NetworkImage(
              imageUrl,
            ),
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: Constants.borderRadius,
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.center,
              colors: [
                Theme.of(context).primaryColor.withOpacity(0.9),
                Theme.of(context).primaryColor.withOpacity(0.0),
              ],
            ),
          ),
          child: Padding(
            padding: Constants.padding,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Title and Subtitle Text
                  Flexible(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        TextDisplay(
                          text: title,
                          color: Theme.of(context).canvasColor,
                        ),

                        // Subtitle
                        TextBody(
                          text: subtitle,
                          color: Theme.of(context).canvasColor,
                        ),
                      ],
                    ),
                  ),

                  // Forward Arrow Icon
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Colors.white.withOpacity(0.5),
                        ),
                        height: 70,
                        width: 70,
                      )
                          .animate(
                            onPlay: (controller) =>
                                controller.repeat(reverse: true),
                          )
                          .scaleXY(
                            begin: 1,
                            end: .5,
                            duration: 800.ms,
                          )
                          .fade()
                          .then(delay: 800.ms),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Theme.of(context).canvasColor,
                        ),
                        child: const CustomIcon(
                          CupertinoIcons.chevron_forward,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
