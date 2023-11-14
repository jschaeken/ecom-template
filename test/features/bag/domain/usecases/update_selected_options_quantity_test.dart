import 'package:dartz/dartz.dart';
import 'package:ecom_template/core/success/write_success.dart';
import 'package:ecom_template/features/bag/data/repositories/bag_repository_impl.dart';
import 'package:ecom_template/features/bag/domain/entities/options_selection.dart';
import 'package:ecom_template/features/bag/domain/usecases/save_selected_options.dart';
import 'package:ecom_template/features/bag/domain/usecases/update_selected_options_quantity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockBagItemRepository extends Mock implements BagRepositoryImpl {}

void main() {
  late MockBagItemRepository mockBagItemRepository;
  late UpdateSelectedOptionsQuantity usecase;

  setUp(() {
    mockBagItemRepository = MockBagItemRepository();
    usecase = UpdateSelectedOptionsQuantity(repository: mockBagItemRepository);
  });

  registerFallbackValue(
    const OptionsSelections(quantity: 10),
  );

  group('updateSelectedOptionsQuantity', () {
    test(
        'should call the UpdateSelectedOptionsQuantity method from the BagRepository with an OptionsSelections object',
        () async {
      // arrange
      when(() =>
              mockBagItemRepository.updateSelectedOptionsQuantity(any(), any()))
          .thenAnswer((_) async => const Right(WriteSuccess()));

      // act
      final response = await usecase(const SelectedOptionsParams(
        productId: '1',
        optionsSelection: OptionsSelections(selectedOptions: {}, quantity: 9),
      ));

      // assert
      expect(response, const Right(WriteSuccess()));
    });
  });
}
