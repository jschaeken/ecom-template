import 'package:dartz/dartz.dart';
import 'package:ecom_template/core/error/failures.dart';
import 'package:ecom_template/core/network/network_info.dart';
import 'package:ecom_template/features/checkout/data/datasources/checkout_remote_datasource.dart';
import 'package:ecom_template/features/checkout/data/models/checkout_model.dart';
import 'package:ecom_template/features/checkout/data/repositories/checkout_repository_impl.dart';
import 'package:ecom_template/features/checkout/domain/entities/checkout.dart';
import 'package:ecom_template/features/checkout/domain/entities/checkout_user_error.dart';
import 'package:ecom_template/features/checkout/domain/entities/line_item.dart';
import 'package:ecom_template/features/checkout/domain/entities/shipping_address.dart';
import 'package:ecom_template/features/order/domain/entities/discount_allocations.dart';
import 'package:ecom_template/features/shop/domain/entities/price.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shopify_flutter/mixins/src/shopfiy_error.dart';

class MockCheckoutDataSource extends Mock implements CheckoutRemoteDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late CheckoutRepositoryImpl repository;
  late MockCheckoutDataSource mockCheckoutDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockCheckoutDataSource = MockCheckoutDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = CheckoutRepositoryImpl(
        dataSource: mockCheckoutDataSource, networkInfo: mockNetworkInfo);
  });

  const testShopCheckoutModel = ShopCheckoutModel(
    id: 'id',
    subtotalPrice: Price(amount: 12.34, currencyCode: 'USD'),
    totalPrice: Price(amount: 12.34, currencyCode: 'USD'),
    totalTax: Price(amount: 0, currencyCode: 'USD'),
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
      ShopLineItem(
        title: 'title',
        quantity: 2,
        discountAllocations: [],
        customAttributes: [],
      )
    ],
  );

  const ShopCheckout testShopCheckout = testShopCheckoutModel;

  group('createCheckout', () {
    test('should check if the device is online', () async {
      // arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockCheckoutDataSource.createCheckout(
            lineItems: any(named: 'lineItems'),
            shippingAddress: any(named: 'shippingAddress'),
            email: any(named: 'email'),
          )).thenAnswer((_) async => testShopCheckoutModel);
      // act
      await repository.createCheckout(
        lineItems: [],
        shippingAddress: null,
        email: null,
      );
      // assert
      verify(() => mockNetworkInfo.isConnected);
    });

    group('Device is online', () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      test(
        'should convert the ShopLineItem to LineItem',
        () async {
          // arrange
          when(() => mockCheckoutDataSource.createCheckout(
                lineItems: any(named: 'lineItems'),
                shippingAddress: any(named: 'shippingAddress'),
                email: any(named: 'email'),
              )).thenAnswer((_) async => testShopCheckoutModel);

          // act

          // assert
        },
      );

      test(
        'should return a ShopCheckout Object when the call to the data source is successful',
        () async {
          // arrange
          when(() => mockCheckoutDataSource.createCheckout(
                lineItems: any(named: 'lineItems'),
                shippingAddress: any(named: 'shippingAddress'),
                email: any(named: 'email'),
              )).thenAnswer((_) async => testShopCheckoutModel);
          // act
          final result = await repository.createCheckout(
            lineItems: [],
            shippingAddress: const ShopShippingAddress(
                firstName: 'firstName',
                lastName: 'lastName',
                name: 'firstName lastName',
                id: 'id',
                address1: 'address1',
                city: 'city',
                country: 'country',
                zip: 'zip'),
            email: '',
          );
          // assert
          expect(result, const Right(testShopCheckout));
        },
      );
      test(
        'should return a ServerFailure when the call to the data source is unsuccessful',
        () async {
          // arrange
          when(() => mockCheckoutDataSource.createCheckout(
                lineItems: any(named: 'lineItems'),
                shippingAddress: any(named: 'shippingAddress'),
                email: any(named: 'email'),
              )).thenThrow(Exception());
          // act
          final result = await repository.createCheckout(
            lineItems: [],
            shippingAddress: null,
            email: null,
          );
          // assert
          expect(result, equals(Left(ServerFailure())));
          // verify(() => mockCheckoutDataSource.createCheckout(
          //       lineItems: [],
          //       shippingAddress: null,
          //       email: null,
          //     ));
          // verifyNoMoreInteractions(mockCheckoutDataSource);
        },
      );
    });

    group('Device is offline', () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      test(
          'should return an InternetConnectionFailure object when device is not online',
          () async {
        // act
        final result = await repository.createCheckout(
          lineItems: [],
          shippingAddress: null,
          email: null,
        );
        // assert
        expect(result, equals(const Left(InternetConnectionFailure())));
        verifyZeroInteractions(mockCheckoutDataSource);
      });
    });
  });

  group('getCheckoutInfo', () {
    test(
      'should check if the device is online',
      () async {
        // arrange
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(() => mockCheckoutDataSource.getCheckoutInfo(
              checkoutId: any(named: 'checkoutId'),
            )).thenAnswer((_) async => testShopCheckoutModel);

        // act
        await repository.getCheckoutById(
          checkoutId: '',
        );

        // assert
        verify(() => mockNetworkInfo.isConnected);
      },
    );

    group('Device is online', () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      test(
        'should return a ShopCheckout Object when the call to the data source is successful',
        () async {
          // arrange
          when(() => mockCheckoutDataSource.getCheckoutInfo(
                checkoutId: any(named: 'checkoutId'),
              )).thenAnswer((_) async => testShopCheckoutModel);
          // act
          final result = await repository.getCheckoutById(
            checkoutId: '',
          );
          // assert
          expect(result, const Right(testShopCheckout));
        },
      );
      test(
        'should return a ServerFailure when the call to the data source is unsuccessful',
        () async {
          // arrange
          when(() => mockCheckoutDataSource.getCheckoutInfo(
                checkoutId: any(named: 'checkoutId'),
              )).thenThrow(Exception());
          // act
          final result = await repository.getCheckoutById(
            checkoutId: '',
          );
          // assert
          expect(result, equals(Left(ServerFailure())));
        },
      );
    });

    group('Device is offline', () {
      setUp(() => when(() => mockNetworkInfo.isConnected)
          .thenAnswer((_) async => false));

      test(
        'should return an InternetConnectionFailure object when device is not online',
        () async {
          // act
          final result = await repository.getCheckoutById(
            checkoutId: '',
          );

          // assert
          expect(result, equals(const Left(InternetConnectionFailure())));
          verifyZeroInteractions(mockCheckoutDataSource);
        },
      );
    });
  });

  group('addDiscountCode', () {
    const testShopCheckoutWithDiscount = ShopCheckoutModel(
      id: 'id',
      subtotalPrice: Price(amount: 12.34, currencyCode: 'USD'),
      totalPrice: Price(amount: 12.34, currencyCode: 'USD'),
      totalTax: Price(amount: 0, currencyCode: 'USD'),
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
      discountCodesApplied: ['discountCode'],
      lineItems: [
        ShopLineItem(
          title: 'title',
          quantity: 2,
          discountAllocations: [
            ShopDiscountAllocations(
              allocatedAmount: Price(amount: 3.80, currencyCode: 'EUR'),
            ),
          ],
          customAttributes: [],
        )
      ],
    );

    const testId = 'id';
    const testDiscountCode = 'discountCode';

    test(
      'should check if the device is online',
      () async {
        // arrange
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(() => mockCheckoutDataSource.getCheckoutInfo(
              checkoutId: any(named: 'checkoutId'),
            )).thenAnswer((_) async => testShopCheckoutModel);

        // act
        await repository.getCheckoutById(
          checkoutId: '',
        );

        // assert
        verify(() => mockNetworkInfo.isConnected);
      },
    );

    group('Device is offline', () {
      setUp(() => when(() => mockNetworkInfo.isConnected)
          .thenAnswer((_) async => false));

      test(
        'should return an InternetConnectionFailure object when device is not online',
        () async {
          // act
          final result = await repository.getCheckoutById(
            checkoutId: '',
          );

          // assert
          expect(result, equals(const Left(InternetConnectionFailure())));
          verifyZeroInteractions(mockCheckoutDataSource);
        },
      );
    });
    group('Device is online', () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      test(
          'should return a ShopCheckout object with a discount code applied to the line item when the call to the data source is successful',
          () async {
        // arrange
        when(() => mockCheckoutDataSource.addDiscountCode(
              checkoutId: any(named: 'checkoutId'),
              discountCode: any(named: 'discountCode'),
            )).thenAnswer((invocation) async => testShopCheckoutWithDiscount);

        // act
        final result = await repository.addDiscountCode(
          checkoutId: testId,
          discountCode: testDiscountCode,
        );

        // assert
        expect(result, equals(const Right(testShopCheckoutWithDiscount)));
        verify(
          () => mockCheckoutDataSource.addDiscountCode(
            checkoutId: testId,
            discountCode: testDiscountCode,
          ),
        );
      });

      test(
        'should return a CheckoutUserFailure when the call to the data source throws a ShopifyException',
        () async {
          // arrange
          when(() => mockCheckoutDataSource.addDiscountCode(
                checkoutId: any(named: 'checkoutId'),
                discountCode: any(named: 'discountCode'),
              )).thenThrow(
            const ShopifyException(
              'key',
              'error',
              errors: ['message 1'],
            ),
          );
          // act
          final result = await repository.addDiscountCode(
            checkoutId: testId,
            discountCode: testDiscountCode,
          );
          // assert
          expect(
            result,
            equals(
              const Left(
                CheckoutUserFailure(
                  userErrors: [
                    CheckoutUserError(
                      message: 'message 1',
                      code: '',
                      fields: [],
                    )
                  ],
                ),
              ),
            ),
          );
        },
      );

      test(
        'should return a ServerFailure when the call to the data source throws a generic or unchecked exception',
        () async {
          // arrange
          when(() => mockCheckoutDataSource.addDiscountCode(
                checkoutId: any(named: 'checkoutId'),
                discountCode: any(named: 'discountCode'),
              )).thenThrow(
            Exception(),
          );
          // act
          final result = await repository.addDiscountCode(
            checkoutId: testId,
            discountCode: testDiscountCode,
          );
          // assert
          expect(
            result,
            equals(
              Left(ServerFailure()),
            ),
          );
        },
      );
    });
  });
}
