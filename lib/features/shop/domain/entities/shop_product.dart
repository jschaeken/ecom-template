import 'package:equatable/equatable.dart';
import 'package:shopify_flutter/models/src/product/associated_collections/associated_collections.dart';
import 'package:shopify_flutter/models/src/product/metafield/metafield.dart';
import 'package:shopify_flutter/models/src/product/option/option.dart';
import 'package:shopify_flutter/models/src/product/price_v_2/price_v_2.dart';
import 'package:shopify_flutter/models/src/product/product_variant/product_variant.dart';
import 'package:shopify_flutter/models/src/product/selected_option/selected_option.dart';
import 'package:shopify_flutter/models/src/product/unit_price_measurement/unit_price_measurement.dart';

class ShopProduct extends Equatable {
  final String title;
  final String id;
  final bool availableForSale;
  final String createdAt;
  final List<ShopProductProductVariant> productVariants;
  final String productType;
  final String publishedAt;
  final List<String> tags;
  final String updatedAt;
  final List<ShopProductImage> images;
  final List<ShopProductOption> options;
  final String vendor;
  final List<ShopProductMetafield> metafields;
  final List<ShopProductAssociatedCollections>? collectionList;
  final String? cursor;
  final String? onlineStoreUrl;
  final String? description;
  final String? descriptionHtml;
  final String? handle;

  const ShopProduct({
    required this.title,
    required this.id,
    required this.availableForSale,
    required this.createdAt,
    required this.productVariants,
    required this.productType,
    required this.publishedAt,
    required this.tags,
    required this.updatedAt,
    required this.images,
    required this.options,
    required this.vendor,
    required this.metafields,
    this.collectionList,
    this.cursor,
    this.onlineStoreUrl,
    this.description,
    this.descriptionHtml,
    this.handle,
  });

  @override
  List<Object?> get props => [
        title,
        id,
        availableForSale,
        createdAt,
        productVariants,
        productType,
        publishedAt,
        tags,
        updatedAt,
        images,
        options,
        vendor,
        metafields,
        collectionList,
        cursor,
        onlineStoreUrl,
        description,
        descriptionHtml,
        handle,
      ];
}

class ShopProductProductVariant extends Equatable {
  final String price;
  final String title;
  final String weight;
  final String weightUnit;
  final bool availableForSale;
  final String sku;
  final bool requiresShipping;
  final String id;
  final int quantityAvailable;
  final Price? unitPrice;
  final ShopProductUnitPriceMeasurement? unitPriceMeasurement;
  final List<ShopProductSelectedOptions>? selectedOptions;
  final String? compareAtPrice;
  final ShopProductImage? image;

  const ShopProductProductVariant({
    required this.price,
    required this.title,
    required this.weight,
    required this.weightUnit,
    required this.availableForSale,
    required this.sku,
    required this.requiresShipping,
    required this.id,
    required this.quantityAvailable,
    this.unitPrice,
    this.unitPriceMeasurement,
    this.selectedOptions,
    this.compareAtPrice,
    this.image,
  });

  @override
  List<Object?> get props => [
        price,
        title,
        weight,
        weightUnit,
        availableForSale,
        sku,
        requiresShipping,
        id,
        quantityAvailable,
        unitPrice,
        unitPriceMeasurement,
        selectedOptions,
        compareAtPrice,
        image,
      ];

  static productVariantToShopProductProductVariant(
      ProductVariant productVariant) {
    return ShopProductProductVariant(
      price: productVariant.price.formattedPrice,
      title: productVariant.title,
      weight: productVariant.weight.toString(),
      weightUnit: productVariant.weightUnit,
      availableForSale: productVariant.availableForSale,
      sku: productVariant.sku,
      requiresShipping: productVariant.requiresShipping,
      id: productVariant.id,
      quantityAvailable: productVariant.quantityAvailable,
      unitPrice: productVariant.unitPrice != null
          ? Price(
              amount: productVariant.unitPrice!.amount.toString(),
              currencyCode: productVariant.unitPrice!.currencyCode,
            )
          : null,
      unitPriceMeasurement: productVariant.unitPriceMeasurement != null
          ? ShopProductUnitPriceMeasurement(
              measuredType: productVariant.unitPriceMeasurement!.measuredType,
              quantityUnit: productVariant.unitPriceMeasurement!.quantityUnit,
              quantityValue: productVariant.unitPriceMeasurement!.quantityValue,
              referenceUnit: productVariant.unitPriceMeasurement!.referenceUnit,
              referenceValue: productVariant
                      .unitPriceMeasurement?.referenceValue
                      .toDouble() ??
                  0.0,
            )
          : null,
      selectedOptions: productVariant.selectedOptions != null
          ? productVariant.selectedOptions!
              .map((selOpt) => ShopProductSelectedOptions(
                    name: selOpt.name,
                    value: selOpt.value,
                  ))
              .toList()
          : null,
      compareAtPrice: productVariant.compareAtPrice != null
          ? productVariant.compareAtPrice!.formattedPrice
          : null,
      image: productVariant.image != null
          ? ShopProductImage(
              altText: productVariant.image!.altText,
              id: productVariant.image!.id,
              originalSrc: productVariant.image!.originalSrc,
            )
          : null,
    );
  }
}

/// Copy of [AssociatedCollections] from shopify_flutter package
class ShopProductAssociatedCollections {
  final String id;
  final String title;
  final String description;
  final String updatedAt;
  final String? descriptionHtml;
  final String? handle;

  const ShopProductAssociatedCollections({
    required this.id,
    required this.title,
    required this.description,
    required this.updatedAt,
    this.descriptionHtml,
    this.handle,
  });
}

/// Copy of [Metafield] from shopify_flutter package
class ShopProductMetafield {
  final String? description;
  final String? id;
  final String? key;
  final String? namespace;
  final String? value;
  final String? valueType;

  const ShopProductMetafield({
    this.description,
    this.id,
    this.key,
    this.namespace,
    this.value,
    this.valueType,
  });
}

/// Copy of [Option] from shopify_flutter package
class ShopProductOption {
  final String? id;
  final String? name;
  final List<String>? values;

  const ShopProductOption({
    this.id,
    this.name,
    this.values,
  });
}

/// Copy of [SelectedOption] from shopify_flutter package
class ShopProductSelectedOptions {
  final String name;
  final String value;

  const ShopProductSelectedOptions({
    required this.name,
    required this.value,
  });
}

/// Copy of [UnitPriceMeasurement] from shopify_flutter package
class ShopProductUnitPriceMeasurement {
  final String measuredType;
  final String quantityUnit;
  final double quantityValue;
  final String referenceUnit;
  final double referenceValue;

  const ShopProductUnitPriceMeasurement({
    required this.measuredType,
    required this.quantityUnit,
    required this.quantityValue,
    required this.referenceUnit,
    required this.referenceValue,
  });
}

/// Copy of [PriceV2] from shopify_flutter package
class Price {
  final String amount;
  final String currencyCode;

  const Price({
    required this.amount,
    required this.currencyCode,
  });
}

/// Copy of [ShopifyImage] from shopify_flutter package
class ShopProductImage {
  final String? altText;
  final String? id;
  final String originalSrc;

  const ShopProductImage({
    this.altText,
    this.id,
    required this.originalSrc,
  });
}