import 'package:dartz/dartz.dart';
import 'package:ecom_template/core/success/write_success.dart';
import 'package:ecom_template/features/bag/data/repositories/bag_repository_impl.dart';
import 'package:ecom_template/features/bag/domain/entities/options_selection.dart';
import 'package:ecom_template/features/bag/domain/usecases/save_selected_options.dart';
import 'package:ecom_template/features/bag/domain/usecases/update_selected_options_fields.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockBagItemRepository extends Mock implements BagRepositoryImpl {}

void main() {
  late MockBagItemRepository mockBagItemRepository;
  late UpdateSelectedOptionsFields usecase;

  setUp(() {
    mockBagItemRepository = MockBagItemRepository();
    usecase = UpdateSelectedOptionsFields(repository: mockBagItemRepository);
  });

  registerFallbackValue(
    const OptionsSelections(selectedOptions: {}, quantity: 1),
  );

  group('updateSelectedOptions', () {
    test(
        'should call the updateSelectedOptionsFields method from the BagRepository with an OptionsSelections object',
        () async {
      // arrange
      when(() =>
              mockBagItemRepository.updateSelectedOptionsFields(any(), any()))
          .thenAnswer((_) async => const Right(WriteSuccess()));

      // act
      final response = await usecase(const SelectedOptionsParams(
        productId: '1',
        optionsSelection: OptionsSelections(selectedOptions: {}, quantity: 2),
      ));

      // assert
      expect(response, const Right(WriteSuccess()));
    });
  });
}
