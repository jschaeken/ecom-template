import 'dart:async';

import 'package:ecom_template/core/constants.dart';
import 'package:ecom_template/core/presentation/widgets/buttons.dart';
import 'package:ecom_template/core/presentation/widgets/custom_snackbar.dart';
import 'package:ecom_template/core/presentation/widgets/icon_components.dart';
import 'package:ecom_template/core/presentation/widgets/layout.dart';
import 'package:ecom_template/core/presentation/widgets/saved_product_list_tile.dart';
import 'package:ecom_template/core/presentation/widgets/text_components.dart';
import 'package:ecom_template/features/bag/domain/entities/bag_item.dart';
import 'package:flutter/cupertino.dart';
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

void showAddedToBagModal({
  required BuildContext context,
  required BagItem bagItem,
  required VoidCallback onCheckoutTap,
}) async {
  await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      showDragHandle: true,
      builder: (context) {
        return ClipRRect(
          borderRadius: Constants.borderRadius.copyWith(
            bottomLeft: Radius.zero,
            topRight: Radius.zero,
          ),
          child: Container(
            color: Theme.of(context).canvasColor,
            height: 340,
            child: Padding(
              padding: Constants.padding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CustomIcon(
                        CupertinoIcons.check_mark_circled_solid,
                        color: Theme.of(context).indicatorColor,
                      ),
                      const StandardSpacing(horizontalAxis: true),
                      TextHeadline(
                        text: 'Item Added',
                        color: Theme.of(context).primaryColor,
                      ),
                    ],
                  ),
                  const StandardSpacing(),
                  SavedProductListTile(
                    onTap: () {},
                    title: bagItem.title,
                    imageUrl: bagItem.image?.originalSrc,
                    isOutOfStock: bagItem.isOutOfStock,
                    price: bagItem.price,
                    subHeadings:
                        bagItem.selectedOptions?.map((e) => e.value).toList(),
                  ),
                  const StandardSpacing(multiplier: 2),
                  CtaButton(
                    onTap: () {
                      Navigator.of(context).pop();
                      onCheckoutTap();
                    },
                    color: Theme.of(context).primaryColor,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomIcon(
                          CupertinoIcons.lock_fill,
                          color: Theme.of(context).canvasColor,
                        ),
                        const StandardSpacing(horizontalAxis: true),
                        TextSubHeadline(
                          text: 'Checkout Securely',
                          color: Theme.of(context).canvasColor,
                        )
                      ],
                    ),
                  ),
                  const StandardSpacing(),
                ],
              ),
            ),
          ),
        );
      });
}
