import 'package:ecom_template/features/checkout/data/datasources/checkout_datasource.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shopify_flutter/models/models.dart';
import 'package:shopify_flutter/models/src/product/price_v_2/price_v_2.dart';
import 'package:shopify_flutter/models/src/shopify_user/address/address.dart';
import 'package:shopify_flutter/shopify/shopify.dart';

class MockShopifyCheckout extends Mock implements ShopifyCheckout {}

void main() {
  late MockShopifyCheckout mockShopifyCheckout;
  late CheckoutDataSourceImpl dataSourceImpl;

  setUp(() {
    mockShopifyCheckout = MockShopifyCheckout();
    dataSourceImpl =
        CheckoutDataSourceImpl(shopifyCheckout: mockShopifyCheckout);
  });

  final testCheckout = Checkout(
    id: 'id',
    subtotalPriceV2: PriceV2(amount: 12.34, currencyCode: 'USD'),
    totalPriceV2: PriceV2(amount: 12.34, currencyCode: 'USD'),
    totalTaxV2: PriceV2(amount: 0, currencyCode: 'USD'),
    appliedGiftCards: [],
    order: null,
    orderStatusUrl: null,
    completedAt: null,
    note: null,
    email: null,
    shippingAddress: null,
    shippingLine: null,
    shopifyPaymentsAccountId: null,
    updatedAt: null,
    webUrl: null,
    ready: true,
    availableShippingRates: null,
    createdAt: 'createdAt',
    currencyCode: 'currencyCode',
    taxesIncluded: true,
    taxExempt: true,
    requiresShipping: true,
    lineItems: [
      LineItem(
        title: 'title',
        quantity: 2,
        discountAllocations: [],
        customAttributes: [],
      )
    ],
  );

  final testLineItems = [
    LineItem(
      title: 'title',
      quantity: 2,
      discountAllocations: [],
      customAttributes: [],
    )
  ];

  final testShippingAddress = Address(
    address1: 'address1',
    address2: 'address2',
    city: 'city',
    company: 'company',
    country: 'country',
    countryCode: 'countryCode',
    firstName: 'firstName',
    id: 'id',
    lastName: 'lastName',
    latitude: 'latitude', // 'latitude
    longitude: 'longitude',
    name: 'name',
    phone: 'phone',
    province: 'province',
    provinceCode: 'provinceCode',
    zip: 'zip',
  );

  const testEmail = 'testEmail';

  group(
    'createCheckout',
    () async {
      test(
        'should return a checkout when the call to shopify_flutter is successful',
        () async {
          // arrange
          when(() => mockShopifyCheckout.createCheckout(
                lineItems: any(named: 'lineItems'),
                shippingAddress: any(named: 'shippingAddress'),
                email: any(named: 'email'),
              )).thenAnswer((_) async => testCheckout);
          // act
          final result = await dataSourceImpl.createCheckout(
            lineItems: testLineItems,
            shippingAddress: testShippingAddress,
            email: testEmail,
          );
          // assert
          expect(result, equals(testCheckout));
          verify(() => mockShopifyCheckout.createCheckout(
                lineItems: any(named: 'lineItems'),
                shippingAddress: any(named: 'shippingAddress'),
                email: any(named: 'email'),
              ));
        },
      );
    },
  );
}
