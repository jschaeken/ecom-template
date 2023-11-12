import 'package:dartz/dartz.dart';
import 'package:ecom_template/features/bag/domain/entities/bag_item.dart';
import 'package:ecom_template/features/bag/domain/entities/bag_item_data.dart';
import 'package:ecom_template/features/bag/util/failures.dart';
import 'package:ecom_template/features/shop/domain/entities/shop_product.dart';
import 'package:ecom_template/features/shop/domain/entities/shop_product_selected_option.dart';
import 'package:flutter/foundation.dart';

Future<Either<IncompleteOptionsSelectionFailure, BagItemData>>
    verifyIncompleteBagItem(IncompleteBagItem incompleteBagItem) async {
  Map<String, int> selectedOptions =
      incompleteBagItem.optionsSelections.selectedOptions;
  List<ShopProductOption> productOptions = incompleteBagItem.product.options;

  if (selectedOptions.length < productOptions.length) {
    return const Left(IncompleteOptionsSelectionFailure(
      message: 'Please select all required options for this product.',
    ));
  }

  List<ShopProductSelectedOption> selectedOptionsList = [];

  for (int i = 0; i < productOptions.length; i++) {
    ShopProductOption productOption = productOptions[i];
    if (productOption.name == null || productOption.values == null) {
      return const Left(IncompleteOptionsSelectionFailure(
        message: 'A configuration error with this product has occured.',
      ));
    }
    String optionName = productOption.name!;
    List<String> optionValues = productOption.values!;
    if (selectedOptions.containsKey(optionName)) {
      int optionIndex = selectedOptions[optionName]!;
      if (optionIndex < 0 || optionIndex >= optionValues.length) {
        return const Left(IncompleteOptionsSelectionFailure(
          message: 'An Unknown Error Has Occured 2.',
        ));
      }
      String optionValue = optionValues[optionIndex];
      selectedOptionsList.add(
        ShopProductSelectedOption(
          name: optionName,
          value: optionValue,
        ),
      );
    } else {
      return const Left(IncompleteOptionsSelectionFailure(
        message: 'Please select all required options for this product',
      ));
    }
  }

  // Find the product variant that matches the selected options
  for (var variant in incompleteBagItem.product.productVariants) {
    if (listEquals(variant.selectedOptions, selectedOptionsList)) {
      return Right(
        BagItemData(
          parentProductId: incompleteBagItem.product.id,
          productVariantId: variant.id,
          quantity: incompleteBagItem.quantity,
        ),
      );
    }
  }

  return const Left(IncompleteOptionsSelectionFailure(
    message: 'An Unknown Error Has Occured 3.',
  ));
}
