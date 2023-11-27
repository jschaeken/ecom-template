import 'package:dartz/dartz.dart';
import 'package:ecom_template/core/success/write_success.dart';
import 'package:ecom_template/features/bag/data/repositories/bag_repository_impl.dart';
import 'package:ecom_template/features/bag/domain/entities/bag_item_data.dart';
import 'package:ecom_template/features/bag/domain/usecases/add_bag_item.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockBagItemRepository extends Mock implements BagRepositoryImpl {}

void main() {
  late AddBagItem usecase;
  late MockBagItemRepository mockBagItemRepository;

  setUp(() {
    mockBagItemRepository = MockBagItemRepository();
    usecase = AddBagItem(repository: mockBagItemRepository);
  });

  const testBagItemData = BagItemData(
    parentProductId: 'testParentId',
    quantity: 1,
    productVariantTitle: 'testVariantTitle',
    productVariantId: 'testVariantId',
    isOutOfStock: false,
  );

  test('should add a bag item to the repository', () async {
    // arrange
    when(() => mockBagItemRepository.addBagItem(testBagItemData))
        .thenAnswer((_) async => const Right(WriteSuccess()));

    // act
    final result = await usecase(testBagItemData);

    // assert
    expect(result, const Right(WriteSuccess()));
    verify(() => mockBagItemRepository.addBagItem(testBagItemData));
    verifyNoMoreInteractions(mockBagItemRepository);
  });
}
