import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:ecom_template/core/error/failures.dart';
import 'package:ecom_template/core/usecases/usecase.dart';
import 'package:ecom_template/features/bag/domain/entities/bag_item.dart';
import 'package:ecom_template/features/bag/domain/entities/bag_item_data.dart';
import 'package:ecom_template/features/bag/domain/entities/options_selection.dart';
import 'package:ecom_template/features/bag/domain/usecases/get_saved_selected_options.dart';
import 'package:ecom_template/features/bag/domain/usecases/option_selection_verification.dart';
import 'package:ecom_template/features/bag/domain/usecases/save_selected_options.dart';
import 'package:ecom_template/features/bag/domain/usecases/update_selected_options_quantity.dart';
import 'package:ecom_template/features/bag/domain/usecases/update_selected_options_fields.dart';
import 'package:ecom_template/features/bag/util/failures.dart';
import 'package:ecom_template/features/shop/domain/entities/shop_product.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

part 'options_selection_event.dart';
part 'options_selection_state.dart';

class OptionsSelectionBloc
    extends Bloc<OptionsSelectionEvent, OptionsSelectionState> {
  GetSavedSelectedOptions getSavedSelectedOptions;
  UpdateSelectedOptionsQuantity updateSelectedOptionsQuantity;
  UpdateSelectedOptionsFields updateSelectedOptionsFields;
  VerifyOptions verifyOptions;

  OptionsSelectionBloc({
    required this.getSavedSelectedOptions,
    required this.updateSelectedOptionsQuantity,
    required this.updateSelectedOptionsFields,
    required this.verifyOptions,
  }) : super(OptionsSelectionInitial()) {
    on<OptionsSelectionEvent>((event, emit) async {
      switch (event.runtimeType) {
        case OptionsSelectionChanged:
          debugPrint('OptionsSelectionChanged');
          // emit(const OptionsSelectionLoadingState());
          (event as OptionsSelectionChanged);
          // Destructuring
          final ShopProduct product = event.product;
          final String changedKey = event.optionName;
          final int changedIndexValue = event.indexValue;
          // Saving the changed option
          await updateSelectedOptionsFields(
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
          final currentSavedOptions = await getSavedSelectedOptions(
            Params(id: product.id),
          );
          final incompleteOrBagItem = await _parseCurrentOptions(
              product: product, currentSavedOptions: currentSavedOptions);
          await incompleteOrBagItem.fold((incomplete) async {
            emit(OptionsSelectionLoadedIncompleteState(
              optionsSelection: incomplete.optionsSelections,
            ));
          }, (bagItemDataAndOptionsSelections) async {
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
          final currentSavedOptions = await getSavedSelectedOptions(
            Params(id: product.id),
          );
          final incompleteOrBagItem = await _parseCurrentOptions(
              product: product, currentSavedOptions: currentSavedOptions);
          await incompleteOrBagItem.fold((incomplete) async {
            emit(OptionsSelectionLoadedIncompleteState(
              optionsSelection: incomplete.optionsSelections,
            ));
          }, (bagItemDataAndOptionsSelections) async {
            emit(OptionsSelectionLoadedCompleteState(
              bagItemData: bagItemDataAndOptionsSelections.$1,
              optionsSelection: bagItemDataAndOptionsSelections.$2,
            ));
          });
          break;
        case OptionsSelectionQuantityChanged:
          event as OptionsSelectionQuantityChanged;
          // Destructuring
          final int quantity = event.quantity;
          if (quantity < 1 || quantity > 10) {
            return;
          }
          final ShopProduct product = event.product;
          // Saving the changed option
          await updateSelectedOptionsQuantity(
            SelectedOptionsParams(
              productId: product.id,
              optionsSelection: OptionsSelections(
                quantity: quantity,
              ),
            ),
          );
          // Getting the current saved options
          final currentSavedOptions = await getSavedSelectedOptions(
            Params(id: product.id),
          );
          final incompleteOrBagItem = await _parseCurrentOptions(
              product: product, currentSavedOptions: currentSavedOptions);
          await incompleteOrBagItem.fold((incomplete) async {
            emit(OptionsSelectionLoadedIncompleteState(
              optionsSelection: incomplete.optionsSelections,
            ));
          }, (bagItemDataAndOptionsSelections) async {
            emit(OptionsSelectionLoadedCompleteState(
              bagItemData: bagItemDataAndOptionsSelections.$1,
              optionsSelection: bagItemDataAndOptionsSelections.$2,
            ));
          });
          break;
        case OptionsSelectionStarted:
      }
    });
  }

  Future<Either<IncompleteBagItem, (BagItemData, OptionsSelections)>>
      _parseCurrentOptions(
          {required ShopProduct product,
          required Either<Failure, OptionsSelections>
              currentSavedOptions}) async {
    return await currentSavedOptions.fold((l) async {
      return Left(
        IncompleteBagItem(
          product: product,
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
        ),
      );
      // Determing if the options make a complete bag item
      return result.fold((incompleteOptions) {
        return Left(
          IncompleteBagItem(
            optionsSelections: incompleteOptions.currentSelectedOptions,
            product: product,
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
