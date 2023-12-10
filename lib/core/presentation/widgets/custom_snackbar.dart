import 'package:ecom_template/core/presentation/widgets/text_components.dart';
import 'package:flutter/material.dart';

SnackBar buildCustomSnackbar({
  required String text,
  String? actionLabel,
  VoidCallback? onActionTap,
  required BuildContext context,
}) {
  return SnackBar(
    behavior: SnackBarBehavior.floating,
    // ignore: avoid_unnecessary_containers
    content: Container(
        child: TextBody(
      text: text,
      maxLines: 3,
    )),
    backgroundColor: Theme.of(context).canvasColor,
    action: actionLabel != null && onActionTap != null
        ? SnackBarAction(
            label: actionLabel,
            onPressed: onActionTap,
          )
        : null,
  );
}
