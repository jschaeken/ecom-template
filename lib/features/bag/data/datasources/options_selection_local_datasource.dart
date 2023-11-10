// ignore_for_file: constant_identifier_names

import 'package:ecom_template/core/error/exceptions.dart';
import 'package:ecom_template/features/bag/domain/entities/options_selection.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

const BOX_NAME = 'options_selection';

abstract class OptionsSelectionDataSource {
  Future<OptionsSelections?> getSavedSelectedOptions(
    String productId,
  );

  Future<void> saveSelectedOptions(
    String entryId,
    OptionsSelections optionsSelections,
  );
}

class OptionsSelectionDataSourceImpl implements OptionsSelectionDataSource {
  final HiveInterface interface;

  OptionsSelectionDataSourceImpl({required this.interface});

  @override
  Future<OptionsSelections?> getSavedSelectedOptions(String productId) async {
    try {
      final Box<OptionsSelections> hiveBox = await _getOpenBox();
      final OptionsSelections? optionsSelections = hiveBox.get(productId);
      if (optionsSelections == null) {
        return null;
      }
      return optionsSelections;
    } catch (e) {
      debugPrint('getSavedSelectedOptions error: ${e.toString()}');
      throw CacheException();
    }
  }

  @override
  Future<void> saveSelectedOptions(
      String entryId, OptionsSelections optionsSelection) async {
    try {
      final Box<OptionsSelections> hiveBox = await _getOpenBox();
      await hiveBox.put(entryId, optionsSelection);
      return;
    } catch (e) {
      debugPrint('saveSelectedOptions error: ${e.toString()}');
      throw CacheException();
    }
  }

  Future<Box<OptionsSelections>> _getOpenBox() async {
    try {
      late final Box<OptionsSelections> hiveBox;
      hiveBox = await interface.openBox<OptionsSelections>(BOX_NAME);
      return hiveBox;
    } catch (e) {
      debugPrint('getOpenBox error: ${e.toString()}');
      throw CacheException();
    }
  }
}
