import 'package:ecom_template/features/checkout/domain/entities/product_variant_checkout.dart';
import 'package:ecom_template/features/checkout/domain/entities/shipping_address.dart';
import 'package:ecom_template/features/order/data/datasources/orders_remote_datasource.dart';
import 'package:ecom_template/features/order/data/models/order_model.dart';
import 'package:ecom_template/features/order/domain/entities/line_item_order.dart';
import 'package:ecom_template/features/order/domain/entities/line_items_order.dart';
import 'package:ecom_template/features/shop/domain/entities/price.dart';
import 'package:ecom_template/features/shop/domain/entities/shop_product_image.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shopify_flutter/models/src/checkout/product_variant_checkout/product_variant_checkout.dart';
import 'package:shopify_flutter/models/src/order/line_item_order/line_item_order.dart';
import 'package:shopify_flutter/models/src/order/line_items_order/line_items_order.dart';
import 'package:shopify_flutter/models/src/order/order.dart';
import 'package:shopify_flutter/models/src/order/shipping_address/shipping_address.dart';
import 'package:shopify_flutter/models/src/product/price_v_2/price_v_2.dart';
import 'package:shopify_flutter/models/src/product/shopify_image/shopify_image.dart';
import 'package:shopify_flutter/shopify/shopify.dart';

class MockShopifyCheckout extends Mock implements ShopifyCheckout {}

void main() {
  late OrdersRemoteDataSourceImpl ordersRemoteDataSourceImpl;
  late MockShopifyCheckout mockShopifyCheckout;

  setUp(() {
    mockShopifyCheckout = MockShopifyCheckout();
    ordersRemoteDataSourceImpl = OrdersRemoteDataSourceImpl(
      shopifyCheckout: mockShopifyCheckout,
    );
  });

  final List<ShopOrderModel> testOrderModels = [
    const ShopOrderModel(
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
      totalPrice: Price(amount: 1, currencyCode: 'EUR'),
      totalRefunded: Price(amount: 2, currencyCode: 'EUR'),
      totalShippingPrice: Price(amount: 3, currencyCode: 'EUR'),
      subtotalPrice: Price(amount: 4, currencyCode: 'EUR'),
      totalTax: Price(amount: 5, currencyCode: 'EUR'),
      currencyCode: 'currencyCode',
      financialStatus: 'financialStatus',
      email: 'email',
      phone: 'phone',
      name: 'name',
      lineItems: ShopLineItemsOrder(
        lineItemOrderList: [
          ShopLineItemOrder(
            currentQuantity: 1,
            discountAllocations: [],
            discountedTotalPrice: Price(amount: 0, currencyCode: 'EUR'),
            originalTotalPrice: Price(amount: 0, currencyCode: 'EUR'),
            quantity: 1,
            title: 'title',
            variant: ShopProductVariantCheckout(
              id: 'id',
              price: Price(amount: 10, currencyCode: 'EUR'),
              title: 'title',
              sku: 'SkuNum',
              availableForSale: true,
              compareAtPrice: Price(amount: 11, currencyCode: 'EUR'),
              image: ShopProductImage(
                altText: 'altText',
                id: 'id',
                originalSrc: 'originalSrc',
              ),
              requiresShipping: true,
              quantityAvailable: 1,
              weight: 10,
              weightUnit: 'Kg',
            ),
          ),
        ],
      ),
    )
  ];

  final List<Order> testOrders = [
    Order(
      billingAddress: ShippingAddress(
        firstName: 'firstName',
        lastName: 'lastName',
        name: 'firstName lastName',
        id: 'id',
        address1: 'address1',
        city: 'city',
        country: 'country',
        zip: 'zip',
      ),
      customerUrl: 'customerUrl',
      fulfillmentStatus: 'fulfillmentStatus',
      shippingAddress: ShippingAddress(
        firstName: 'firstName',
        lastName: 'lastName',
        name: 'firstName lastName',
        id: 'id',
        address1: 'address1',
        city: 'city',
        country: 'country',
        zip: 'zip',
      ),
      statusUrl: 'statusUrl',
      cursor: 'cursor',
      successfulFulfillments: [],
      id: 'id',
      orderNumber: 1,
      processedAt: 'processedAt',
      totalPriceV2: PriceV2(amount: 1, currencyCode: 'EUR'),
      totalRefundedV2: PriceV2(amount: 2, currencyCode: 'EUR'),
      totalShippingPriceV2: PriceV2(amount: 3, currencyCode: 'EUR'),
      subtotalPriceV2: PriceV2(amount: 4, currencyCode: 'EUR'),
      totalTaxV2: PriceV2(
        amount: 5,
        currencyCode: 'EUR',
      ),
      currencyCode: 'currencyCode',
      financialStatus: 'financialStatus',
      email: 'email',
      phone: 'phone',
      name: 'name',
      lineItems: LineItemsOrder(
        lineItemOrderList: [
          LineItemOrder(
            currentQuantity: 1,
            discountAllocations: [],
            discountedTotalPrice: PriceV2(amount: 0, currencyCode: 'EUR'),
            originalTotalPrice: PriceV2(amount: 0, currencyCode: 'EUR'),
            quantity: 1,
            title: 'title',
            variant: ProductVariantCheckout(
              id: 'id',
              priceV2: PriceV2(amount: 10, currencyCode: 'EUR'),
              title: 'title',
              sku: 'SkuNum',
              availableForSale: true,
              requiresShipping: true,
              compareAtPrice: PriceV2(
                amount: 11,
                currencyCode: 'EUR',
              ),
              image: ShopifyImage(
                altText: 'altText',
                id: 'id',
                originalSrc: 'originalSrc',
              ),
              quantityAvailable: 1,
              weight: 10,
              weightUnit: 'Kg',
            ),
          ),
        ],
      ),
    )
  ];

  const String testAccessToken = 'customerAccessTokenValue';
  test(
      'should return list of orders from the ShopifyStore when the getAllOrders method is called on the datasourceImpl',
      () async {
    // arrange
    when(() => mockShopifyCheckout.getAllOrders(any()))
        .thenAnswer((_) async => testOrders);
    // act
    final result = await ordersRemoteDataSourceImpl.getAllOrders(
      testAccessToken,
    );

    // assert
    expect(result, equals(testOrderModels));
  });
}
