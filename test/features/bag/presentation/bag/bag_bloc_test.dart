import 'package:dartz/dartz.dart';
import 'package:ecom_template/core/error/failures.dart';
import 'package:ecom_template/core/success/write_success.dart';
import 'package:ecom_template/core/usecases/usecase.dart';
import 'package:ecom_template/features/bag/domain/entities/bag_item.dart';
import 'package:ecom_template/features/bag/domain/entities/bag_item_data.dart';
import 'package:ecom_template/features/bag/domain/entities/bag_totals.dart';
import 'package:ecom_template/features/bag/domain/usecases/add_bag_item.dart';
import 'package:ecom_template/features/bag/domain/usecases/calculate_bag_totals.dart';
import 'package:ecom_template/features/bag/domain/usecases/clear_bag_items.dart';
import 'package:ecom_template/features/bag/domain/usecases/get_all_bag_items.dart';
import 'package:ecom_template/features/bag/domain/usecases/remove_bag_item.dart';
import 'package:ecom_template/features/bag/domain/usecases/update_bag_item.dart';
import 'package:ecom_template/features/bag/presentation/bloc/bag/bag_bloc.dart';
import 'package:ecom_template/features/bag/presentation/bloc/options_selection/options_selection_bloc.dart';
import 'package:ecom_template/features/checkout/presentation/bloc/checkout_bloc.dart';
import 'package:ecom_template/features/shop/domain/entities/price.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAddBagItem extends Mock implements AddBagItem {}

class MockRemoveBagItem extends Mock implements RemoveBagItem {}

class MockGetAllBagItems extends Mock implements GetAllBagItems {}

class MockClearBagItems extends Mock implements ClearBagItems {}

class MockCheckoutBloc extends Mock implements CheckoutBloc {}

class MockUpdateBagItem extends Mock implements UpdateBagItem {}

class MockOptionsSelectionBloc extends Mock implements OptionsSelectionBloc {}

class MockCalculateBagTotals extends Mock implements CalculateBagTotals {}

void main() {
  late BagBloc bagBloc;
  late MockAddBagItem mockAddBagItem;
  late MockGetAllBagItems mockGetAllBagItems;
  late MockRemoveBagItem mockRemoveBagItem;
  late MockUpdateBagItem mockUpdateBagItem;
  late MockCalculateBagTotals mockCalculateBagTotals;
  late MockClearBagItems mockClearBagItems;
  late MockCheckoutBloc mockCheckoutBloc;

  setUp(() {
    mockAddBagItem = MockAddBagItem();
    mockRemoveBagItem = MockRemoveBagItem();
    mockGetAllBagItems = MockGetAllBagItems();
    mockUpdateBagItem = MockUpdateBagItem();
    mockCheckoutBloc = MockCheckoutBloc();
    mockCalculateBagTotals = MockCalculateBagTotals();
    mockClearBagItems = MockClearBagItems();

    when(() => mockCheckoutBloc.stream).thenAnswer((_) =>
        Stream<CheckoutState>.fromIterable(
            [const CheckoutCompleted(orderId: 'testOrderId')]));

    bagBloc = BagBloc(
      addBagItem: mockAddBagItem,
      removeBagItem: mockRemoveBagItem,
      getAllBagItems: mockGetAllBagItems,
      clearBagItems: mockClearBagItems,
      checkoutBloc: mockCheckoutBloc,
      updateBagItem: mockUpdateBagItem,
      calculateBagTotals: mockCalculateBagTotals,
    );
    registerFallbackValue(const BagItemData(
      parentProductId: 'parentProductId',
      productVariantTitle: 'productVariantTitle',
      quantity: 1,
      productVariantId: 'productVariantId',
      isOutOfStock: false,
    ));
    registerFallbackValue(NoParams());
  });
  const tItem = BagItemData(
    parentProductId: 'testParentId',
    quantity: 1,
    productVariantTitle: 'variantTitle1',
    productVariantId: 'testVariantId',
    isOutOfStock: false,
  );

  final testBagItems = [
    BagItem(
      id: tItem.productVariantId,
      title: 'test',
      image: null,
      price: const Price(amount: 100, currencyCode: 'USD'),
      quantity: tItem.quantity,
      availableForSale: true,
      quantityAvailable: 1,
      requiresShipping: true,
      selectedOptions: const [],
      sku: '',
      weight: 200,
      weightUnit: '',
      parentProductId: tItem.parentProductId,
    )
  ];

  const testBagTotals = BagTotals(
    total: Price(amount: 100, currencyCode: 'USD'),
    subtotal: Price(amount: 100, currencyCode: 'USD'),
  );

  test('Initial state should be BagInitial', () {
    // assert
    expect(bagBloc.state, equals(BagInitial()));
  });

  group('Add product to bag', () {
    test(
        'should emit [BagLoadingState, BagLoadedAddedState] when data is gotten successfully',
        () async {
      // arrange
      when(() => mockAddBagItem.call(any()))
          .thenAnswer((_) async => const Right(WriteSuccess()));
      when(() => mockGetAllBagItems(NoParams()))
          .thenAnswer((_) async => Right(testBagItems));
      when(() => mockCalculateBagTotals(any()))
          .thenAnswer((_) async => const Right(testBagTotals));

      // assert later
      final expected = [
        BagLoadedAddedState(bagItems: testBagItems, bagTotals: testBagTotals),
      ];
      expectLater(bagBloc.stream, emitsInOrder(expected));

      // act
      bagBloc.add(const AddBagItemEvent(bagItemData: tItem));
    });

    test('should emit [BagLoadingState, BagErrorState] when getting data fails',
        () async {
      final cacheFailure = CacheFailure();

      // arrange
      when(() => mockAddBagItem(any()))
          .thenAnswer((_) async => Left(cacheFailure));
      when(() => mockGetAllBagItems(NoParams()))
          .thenAnswer((_) async => const Right([]));

      // assert later
      final expected = [
        BagErrorState(failure: cacheFailure),
      ];
      expectLater(bagBloc.stream, emitsInOrder(expected));

      // act
      bagBloc.add(const AddBagItemEvent(bagItemData: tItem));
    });
  });

  group('Remove product from bag', () {
    test(
        'should emit [BagLoadingState, BagLoadedRemovedState] when data is gotten',
        () async {
      // arrange
      when(() => mockRemoveBagItem(any()))
          .thenAnswer((_) async => const Right(WriteSuccess()));
      when(() => mockGetAllBagItems(NoParams()))
          .thenAnswer((_) async => Right(testBagItems));
      when(() => mockCalculateBagTotals(any()))
          .thenAnswer((_) async => const Right(testBagTotals));

      // assert later
      final expected = [
        BagLoadedRemovedState(bagItems: testBagItems, bagTotals: testBagTotals),
      ];

      expectLater(bagBloc.stream, emitsInOrder(expected));

      // act
      bagBloc.add(RemoveBagItemEvent(bagItem: testBagItems[0]));
    });

    test(
        'should emit [BagLoadingState , BagErrorState] when getting data fails',
        () async {
      final cacheFailure = CacheFailure();

      // arrange
      when(() => mockRemoveBagItem(any()))
          .thenAnswer((_) async => Left(cacheFailure));
      when(() => mockGetAllBagItems(NoParams()))
          .thenAnswer((_) async => const Right([]));

      // assert later
      final expected = [
        BagErrorState(failure: cacheFailure),
      ];
      expectLater(bagBloc.stream, emitsInOrder(expected));

      // act
      bagBloc.add(RemoveBagItemEvent(bagItem: testBagItems[0]));
    });
  });

  group('Clear bag', () {
    test(
      'should clear bag items when checkout bloc listened to emits a CheckoutCompleted event',
      () async {
        // arrange
        when(() => mockClearBagItems(any()))
            .thenAnswer((_) async => const Right(WriteSuccess()));
        when(() => mockGetAllBagItems(NoParams()))
            .thenAnswer((_) async => const Right([]));

        // assert later
        final expected = [
          BagEmptyState(),
        ];
        expectLater(bagBloc.stream, emitsInOrder(expected));

        // act
        bagBloc.add(ClearBagEvent());
      },
    );
  });
}
