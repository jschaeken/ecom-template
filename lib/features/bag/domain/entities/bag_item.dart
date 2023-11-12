// ignore_for_file: overridden_fields
import 'package:ecom_template/features/bag/domain/entities/options_selection.dart';
import 'package:ecom_template/features/shop/domain/entities/price.dart';
import 'package:ecom_template/features/shop/domain/entities/shop_product.dart';
import 'package:ecom_template/features/shop/domain/entities/shop_product_image.dart';
import 'package:ecom_template/features/shop/domain/entities/shop_product_unit_price_measurement.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

import '../../../shop/domain/entities/shop_product_selected_option.dart';

part 'bag_item.g.dart';

@HiveType(typeId: 1)
class BagItem extends ShopProductProductVariant {
  @override
  @HiveField(0)
  final Price price;

  @override
  @HiveField(1)
  final String title;

  @override
  @HiveField(2)
  final String weight;

  @override
  @HiveField(3)
  final String weightUnit;

  @override
  @HiveField(4)
  final bool availableForSale;

  @override
  @HiveField(5)
  final String sku;

  @override
  @HiveField(6)
  final bool requiresShipping;

  @override
  @HiveField(7)
  final String id;

  @override
  @HiveField(8)
  final int quantityAvailable;

  @override
  @HiveField(9)
  final Price? unitPrice;

  @override
  @HiveField(10)
  final ShopProductUnitPriceMeasurement? unitPriceMeasurement;

  @override
  @HiveField(11)
  final List<ShopProductSelectedOption>? selectedOptions;

  @override
  @HiveField(12)
  final Price? compareAtPrice;

  @override
  @HiveField(13)
  final ShopProductImage? image;

  @HiveField(14)
  final int quantity;

  @HiveField(15)
  final String parentProductId;

  @HiveField(16)
  final String uniqueKey;

  const BagItem({
    required this.title,
    required this.id,
    required this.availableForSale,
    required this.price,
    required this.sku,
    required this.weight,
    required this.weightUnit,
    required this.image,
    required this.selectedOptions,
    required this.requiresShipping,
    required this.quantityAvailable,
    this.compareAtPrice,
    this.unitPrice,
    this.unitPriceMeasurement,
    required this.quantity,
    required this.parentProductId,
    this.uniqueKey = 'none',
  }) : super(
          price: price,
          title: title,
          weight: weight,
          weightUnit: weightUnit,
          availableForSale: availableForSale,
          sku: sku,
          requiresShipping: requiresShipping,
          id: id,
          quantityAvailable: quantityAvailable,
          unitPrice: unitPrice,
          unitPriceMeasurement: unitPriceMeasurement,
          selectedOptions: selectedOptions,
          compareAtPrice: compareAtPrice,
          image: image,
        );

  static BagItem fromShopProductVariant(
      {required ShopProductProductVariant product,
      required int quantity,
      required String parentProductId}) {
    return BagItem(
      title: product.title,
      id: product.id,
      availableForSale: product.availableForSale,
      price: product.price,
      sku: product.sku,
      weight: product.weight,
      weightUnit: product.weightUnit,
      image: product.image,
      selectedOptions: product.selectedOptions,
      requiresShipping: product.requiresShipping,
      quantityAvailable: product.quantityAvailable,
      compareAtPrice: product.compareAtPrice,
      unitPrice: product.unitPrice,
      unitPriceMeasurement: product.unitPriceMeasurement,
      quantity: quantity,
      parentProductId: parentProductId,
    );
  }

  BagItem copyWith({
    Price? price,
    String? title,
    String? weight,
    String? weightUnit,
    bool? availableForSale,
    String? sku,
    bool? requiresShipping,
    String? id,
    int? quantityAvailable,
    Price? unitPrice,
    ShopProductUnitPriceMeasurement? unitPriceMeasurement,
    List<ShopProductSelectedOption>? selectedOptions,
    Price? compareAtPrice,
    ShopProductImage? image,
    int? quantity,
    String? parentProductId,
    String? uniqueKey,
  }) {
    return BagItem(
      title: title ?? this.title,
      id: id ?? this.id,
      availableForSale: availableForSale ?? this.availableForSale,
      price: price ?? this.price,
      sku: sku ?? this.sku,
      weight: weight ?? this.weight,
      weightUnit: weightUnit ?? this.weightUnit,
      image: image ?? this.image,
      selectedOptions: selectedOptions ?? this.selectedOptions,
      requiresShipping: requiresShipping ?? this.requiresShipping,
      quantityAvailable: quantityAvailable ?? this.quantityAvailable,
      compareAtPrice: compareAtPrice ?? this.compareAtPrice,
      unitPrice: unitPrice ?? this.unitPrice,
      unitPriceMeasurement: unitPriceMeasurement ?? this.unitPriceMeasurement,
      quantity: quantity ?? this.quantity,
      parentProductId: parentProductId ?? this.parentProductId,
      uniqueKey: uniqueKey ?? this.uniqueKey,
    );
  }
}

class IncompleteBagItem extends Equatable {
  final ShopProduct product;
  final OptionsSelections optionsSelections;
  final int quantity;

  const IncompleteBagItem({
    required this.product,
    required this.optionsSelections,
    required this.quantity,
  });

  @override
  List<Object?> get props => [
        product,
        optionsSelections,
        quantity,
      ];

  @override
  String toString() {
    return 'IncompleteBagItem(product: $product, optionsSelections: $optionsSelections, quantity: $quantity)';
  }
}
