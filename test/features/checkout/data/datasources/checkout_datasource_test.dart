import 'package:ecom_template/features/checkout/data/datasources/checkout_remote_datasource.dart';
import 'package:ecom_template/features/checkout/data/models/checkout_model.dart';
import 'package:ecom_template/features/checkout/domain/entities/applied_gift_cards.dart';
import 'package:ecom_template/features/checkout/domain/entities/available_shipping_rates.dart';
import 'package:ecom_template/features/checkout/domain/entities/line_item.dart';
import 'package:ecom_template/features/checkout/domain/entities/shipping_address.dart';
import 'package:ecom_template/features/checkout/domain/entities/shipping_rate.dart';
import 'package:ecom_template/features/order/domain/entities/line_items_order.dart';
import 'package:ecom_template/features/order/domain/entities/order.dart';
import 'package:ecom_template/features/shop/domain/entities/price.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shopify_flutter/models/models.dart';
import 'package:shopify_flutter/models/src/checkout/applied_gift_cards/applied_gift_cards.dart';
import 'package:shopify_flutter/models/src/checkout/available_shipping_rates/available_shipping_rates.dart';
import 'package:shopify_flutter/models/src/checkout/mailing_address/mailing_address.dart';
import 'package:shopify_flutter/models/src/checkout/shipping_rates/shipping_rates.dart';
import 'package:shopify_flutter/models/src/order/line_items_order/line_items_order.dart';
import 'package:shopify_flutter/models/src/order/shipping_address/shipping_address.dart';
import 'package:shopify_flutter/models/src/product/price_v_2/price_v_2.dart';
import 'package:shopify_flutter/models/src/shopify_user/address/address.dart';
import 'package:shopify_flutter/shopify/shopify.dart';

class MockShopifyCheckout extends Mock implements ShopifyCheckout {}

void main() {
  late MockShopifyCheckout mockShopifyCheckout;
  late CheckoutRemoteDataSourceImpl dataSourceImpl;

  setUp(() {
    mockShopifyCheckout = MockShopifyCheckout();
    dataSourceImpl =
        CheckoutRemoteDataSourceImpl(shopifyCheckout: mockShopifyCheckout);
  });

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

  const testShopCheckoutModel = ShopCheckoutModel(
    id: 'id',
    ready: true,
    availableShippingRates:
        ShopAvailableShippingRates(ready: true, shippingRates: [
      ShopShippingRate(
          handle: '', price: Price(amount: 2, currencyCode: ''), title: '')
    ]),
    createdAt: 'createdAt',
    currencyCode: 'currencyCode',
    totalTax: Price(amount: 1, currencyCode: ''),
    totalPrice: Price(amount: 3, currencyCode: ''),
    taxesIncluded: false,
    taxExempt: false,
    subtotalPrice: Price(amount: 2, currencyCode: ''),
    requiresShipping: false,
    lineItems: [
      ShopLineItem(
        title: 'title',
        quantity: 1,
        discountAllocations: [],
        customAttributes: [],
      ),
      ShopLineItem(
        title: 'title2',
        quantity: 2,
        discountAllocations: [],
        customAttributes: [],
      ),
      ShopLineItem(
        title: 'title3',
        quantity: 3,
        discountAllocations: [],
        customAttributes: [],
      ),
      ShopLineItem(
        title: 'title4',
        quantity: 4,
        discountAllocations: [],
        customAttributes: [],
      ),
      ShopLineItem(
        title: 'title5',
        quantity: 5,
        discountAllocations: [],
        customAttributes: [],
      ),
    ],
    appliedGiftCards: [
      ShopAppliedGiftCards(
          amountUsed: Price(amount: 1, currencyCode: 'ss'),
          balance: Price(amount: 3, currencyCode: ''),
          id: 's')
    ],
    completedAt: 'completedAt',
    email: 'email',
    note: 'note',
    order: ShopOrder(
      billingAddress: ShopShippingAddress(
          firstName: 'firstName',
          lastName: 'lastName',
          name: 'firstName lastName',
          id: 'id',
          address1: 'address1',
          city: 'city',
          country: 'country',
          zip: 'zip'),
      customerUrl: 'customerUrl',
      fulfillmentStatus: 'fulfillmentStatus',
      shippingAddress: ShopShippingAddress(
          firstName: 'firstName',
          lastName: 'lastName',
          name: 'firstName lastName',
          id: 'id',
          address1: 'address1',
          city: 'city',
          country: 'country',
          zip: 'zip'),
      statusUrl: 'statusUrl',
      cursor: 'cursor',
      successfulFulfillments: [],
      id: 'id',
      orderNumber: 1,
      processedAt: 'processedAt',
      totalPrice: Price(amount: 1, currencyCode: 'USD'),
      totalRefunded: Price(amount: 2, currencyCode: 'EUR'),
      totalShippingPrice: Price(amount: 3, currencyCode: 'YEN'),
      subtotalPrice: Price(amount: 4, currencyCode: 'CAD'),
      totalTax: Price(amount: 5, currencyCode: 'CHZ'),
      currencyCode: 'currencyCode',
      financialStatus: 'financialStatus',
      email: 'email',
      phone: 'phone',
      name: 'name',
      lineItems: ShopLineItemsOrder(lineItemOrderList: []),
    ),
    orderStatusUrl: 'orderStatusUrl',
    shippingAddress: ShopShippingAddress(
      address1: 'address1',
      address2: 'address2',
      city: 'city',
      company: 'company',
      country: 'country',
      countryCodeV2: 'countryCodeV2',
      firstName: 'firstName',
      formattedArea: 'formattedArea',
      id: 'id',
      lastName: 'lastName',
      latitude: 1,
      longitude: 1,
      name: 'name',
      phone: 'phone',
      province: 'province',
      provinceCode: 'provinceCode',
      zip: 'zip',
    ),
    shippingLine: [
      ShopShippingRate(
        handle: '',
        price: Price(amount: 2, currencyCode: ''),
        title: '',
      ),
    ],
    shopifyPaymentsAccountId: 'shopifyPaymentsAccountId',
    updatedAt: 'updatedAt',
    webUrl: 'webUrl',
  );

  final Checkout testCheckout = Checkout(
    id: 'id',
    ready: true,
    availableShippingRates: AvailableShippingRates(ready: true, shippingRates: [
      ShippingRates(
        handle: '',
        priceV2: PriceV2(amount: 2, currencyCode: ''),
        title: '',
      )
    ]),
    createdAt: 'createdAt',
    currencyCode: 'currencyCode',
    totalTaxV2: PriceV2(amount: 1, currencyCode: ''),
    totalPriceV2: PriceV2(amount: 3, currencyCode: ''),
    taxesIncluded: false,
    taxExempt: false,
    subtotalPriceV2: PriceV2(amount: 2, currencyCode: ''),
    requiresShipping: false,
    lineItems: [
      LineItem(
        title: 'title',
        quantity: 1,
        discountAllocations: [],
        customAttributes: [],
      ),
      LineItem(
        title: 'title2',
        quantity: 2,
        discountAllocations: [],
        customAttributes: [],
      ),
      LineItem(
        title: 'title3',
        quantity: 3,
        discountAllocations: [],
        customAttributes: [],
      ),
      LineItem(
        title: 'title4',
        quantity: 4,
        discountAllocations: [],
        customAttributes: [],
      ),
      LineItem(
        title: 'title5',
        quantity: 5,
        discountAllocations: [],
        customAttributes: [],
      ),
    ],
    appliedGiftCards: [
      AppliedGiftCards(
          amountUsedV2: PriceV2(amount: 1, currencyCode: 'ss'),
          balanceV2: PriceV2(amount: 3, currencyCode: ''),
          id: 's')
    ],
    completedAt: 'completedAt',
    email: 'email',
    note: 'note',
    order: Order(
      billingAddress: ShippingAddress(
          firstName: 'firstName',
          lastName: 'lastName',
          name: 'firstName lastName',
          id: 'id',
          address1: 'address1',
          city: 'city',
          country: 'country',
          zip: 'zip'),
      shippingAddress: ShippingAddress(
          firstName: 'firstName',
          lastName: 'lastName',
          name: 'firstName lastName',
          id: 'id',
          address1: 'address1',
          city: 'city',
          country: 'country',
          zip: 'zip'),
      customerUrl: 'customerUrl',
      fulfillmentStatus: 'fulfillmentStatus',
      statusUrl: 'statusUrl',
      cursor: 'cursor',
      successfulFulfillments: [],
      id: 'id',
      orderNumber: 1,
      processedAt: 'processedAt',
      totalPriceV2: PriceV2(amount: 1, currencyCode: 'USD'),
      totalRefundedV2: PriceV2(amount: 2, currencyCode: 'EUR'),
      totalShippingPriceV2: PriceV2(amount: 3, currencyCode: 'YEN'),
      subtotalPriceV2: PriceV2(amount: 4, currencyCode: 'CAD'),
      totalTaxV2: PriceV2(amount: 5, currencyCode: 'CHZ'),
      currencyCode: 'currencyCode',
      financialStatus: 'financialStatus',
      email: 'email',
      phone: 'phone',
      name: 'name',
      lineItems: LineItemsOrder(lineItemOrderList: []),
    ),
    orderStatusUrl: 'orderStatusUrl',
    shippingAddress: MailingAddress(
      address1: 'address1',
      address2: 'address2',
      city: 'city',
      company: 'company',
      country: 'country',
      countryCodeV2: 'countryCodeV2',
      firstName: 'firstName',
      formattedArea: 'formattedArea',
      id: 'id',
      lastName: 'lastName',
      latitude: 1,
      longitude: 1,
      name: 'name',
      phone: 'phone',
      province: 'province',
      provinceCode: 'provinceCode',
      zip: 'zip',
    ),
    shippingLine: ShippingRates(
      handle: '',
      priceV2: PriceV2(amount: 2, currencyCode: ''),
      title: '',
    ),
    shopifyPaymentsAccountId: 'shopifyPaymentsAccountId',
    updatedAt: 'updatedAt',
    webUrl: 'webUrl',
  );

  group(
    'createCheckout',
    () {
      test(
        'should return a ShopCheckoutModel when the call to shopify_flutter is successful',
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
          expect(result, equals(testShopCheckoutModel));
          verify(() => mockShopifyCheckout.createCheckout(
                lineItems: any(named: 'lineItems'),
                shippingAddress: any(named: 'shippingAddress'),
                email: any(named: 'email'),
              ));
        },
      );
    },
  );

  group(
    'addDiscountCode',
    () {
      const testCheckoutId = 'checkoutId';
      const testDiscountCode = 'discountCode';

      test(
        'should return a ShopCheckoutModel when the call to shopify_flutter of checkoutDiscountCodeApplyis successful with the discount code params',
        () async {
          // arrange
          when(() => mockShopifyCheckout.checkoutDiscountCodeApply(
                any(),
                any(),
              )).thenAnswer((_) async => testCheckout);
          // act
          final result = await dataSourceImpl.addDiscountCode(
            checkoutId: testCheckoutId,
            discountCode: testDiscountCode,
          );
          // assert
          expect(result, equals(testShopCheckoutModel));
          verify(() => mockShopifyCheckout.checkoutDiscountCodeApply(
                testCheckoutId,
                testDiscountCode,
              ));
        },
      );
    },
  );
}
