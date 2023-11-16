import 'package:ecom_template/features/shop/domain/entities/price.dart';
import 'package:ecom_template/features/shop/domain/entities/shop_product.dart';
import 'package:ecom_template/features/shop/domain/entities/shop_product_image.dart';
import 'package:equatable/equatable.dart';

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
      ];
}
