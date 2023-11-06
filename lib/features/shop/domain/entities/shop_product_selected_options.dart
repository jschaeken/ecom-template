import 'package:hive_flutter/hive_flutter.dart';

part 'shop_product_selected_options.g.dart';

/// Copy of [SelectedOption] from shopify_flutter package
@HiveType(typeId: 4)
class ShopProductSelectedOptions {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String value;

  const ShopProductSelectedOptions({
    required this.name,
    required this.value,
  });
}
