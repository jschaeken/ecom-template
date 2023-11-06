import 'package:dartz/dartz.dart';
import 'package:ecom_template/core/error/failures.dart';
import 'package:ecom_template/core/success/write_success.dart';
import 'package:ecom_template/core/usecases/usecase.dart';
import 'package:ecom_template/features/bag/domain/entities/bag_item.dart';
import 'package:ecom_template/features/bag/domain/usecases/add_bag_item.dart';
import 'package:ecom_template/features/bag/domain/usecases/get_all_bag_items.dart';
import 'package:ecom_template/features/bag/domain/usecases/remove_bag_item.dart';
import 'package:ecom_template/features/bag/domain/usecases/update_bag_item.dart';
import 'package:ecom_template/features/bag/presentation/bloc/bag/bag_bloc.dart';
import 'package:ecom_template/features/shop/domain/entities/price.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAddBagItem extends Mock implements AddBagItem {}

class MockRemoveBagItem extends Mock implements RemoveBagItem {}

class MockGetAllBagItems extends Mock implements GetAllBagItems {}

class MockUpdateBagItem extends Mock implements UpdateBagItem {}

void main() {
  late BagBloc bloc;
  late MockAddBagItem mockAddBagItem;
  late MockGetAllBagItems mockGetAllBagItems;
  late MockRemoveBagItem mockRemoveBagItem;
  late MockUpdateBagItem mockUpdateBagItem;

  setUp(() {
    mockAddBagItem = MockAddBagItem();
    mockRemoveBagItem = MockRemoveBagItem();
    mockGetAllBagItems = MockGetAllBagItems();
    mockUpdateBagItem = MockUpdateBagItem();
    bloc = BagBloc(
      addBagItem: mockAddBagItem,
      removeBagItem: mockRemoveBagItem,
      getAllBagItems: mockGetAllBagItems,
      updateBagItem: mockUpdateBagItem,
    );
  });

  const tItem = BagItemParams(
      bagItem: BagItem(
    id: '1',
    title: 'test',
    image: null,
    price: Price(amount: '100', currencyCode: 'USD'),
    quantity: 0,
    availableForSale: true,
    quantityAvailable: 1,
    requiresShipping: true,
    selectedOptions: [],
    sku: '',
    weight: '',
    weightUnit: '',
    parentProductId: 'testParentId',
  ));

  final testBagItems = [tItem.bagItem];

  test('Initial state should be BagInitial', () {
    // assert
    expect(bloc.state, equals(BagInitial()));
  });

  group('Add product to bag', () {
    test(
        'should emit [BagLoadingState, BagLoadedState] when data is gotten successfully',
        () async {
      // arrange
      when(() => mockAddBagItem.call(tItem))
          .thenAnswer((_) async => const Right(WriteSuccess()));
      when(() => mockGetAllBagItems(NoParams()))
          .thenAnswer((_) async => Right(testBagItems));

      print('testBagItems: $testBagItems');

      // assert later
      final expected = [
        BagLoadingState(),
        BagLoadedState(bagItems: testBagItems),
      ];
      expectLater(bloc.stream, emitsInOrder(expected));

      // act
      bloc.add(AddBagItemEvent(bagItem: tItem.bagItem));
    });

    test('should emit [BagLoadingState, BagErrorState] when getting data fails',
        () async {
      final cacheFailure = CacheFailure();

      // arrange
      when(() => mockAddBagItem(tItem))
          .thenAnswer((_) async => Left(cacheFailure));
      when(() => mockGetAllBagItems(NoParams()))
          .thenAnswer((_) async => const Right([]));

      // assert later
      final expected = [
        BagLoadingState(),
        BagErrorState(failure: cacheFailure),
      ];
      expectLater(bloc.stream, emitsInOrder(expected));

      // act
      bloc.add(AddBagItemEvent(bagItem: tItem.bagItem));
    });
  });

  group('Remove product from bag', () {
    test('should emit [BagLoadingState, BagLoadedState] when data is gotten',
        () async {
      // arrange
      when(() => mockRemoveBagItem(tItem))
          .thenAnswer((_) async => const Right(WriteSuccess()));
      when(() => mockGetAllBagItems(NoParams()))
          .thenAnswer((_) async => Right(testBagItems));

      // assert later
      final expected = [
        BagLoadingState(),
        BagLoadedState(bagItems: testBagItems),
      ];

      expectLater(bloc.stream, emitsInOrder(expected));

      // act
      bloc.add(RemoveBagItemEvent(bagItem: tItem.bagItem));
    });

    test('should emit [BagLoadingState, BagErrorState] when getting data fails',
        () async {
      final cacheFailure = CacheFailure();

      // arrange
      when(() => mockRemoveBagItem(tItem))
          .thenAnswer((_) async => Left(cacheFailure));
      when(() => mockGetAllBagItems(NoParams()))
          .thenAnswer((_) async => const Right([]));

      // assert later
      final expected = [
        BagLoadingState(),
        BagErrorState(failure: cacheFailure),
      ];
      expectLater(bloc.stream, emitsInOrder(expected));

      // act
      bloc.add(RemoveBagItemEvent(bagItem: tItem.bagItem));
    });
  });
}