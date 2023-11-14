import 'package:equatable/equatable.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'bag_item_data.g.dart';

@HiveType(typeId: 0)
class BagItemData extends Equatable {
  @HiveField(0)
  final String parentProductId;

  @HiveField(1)
  final int quantity;

  @HiveField(2)
  final String productVariantId;

  @HiveField(3)
  final String productVariantTitle;

  const BagItemData({
    required this.parentProductId,
    required this.quantity,
    required this.productVariantId,
    required this.productVariantTitle,
  });

  @override
  List<Object> get props => [
        parentProductId,
        quantity,
        productVariantId,
        productVariantTitle,
      ];
}
