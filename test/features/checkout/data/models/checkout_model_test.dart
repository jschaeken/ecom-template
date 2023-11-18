import 'package:ecom_template/features/checkout/data/models/checkout_model.dart';
import 'package:ecom_template/features/checkout/domain/entities/applied_gift_cards.dart';
import 'package:ecom_template/features/checkout/domain/entities/available_shipping_rates.dart';
import 'package:ecom_template/features/checkout/domain/entities/checkout.dart';
import 'package:ecom_template/features/checkout/domain/entities/line_item.dart';
import 'package:ecom_template/features/checkout/domain/entities/shipping_address.dart';
import 'package:ecom_template/features/checkout/domain/entities/shipping_rate.dart';
import 'package:ecom_template/features/shop/domain/entities/price.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shopify_flutter/models/models.dart';
import 'package:shopify_flutter/models/src/checkout/applied_gift_cards/applied_gift_cards.dart';
import 'package:shopify_flutter/models/src/checkout/available_shipping_rates/available_shipping_rates.dart';
import 'package:shopify_flutter/models/src/checkout/mailing_address/mailing_address.dart';
import 'package:shopify_flutter/models/src/checkout/shipping_rates/shipping_rates.dart';
import 'package:shopify_flutter/models/src/product/price_v_2/price_v_2.dart';

void main() {
  const testShopCheckoutModel = ShopCheckoutModel(
    id: 'id',
    ready: true,
    availableShippingRates: ShopAvailableShippingRates(shippingRates: [
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
    // order: const ShopOrder()
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
          handle: '', price: Price(amount: 2, currencyCode: ''), title: ''),
    ],
    shopifyPaymentsAccountId: 'shopifyPaymentsAccountId',
    updatedAt: 'updatedAt',
    webUrl: 'webUrl',
  );
  const ShopCheckout testShopCheckout = testShopCheckoutModel;

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
    // order: const ShopOrder()
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

  group('ShopCheckoutModel', () {
    test('should be a subclass of ShopCheckout entity', () async {
      // assert
      expect(testShopCheckoutModel, isA<ShopCheckout>());
    });

    test('should return a valid model', () async {
      // act
      final result = ShopCheckoutModel.fromShopifyCheckout(testCheckout);

      // assert
      expect(result, testShopCheckoutModel);
    });
  });
}
