import 'package:ecom_template/features/checkout/domain/entities/shipping_address.dart';
import 'package:ecom_template/features/customer/domain/entities/address.dart';
import 'package:ecom_template/features/customer/domain/entities/last_incomplete_checkout.dart';
import 'package:equatable/equatable.dart';
import 'package:shopify_flutter/models/src/shopify_user/address/address.dart';

class ShopShopifyUser extends Equatable {
  final List<Address>? addresses;
  final String? createdAt;
  final String? displayName;
  final String? email;
  final String? firstName;
  final String? id;
  final String? lastName;
  final String? phone;
  final List<String>? tags;
  final ShopLastIncompleteCheckout? lastIncompleteCheckout;

  const ShopShopifyUser({
    this.addresses,
    this.createdAt,
    this.displayName,
    this.email,
    this.firstName,
    this.id,
    this.lastName,
    this.phone,
    this.tags,
    this.lastIncompleteCheckout,
  });

  @override
  List<Object?> get props => [
        addresses,
        createdAt,
        displayName,
        email,
        firstName,
        id,
        lastName,
        phone,
        tags,
        lastIncompleteCheckout,
      ];
}
