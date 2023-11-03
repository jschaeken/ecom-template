import 'package:ecom_template/features/shop/presentation/bloc/images/images_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late ImagesBloc bloc;

  setUp(() {
    bloc = ImagesBloc();
  });

  group('Variant Selection', () {
    test('Initial state should be ImagesInitial', () {
      // assert
      expect(bloc.state, equals(const ImagesInitial(variantIndexSelected: 0)));
    });

    test(
        'When the VariantImageSelected event with an index is passed into the bloc, the images initial state should be emitted with the corresponding index',
        () async {
      // arrange
      const tIndex = 1;

      // assert later
      const expected = [
        VariantSelectionUpdate(variantIndexSelected: tIndex),
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(const VariantImageSelected(index: tIndex));
    });
  });
}
