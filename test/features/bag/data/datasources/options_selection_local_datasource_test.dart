import 'package:ecom_template/core/constants.dart';
import 'package:ecom_template/features/bag/data/datasources/options_selection_local_datasource.dart';
import 'package:ecom_template/features/bag/domain/entities/options_selection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mocktail/mocktail.dart';

class MockStorageInterface extends Mock implements HiveInterface {}

class MockHiveBox extends Mock implements Box<OptionsSelections> {}

void main() {
  late MockStorageInterface mockStorageInterface;
  late OptionsSelectionDataSourceImpl dataSourceImpl;

  setUp(() {
    mockStorageInterface = MockStorageInterface();
    dataSourceImpl =
        OptionsSelectionDataSourceImpl(interface: mockStorageInterface);
  });

  group('getSavedSelectedOptions', () {
    test(
        'should get the map of saved selected options from the hive box associated with the given id',
        () async {
      const testId = '1';
      const testOptionsSelections = OptionsSelections(selectedOptions: {
        'Option Name 1': 0,
        'Option Name 2': 1,
      });
      final mockHiveBox = MockHiveBox();
      when(() => mockStorageInterface.isBoxOpen(Constants.OPTIONS_BOX_NAME))
          .thenAnswer((_) => true);
      when(() => mockStorageInterface.openBox<OptionsSelections>(
          Constants.OPTIONS_BOX_NAME)).thenAnswer((_) async => mockHiveBox);
      when(() => mockHiveBox.get(testId)).thenReturn(testOptionsSelections);

      final result = await dataSourceImpl.getSavedSelectedOptions(testId);

      expect(result, equals(testOptionsSelections));
    });
  });

  group('saveSelectedOptions', () {
    test(
        'should save the map of selected options to the hive box associated with the given id and return WriteSuccess',
        () async {
      const testId = '1';
      const testOptionsSelections = OptionsSelections(selectedOptions: {
        'Option Name 1': 0,
        'Option Name 2': 1,
      });
      final mockHiveBox = MockHiveBox();
      when(() => mockStorageInterface.isBoxOpen(Constants.OPTIONS_BOX_NAME))
          .thenAnswer((_) => true);
      when(() => mockStorageInterface.openBox<OptionsSelections>(
          Constants.OPTIONS_BOX_NAME)).thenAnswer((_) async => mockHiveBox);
      when(() => mockHiveBox.put(testId, testOptionsSelections))
          .thenAnswer((_) async => {});

      await dataSourceImpl.saveSelectedOptions(testId, testOptionsSelections);

      verify(() => mockHiveBox.put(testId, testOptionsSelections));
    });
  });
}
