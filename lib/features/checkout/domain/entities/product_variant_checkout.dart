import 'package:ecom_template/features/shop/data/models/shop_product_model.dart';
import 'package:ecom_template/features/shop/domain/entities/price.dart';
import 'package:ecom_template/features/shop/domain/entities/shop_product.dart';
import 'package:ecom_template/features/shop/domain/entities/shop_product_image.dart';
import 'package:equatable/equatable.dart';
import 'package:shopify_flutter/models/src/checkout/product_variant_checkout/product_variant_checkout.dart';

class ShopProductVariantCheckout extends Equatable {
  final String id;
  final String title;
  final String sku;
  final Price price;
  final double? weight;
  final String? weightUnit;
  final ShopProductImage? image;
  final Price? compareAtPrice;
  final int quantityAvailable;
  final ShopProduct? product;
  final bool availableForSale;
  final bool requiresShipping;

  const ShopProductVariantCheckout({
    required this.id,
    required this.title,
    required this.sku,
    required this.price,
    this.weight,
    this.weightUnit,
    this.image,
    this.compareAtPrice,
    this.quantityAvailable = 0,
    this.product,
    this.availableForSale = false,
    this.requiresShipping = true,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        sku,
        weight,
        weightUnit,
        image,
        price,
        compareAtPrice,
        quantityAvailable,
        product,
        availableForSale,
      ];

  static fromProductVariantCheckout(ProductVariantCheckout productVariant) {
    return ShopProductVariantCheckout(
      id: productVariant.id,
      title: productVariant.title,
      sku: productVariant.sku,
      price: Price.fromPriceV2(productVariant.priceV2),
      weight: productVariant.weight,
      weightUnit: productVariant.weightUnit,
      image: productVariant.image != null
          ? ShopProductImage.fromProductImage(productVariant.image!)
          : null,
      availableForSale: productVariant.availableForSale,
      compareAtPrice: productVariant.compareAtPrice != null
          ? Price.fromPriceV2(productVariant.compareAtPrice!)
          : null,
      quantityAvailable: productVariant.quantityAvailable,
      product: productVariant.product != null
          ? ShopProductModel.fromShopifyProduct(productVariant.product!)
          : null,
    );
  }

  static fromProductVariant(ShopProductProductVariant productVariant) {
    return ShopProductVariantCheckout(
      id: productVariant.id,
      title: productVariant.title,
      sku: productVariant.sku,
      price: productVariant.price,
      weight: productVariant.weight,
      weightUnit: productVariant.weightUnit,
      image: productVariant.image,
      availableForSale: productVariant.availableForSale,
      compareAtPrice: productVariant.compareAtPrice,
      quantityAvailable: productVariant.quantityAvailable,
    );
  }

  static ProductVariantCheckout toProductVariantCheckout(
      ShopProductVariantCheckout shopProductVariantCheckout) {
    return ProductVariantCheckout(
      id: shopProductVariantCheckout.id,
      title: shopProductVariantCheckout.title,
      availableForSale: shopProductVariantCheckout.availableForSale,
      requiresShipping: true,
      sku: shopProductVariantCheckout.sku,
      priceV2: Price.toPriceV2(shopProductVariantCheckout.price),
      weight: shopProductVariantCheckout.weight,
      weightUnit: shopProductVariantCheckout.weightUnit,
      image: shopProductVariantCheckout.image != null
          ? ShopProductImage.toProductImage(shopProductVariantCheckout.image!)
          : null,
      compareAtPrice: shopProductVariantCheckout.compareAtPrice != null
          ? Price.toPriceV2(shopProductVariantCheckout.compareAtPrice!)
          : null,
      quantityAvailable: shopProductVariantCheckout.quantityAvailable,
      product: shopProductVariantCheckout.product != null
          ? (shopProductVariantCheckout.product! as ShopProductModel)
              .toShopifyProduct()
          : null,
    );
  }
}
