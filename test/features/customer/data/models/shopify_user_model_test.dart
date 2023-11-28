import 'package:ecom_template/features/customer/data/models/shopify_user_model.dart';
import 'package:ecom_template/features/customer/domain/entities/last_incomplete_checkout.dart';
import 'package:ecom_template/features/customer/domain/entities/shopify_user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shopify_flutter/models/models.dart';
import 'package:shopify_flutter/models/src/shopify_user/address/address.dart';
import 'package:shopify_flutter/models/src/shopify_user/addresses/addresses.dart';
import 'package:shopify_flutter/models/src/shopify_user/last_incomplete_checkout/last_incomplete_checkout.dart';
import 'package:shopify_flutter/models/src/shopify_user/shopify_user.dart';

void main() {
  ShopShopifyUserModel shopShopifyUserModel = ShopShopifyUserModel(
      addresses: [
        Address(
          address1: 'address1',
          address2: 'address2',
          city: 'city',
          country: 'country',
          firstName: 'firstName',
          id: 'id',
          lastName: 'lastName',
          latitude: '0',
          longitude: '0',
          name: 'name',
          phone: 'phone',
          province: 'province',
          provinceCode: 'provinceCode',
          zip: 'zip',
          company: 'company',
          formattedArea: 'formattedArea',
        ),
      ],
      createdAt: 'createdAt',
      displayName: 'displayName',
      email: 'email',
      firstName: 'firstName',
      id: 'id',
      lastName: 'lastName',
      phone: 'phone',
      tags: const ['tags'],
      lastIncompleteCheckout: const ShopLastIncompleteCheckout(
        completedAt: 'completedAt',
        createdAt: 'createdAt',
        currencyCode: 'currencyCode',
        email: 'email',
        id: 'id',
        lineItems: [],
        lineItemsSubtotalPrice: null,
        totalPriceV2: null,
        webUrl: 'webUrl',
      ));

  ShopShopifyUser shopShopifyUser = shopShopifyUserModel;

  ShopifyUser shopifyUser = ShopifyUser(
    address: Addresses(
      addressList: [
        Address(
          address1: 'address1',
          address2: 'address2',
          city: 'city',
          country: 'country',
          firstName: 'firstName',
          id: 'id',
          lastName: 'lastName',
          latitude: '0',
          longitude: '0',
          name: 'name',
          phone: 'phone',
          province: 'province',
          provinceCode: 'provinceCode',
          zip: 'zip',
          company: 'company',
          formattedArea: 'formattedArea',
        ),
      ],
    ),
    createdAt: 'createdAt',
    displayName: 'displayName',
    email: 'email',
    firstName: 'firstName',
    id: 'id',
    lastName: 'lastName',
    phone: 'phone',
    tags: ['tags'],
    lastIncompleteCheckout: LastIncompleteCheckout(
      completedAt: 'completedAt',
      createdAt: 'createdAt',
      currencyCode: 'currencyCode',
      email: 'email',
      id: 'id',
      lineItems: [],
      lineItemsSubtotalPrice: null,
      totalPriceV2: null,
      webUrl: 'webUrl',
    ),
  );

  group('Shop Shopify User Model', () {
    test(
      'should be a subclass of ShopShopifyUser entity',
      () {
        // assert
        expect(shopShopifyUserModel, isA<ShopShopifyUser>());
      },
    );
    test(
        'fromShopifyUser method should convert a ShopifyUser into a ShopShopifyUserModel',
        () {
      // act
      final result = ShopShopifyUserModel.fromShopifyUser(shopifyUser);

      // assert
      expect(result, shopShopifyUserModel);
    });
  });
}
