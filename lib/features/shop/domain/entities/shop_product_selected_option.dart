import 'package:equatable/equatable.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'shop_product_selected_option.g.dart';

/// Copy of [SelectedOption] from shopify_flutter package
@HiveType(typeId: 4)
class ShopProductSelectedOption extends Equatable {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String value;

  const ShopProductSelectedOption({
    required this.name,
    required this.value,
  });

  @override
  List<Object?> get props => [name, value];

  @override
  bool get stringify => true;
}
