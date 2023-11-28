import 'package:ecom_template/features/checkout/domain/entities/shipping_address.dart';
import 'package:ecom_template/features/customer/domain/entities/address.dart';
import 'package:ecom_template/features/customer/domain/entities/last_incomplete_checkout.dart';
import 'package:ecom_template/features/customer/domain/entities/shopify_user.dart';
import 'package:shopify_flutter/models/src/shopify_user/address/address.dart';
import 'package:shopify_flutter/models/src/shopify_user/shopify_user.dart';

class ShopShopifyUserModel extends ShopShopifyUser {
  const ShopShopifyUserModel({
    super.addresses,
    super.createdAt,
    super.displayName,
    super.email,
    super.firstName,
    super.id,
    super.lastName,
    super.phone,
    super.tags,
    super.lastIncompleteCheckout,
  });

  static ShopShopifyUserModel fromShopifyUser(ShopifyUser shopifyUser) {
    return ShopShopifyUserModel(
      addresses: shopifyUser.address?.addressList.map((e) {
        return Address(
          address1: e.address1,
          address2: e.address2,
          city: e.city,
          company: e.company,
          country: e.country,
          firstName: e.firstName,
          formattedArea: e.formattedArea,
          id: e.id,
          lastName: e.lastName,
          latitude: e.latitude,
          longitude: e.longitude,
          name: e.name,
          phone: e.phone,
          province: e.province,
          provinceCode: e.provinceCode,
          zip: e.zip,
        );
      }).toList(),
      createdAt: shopifyUser.createdAt,
      displayName: shopifyUser.displayName,
      email: shopifyUser.email,
      firstName: shopifyUser.firstName,
      id: shopifyUser.id,
      lastName: shopifyUser.lastName,
      phone: shopifyUser.phone,
      tags: shopifyUser.tags,
      lastIncompleteCheckout:
          ShopLastIncompleteCheckout.fromLastIncompleteCheckout(
        shopifyUser.lastIncompleteCheckout,
      ),
    );
  }
}
