import 'package:ecom_template/core/error/exceptions.dart';
import 'package:ecom_template/features/customer/data/datasources/customer_auth_datasource.dart';
import 'package:ecom_template/features/customer/data/models/shopify_user_model.dart';
import 'package:ecom_template/features/customer/domain/entities/last_incomplete_checkout.dart';
import 'package:ecom_template/features/customer/domain/entities/shopify_user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shopify_flutter/mixins/src/shopfiy_error.dart';
import 'package:shopify_flutter/models/src/shopify_user/address/address.dart';
import 'package:shopify_flutter/models/src/shopify_user/addresses/addresses.dart';
import 'package:shopify_flutter/models/src/shopify_user/last_incomplete_checkout/last_incomplete_checkout.dart';
import 'package:shopify_flutter/models/src/shopify_user/shopify_user.dart';
import 'package:shopify_flutter/shopify/src/shopify_auth.dart';

class MockShopifyAuth extends Mock implements ShopifyAuth {}

void main() {
  late MockShopifyAuth mockShopifyAuth;
  late CustomerAuthDatasourceImpl customerAuthDataSourceImpl;
  setUp(() {
    mockShopifyAuth = MockShopifyAuth();
    customerAuthDataSourceImpl = CustomerAuthDatasourceImpl(
      shopifyAuth: mockShopifyAuth,
    );
  });

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

  const testEmail = 'testEmail';
  const testPassword = 'testPassword';

  group('signInWithEmailAndPassword', () {
    test(
        'should return a ShopShopifyUserModel object when given valid credentials',
        () async {
      // arrange
      when(() => mockShopifyAuth.signInWithEmailAndPassword(
            email: testEmail,
            password: testPassword,
          )).thenAnswer((_) async => shopifyUser);
      // act
      final result = await customerAuthDataSourceImpl
          .signInWithEmailAndPassword(email: testEmail, password: testPassword);
      // assert
      expect(result, equals(shopShopifyUser));
    });

    test(
        'should throw an AuthException when given a ShopifyException from the shopify api',
        () async {
      // arrange
      when(() => mockShopifyAuth.signInWithEmailAndPassword(
            email: testEmail,
            password: testPassword,
          )).thenThrow(
        const ShopifyException(
          'error key',
          'error message',
          errors: ['generic error'],
        ),
      );
      // act
      final call = customerAuthDataSourceImpl.signInWithEmailAndPassword;
      // assert
      expect(() => call(email: testEmail, password: testPassword),
          throwsA(isA<AuthException>()));
    });

    test(
        'should throw an AuthException with the relevant message when given a ShopifyException from the shopify api',
        () async {
      // arrange
      when(() => mockShopifyAuth.signInWithEmailAndPassword(
            email: testEmail,
            password: testPassword,
          )).thenThrow(
        const ShopifyException(
          'error key',
          'error message',
          errors: ['generic error description'],
        ),
      );
      // act
      final call = customerAuthDataSourceImpl.signInWithEmailAndPassword;
      // assert
      expect(
          () => call(email: testEmail, password: testPassword),
          throwsA(isA<AuthException>().having(
            (e) => e.message,
            'message',
            'generic error description',
          )));
    });
  });
}
