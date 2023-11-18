import 'package:equatable/equatable.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Copy of [UnitPriceMeasurement] from shopify_flutter package

part 'shop_product_unit_price_measurement.g.dart';

@HiveType(typeId: 5)
class ShopProductUnitPriceMeasurement extends Equatable {
  @HiveField(0)
  final String measuredType;

  @HiveField(1)
  final String quantityUnit;

  @HiveField(2)
  final double quantityValue;

  @HiveField(3)
  final String referenceUnit;

  @HiveField(4)
  final double referenceValue;

  const ShopProductUnitPriceMeasurement({
    required this.measuredType,
    required this.quantityUnit,
    required this.quantityValue,
    required this.referenceUnit,
    required this.referenceValue,
  });

  @override
  List<Object?> get props => [
        measuredType,
        quantityUnit,
        quantityValue,
        referenceUnit,
        referenceValue,
      ];
}
