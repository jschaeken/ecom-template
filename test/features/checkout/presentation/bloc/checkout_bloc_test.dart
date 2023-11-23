import 'package:dartz/dartz.dart';
import 'package:ecom_template/core/error/failures.dart';
import 'package:ecom_template/core/usecases/usecase.dart';
import 'package:ecom_template/features/bag/domain/entities/bag_item.dart';
import 'package:ecom_template/features/checkout/domain/entities/applied_gift_cards.dart';
import 'package:ecom_template/features/checkout/domain/entities/available_shipping_rates.dart';
import 'package:ecom_template/features/checkout/domain/entities/checkout.dart';
import 'package:ecom_template/features/checkout/domain/entities/line_item.dart';
import 'package:ecom_template/features/checkout/domain/entities/shipping_address.dart';
import 'package:ecom_template/features/checkout/domain/entities/shipping_rate.dart';
import 'package:ecom_template/features/checkout/domain/usecases/add_discount_code.dart';
import 'package:ecom_template/features/checkout/domain/usecases/bag_items_to_line_items.dart';
import 'package:ecom_template/features/checkout/domain/usecases/create_checkout.dart';
import 'package:ecom_template/features/checkout/domain/usecases/get_checkout_info.dart';
import 'package:ecom_template/features/checkout/presentation/bloc/checkout_bloc.dart';
import 'package:ecom_template/features/order/domain/entities/line_items_order.dart';
import 'package:ecom_template/features/order/domain/entities/order.dart';
import 'package:ecom_template/features/shop/domain/entities/price.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCreateCheckout extends Mock implements CreateCheckout {}

class MockBagItemsToLineItems extends Mock implements BagItemsToLineItems {}

class MockGetCheckoutInfo extends Mock implements GetCheckoutInfo {}

class MockAddDiscountCode extends Mock implements AddDiscountCode {}

void main() {
  late CheckoutBloc checkoutBloc;
  late MockCreateCheckout mockCreateCheckout;
  late MockGetCheckoutInfo mockGetCheckoutInfo;
  late MockAddDiscountCode mockAddDiscountCode;
  late BagItemsToLineItems bagItemsToLineItems;

  setUp(() {
    mockCreateCheckout = MockCreateCheckout();
    bagItemsToLineItems = MockBagItemsToLineItems();
    mockGetCheckoutInfo = MockGetCheckoutInfo();
    mockAddDiscountCode = MockAddDiscountCode();
    checkoutBloc = CheckoutBloc(
      createCheckout: mockCreateCheckout,
      getCheckoutInfo: mockGetCheckoutInfo,
      bagItemsToLineItems: bagItemsToLineItems,
      addDiscountCode: mockAddDiscountCode,
    );
  });

  registerFallbackValue(const ShopCreateCheckoutParams());
  registerFallbackValue(const Params(id: 'id'));
  registerFallbackValue(const ShopCheckoutActionParams(
    checkoutId: 'id',
    option: 'discountCode',
  ));

  test('initialState should be CheckoutInitial', () {
    // assert
    expect(checkoutBloc.state, equals(CheckoutInitial()));
  });

  const tCheckout = ShopCheckout(
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
    // order: ** Order is null because this is an incomplete checkout **
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

  const tCheckoutOrderComplete = ShopCheckout(
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

  group('AddToCheckoutEvent', () {
    test(
      'should emit [CheckoutLoading, CheckoutLoaded] when data is gotten successfully',
      () async {
        // arrange
        when(() => bagItemsToLineItems(bagItems: any(named: 'bagItems')))
            .thenAnswer((_) async => [
                  const ShopLineItem(
                    id: 'id',
                    variantId: 'variantId',
                    title: 'title',
                    quantity: 1,
                    discountAllocations: [],
                    customAttributes: [],
                  )
                ]);
        when(() => mockCreateCheckout(any()))
            .thenAnswer((_) async => const Right(tCheckout));
        // assert later
        final expected = [
          CheckoutLoading(),
          const CheckoutLoaded(checkout: tCheckout),
        ];
        expectLater(checkoutBloc.stream, emitsInOrder(expected));
        // act
        checkoutBloc.add(const AddToCheckoutEvent(
          bagItems: [
            BagItem(
              id: 'id',
              title: 'test',
              image: null,
              price: Price(amount: 100, currencyCode: 'USD'),
              quantity: 2,
              availableForSale: true,
              quantityAvailable: 1,
              requiresShipping: true,
              selectedOptions: [],
              sku: '',
              weight: 200,
              weightUnit: '',
              parentProductId: 'parentProductId',
            )
          ],
          email: '',
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
        ));
      },
    );
  });

  group('GetCheckoutInfoEvent', () {
    test(
      'should emit [CheckoutLoading, CheckoutLoaded] when data is gotten successfully, but order has not been placed yet',
      () async {
        // arrange
        when(() => mockGetCheckoutInfo(any()))
            .thenAnswer((_) async => const Right(tCheckout));
        // assert later
        final expected = [
          CheckoutLoading(),
          const CheckoutLoaded(checkout: tCheckout),
        ];
        expectLater(checkoutBloc.stream, emitsInOrder(expected));
        // act
        checkoutBloc.add(const GetCheckoutInfoEvent(checkoutId: 'id'));
      },
    );

    test(
      'should emit [CheckoutLoading, CheckoutCompleted] when data is gotten successfully, and order has been placed',
      () async {
        // arrange
        when(() => mockGetCheckoutInfo(any())).thenAnswer(
            (invocation) async => const Right(tCheckoutOrderComplete));
        // assert later
        final expected = [
          CheckoutLoading(),
          const CheckoutCompleted(orderId: 'id'),
        ];
        expectLater(checkoutBloc.stream, emitsInOrder(expected));
        // act
        checkoutBloc.add(const GetCheckoutInfoEvent(checkoutId: 'id'));
      },
    );

    test(
      'should emit [CheckoutLoading, CheckoutError] when getting data fails',
      () async {
        // arrange
        when(() => mockGetCheckoutInfo(any()))
            .thenAnswer((_) async => Left(ServerFailure()));

        // assert later
        final expected = [
          CheckoutLoading(),
          CheckoutError(failure: ServerFailure()),
        ];
        expectLater(checkoutBloc.stream, emitsInOrder(expected));
        // act
        checkoutBloc.add(const GetCheckoutInfoEvent(checkoutId: 'id'));
      },
    );
  });

  group('AddDiscountCodeEvent', () {
    test(
      'should emit [CheckoutLoading, CheckoutLoaded] when discount is added is gotten successfully',
      () async {
        // arrange
        when(() => mockAddDiscountCode(any()))
            .thenAnswer((_) async => const Right(tCheckout));
        // assert later
        final expected = [
          CheckoutLoading(),
          const CheckoutLoaded(checkout: tCheckout),
        ];
        expectLater(checkoutBloc.stream, emitsInOrder(expected));
        // act
        checkoutBloc.add(const AddDiscountCodeEvent(
          checkoutId: 'id',
          discountCode: 'discountCode',
        ));
      },
    );

    test(
      'should emit [CheckoutLoading, CheckoutError] when getting data fails',
      () async {
        // arrange
        when(() => mockAddDiscountCode(any())).thenAnswer(
          (_) async => const Left(
            DiscountCodeFailure(message: 'tMessage'),
          ),
        );

        // assert later
        final expected = [
          CheckoutLoading(),
          const CheckoutError(
            failure: DiscountCodeFailure(message: 'tMessage'),
          ),
        ];
        expectLater(
          checkoutBloc.stream,
          emitsInOrder(expected),
        );
        // act
        checkoutBloc.add(const AddDiscountCodeEvent(
          checkoutId: 'id',
          discountCode: 'discountCode',
        ));
      },
    );
  });
}
