import 'package:ecom_template/core/presentation/widgets/custom_snackbar.dart';
import 'package:ecom_template/features/bag/domain/entities/bag_item.dart';
import 'package:flutter/material.dart';

void showAddedToBagSnackBar({
  required BuildContext context,
  required BagItem bagItem,
  required VoidCallback onTap,
}) async {
  ScaffoldMessenger.of(context).clearSnackBars();
  // Show SnackBar
  ScaffoldMessenger.of(context).showSnackBar(
    buildCustomSnackbar(
      text: '${bagItem.title} Added to bag',
      actionLabel: 'View Bag',
      onActionTap: onTap,
      context: context,
    ),
  );
}

void showRemovedFromBagSnackBar({
  required BuildContext context,
  required BagItem bagItem,
  required VoidCallback onTap,
}) async {
  ScaffoldMessenger.of(context).clearSnackBars();
  // Show SnackBar
  ScaffoldMessenger.of(context).showSnackBar(
    buildCustomSnackbar(
      text: 'Item Removed',
      context: context,
    ),
  );
}
