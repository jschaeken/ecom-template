import 'package:ecom_template/features/shop/domain/entities/shop_product.dart';
import 'package:ecom_template/features/shop/domain/entities/shop_product_image.dart';
import 'package:shopify_flutter/models/src/product/metafield/metafield.dart';
import 'package:shopify_flutter/models/src/product/option/option.dart';
import 'package:shopify_flutter/models/src/product/product.dart';
import 'package:shopify_flutter/models/src/product/product_variant/product_variant.dart';
import 'package:shopify_flutter/models/src/product/shopify_image/shopify_image.dart';

class ShopProductModel extends ShopProduct {
  const ShopProductModel({
    required String title,
    required String id,
    required bool availableForSale,
    required String createdAt,
    required List<ShopProductProductVariant> productVariants,
    required String productType,
    required String publishedAt,
    required List<String> tags,
    required String updatedAt,
    required List<ShopProductImage> images,
    required List<ShopProductOption> options,
    required String vendor,
    required List<ShopProductMetafield> metafields,
    required List<ShopProductAssociatedCollections>? collectionList,
    required String? cursor,
    required String? onlineStoreUrl,
    required String? description,
    required String? descriptionHtml,
    required String? handle,
  }) : super(
          title: title,
          id: id,
          availableForSale: availableForSale,
          createdAt: createdAt,
          productVariants: productVariants,
          productType: productType,
          publishedAt: publishedAt,
          tags: tags,
          updatedAt: updatedAt,
          images: images,
          options: options,
          metafields: metafields,
          collectionList: collectionList,
          cursor: cursor,
          onlineStoreUrl: onlineStoreUrl,
          description: description,
          descriptionHtml: descriptionHtml,
          handle: handle,
          vendor: vendor,
        );

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
        metafields,
        collectionList,
        cursor,
        onlineStoreUrl,
        description,
        descriptionHtml,
        handle,
        vendor,
      ];

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
            description: metafield.description,
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
      collectionList: product.collectionList != null
          ? product.collectionList!
              .map((e) => ShopProductAssociatedCollections(
                    description: e.description,
                    id: e.id,
                    title: e.title,
                    updatedAt: e.updatedAt,
                    descriptionHtml: e.descriptionHtml,
                    handle: e.handle,
                  ))
              .toList()
          : null,
      cursor: product.cursor,
      description: product.description,
      descriptionHtml: product.descriptionHtml,
      handle: product.handle,
      onlineStoreUrl: product.onlineStoreUrl,
    );
  }

  Product toShopifyProduct() {
    /// ShopProduct option field to ShopifyProduct option field
    List<Option> shopProductOptionsToShopifyOptions(
        List<ShopProductOption> options) {
      try {
        return options.map((e) {
          return Option(id: e.id, name: e.name, values: e.values);
        }).toList();
      } catch (e) {
        return [];
      }
    }

    /// ShopProduct images field to ShopifyProduct images field
    List<ShopifyImage> shopProductImagesToShopifyImages(
        List<ShopProductImage> images) {
      try {
        return images.map((e) {
          return ShopifyImage(
            id: e.id ?? '',
            altText: e.altText,
            originalSrc: e.originalSrc,
          );
        }).toList();
      } catch (e) {
        return [];
      }
    }

    /// ShopProduct productVariants field to ShopifyProduct productVariants field
    List<ProductVariant> shopProductProductVariantsToShopifyProductVariants(
        List<ShopProductProductVariant> productVariants) {
      final shopifyProductVariants = <ProductVariant>[];
      for (ShopProductProductVariant shopProductProductVariant
          in productVariants) {
        shopifyProductVariants.add(
          ShopProductProductVariant.shopProductProductVariantToProductVariant(
            shopProductProductVariant,
          ),
        );
      }
      return shopifyProductVariants;
    }

    /// ShopProduct Metafields field to ShopifyProduct Metafields fields
    List<Metafield> shopProductMetafieldsToShopifyMetafields(
        List<ShopProductMetafield> metafields) {
      final shopifyMetafields = <Metafield>[];
      for (ShopProductMetafield shopProductMetafield in metafields) {
        shopifyMetafields.add(
          Metafield(
            id: shopProductMetafield.id ?? 'N/A',
            key: shopProductMetafield.key ?? 'N/A',
            namespace: shopProductMetafield.namespace ?? 'N/A',
            value: shopProductMetafield.value ?? 'N/A',
            valueType: shopProductMetafield.valueType ?? 'N/A',
          ),
        );
      }
      return shopifyMetafields;
    }

    return Product(
      id: id,
      title: title,
      productType: productType,
      vendor: vendor,
      tags: tags,
      option: shopProductOptionsToShopifyOptions(options),
      images: shopProductImagesToShopifyImages(images),
      productVariants: shopProductProductVariantsToShopifyProductVariants(
        productVariants,
      ),
      availableForSale: availableForSale,
      createdAt: createdAt,
      updatedAt: updatedAt,
      publishedAt: publishedAt,
      metafields: shopProductMetafieldsToShopifyMetafields(metafields),
      collectionList: [],
      cursor: cursor,
      description: description,
      descriptionHtml: descriptionHtml,
      handle: handle,
    );
  }
}
