import 'package:dartz/dartz.dart';
import 'package:ecom_template/features/bag/domain/entities/bag_item.dart';
import 'package:ecom_template/features/bag/domain/entities/bag_item_data.dart';
import 'package:ecom_template/features/bag/domain/entities/options_selection.dart';
import 'package:ecom_template/features/bag/util/failures.dart';
import 'package:ecom_template/features/shop/domain/entities/shop_product.dart';
import 'package:ecom_template/features/shop/domain/entities/shop_product_selected_option.dart';
import 'package:flutter/foundation.dart';

class VerifyOptions {
  Future<Either<IncompleteOptionsSelectionFailure, BagItemData>>
      verifyIncompleteBagItem(
          {required IncompleteBagItem incompleteBagItem}) async {
    Map<String, int> selectedOptions =
        incompleteBagItem.optionsSelections.selectedOptions;
    List<ShopProductOption> productOptions = incompleteBagItem.product.options;

    Map<String, int> currentOptions = {};
    List<ShopProductSelectedOption> selectedOptionsList = [];
    for (int i = 0; i < productOptions.length; i++) {
      ShopProductOption productOption = productOptions[i];
      if (productOption.name == null || productOption.values == null) {
        continue;
      }
      String optionName = productOption.name!;
      List<String> optionValues = productOption.values!;
      if (selectedOptions.containsKey(optionName)) {
        int optionIndex = selectedOptions[optionName]!;
        if (optionIndex < 0 || optionIndex >= optionValues.length) {
        } else {
          currentOptions.addAll({optionName: optionIndex});
          String optionValue = optionValues[optionIndex];
          selectedOptionsList.add(
            ShopProductSelectedOption(
              name: optionName,
              value: optionValue,
            ),
          );
        }
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

    return Left(IncompleteOptionsSelectionFailure(
      currentSelectedOptions: OptionsSelections(
        selectedOptions: currentOptions,
      ),
    ));
  }
}
