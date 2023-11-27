import 'package:dartz/dartz.dart';
import 'package:ecom_template/core/error/exceptions.dart';
import 'package:ecom_template/core/error/failures.dart';
import 'package:ecom_template/core/network/network_info.dart';
import 'package:ecom_template/features/checkout/domain/entities/product_variant_checkout.dart';
import 'package:ecom_template/features/checkout/domain/entities/shipping_address.dart';
import 'package:ecom_template/features/customer/data/datasources/customer_info_datasource.dart';
import 'package:ecom_template/features/order/data/datasources/orders_remote_datasource.dart';
import 'package:ecom_template/features/order/data/models/order_model.dart';
import 'package:ecom_template/features/order/data/repositories/orders_repositories_impl.dart';
import 'package:ecom_template/features/order/domain/entities/line_item_order.dart';
import 'package:ecom_template/features/order/domain/entities/line_items_order.dart';
import 'package:ecom_template/features/order/domain/entities/order.dart';
import 'package:ecom_template/features/shop/domain/entities/price.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mocktail/mocktail.dart';

class MockOrdersRemoteDataSource extends Mock
    implements OrdersRemoteDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

class MockCustomerInfoDataSource extends Mock
    implements CustomerInfoDataSource {}

void main() {
  late MockOrdersRemoteDataSource mockOrdersRemoteDataSource;
  late OrdersRepositoryImpl ordersRepositoryImpl;
  late MockNetworkInfo mockNetworkInfo;
  late MockCustomerInfoDataSource mockLocalCustomerDataSource;

  setUp(() {
    mockOrdersRemoteDataSource = MockOrdersRemoteDataSource();
    mockNetworkInfo = MockNetworkInfo();
    mockLocalCustomerDataSource = MockCustomerInfoDataSource();

    ordersRepositoryImpl = OrdersRepositoryImpl(
      remoteDataSource: mockOrdersRemoteDataSource,
      networkInfo: mockNetworkInfo,
      customerInfoDataSource: mockLocalCustomerDataSource,
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
              title: 'title',
              sku: 'SkuNum',
              price: Price(amount: 10, currencyCode: 'EUR'),
            ),
          ),
        ],
      ),
    )
  ];

  final List<ShopOrder> testOrders = testOrderModels;

  const String testAccessToken = 'customerAccessTokenValue';

  void runTestsOnline(Function body) {
    group('device is online', () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });
      body();
    });
  }

  void runTestsOffline(Function body) {
    group('device is offline', () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });
    });
  }

  void runTestsWithToken(Function body) {
    group('with customer access token', () {
      setUp(() {
        when(() => mockLocalCustomerDataSource.getCustomerAccessToken())
            .thenAnswer((_) async => testAccessToken);
      });
      body();
    });
  }

  void runTestsWithoutToken(Function body) {
    group('without customer access token', () {
      setUp(() {
        when(() => mockLocalCustomerDataSource.getCustomerAccessToken())
            .thenAnswer((_) async => null);
      });
      body();
    });
  }

  group('getAllOrders', () {
    test(
      'should check if the device is online',
      () async {
        // arrange
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(() => mockOrdersRemoteDataSource.getAllOrders(any()))
            .thenAnswer((_) async => testOrderModels);
        when(() => mockLocalCustomerDataSource.getCustomerAccessToken())
            .thenAnswer((invocation) async => 'testEmptyAccessToken');
        // act
        await ordersRepositoryImpl.getAllOrders();
        // assert
        verify(() => mockNetworkInfo.isConnected);
      },
    );

    test(
      'should call the getCustomerAccessToken from the customer info data source after verifying that the device is online',
      () async {
        // arrange
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(() => mockLocalCustomerDataSource.getCustomerAccessToken())
            .thenAnswer((_) async => testAccessToken);
        when(() => mockOrdersRemoteDataSource.getAllOrders(any()))
            .thenAnswer((_) async => []);

        // act
        await ordersRepositoryImpl.getAllOrders();

        // assert
        verify(() => mockLocalCustomerDataSource.getCustomerAccessToken());
      },
    );

    runTestsOnline(() {
      runTestsWithToken(() {
        test(
          'should return remote data as a ShopOrderModel object when the call to remote data source is successful',
          () async {
            when(() => mockOrdersRemoteDataSource.getAllOrders(any()))
                .thenAnswer((_) async => testOrderModels);
            // act
            final result = await ordersRepositoryImpl.getAllOrders();
            // assert
            verify(() => mockOrdersRemoteDataSource.getAllOrders(any()));
            expect(result, equals(Right(testOrders)));
          },
        );

        test(
          'should return server failure when the call to remote data source is unsuccessful',
          () async {
            when(() => mockOrdersRemoteDataSource.getAllOrders(any()))
                .thenThrow(ServerException());
            // act
            final result = await ordersRepositoryImpl.getAllOrders();
            // assert
            verify(() => mockOrdersRemoteDataSource.getAllOrders(any()));
            expect(result, equals(Left(ServerFailure())));
          },
        );
      });

      runTestsWithoutToken(() {
        test(
          'should return an AuthFailure when the customer access token is null',
          () async {
            // act
            final response = await ordersRepositoryImpl.getAllOrders();
            // assert
            expect(response, equals(const Left(AuthFailure())));
          },
        );
      });
    });

    runTestsOffline(() {
      test(
          'should return an InternetConnectionFailure when the device is offline',
          () async {
        // act
        final response = ordersRepositoryImpl.getAllOrders();
        // assert
        expect(response, equals(Left(InternetConnectionFailure())));
      });
    });
  });
}
