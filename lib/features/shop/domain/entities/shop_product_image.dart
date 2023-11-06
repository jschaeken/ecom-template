import 'package:hive_flutter/hive_flutter.dart';

part 'shop_product_image.g.dart';

/// Copy of [ShopifyImage] from shopify_flutter package
@HiveType(typeId: 3)
class ShopProductImage {
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
}
