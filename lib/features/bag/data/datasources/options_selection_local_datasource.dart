// ignore_for_file: constant_identifier_names

import 'package:ecom_template/features/bag/domain/entities/options_selection.dart';
import 'package:hive_flutter/hive_flutter.dart';

const BOX_NAME = 'options_selection';

abstract class OptionsSelectionDataSource {
  Future<OptionsSelections?> getSavedSelectedOptions(
    String productId,
  );

  Future<void> saveSelectedOptions(
    String entryId,
    OptionsSelections optionsSelection,
  );

  Future<void> deleteSelectedOptions(String productId);
}

class OptionsSelectionDataSourceImpl implements OptionsSelectionDataSource {
  final HiveInterface interface;

  OptionsSelectionDataSourceImpl({required this.interface});

  @override
  Future<OptionsSelections?> getSavedSelectedOptions(String productId) async {
    final Box<OptionsSelections> hiveBox = await _getOpenBox();
    return hiveBox.get(productId);
  }

  @override
  Future<void> saveSelectedOptions(
      String entryId, OptionsSelections optionsSelection) async {
    final Box<OptionsSelections> hiveBox = await _getOpenBox();
    await hiveBox.put(entryId, optionsSelection);
    return;
  }

  @override
  Future<void> deleteSelectedOptions(String productId) {
    // TODO: implement deleteSelectedOptions
    throw UnimplementedError();
  }

  Future<Box<OptionsSelections>> _getOpenBox() async {
    late final Box<OptionsSelections> hiveBox;
    hiveBox = await interface.openBox<OptionsSelections>(BOX_NAME);
    return hiveBox;
  }
}
