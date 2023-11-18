import 'package:equatable/equatable.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shopify_flutter/models/src/product/shopify_image/shopify_image.dart';

part 'shop_product_image.g.dart';

/// Copy of [ShopifyImage] from shopify_flutter package
@HiveType(typeId: 3)
class ShopProductImage extends Equatable {
  @HiveField(0)
  final String? altText;

  @HiveField(1)
  final String? id;

  @HiveField(2)
  final String originalSrc;

  const ShopProductImage({
    this.altText,
    this.id,
    required this.originalSrc,
  });

  @override
  List<Object?> get props => [altText, id, originalSrc];

  static fromProductImage(ShopifyImage image) {
    return ShopProductImage(
      altText: image.altText,
      id: image.id,
      originalSrc: image.originalSrc,
    );
  }

  static ShopifyImage toProductImage(ShopProductImage image) {
    return ShopifyImage(
      altText: image.altText,
      id: image.id ?? '',
      originalSrc: image.originalSrc,
    );
  }
}
