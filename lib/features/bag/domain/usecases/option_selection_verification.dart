import 'package:dartz/dartz.dart';
import 'package:ecom_template/core/error/failures.dart';
import 'package:ecom_template/features/bag/domain/entities/bag_item_data.dart';
import 'package:ecom_template/features/bag/domain/entities/product_selections.dart';
import 'package:ecom_template/features/shop/domain/entities/shop_product.dart';
import 'package:ecom_template/features/shop/domain/entities/shop_product_selected_option.dart';
import 'package:flutter/foundation.dart';

class VerifyOptions {
  Either<Failure, BagItemData> getBagItemData(
      {required ShopProduct shopProduct,
      required ProductSelections productSelections}) {
    List<ShopProductOption> productOptions = shopProduct.options;
    List<ProductSelection> selections = productSelections.selections;

    List<ShopProductSelectedOption> userSelectedOptions = [];
    for (int i = 0; i < productOptions.length; i++) {
      ShopProductOption productOption = productOptions[i];
      if (productOption.values.isEmpty) {
        continue;
      }
      String optionName = productOption.name;
      String optionValue = selections[i].chosenValue;
      userSelectedOptions.add(
        ShopProductSelectedOption(
          name: optionName,
          value: optionValue,
        ),
      );
    }

    // Find the product variant that matches the selected options
    for (var variant in shopProduct.productVariants) {
      if (listEquals(variant.selectedOptions, userSelectedOptions)) {
        return Right(
          BagItemData(
            parentProductId: shopProduct.id,
            productVariantTitle: variant.title,
            productVariantId: variant.id,
            quantity: productSelections.quantity,
          ),
        );
      }
    }

    return Left(CacheFailure());
  }
}
