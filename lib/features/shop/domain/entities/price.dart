import 'package:hive_flutter/hive_flutter.dart';

part 'price.g.dart';

/// Copy of [PriceV2] from shopify_flutter package
@HiveType(typeId: 2)
class Price {
  @HiveField(0)
  final String amount;

  @HiveField(1)
  final String currencyCode;

  const Price({
    required this.amount,
    required this.currencyCode,
  });

  @override
  String toString() {
    return '$currencyCode $amount';
  }
}
