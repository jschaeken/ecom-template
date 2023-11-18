import 'package:equatable/equatable.dart';
import 'package:shopify_flutter/models/src/checkout/attribute/attribute.dart';

class ShopAttribute extends Equatable {
  final String key;
  final String? value;

  const ShopAttribute({
    required this.key,
    this.value,
  });

  @override
  List<Object?> get props => [
        key,
        value,
      ];

  static ShopAttribute fromAttribute(Attribute attribute) {
    return ShopAttribute(
      key: attribute.key,
      value: attribute.value,
    );
  }
}
