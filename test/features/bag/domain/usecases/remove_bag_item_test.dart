import 'package:dartz/dartz.dart';
import 'package:ecom_template/core/success/write_success.dart';
import 'package:ecom_template/features/bag/data/repositories/bag_repository_impl.dart';
import 'package:ecom_template/features/bag/domain/entities/bag_item_data.dart';
import 'package:ecom_template/features/bag/domain/usecases/remove_bag_item.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockBagItemRepository extends Mock implements BagRepositoryImpl {}

void main() {
  late RemoveBagItem usecase;
  late MockBagItemRepository mockBagItemRepository;

  setUp(() {
    mockBagItemRepository = MockBagItemRepository();
    usecase = RemoveBagItem(repository: mockBagItemRepository);
  });

  const testBagItemParams = BagItemData(
    parentProductId: 'parentProductId',
    quantity: 1,
    productVariantId: 'productVariantId',
  );

  test('should remove a bag item from the repository', () async {
    // arrange
    when(() => mockBagItemRepository.removeBagItem(testBagItemParams))
        .thenAnswer((_) async => const Right(WriteSuccess()));

    // act
    final result = await usecase(testBagItemParams);

    // assert
    expect(result, const Right(WriteSuccess()));
    verify(() => mockBagItemRepository.removeBagItem(testBagItemParams));
    verifyNoMoreInteractions(mockBagItemRepository);
  });
}
