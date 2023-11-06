import 'package:ecom_template/features/shop/domain/entities/shop_product.dart';
import 'package:ecom_template/features/shop/domain/entities/shop_product_image.dart';
import 'package:shopify_flutter/models/src/product/metafield/metafield.dart';
import 'package:shopify_flutter/models/src/product/option/option.dart';
import 'package:shopify_flutter/models/src/product/product.dart';
import 'package:shopify_flutter/models/src/product/product_variant/product_variant.dart';
import 'package:shopify_flutter/models/src/product/shopify_image/shopify_image.dart';

class ShopProductModel extends ShopProduct {
  const ShopProductModel({
    required String id,
    required String title,
    required String productType,
    required String vendor,
    required List<String> tags,
    required List<ShopProductOption> options,
    required List<ShopProductImage> images,
    required List<ShopProductProductVariant> productVariants,
    required bool availableForSale,
    required String createdAt,
    required String updatedAt,
    required String publishedAt,
    required List<ShopProductMetafield> metafields,
    required bool isPopular,
  }) : super(
          id: id,
          title: title,
          productType: productType,
          vendor: vendor,
          tags: tags,
          options: options,
          images: images,
          productVariants: productVariants,
          availableForSale: availableForSale,
          createdAt: createdAt,
          updatedAt: updatedAt,
          publishedAt: publishedAt,
          metafields: metafields,
        );

  static ShopProductModel fromShopifyProduct(Product product) {
    /// ShopifyProduct option field to ShopProduct option field
    List<ShopProductOption> shopifyOptionsToShopProductOptions(
        List<Option> options) {
      try {
        return options.map((e) {
          return ShopProductOption(id: e.id, name: e.name, values: e.values);
        }).toList();
      } catch (e) {
        return [];
      }
    }

    /// ShopifyProduct images field to ShopProduct images fiel
    List<ShopProductImage> shopifyImagesToShopProductImages(
        List<ShopifyImage> images) {
      try {
        return images.map((e) {
          return ShopProductImage(
            id: e.id,
            altText: e.altText,
            originalSrc: e.originalSrc,
          );
        }).toList();
      } catch (e) {
        return [];
      }
    }

    /// ShopifyProduct productVariants field to ShopProduct productVariants field
    List<ShopProductProductVariant>
        shopifyProductVariantsToShopProductProductVariants(
            List<ProductVariant> productVariants) {
      final shopProductProductVariants = <ShopProductProductVariant>[];
      for (ProductVariant productVariant in productVariants) {
        shopProductProductVariants.add(
          ShopProductProductVariant.productVariantToShopProductProductVariant(
            productVariant,
          ),
        );
      }
      return shopProductProductVariants;
    }

    /// ShopifyProduct Metafields field to ShopProduct Metafields fields
    List<ShopProductMetafield> shopifyMetafieldsToShopProductMetafields(
        List<Metafield> metafields) {
      final shopProductMetafields = <ShopProductMetafield>[];
      for (Metafield metafield in metafields) {
        shopProductMetafields.add(
          ShopProductMetafield(
            id: metafield.id,
            key: metafield.key,
            namespace: metafield.namespace,
            value: metafield.value,
            valueType: metafield.valueType,
          ),
        );
      }
      return shopProductMetafields;
    }

    return ShopProductModel(
      id: product.id,
      title: product.title,
      productType: product.productType,
      vendor: product.vendor,
      tags: product.tags,
      options: shopifyOptionsToShopProductOptions(product.option),
      images: shopifyImagesToShopProductImages(product.images),
      productVariants: shopifyProductVariantsToShopProductProductVariants(
        product.productVariants,
      ),
      availableForSale: product.availableForSale,
      createdAt: product.createdAt,
      updatedAt: product.updatedAt,
      publishedAt: product.publishedAt,
      metafields: shopifyMetafieldsToShopProductMetafields(product.metafields),
      isPopular: false,
    );
  }
}
