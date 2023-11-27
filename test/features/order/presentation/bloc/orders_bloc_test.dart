import 'package:dartz/dartz.dart';
import 'package:ecom_template/core/error/failures.dart';
import 'package:ecom_template/core/usecases/usecase.dart';
import 'package:ecom_template/features/checkout/domain/entities/product_variant_checkout.dart';
import 'package:ecom_template/features/checkout/domain/entities/shipping_address.dart';
import 'package:ecom_template/features/order/data/repositories/orders_repositories_impl.dart';
import 'package:ecom_template/features/order/domain/entities/line_item_order.dart';
import 'package:ecom_template/features/order/domain/entities/line_items_order.dart';
import 'package:ecom_template/features/order/domain/entities/order.dart';
import 'package:ecom_template/features/order/domain/repositories/orders_repository.dart';
import 'package:ecom_template/features/order/domain/usecases/get_all_orders.dart';
import 'package:ecom_template/features/order/presentation/bloc/orders_bloc.dart';
import 'package:ecom_template/features/shop/domain/entities/price.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetAllOrders extends Mock implements GetAllOrders {}

void main() {
  late OrdersBloc ordersBloc;
  late MockGetAllOrders mockGetAllOrders;

  setUp(() {
    mockGetAllOrders = MockGetAllOrders();
    ordersBloc = OrdersBloc(
      getAllOrders: mockGetAllOrders,
    );

    registerFallbackValue(NoParams());
  });

  const List<ShopOrder> testOrders = [
    ShopOrder(
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

  test('initialState should be OrdersInitial', () {
    // assert
    expect(ordersBloc.state, equals(OrdersInitial()));
  });

  group('GetAllOrdersEvent', () {
    test(
        'should emit [OrdersInitial, OrdersLoading, OrdersLoaded] from the Bloc when data is gotten successfully',
        () async {
      // arrange
      when(() => mockGetAllOrders(any()))
          .thenAnswer((_) async => const Right(testOrders));

      final expected = [
        OrdersLoading(),
        const OrdersLoaded(orders: testOrders),
      ];
      // assert later
      expectLater(ordersBloc.stream, emitsInOrder(expected));

      // act
      ordersBloc.add(const GetAllOrdersEvent());
    });

    test(
        'should emit [OrdersInitial, OrdersLoading, OrdersError] from the Bloc when getting data fails',
        () async {
      final testFailure = CacheFailure();
      // arrange
      when(() => mockGetAllOrders(any()))
          .thenAnswer((_) async => Left(testFailure));

      final expected = [
        OrdersLoading(),
        OrdersError(failure: testFailure),
      ];
      // assert/expect later
      expectLater(ordersBloc.stream, emitsInOrder(expected));

      // act
      ordersBloc.add(const GetAllOrdersEvent());
    });
  });
}
