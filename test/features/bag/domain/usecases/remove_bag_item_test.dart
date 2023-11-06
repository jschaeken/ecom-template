import 'package:dartz/dartz.dart';
import 'package:ecom_template/core/success/write_success.dart';
import 'package:ecom_template/features/bag/data/repositories/bag_items_repository_impl.dart';
import 'package:ecom_template/features/bag/domain/entities/bag_item.dart';
import 'package:ecom_template/features/bag/domain/usecases/add_bag_item.dart';
import 'package:ecom_template/features/bag/domain/usecases/remove_bag_item.dart';
import 'package:ecom_template/features/shop/domain/entities/price.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockBagItemRepository extends Mock implements BagItemsRepositoryImpl {}

void main() {
  late RemoveBagItem usecase;
  late MockBagItemRepository mockBagItemRepository;

  setUp(() {
    mockBagItemRepository = MockBagItemRepository();
    usecase = RemoveBagItem(repository: mockBagItemRepository);
  });

  const testBagItemParams = BagItemParams(
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
    ),
  );

  test('should remove a bag item from the repository', () async {
    // arrange
    when(() =>
            mockBagItemRepository.removeBagItem(testBagItemParams.bagItem.id))
        .thenAnswer((_) async => const Right(WriteSuccess()));

    // act
    final result = await usecase(testBagItemParams);

    // assert
    expect(result, const Right(WriteSuccess()));
    verify(() =>
        mockBagItemRepository.removeBagItem(testBagItemParams.bagItem.id));
    verifyNoMoreInteractions(mockBagItemRepository);
  });
}
