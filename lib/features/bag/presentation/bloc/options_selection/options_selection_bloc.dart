import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:ecom_template/core/usecases/usecase.dart';
import 'package:ecom_template/features/bag/domain/entities/bag_item.dart';
import 'package:ecom_template/features/bag/domain/entities/bag_item_data.dart';
import 'package:ecom_template/features/bag/domain/entities/options_selection.dart';
import 'package:ecom_template/features/bag/domain/usecases/get_saved_selected_options.dart';
import 'package:ecom_template/features/bag/domain/usecases/option_selection_verification.dart';
import 'package:ecom_template/features/bag/domain/usecases/save_selected_options.dart';
import 'package:ecom_template/features/bag/domain/usecases/update_saved_selected_options.dart';
import 'package:ecom_template/features/bag/util/failures.dart';
import 'package:ecom_template/features/shop/domain/entities/shop_product.dart';
import 'package:equatable/equatable.dart';

part 'options_selection_event.dart';
part 'options_selection_state.dart';

class OptionsSelectionBloc
    extends Bloc<OptionsSelectionEvent, OptionsSelectionState> {
  GetSavedSelectedOptions getSavedSelectedOptions;
  UpdateSelectedOptions updateSelectedOptions;
  VerifyOptions verifyOptions;

  OptionsSelectionBloc({
    required this.getSavedSelectedOptions,
    required this.updateSelectedOptions,
    required this.verifyOptions,
  }) : super(OptionsSelectionInitial()) {
    on<OptionsSelectionEvent>((event, emit) async {
      switch (event.runtimeType) {
        case OptionsSelectionChanged:
          print('OptionsSelectionChanged');
          // emit(const OptionsSelectionLoadingState());
          (event as OptionsSelectionChanged);
          // Destructuring
          final ShopProduct product = event.product;
          final String changedKey = event.optionName;
          final int changedIndexValue = event.indexValue;
          // Saving the changed option
          await updateSelectedOptions(
            SelectedOptionsParams(
              productId: product.id,
              optionsSelection: OptionsSelections(
                selectedOptions: {
                  changedKey: changedIndexValue,
                },
              ),
            ),
          );
          // Getting the current saved options
          final incompleteOrBagItem =
              await _parseSavedOptions(product: product);
          await incompleteOrBagItem.fold((incomplete) async {
            log('Emitting the incomplete bag item, with the current options selection: ${incomplete.optionsSelections}');
            // Emitting the incomplete bag item, with the current options selection
            emit(OptionsSelectionLoadedIncompleteState(
              optionsSelection: incomplete.optionsSelections,
            ));
          }, (bagItemDataAndOptionsSelections) async {
            // Emitting the complete bag item, ready to be added to the bag
            log('Emitting the complete bag item, ready to be added to the bag: ${bagItemDataAndOptionsSelections.$2}');
            emit(OptionsSelectionLoadedCompleteState(
              bagItemData: bagItemDataAndOptionsSelections.$1,
              optionsSelection: bagItemDataAndOptionsSelections.$2,
            ));
          });
          break;
        case CheckValidOptionsSelectionEvent:
          event as CheckValidOptionsSelectionEvent;
          // Destructuring
          final ShopProduct product = event.product;
          // Getting the current saved options
          final incompleteOrBagItem =
              await _parseSavedOptions(product: product);
          await incompleteOrBagItem.fold((incomplete) async {
            log('Emitting the incomplete bag item, with the current options selection: ${incomplete.optionsSelections}');
            // Emitting the incomplete bag item, with the current options selection
            emit(OptionsSelectionLoadedIncompleteState(
              optionsSelection: incomplete.optionsSelections,
            ));
          }, (bagItemDataAndOptionsSelections) async {
            // Emitting the complete bag item, ready to be added to the bag
            log('Emitting the complete bag item, ready to be added to the bag: ${bagItemDataAndOptionsSelections.$2}');
            emit(OptionsSelectionLoadedCompleteState(
              bagItemData: bagItemDataAndOptionsSelections.$1,
              optionsSelection: bagItemDataAndOptionsSelections.$2,
            ));
          });
          break;
        case OptionsSelectionStarted:
          emit(OptionsSelectionInitial());
      }
    });
  }

  Future<Either<IncompleteBagItem, (BagItemData, OptionsSelections)>>
      _parseSavedOptions({required ShopProduct product}) async {
    final currentSavedOptions = await getSavedSelectedOptions(
      Params(id: product.id),
    );
    return await currentSavedOptions.fold((l) async {
      return Left(
        IncompleteBagItem(
          product: product,
          quantity: 1,
          optionsSelections: const OptionsSelections(
            selectedOptions: {},
          ),
        ),
      );
    }, (selections) async {
      // Verifying the options
      final result = await verifyOptions.verifyIncompleteBagItem(
        incompleteBagItem: IncompleteBagItem(
          product: product,
          // If null, then the options are incomplete, and a blank options selection is used
          optionsSelections: selections,
          quantity: selections.quantity,
        ),
      );
      // Determing if the options make a complete bag item
      return result.fold((incompleteOptions) {
        return Left(
          IncompleteBagItem(
            optionsSelections: incompleteOptions.currentSelectedOptions,
            product: product,
            quantity: incompleteOptions.currentSelectedOptions.quantity,
          ),
        );
      }, (bagItemReady) {
        return Right(
          (bagItemReady, selections),
        );
      });
    });
  }
}
