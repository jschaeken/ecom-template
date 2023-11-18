import 'package:ecom_template/features/shop/domain/entities/price.dart';
import 'package:ecom_template/features/shop/domain/entities/shop_product_image.dart';
import 'package:ecom_template/features/shop/domain/entities/shop_product_selected_option.dart';
import 'package:ecom_template/features/shop/domain/entities/shop_product_unit_price_measurement.dart';
import 'package:equatable/equatable.dart';
import 'package:shopify_flutter/models/src/product/price_v_2/price_v_2.dart';
import 'package:shopify_flutter/models/src/product/product_variant/product_variant.dart';
import 'package:shopify_flutter/models/src/product/selected_option/selected_option.dart';
import 'package:shopify_flutter/models/src/product/shopify_image/shopify_image.dart';
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

  @override
  bool get stringify => true;
}

class ShopProductProductVariant extends Equatable {
  final Price price;
  final String title;
  final double weight;
  final String weightUnit;
  final bool availableForSale;
  final String sku;
  final bool requiresShipping;
  final String id;
  final int quantityAvailable;
  final Price? unitPrice;
  final ShopProductUnitPriceMeasurement? unitPriceMeasurement;
  final List<ShopProductSelectedOption>? selectedOptions;
  final Price? compareAtPrice;
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
      price: Price(
        amount: productVariant.price.amount,
        currencyCode: productVariant.price.currencyCode,
      ),
      title: productVariant.title,
      weight: productVariant.weight,
      weightUnit: productVariant.weightUnit,
      availableForSale: productVariant.availableForSale,
      sku: productVariant.sku,
      requiresShipping: productVariant.requiresShipping,
      id: productVariant.id,
      quantityAvailable: productVariant.quantityAvailable,
      unitPrice: productVariant.unitPrice != null
          ? Price(
              amount: productVariant.unitPrice!.amount,
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
              .map((selOpt) => ShopProductSelectedOption(
                    name: selOpt.name,
                    value: selOpt.value,
                  ))
              .toList()
          : null,
      compareAtPrice: productVariant.compareAtPrice != null
          ? Price(
              amount: productVariant.compareAtPrice!.amount,
              currencyCode: productVariant.compareAtPrice!.currencyCode,
            )
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

  @override
  bool get stringify => true;

  static ProductVariant shopProductProductVariantToProductVariant(
      ShopProductProductVariant shopProductProductVariant) {
    return ProductVariant(
      price: PriceV2(
        amount: shopProductProductVariant.price.amount,
        currencyCode: shopProductProductVariant.price.currencyCode,
      ),
      title: shopProductProductVariant.title,
      weight: shopProductProductVariant.weight,
      weightUnit: shopProductProductVariant.weightUnit,
      availableForSale: shopProductProductVariant.availableForSale,
      sku: shopProductProductVariant.sku,
      requiresShipping: shopProductProductVariant.requiresShipping,
      id: shopProductProductVariant.id,
      quantityAvailable: shopProductProductVariant.quantityAvailable,
      unitPrice: shopProductProductVariant.unitPrice != null
          ? PriceV2(
              amount: shopProductProductVariant.unitPrice!.amount,
              currencyCode: shopProductProductVariant.unitPrice!.currencyCode,
            )
          : null,
      unitPriceMeasurement: shopProductProductVariant.unitPriceMeasurement !=
              null
          ? UnitPriceMeasurement(
              measuredType:
                  shopProductProductVariant.unitPriceMeasurement!.measuredType,
              quantityUnit:
                  shopProductProductVariant.unitPriceMeasurement!.quantityUnit,
              quantityValue:
                  shopProductProductVariant.unitPriceMeasurement!.quantityValue,
              referenceUnit:
                  shopProductProductVariant.unitPriceMeasurement!.referenceUnit,
              referenceValue: (shopProductProductVariant
                          .unitPriceMeasurement?.referenceValue
                          .toDouble() ??
                      1.0)
                  .toInt(),
            )
          : null,
      selectedOptions: shopProductProductVariant.selectedOptions != null
          ? shopProductProductVariant.selectedOptions!
              .map((selOpt) => SelectedOption(
                    name: selOpt.name,
                    value: selOpt.value,
                  ))
              .toList()
          : null,
      compareAtPrice: shopProductProductVariant.compareAtPrice != null
          ? PriceV2(
              amount: shopProductProductVariant.compareAtPrice!.amount,
              currencyCode:
                  shopProductProductVariant.compareAtPrice!.currencyCode,
            )
          : null,
      image: shopProductProductVariant.image != null
          ? ShopifyImage(
              altText: shopProductProductVariant.image!.altText,
              id: shopProductProductVariant.image!.id ?? '',
              originalSrc: shopProductProductVariant.image!.originalSrc,
            )
          : null,
    );
  }
}

/// Copy of [AssociatedCollections] from shopify_flutter package
class ShopProductAssociatedCollections extends Equatable {
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

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        updatedAt,
        descriptionHtml,
        handle,
      ];
}

/// Copy of [Metafield] from shopify_flutter package
class ShopProductMetafield extends Equatable {
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

  @override
  List<Object?> get props => [
        description,
        id,
        key,
        namespace,
        value,
        valueType,
      ];
}

/// Copy of [Option] from shopify_flutter package
class ShopProductOption extends Equatable {
  final String id;
  final String name;
  final List<String> values;

  const ShopProductOption({
    required this.id,
    required this.name,
    required this.values,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        values,
      ];
}
