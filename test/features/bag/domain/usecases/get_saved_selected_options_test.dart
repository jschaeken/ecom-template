import 'package:dartz/dartz.dart';
import 'package:ecom_template/core/usecases/usecase.dart';
import 'package:ecom_template/features/bag/data/repositories/bag_repository_impl.dart';
import 'package:ecom_template/features/bag/domain/entities/options_selection.dart';
import 'package:ecom_template/features/bag/domain/usecases/get_saved_selected_options.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockBagItemRepository extends Mock implements BagRepositoryImpl {}

void main() {
  late GetSavedSelectedOptions usecase;
  late MockBagItemRepository mockBagItemRepository;

  setUp(() {
    mockBagItemRepository = MockBagItemRepository();
    usecase = GetSavedSelectedOptions(repository: mockBagItemRepository);
  });

  registerFallbackValue(const Params(id: '1'));

  group('getSavedSelectedOptions', () {
    test(
        'should call the getSavedSelectedOptions method from the BagRepository with an id',
        () async {
      // arrange
      when(() => mockBagItemRepository.getSavedSelectedOptions(any()))
          .thenAnswer((_) async =>
              const Right(OptionsSelections(selectedOptions: {}, quantity: 1)));

      // act
      final response = await usecase(const Params(id: '1'));

      // assert
      expect(response,
          const Right(OptionsSelections(selectedOptions: {}, quantity: 1)));
    });
  });
}
